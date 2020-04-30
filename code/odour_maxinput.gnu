# Add this definition to the postscript file and replace CircleF by VLine
# /VLine { stroke [] 0 setdash vpt sub M 0 vpt2 V
#   currentpoint stroke
#   } def


set term post port enhanced mono "Helvetica" 7
set output "bulbnet_odour_maxinput.eps"
set size 0.5,0.56

set multiplot
set size 0.19,0.075
set nokey
set noxtics
set noytics
set noborder
set bmargin 0
set tmargin 0
set lmargin 0
set rmargin 0

set origin 0.03,0.445
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_0.5_nosyn.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.03,0.33
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_1.0_nosyn.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.03,0.205
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_1.5_nosyn.ras" u 4:3 w p pt 7 ps 0.22

set origin 0.285,0.445
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_0.5_wsyn.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.285,0.33
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_1.0_wsyn.ras" u 4:3 w p pt 7 ps 0.22
set origin 0.285,0.205
pl [900:3000][-0.5:35.5] "odour_maxinput_ii_1.5_wsyn.ras" u 4:3 w p pt 7 ps 0.22

set size 0.04,0.075
set noxtics
set border 2 lw 0.5
set origin 0.48,0.445
pl [0:73][0:36] "odour_maxinput_ii_0.5_wsyn.nbar" u 1:($2+1) w steps lw 0.5
set origin 0.48,0.33
pl [0:73][0:36] "odour_maxinput_ii_1.0_wsyn.nbar" u 1:($2+1) w steps lw 0.5
set origin 0.48,0.205
pl [0:73][0:36] "odour_maxinput_ii_1.5_wsyn.nbar" u 1:($2+1) w steps lw 0.5

set origin 0.23,0.445
pl [0:73][0:36] "odour_maxinput_ii_0.5_nosyn.nbar" u 1:($2+1) w steps lw 0.5
set origin 0.23,0.33
pl [0:73][0:36] "odour_maxinput_ii_1.0_nosyn.nbar" u 1:($2+1) w steps lw 0.5
set origin 0.23,0.205
set arrow from 5,-2 to 55,-2 nohead lw 2
set label '{50 s^{/=6 -1}}' at -5,-6
pl [0:73][0:36] "odour_maxinput_ii_1.5_nosyn.nbar" u 1:($2+1) w steps lw 0.5
set noarrow
set nolabel

set size 0.19,0.05
set border 1 lw 0.5
set origin 0.03,0.42
pl [900:3000][0:2] "odour_maxinput_ii_0.5_nosyn.smhist" w l lw 0.5
set origin 0.03,0.295
pl [900:3000][0:2] "odour_maxinput_ii_1.0_nosyn.smhist" w l lw 0.5
set origin 0.03,0.155
pl [900:3000][0:2] "odour_maxinput_ii_1.5_nosyn.smhist" w l lw 0.5

set origin 0.285,0.42
set arrow from 2400,0.5 to 2900,0.5 nohead lw 2
set label "500 ms" at 2400,0.75
pl [900:3000][0:2] "odour_maxinput_ii_0.5_wsyn.smhist" w l lw 0.5
set nolabel
set noarrow
set origin 0.285,0.295
pl [900:3000][0:2] "odour_maxinput_ii_1.0_wsyn.smhist" w l lw 0.5
set origin 0.285,0.155
pl [900:3000][0:2] "odour_maxinput_ii_1.5_wsyn.smhist" w l lw 0.5

# D ###############################
set style data p
set border 3 lw 0.5

set size 0.48,0.14
set origin 0.02,0
set bmargin
set lmargin
set xtics nomirror
set ytics nomirror
set xtics 0.5
set ytics 0.05
set key left bottom
set xlabel "Maximum input current /nA" font "Helvetica, 8"
set ylabel "Phase-locking index" font "Helvetica, 8"
pl [0:1.6][0:0.15] "synch_summary" u 1:2 title "No synapses" pt 1, "synch_summary" u 1:3 title "500 synapses per mitral cell" pt 2

set label 12 "No mitral-granule" at screen 0.05,0.553 font "Helvetica,10"
set label 121 "connections" at screen 0.08,0.538 font "Helvetica,10"
set label 13 "500 synapses" at screen 0.318,0.553 font "Helvetica,10"
set label 131 "per mitral cell" at screen 0.32,0.538 font "Helvetica,10"
set label 14 "A" at screen 0,0.51 font "Helvetica-Bold, 14"
set label 15 "B" at screen 0,0.395 font "Helvetica-Bold, 14"
set label 16 "C" at screen 0,0.27 font "Helvetica-Bold, 14"
set label 17 "D" at screen 0,0.13 font "Helvetica-Bold, 14"

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

