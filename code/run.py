"""
Main script for running simulations.

"""

import os
import sys
from datetime import datetime
import subprocess
from copy import deepcopy
from glob import glob
import re
import shutil
from collections import defaultdict
import yaml
import numpy as np

# this import is just so that Sumatra will capture it,
# since Sumatra does not capture sub-processes.
from neuron import h


GLOMSHOCK = 1
ODOUR = 2
FOCAL = 3


def load_default_parameters(experiment_type):
    with open(f"parameters_{experiment_type}.yml") as fp:
        return yaml.safe_load(fp)


def write_parameters(P, filename):
    """
    Write a dictionary of parameters to file in Hoc format
    """
    with open(filename, "w") as fp:
        fp.write("// Olfactory bulb network model: parameters file\n")
        fp.write('load_file("stdrun.hoc")\n')  # load this here so that the default
                                               # t_stop and dt are overwritten by parameters
        fp.write("strdef fileroot\n")
        fp.write('sprint(fileroot,"{}")\n'.format(P["fileroot"]))
        for name, value in P.items():
            if name != "fileroot":
                fp.write(f"{name} = {value}\n")


def run_simulation(parameter_file):
    print("Running simulation...")
    subprocess.run(f"nrniv {parameter_file} init.hoc",
                   shell=True)
    print("Simulation complete.")


def plot_figure(script, output_dir):
    subprocess.run(f'gnuplot {script}', shell=True, cwd=output_dir)
    print(f"Generated figure in {output_dir}")


def postprocess_postscript(file_path):
    shutil.copyfile(file_path, file_path.replace(".eps", "_orig.eps"))
    with open(file_path) as fp:
        content = fp.readlines()
    with open(file_path, "w") as fp:
        for line in content:
            if line.startswith("/CircleF"):
                fp.write(line)
                fp.write("/VLine { stroke [] 0 setdash vpt sub M 0 vpt2 V currentpoint stroke } def")
            elif "CircleF" in line:
                fp.write(line.replace("CircleF", "VLine"))
            else:
                fp.write(line)


def convert_figure_formats(output_dir, use_vline=False):
    output_dir = os.path.abspath(output_dir)
    for file_path in glob(f"{output_dir}/*.eps"):
        if use_vline:
            postprocess_postscript(file_path)
        subprocess.run(f'epstopdf {file_path}', shell=True, cwd=output_dir)
        subprocess.run(f'convert -density 150 {file_path} {file_path.replace(".eps", ".png")}',
                       shell=True, cwd=output_dir)


def create_output_dir():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_dir = f"../results/{timestamp}"
    os.makedirs(output_dir)
    return output_dir


def calculate_total_charge_transfer(mg_concentrations, output_dir):
    total_charge = {}
    for mg_conc in mg_concentrations:
        data_file = os.path.join(output_dir, f"ddi_mg{mg_conc:4.2f}.curvs")
        data = np.loadtxt(data_file)
        total_charge[mg_conc] = data[:, 1].sum()  # todo: convert into pA.s
    with open(os.path.join(output_dir, "ddi_effect_of_mg.dat"), "w") as fp:
        fp.write("# Mg pA-s %(sim)\n")
        for mg_conc in mg_concentrations:
            q = total_charge[mg_conc]
            fp.write(f"{mg_conc} {q} {q/total_charge[0.0]}\n")


def read_phase_locking_index(filename):
    with open(filename) as fp:
        content = fp.read()
    match = re.search(r"Phase-locking index:\s*(?P<index>\d+.\d*)", content)
    if not match:
        raise Exception(f"No match: '{content}'")
    return float(match.groupdict()["index"])


def plot_firing_rate_maps(template_file, data, output_dir):
    from jinja2 import Environment, FileSystemLoader
    env = Environment(loader=FileSystemLoader('.'))
    template = env.get_template(template_file)
    output_filename = template_file.replace(".eps_template", ".eps")
    content = template.render(filename=output_filename,
                              creation_date=datetime.now().isoformat(),
                              data=data)

    with open(os.path.join(output_dir, output_filename), 'w') as fp:
        fp.write(content)


def _calc_firing_rate_map(map_size, indices_of_firing_neurons):
    map = np.zeros(map_size, dtype=float)
    unique, counts = np.unique(indices_of_firing_neurons, return_counts=True)
    for index, count in zip(unique, counts):
        i, j = index // 10, index % 10
        map[i, j] = count / 2  # spikes / s
    return map


