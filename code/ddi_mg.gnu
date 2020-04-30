
set term post port enhanced mono solid "Helvetica" 7
set output "ddi_mg.eps"

set style data l
set size 0.5,0.6
set multiplot
set size 0.48,0.4
set nokey
set arrow 1 from 500,-23 to 600,-23 nohead lw 2
set arrow 2 from 500,-23 to 500,-22 nohead lw 2
set label 1 "100 ms" at 510,-23.7 font "Helvetica, 8"
set label 2 "1 nA " at 500,-22.5 right font "Helvetica, 8"
set noborder
set noxtics
set noytics
set label 3 "0.0 mM" at -20,-1 right font "Helvetica, 10"
set label 4 "0.03 mM" at -20,-4.5 right font "Helvetica, 10"
set label 5 "0.05 mM" at -20,-8 right font "Helvetica, 10"
set label 6 "0.1 mM" at -20,-11.5 right font "Helvetica, 10"
set label 7 "0.2 mM" at -20,-15 right font "Helvetica, 10"
set label 8 "0.5 mM" at -20,-18.5 right font "Helvetica, 10"
set label 9 "1.0 mM" at -20,-22 right font "Helvetica, 10"
set label 10 '{[Mg^{/=10 2+}]}' at -25,0.8 right font "Helvetica, 10"

set linestyle 1 lt 7 lw 0.5
set linestyle 2 lt 1 lw 0.5
set origin 0.04,0.19
pl [-100:800][-25:1] "ddi_mg0.00.curvs" u 1:2 ls 2, "ddi_mg0.03.curvs" u 1:($2-3.5) ls 2, "ddi_mg0.05.curvs" u 1:($2-7) ls 2, "ddi_mg0.10.curvs"u 1:($2-10.5) ls 2, "ddi_mg0.20.curvs" u 1:($2-14) ls 2, "ddi_mg0.50.curvs" u 1:($2-17.5) ls 2, "ddi_mg1.00.curvs" u 1:($2-21) ls 2

set border 3 lw 0.5
set ytics nomirror
set origin 0.03,-0.0
set size 0.48,0.2
set nokey
set logscale x
set arrow from 0.02,1 to 2,1 nohead lt 0
set xlabel '{/=10 [Mg^{/=6 2+}] / mM}'
set ylabel '{/=8 Fraction of charge in zero [Mg^{/=5 2+}]}'
set xtics nomirror ("" 0.02, "0.03" 0.03, "" 0.04, "" 0.05, "" 0.06, "" 0.07, "" 0.08, "" 0.09, "0.1" 0.1, "" 0.2, "0.3" 0.3, "" 0.4, "" 0.5, "" 0.6, "" 0.7, "" 0.8, "" 0.9, "1" 1)
set nolabel
set label 1 '{/Helvetica-Bold=14 A}' at screen 0,0.59
set label 2 '{/Helvetica-Bold=14 B}' at screen 0,0.19
set key
pl [0.02:2][0:1.3] "ddi_effect_of_mg.dat" u 1:3 w p lt 7 pt 6 title "Model", "../../data/expt3_effect_of_Mg" u 1:4:5 w errorbars lt -1 pt 2 title "Experiment"


