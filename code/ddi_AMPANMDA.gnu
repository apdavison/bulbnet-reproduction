
set term post port enhanced mono solid "Helvetica" 10
set output "bulbnet_schoppa_CNQXAPV.eps"

set size 0.5,0.65

set multiplot
set size 0.25,0.325
set nokey
set noxtics
set noborder
set noytics

# granule EPSC
set origin 0,0.325
set arrow 2 from 400,-0.12 to 400,-0.10 nohead lw 2
set label 2 "  20 pA" at 400,-0.11 left
set label 3 "Baseline" at 350,-0.005 center
set label 4 "No AMPA" at 350,-0.052 center
set label 5 "No NMDA" at 350,-0.080 center
pl [40:600][-0.15:0] "ddi_baseline.curvs" u 1:8 w l lt -1 lw 0.5, "ddi_noAMPA.curvs" u 1:($8-0.05) w l lt -1 lw 0.5, "ddi_noNMDA.curvs" u 1:($8-0.08) w l lt -1 lw 0.5
set nolabel 3
set nolabel 4
set nolabel 5


# granule firing
set origin 0.25,0.325
set arrow 2 from 400,-280 to 400,-230 nohead lw 2
set label 2 "  50 mV" at 400,-255 left
pl [40:600][-315:50] "ddi_baseline.curvs" u 1:4 w l lt -1 lw 0.5, "ddi_noAMPA.curvs" u 1:($4-120) w l lt -1 lw 0.5, "ddi_noNMDA.curvs" u 1:($4-240) w l lt -1 lw 0.5

# mitral IPSC
set origin 0,0
set arrow 2 from 400,-9.8 to 400,-8.8 nohead lw 2
set label 2 "  1 nA" at 400,-9.3 left
set arrow 1 from 200,-9.8 to 400,-9.8 nohead lw 2
set label 1 "200 ms" at 230,-10.3
pl [40:600][-12:1] "ddi_baseline.curvs" u 1:2 w l lt -1 lw 0.5, "ddi_noAMPA.curvs" u 1:($2-4) w l lt -1 lw 0.5, "ddi_noNMDA.curvs" u 1:($2-8) w l lt -1 lw 0.5
set noarrow 1
set nolabel 1

# granule histogram
set origin 0.25,0
set arrow 2 from 400,-170 to 400,-220 nohead lw 2
set label 2 "   50\nspikes/s" at 420,-190 left
set label 3 "*" at 60,105
set label 4 "*" at 60,-135
set label 5 "*" at 160,-135

pl [40:600][-240:120] "ddi_baseline.gran.truncated_hist" u 0:1 w l lt -1 lw 0.5, "ddi_noAMPA.gran.hist" u 0:($1-100) w l lt -1 lw 0.5, "ddi_noNMDA.gran.truncated_hist" u 0:($1-240) w l lt -1 lw 0.5

set label 1 '{/Helvetica-Bold=14 A}' at screen 0,0.64
set label 2 '{/Helvetica-Bold=14 C}' at screen 0,0.305
set label 3 '{/Helvetica-Bold=14 B}' at screen 0.25,0.64
set label 4 '{/Helvetica-Bold=14 D}' at screen 0.25,0.305
set nolabel 5
pl [0:1][2:3] sin(x)

