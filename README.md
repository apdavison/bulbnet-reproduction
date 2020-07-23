# bulbnet-reproduction

This is a model of the mammalian olfactory bulb for the
NEURON simulator. The model contains only mitral and
granule cells.

A full description may be found in:
Davison A.P., Feng J. and Brown D. (2003) Dendrodendritic
inhibition and simulated odor responses in a detailed
olfactory bulb network model. J. Neurophysiol. 90:1921-35

To reproduce the figures from this paper, install NEURON, change to the code
directory, run:

```
  $ nrnivmodl
```

then for each figure run:

```
  $ python run.py figure_2
```

and similarly for the other figures.


## Time required to run simulations

The following times are for running with 32 threads on a workstation with dual Intel Xeon E5-2640 processors (8 cores, 2.6 GHz, 20 MB cache), 128 GB 2400 MHz DDR4 ECC RAM, writing to a 400 GB SSD SAS 12 Gbit/s hard disk. The time to run with a single core was about 10 times as long.

```
figure_2   1m 19s
figure_3   9m 10s
figure_4   3m 46s
figure_5   3m 56s
figure_7   2m 32s
figure_8   5m 25s
figure_9   14m 58s
figure_10  1h 46m
figure_11  15m 50s
figure_12  10m 42s
figure_13  1h 24m
figure_14  34m 19s
figure_15  8m 46s
figure_16  25m 32s
figure_17  6m 23s
```

## Dependencies

- NEURON (https://neuron.yale.edu/neuron/)
- Gnuplot (http://www.gnuplot.info/)
- Python (v3.6 or more recent)
- NumPy
- PyYAML
- Jinja2

For more information, contact andrew.davison@cnrs.fr