def calc_firing_rate_maps(fileroot, parameters):
    P = parameters
    filename = fileroot + ".ras"
    data = np.loadtxt(filename)
    background = data[np.where(np.logical_and(data[:, 3] >= 1000,  data[:, 3] < P["ttrans"]))]
    response = data[data[:, 3] >= P["ttrans"]]
    map_size = (P["nmitx"], P["nmity"])
    background_map = _calc_firing_rate_map(map_size, background[:, 2].astype(int))
    response_map =  _calc_firing_rate_map(map_size, response[:, 2].astype(int))
    return background_map, response_map


def write_firing_rate_vectors(output_dir, parameters):
    P = parameters
    for filename in glob(os.path.join(output_dir, "*.ras")):
        data = np.loadtxt(filename)
        background = data[np.where(np.logical_and(data[:, 3] >= 1000,  data[:, 3] < P["ttrans"]))]
        response = data[data[:, 3] >= P["ttrans"]]
        unique, counts = np.unique(response[:, 2], return_counts=True)
        outputs = {index: n for index, n in zip(unique, counts)}
        output_filename = filename.replace(".ras", ".output")
        with open(output_filename, "w") as fp:
            for i in range(P["nmitx"]**2):
                fp.write("{}\n".format(outputs.get(i, 0)))


def truncate_histograms(output_dir, max_count):
    for file_path in glob(f"{output_dir}/*.gran.hist"):
        output_file = open(file_path.replace(".hist", ".truncated_hist"), "w")
        truncated_lines = []
        with open(file_path) as input_file:
            for i, line in enumerate(input_file):
                if line.startswith("#"):
                    output_file.write(line)
                elif len(line) > 1 and float(line) > max_count:
                    output_file.write(f"{max_count}\n")
                    truncated_lines.append(i)
                else:
                    output_file.write(line)
            print(file_path)
            print(truncated_lines)


def stats2nbar(output_dir, population_size):
    for stats_filename in glob(f"{output_dir}/*.stats"):
        nbar = {"mit": ["0 -1"], "gran": ["0 -1"]}
        population = "mit"
        with open(stats_filename) as fp:
            for line in fp.readlines():
                size = population_size[population]
                if line.startswith("#"):
                    if "granule" in line:
                        population = "gran"
                else:
                    i, j, n = [int(p) for p in line.strip().split()[:3]]
                    nbar[population].append(f"{n} {i*size + j}")
        for population in ("mit", "gran"):
            nbar[population].append("0 {}".format(population_size[population]**2 - 1))
        with open(stats_filename.replace(".stats", ".nbar"), "w") as fp:
            fp.write("\n".join(nbar["mit"]))
        with open(stats_filename.replace(".stats", ".gran.nbar"), "w") as fp:
            fp.write("\n".join(nbar["gran"]))


