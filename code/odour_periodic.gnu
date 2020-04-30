# Response of BulbNet model to periodic input.

#load "/home/andrew/defaults.gnu"

set term post port enhanced mono solid "Helvetica" 8
set output "odour_periodic.eps"

set linestyle 1 lt 1 lw 0.5
set style data lines

set size 0.49,0.6
set multiplot

set size 0.48,0.11
set nokey
set noxtics
set border 1
set noytics
set tmargin 0
set bmargin 0
set rmargin 0

set label 1 '{/Helvetica-Bold=14 A}' at screen 0,0.57
set arrow 1 from 3200,1.4 to 5200,1.4 nohead
set label 2 "2 s" at 4000,1.3
set origin 0,0.48
pl [500:6000][0:1.4] "odour_sine0p5_maxinput_1p2.smhist" ls 1

set label 1 '{/Helvetica-Bold=14 B}' at screen 0,0.45
set origin 0,0.36
pl [500:6000][0:1.4] "odour_sine0p5_maxinput_1p2_nosyn.smhist" ls 1

set label 1 '{/Helvetica-Bold=14 C}' at screen 0,0.33
set arrow 1 from 1850,0.7 to 2350,0.7 nohead
set label 2 "500 ms" at 1950,0.6
set origin 0,0.24
pl [1100:3000][0:1.4] "odour_sine2p0_maxinput_1p2.smhist" ls 1

set label 1 '{/Helvetica-Bold=14 D}' at screen 0,0.21
set arrow 1 from 1850,1.1 to 2350,1.1 nohead
set label 2 "500 ms" at 1950,1.0
set origin 0,0.12
pl [1100:3000][0:1.4] "odour_sine2p0_maxinput_2p0.smhist" ls 1

set label 1 '{/Helvetica-Bold=14 E}' at screen 0,0.09
set arrow 1 from 1480,0.6 to 1605,0.6 nohead
set label 2 "125 ms" at 1460,0.5
set origin 0,0.0
pl [1100:2100][0:1.4] "odour_sine8p0_maxinput_2p0.smhist" ls 1

