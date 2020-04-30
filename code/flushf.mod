: Adds the function flushf() to hoc. This is used for the
: cell-creation progress meter.

NEURON {
    THREADSAFE
	SUFFIX nothing
}

PROCEDURE flushf() {
  VERBATIM
    fflush(NULL);
  ENDVERBATIM
}
