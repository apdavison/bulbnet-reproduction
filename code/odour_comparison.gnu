set term post port enhanced mono "Helvetica" 7
set output "odour_comparison.eps"
set size 0.8,0.15

set multiplot
set size 0.22,0.075
set nokey
set noxtics
set noytics
set noborder
set bmargin 0
set tmargin 0
set lmargin 0
set rmargin 0

set origin 0.02,0.07
pl [0:3000][-0.5:35.5] "odour_comparison_odour1_maxinput1.50.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.27,0.07
pl [0:3000][-0.5:35.5] "odour_comparison_odour2_maxinput1.50.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.52,0.07
pl [0:3000][-0.5:35.5] "odour_comparison_odour1_maxinput2.97.ras" u 4:3 w p pt 7 ps 0.22

set noxtics
set noarrow
set nolabel

set size 0.22,0.05
set origin 0.02,0.001
set border 1 linewidth 0.5
pl [0:3000][0:2] "odour_comparison_odour1_maxinput1.50.smhist" w l lw 0.5
set origin 0.27,0.001
pl [0:3000][0:2] "odour_comparison_odour2_maxinput1.50.smhist" w l lw 0.5
set arrow from 0,0.5 to 500,0.5 nohead lw 2
set label "500 ms" at -20,0.75
set origin 0.52,0.001
pl [0:3000][0:2] "odour_comparison_odour1_maxinput2.97.smhist" w l lw 0.5
set nolabel
set noarrow

# todo: need x-axis for smhist plots

set label 14 "A" at screen 0,0.14 font "Helvetica-Bold, 14"
set label 15 "B" at screen 0.25,0.14 font "Helvetica-Bold, 14"
set label 16 "C" at screen 0.5,0.14 font "Helvetica-Bold, 14"

set size
set origin
set noborder
set noytics
set xlabel
set ylabel
set noxtics
set nokey
pl [0:1][2:3] sin(x)

set nomultiplot
