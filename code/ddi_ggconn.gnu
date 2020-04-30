load "../../code/defaults.gnu"
set term post port enhanced mono solid "Helvetica" 10

set output "ddi_ggconn_vs_baseline.eps"

set size 0.49,0.4
set nokey
set noborder
set noytics
set noxtics
set multiplot
set tmargin 0
set bmargin 0
set size 0.49,0.085
set origin 0,0.31
set label 1 '{/Helvetica-Bold=14 A}' at screen 0,0.39
set label 2 '{/Helvetica=10 No granule-granule synapses}' at 100,-2.5
sbxs = 900
sbx = -100
sbys = -3
sby = 1
sblt = 1
sblw = 2
load "../../code/scalebar.gnu"
set label 1000 "100 ms" at sbxlx-100,sbxly
set label 1001 " 1 nA" at sbylx,sbyly
pl [0:1000][-3.5:0] "ddi_baseline.curvs" u 1:2 w l lw 0.5

set nolabel 1000
set nolabel 1001
set noarrow 1000
set noarrow 1001
set origin 0,0.22
set label 2 '{/Helvetica=10 With granule-granule synapses}' at 100,-2.5
pl [0:1000][-3.5:0] "ddi_ggconn.curvs" u 1:2 w l lw 1


sbxs = 900
sbx = 0
sbys = -25
sby = 20
load "../../code/scalebar.gnu"
set noarrow 1000
set label 1001 " 20 spikes per second " at sbylx,sbyly right
set origin 0,0.09
set label 1 '{/Helvetica-Bold=14 B}' at screen 0,0.17
set label 2 '{/Helvetica=10 No granule-granule synapses}' at 100,30
pl [0:1000][0:70] "ddi_baseline.gran.hist" u 0:1 w steps lw 0.5

set nolabel 1001
set noarrow 1001
set origin 0,0
set label 2 '{/Helvetica=10 With granule-granule synapses}' at 100,30
pl [0:1000][0:70] "ddi_ggconn.gran.hist" u 0:1 w steps lw 1