def figure_2():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_baseline")
    P["input_type"] = GLOMSHOCK
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    plot_figure("../../code/ddi_baseline.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_3():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("ddi"))
    mg_concentrations = (0.0, 0.03, 0.05, 0.1, 0.2, 0.5, 1.0)
    for mg_conc in mg_concentrations:
        print(mg_conc)
        P["fileroot"] = os.path.join(output_dir, f"ddi_mg{mg_conc:4.2f}")
        P["input_type"] = GLOMSHOCK
        P["mgconc"] = mg_conc
        parameter_file = P["fileroot"] + "_parameters.hoc"
        write_parameters(P, parameter_file)
        run_simulation(parameter_file)
    calculate_total_charge_transfer(mg_concentrations, output_dir)
    plot_figure("../../code/ddi_mg.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_4():
    output_dir = create_output_dir()
    # baseline
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_baseline")
    P["input_type"] = GLOMSHOCK
    P["shock_onset"] = 50.0
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # no AMPA
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_noAMPA")
    P["input_type"] = GLOMSHOCK
    P["shock_onset"] = 50.0
    P["AMPAweight"] = 0
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # noNMDA
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_noNMDA")
    P["input_type"] = GLOMSHOCK
    P["shock_onset"] = 50.0
    P["NMDAweight"] = 0
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    truncate_histograms(output_dir, 100)
    plot_figure("../../code/ddi_AMPANMDA.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_5():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("ddi"))
    num_synapses = (50, 200, 500)
    for n_syn in num_synapses:
        P["fileroot"] = os.path.join(output_dir, f"ddi_nsyn{n_syn}")
        P["input_type"] = GLOMSHOCK
        P["synpermit"] = n_syn
        if n_syn == 500:
            P["eGABAA_vclamp"] = -40.0  # prevent space clamp breakdown
        parameter_file = P["fileroot"] + "_parameters.hoc"
        write_parameters(P, parameter_file)
        run_simulation(parameter_file)
    plot_figure("../../code/ddi_nsyn.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_7():
    output_dir = create_output_dir()
    # baseline
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_baseline")
    P["input_type"] = GLOMSHOCK
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # with granule-granule connections
    P = deepcopy(load_default_parameters("ddi"))
    P["fileroot"] = os.path.join(output_dir, "ddi_ggconn")
    P["input_type"] = GLOMSHOCK
    P["gg_conn"] = 1
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    plot_figure("../../code/ddi_ggconn.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_8():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["fileroot"] = os.path.join(output_dir, "odour_baseline")
    P["input_type"] = ODOUR
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    stats2nbar(output_dir, population_size={"mit": P["nmitx"], "gran": P["nmitx"] * P["g2m"]})
    plot_figure("../../code/odour_baseline.gnu", output_dir)
    convert_figure_formats(output_dir, use_vline=True)


def figure_9():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR
    P["inputnumber"] = 0
    for odour_number, i_peak in zip((1, 2, 1), (1.5, 1.5, 2.97)):
        # todo: check if 2.97 is correct. Should be "same total input current"
        P["odournumber"] = odour_number
        P["maxinput"] = i_peak
        P["fileroot"] = os.path.join(output_dir, f"odour_comparison_odour{odour_number}_maxinput{i_peak:4.2f}")
        parameter_file = P["fileroot"] + "_parameters.hoc"
        write_parameters(P, parameter_file)
        run_simulation(parameter_file)
    plot_figure("../../code/odour_comparison.gnu", output_dir)
    convert_figure_formats(output_dir, use_vline=True)


def figure_10():
    output_dir = create_output_dir()

    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR
    input_currents = (0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0, 1.1, 1.2, 1.5)
    phase_locking_index = {"wsyn": {}, "nosyn": {}}
    for connections in ("wsyn", "nosyn"):
        for i_peak in input_currents:
            P["fileroot"] = os.path.join(output_dir, f"odour_maxinput_ii_{i_peak:3.1f}_{connections}")
            P["maxinput"] = i_peak
            if connections == "nosyn":
                P["synpermit"] = 0
            parameter_file = P["fileroot"] + "_parameters.hoc"
            write_parameters(P, parameter_file)
            run_simulation(parameter_file)
            phase_locking_index[connections][i_peak] = read_phase_locking_index(P["fileroot"] + ".synch")
    pli_filename = os.path.join(output_dir, "synch_summary")
    with open(pli_filename, "w") as fp:
        fp.write("#maxinput No syn	With syn\n")
        for i_peak in input_currents:
            fp.write("{} {} {}\n".format(i_peak,
                                         phase_locking_index["nosyn"][i_peak],
                                         phase_locking_index["wsyn"][i_peak]))
    stats2nbar(output_dir, population_size={"mit": P["nmitx"], "gran": P["nmitx"] * P["g2m"]})
    plot_figure("../../code/odour_maxinput.gnu", output_dir)
    convert_figure_formats(output_dir, use_vline=True)


def figure_11():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR

    P["fileroot"] = os.path.join(output_dir, f"odour_baseline")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)

    P["fileroot"] = os.path.join(output_dir, f"odour_noNMDA")
    orig_NMDAweight = P["NMDAweight"]
    P["NMDAweight"] = 0.0
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)

    P["fileroot"] = os.path.join(output_dir, f"odour_noAMPA_mg0")
    P["NMDAweight"] = orig_NMDAweight
    P["AMPAweight"] = 0.0
    P["mgconc"] = 0.0
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)

    stats2nbar(output_dir, population_size={"mit": P["nmitx"], "gran": P["nmitx"] * P["g2m"]})
    plot_figure("../../code/odour_CNQXAPV.gnu", output_dir)
    convert_figure_formats(output_dir, use_vline=True)


def figure_12():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR

    P["fileroot"] = os.path.join(output_dir, f"odour_baseline")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)

    P["fileroot"] = os.path.join(output_dir, f"odour_ggconn")
    P["gg_conn"] = 1
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)

    plot_figure("../../code/odour_ggconn.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_13():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR
    P["maxinput"] = 1.0  # nA
    phase_locking_index = defaultdict(list)
    seeds = (683770, 596125, 119387, 28982, 66621, 54997)
    for g2m, nsyn, ggabaa in (
        (2, 14, 21.6e-3),
        (3, 31, 9.6e-3),
        (5, 87, 3.46e-3),
        (7, 170, 1.76e-3),
        (10, 347, 0.864e-3),
        #(12, 500, 0.6e-3),
        (13, 587, 0.511e-3)
    ):
        for seed in seeds:
            P["g2m"] = g2m
            P["synpermit"] = nsyn
            P["iweight"] = ggabaa
            P["seed"] = seed
            P["fileroot"] = os.path.join(output_dir, f"odour_g2m_{g2m}_seed_{seed}")
            parameter_file = P["fileroot"] + "_parameters.hoc"
            write_parameters(P, parameter_file)
            run_simulation(parameter_file)
            pli = read_phase_locking_index(P["fileroot"] + ".synch")
            phase_locking_index[g2m].append(pli)
    # create "synch_g2m_plot.dat" file
    with open(os.path.join(output_dir, "synch_g2m_plot.txt"), "w") as fp:
        fp.write("#		m			s\n")
        for g2m in sorted(phase_locking_index):
            values = np.array(phase_locking_index[g2m])
            mean = np.mean(values)
            stdev = np.std(values, ddof=1)
            stderr = stdev / len(seeds)
            fp.write(f"{g2m}		{mean}		{stderr}\n")
    plot_figure("../../code/odour_g2m_synch.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_14():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR
    P["maxinput"] = 1.2  # nA
    # A 0.5 Hz
    P["stimfreq"] = 0.5  # Hz
    P["tstop"] = 6000
    P["fileroot"] = os.path.join(output_dir, "odour_sine0p5_maxinput_1p2")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # B 0.5 Hz no syn
    P["stimfreq"] = 0.5
    P["synpermit"] = 0
    P["fileroot"] = os.path.join(output_dir, "odour_sine0p5_maxinput_1p2_nosyn")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # C 2 Hz 1.2 nA
    P["stimfreq"] = 2.0
    P["synpermit"] = 500
    P["tstop"] = 3000
    P["fileroot"] = os.path.join(output_dir, "odour_sine2p0_maxinput_1p2")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # D 2 Hz 2 nA
    P["maxinput"] = 2.0
    P["fileroot"] = os.path.join(output_dir, "odour_sine2p0_maxinput_2p0")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # E 8 Hz
    P["stimfreq"] = 8.0
    P["tstop"] = 2100
    # keep same maxinput?
    P["maxinput"] = 1.2
    P["fileroot"] = os.path.join(output_dir, "odour_sine8p0_maxinput_2p0")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    plot_figure("../../code/odour_periodic.gnu", output_dir)
    convert_figure_formats(output_dir)


def figure_15():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = FOCAL
    P["nmitx"] = 10
    P["nmity"] = 10
    P["g2m"] = 5
    P["synpermit"] = 86
    P["rmax"] = "ngranx*0.2"
    P["iweight"] = 3.46e-3  # uS
    P["maxinput"] = 2.0
    P["minbg"] = 0.28
    P["maxbg"] = 0.28
    P["ttrans"] = 3000
    P["tstop"] = 5000
    P["stimsize"] = 0.5
    P["fileroot"] = os.path.join(output_dir, "focal_1")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    P["stimsize"] = 3
    P["fileroot"] = os.path.join(output_dir, "focal_3")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    # read raster files and calculate firing rates
    background_map_1, response_map_1 = calc_firing_rate_maps(os.path.join(output_dir, "focal_1"), P)
    background_map_3, response_map_3 = calc_firing_rate_maps(os.path.join(output_dir, "focal_3"), P)
    print(background_map_1)
    print(response_map_1)
    print(background_map_3)
    print(response_map_3)
    plot_firing_rate_maps('bulbnet_latinh_uniform.eps_template',
                          {"A": " ".join(background_map_1.flatten().astype(str)),
                           "B": " ".join(response_map_1.flatten().astype(str)),
                           "C": " ".join(background_map_3.flatten().astype(str)),
                           "D": " ".join(response_map_3.flatten().astype(str))},
                          output_dir)
    convert_figure_formats(output_dir)


def figure_16():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = FOCAL
    P["nmitx"] = 10
    P["nmity"] = 10
    P["g2m"] = 5
    P["synpermit"] = 86
    P["rmax"] = "ngranx*0.2"
    P["iweight"] = 3.46e-3  # uS
    P["maxinput"] = 2.0
    P["minbg"] = -0.1
    P["maxbg"] = 0.2
    P["ttrans"] = 3000
    P["tstop"] = 5000
    P["stimsize"] = 2.5
    seeds = (683770, 596125, 119387, 28982, 66621, 54997)
    background_maps = []
    response_maps = []
    diff_maps = []
    for seed in seeds:
        P["fileroot"] = os.path.join(output_dir, f"focal_seed{seed}")
        P["seed"] = seed
        parameter_file = P["fileroot"] + "_parameters.hoc"
        write_parameters(P, parameter_file)
        run_simulation(parameter_file)
        # read raster files and calculate firing rates
        background_map, response_map = calc_firing_rate_maps(os.path.join(output_dir, f"focal_seed{seed}"), P)
        print(background_map)
        print(response_map)
        background_maps.append(background_map)
        response_maps.append(response_map)
        diff_maps.append(response_map - background_map)
    mean_diff_map = sum(diff_maps) / len(diff_maps)
    plot_firing_rate_maps('bulbnet_latinh_nonuniform.eps_template',
                          {"A": " ".join(background_maps[0].flatten().astype(str)),
                           "B": " ".join(response_maps[0].flatten().astype(str)),
                           "C": " ".join(diff_maps[0].flatten().astype(str)),
                           "D": " ".join(mean_diff_map.flatten().astype(str))},
                          output_dir)
    convert_figure_formats(output_dir)


def figure_17():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("odour"))
    P["input_type"] = ODOUR
    P["nmitx"] = 8
    P["nmity"] = 8
    P["g2m"] = 7
    P["rmax"] = "ngranx*0.25"
    P["maxinput"] = 1.0
    P["inputnumber"] = 0
    P["odournumber"] = 3
    P["fileroot"] = os.path.join(output_dir, f"simil_odour3")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    P["odournumber"] = 4
    P["fileroot"] = os.path.join(output_dir, f"simil_odour4")
    parameter_file = P["fileroot"] + "_parameters.hoc"
    write_parameters(P, parameter_file)
    run_simulation(parameter_file)
    write_firing_rate_vectors(output_dir, P)
    plot_figure("../../code/odour_simil.gnu", output_dir)
    convert_figure_formats(output_dir)


def new_figure_random_variability():
    output_dir = create_output_dir()
    P = deepcopy(load_default_parameters("ddi"))
    P["input_type"] = GLOMSHOCK
    seeds = (
        133572, 987209, 357220, 977777, 966801, 396894, 214022, 141958,
        186752, 186683, 560231, 960032, 430881, 229799, 973396, 786750,
        280724, 690835, 373176, 158229, 725253, 674083, 359226, 489080,
        893996, 458915, 825886, 988202, 850007, 603646, 116092, 715846,
        573034, 118660, 148936, 927211, 154596, 277860, 189048, 436368,
        393813, 691679, 965216, 590884, 453150, 230314, 677866, 363410,
        349025, 880214
    )
    for seed in seeds:
        P["seed"] = seed
        P["fileroot"] = os.path.join(output_dir, f"ddi_baseline_seed_{seed}")
        parameter_file = P["fileroot"] + "_parameters.hoc"
        write_parameters(P, parameter_file)
        run_simulation(parameter_file)
    #plot_figure("../../code/ddi_baseline.gnu", output_dir)
    #convert_figure_formats(output_dir)




if __name__ == "__main__":
    for arg in sys.argv[1:]:
        func = eval(arg)
        func()
