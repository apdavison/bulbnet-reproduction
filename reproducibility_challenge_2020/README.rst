


Finding the code

There is a version of the code on ModelDB at https://senselab.med.yale.edu/ModelDB/ShowModel?model=2730
This includes the code used to create figures 2, 8

On my desktop machine, there is a directory /home/andrew/chalmont/Projects/Olfaction/bulbNet containing a version of the code, as well as subdirectories "Jan2003", "R1", "ModelDB", "oo". The file timestamps reflect when the files were copied to my current desktop machine (in 2017). A CD-R labelled "Gonzo weekly backup" from 30/08/2002 only has the "R1" directory. I am fairly certain that "Jan2003" contains the code used for the published manuscript.

It seems that Jan2003 does indeed contain code, including gnuplot scripts for creating figures. These refer to data files (simulation results) that may be in /home/andrew/chalmont/Projects/Olfaction/Thesis. I also have a CD-R "Revised Thesis files" from 20/08/01 which contains the same, or similar files.

There is minimal documentation (an occasional README file). I have a box file labelled "Thesis Notes", which seems like it might have some useful stuff, but I think I might make faster progress just trying to re-run the code.


Running the ModelDB version

Compiling NMODL files using nrnivmodl (NEURON v7.6.7 from 2019-04-19), using "simulation" conda env on Desktop.

Ran using nrngui init.hoc, then followed on-screen instructions (see Screenshot_2020-02-25_16-59-42.png)

Installed gnuplot using `sudo apt install gnuplot-x11`

ran gnuplot ddi_baseline.gnu --> ddi_baseline.eps Resulting figure is similar to Fig 2 in the paper, but shows differences due to random number seeds
(might be possible to find the exact connectivity I used for the paper, and use that rather than generating randomly)

repeated for second experiment ("odour_baseline") - Resulting figure is similar to Fig 8, although missing the vertically-oriented histograms



Modernising

Created a folder ~/projects/bulbnet_reproduction/March2020 into which I copied the ModelDB version

Started writing a Python script run.py to generate all figures
Also adapted NMODL and Hoc files to allow multithreading. Using 32 threads reduced the simulation time by a factor of about 10, from over 10 minutes to 1 min 13 seconds.
