#load "/home/andrew/defaults.gnu"

set term post port enhanced mono 10
set output "odour_simil.eps"
set size 0.5,0.5
#cd "/home/andrew/Projects/ThesisRevisions/BulbNet2/OdourInput/Similar"
set multiplot
set noxtics
set noytics
set nokey
set tmargin 0
set bmargin 0
set lmargin 0
set rmargin 0

set noborder
set size 0.47,0.105
set origin 0.03,0.24
set label '{/Helvetica-Bold=14 B}' at screen 0,0.34
pl [0:3000] "simil_odour3.ras" u 4:3 w p pt 7 ps 0.15

set size 0.47,0.06
set origin 0.03,0.18
set border 1 lw 0.5
set nolabel
pl [0:3000][0:1.6] "simil_odour3.smhist" w l lw 0.5

set size 0.47,0.105
set origin 0.03,0.06
set noborder
set label '{/Helvetica-Bold=14 C}' at screen 0,0.16
pl [0:3000] "simil_odour4.ras" u 4:3 w p pt 7 ps 0.15

set size 0.47,0.06
set origin 0.03,0.0
set border 1 lw 0.5
set label '{/=8 500 ms}' at 2400,0.9
set arrow from 2350,1.1 to 2850,1.1 nohead lw 2
pl [0:3000][0:1.6] "simil_odour4.smhist" w l lw 0.5

set label 1 '{/Helvetica-Bold=14 A{/Helvetica-Bold=12 1}}' at screen 0,0.49
set origin 0.04,0.39
set size 0.46,0.05
set xlabel "Mitral cell number"
set label 2 "1" at 1,-4 font "Helvetica, 6"
set label 3 "64" at 63.2,-4 font "Helvetica, 6"
set label 4 "17" at 16.5,-4 font "Helvetica, 6"
set label 5 "45" at 44.7,-4 font "Helvetica, 6"
pl [1:65] "simil_odour3.output" w steps lw 0.5, "simil_odour4.output" u ($0+0.1):1 w steps lt 4 lw 0.5

set nolabel
set label '{/Helvetica-Bold=14 A{/Helvetica-Bold=12 2}}' at screen 0,0.43
set origin 0.04,0.45
set xlabel
pl [1:65] "simil_odour3.input" w steps lw 0.5, "simil_odour4.input" u ($0+0.1):1 w steps lt 4 lw 0.5

