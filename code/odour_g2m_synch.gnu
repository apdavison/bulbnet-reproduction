#load "/home/andrew/defaults.gnu"

set term post port enhanced mono solid "Helvetica" 10
set output "odour_g2m_synch.eps"
set size 0.495,0.2

set nokey
set border 3
set style data errorbars
set xlabel "Ratio of granule:mitral cells"
#set xtics nomirror ("4" 2,"9" 3,"16" 4,"25" 5,"36" 6,"49" 7,"64" 8,"81" 9,"100" 10, "121" 11,"144" 12, "169" 13)
set xtics nomirror
set ylabel "Phase-locking index"
set ytics nomirror 0.01
set logscale x
pl [1:300][0.10:0.13] "synch_g2m_plot.txt" u ($1*$1):2:3 pt 6

#load "/home/andrew/defaults.gnu"
