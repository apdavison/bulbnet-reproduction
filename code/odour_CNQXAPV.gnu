# Add this definition to the postscript file and replace CircleF by VLine
# /VLine { stroke [] 0 setdash vpt sub M 0 vpt2 V
#   currentpoint stroke
#   } def

 
set term post port enhanced mono "Helvetica" 8
set output "odour_CNQXAPV.eps"
offset = -0.15
set size 0.5,0.39
hoffset = 0.1
set multiplot
set size 0.3,0.075
set nokey
set noxtics
set noytics
set noborder
set bmargin 0
set tmargin 0
set lmargin 0
set rmargin 0

set origin 0.03,0.3
pl [0:3000][-0.5:35.5] "odour_baseline.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.03,0.17
pl [0:3000][-0.5:35.5] "odour_noNMDA.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.03,0.04
pl [0:3000][-0.5:35.5] "odour_noAMPA_mg0.ras" u 4:3 w p pt 7 ps 0.22

set size 0.09,0.075
set noxtics
set border 2 lw 0.5

set origin 0.34,0.3
pl [0:73][0:18] "odour_baseline.nbar" u ($1/2):($2+1) w steps lw 0.5
set origin 0.34,0.17
pl [0:73][0:18] "odour_noNMDA.nbar" u ($1/2):($2+1) w steps lw 0.5
set origin 0.34,0.04
set arrow from 0,-2 to 25,-2 nohead lw 2
set label '{25 s^{/=6 -1}}' at -3,-4
pl [0:73][0:18] "odour_noAMPA_mg0.nbar" u ($1/2):($2+1) w steps lw 0.5

set noarrow
set nolabel

set size 0.3,0.04
set border 1 lw 0.5
set origin 0.03,0.26
pl [0:3000][0:2] "odour_baseline.smhist" w l lw 0.5
set origin 0.03,0.13
pl [0:3000][0:2] "odour_noNMDA.smhist" w l lw 0.5
set arrow from 300,0.5 to 800,0.5 nohead lw 2
set label "500 ms" at 300,0.8
set origin 0.03,0.005
pl [0:3000][0:2] "odour_noAMPA_mg0.smhist" w l lw 0.5




set nolabel
set noarrow



set label 12 "Control" at screen 0.38,0.35 font "Helvetica,9"
set label 13 "No NMDA" at screen 0.38,0.22 font "Helvetica,9"
set label 131 "receptors" at screen 0.38,0.207 font "Helvetica,9"
set label 17 "No AMPA" at screen 0.38,0.09 font "Helvetica,9"
set label 171 "receptors," at screen 0.38,0.077 font "Helvetica,9"
set label 172 '{[Mg^{2+}] = 0 mM}' at screen 0.38,0.060 font "Helvetica,9"
set label 14 "A" at screen 0,0.365 font "Helvetica-Bold, 14"
set label 15 "B" at screen 0,0.235 font "Helvetica-Bold, 14"
set label 16 "C" at screen 0,0.105 font "Helvetica-Bold, 14"

set size
set origin
set noborder
set noytics
set xlabel
set ylabel
set noxtics
pl [0:1][2:3] sin(x)

set nomultiplot

