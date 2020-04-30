COMMENT
Since this is an electrode current, positive values of i depolarize the cell
and in the presence of the extracellular mechanism there will be a change
in vext since i is not a transmembrane current but a current injected
directly to the inside of the cell.
ENDCOMMENT

NEURON {
	POINT_PROCESS SineClamp
	RANGE del, dur, amp, freq, i
	ELECTRODE_CURRENT i
}
UNITS {
	(nA) = (nanoamp)
}

PARAMETER {
	del  (ms)
	dur  (ms)	<0,1e9>
	amp  (nA)
	freq (/s)	<1e-9,1e9>
}
ASSIGNED { i (nA) }

INITIAL {
	i = 0
}

BREAKPOINT {
	at_time(del)
	at_time(del+dur)

	if (t < del + dur && t > del) {
		i = (1 - cos(6.283185307*(0.001)*(t-del)*freq))*amp/2
	}else{
		i = 0
	}
}
