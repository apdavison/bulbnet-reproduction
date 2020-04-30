#load "/home/andrew/defaults.gnu"

set term post port enhanced mono solid 10
set output "odour_ggconn.eps"

vsize = 0.2
set size 0.48,vsize
set multiplot

set size 0.46,vsize/2
set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0
set noxtics
set noytics
set nokey

set origin 0.01,vsize/2
set border 1 lw 0.5
set label 1 '{/Helvetica=10 No granule-granule cell connections}' at screen 0,vsize*0.95
pl [0:3000][0:2.2] "odour_baseline.smhist" w l lt 7 lw 0.5
set label 1 '{/Helvetica=10 Granule-granule cell connections}' at screen 0,vsize/2*0.9
set origin 0.01,0
set arrow from 200,1 to 700,1 nohead lt 7 lw 2
set label 2 '500 ms' at 250,0.8
pl [0:3000][0:2.2] "odour_ggconn.smhist" w l lt 7 lw 0.5


