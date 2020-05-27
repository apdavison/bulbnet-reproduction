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

  $ nrnivmodl

then for each figure run:

  $ python run.py figure_2

and similarly for the other figures.

For more information, contact andrew.davison@cnrs.fr
