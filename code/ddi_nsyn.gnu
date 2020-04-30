
set term post port enhanced mono solid "Helvetica" 10
set output "ddi_nsyn.eps"

g(x) = (x>50) ? A1*exp(-x/tau1) + A2*exp(-x/tau2) : sqrt(-1)

set size 0.5,0.48
set multiplot
set size 0.5,0.14
set nokey
set noxtics
set noborder
set noytics
set tmargin 0
set bmargin 0

set style data lines
set linestyle 1 lt 7 lw 0.5
set linestyle 2 lt 1 lw 0.5

# synpermit 50
A1 = -4.9
A2 = -0.22
tau1 = 21
tau2 = 381

fit [50:1500] g(x) "ddi_nsyn50.curvs" u 1:2 via A1,tau1,A2,tau2

set origin 0,0.325
set label 1 '{/Times-Italic=12 n_{/Times-Roman=8 syn}}{/Times-Roman=12 = 50}' at screen 0.01,0.47 left
set arrow 2 from 1100,-0.5 to 1100,-0.4 nohead lw 2
set label 2 " 0.1 nA" at 1100,-0.45 left
set label 3 sprintf('{/Times-Italic=10 I} {/Times-Roman=10 = %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}} %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}}}', A1, tau1, A2, tau2) at screen 0.2,0.42
pl [0:1490][] "ddi_nsyn50.curvs" ls 2, g(x) lt 0 lw 1


# synpermit 200
A1 = -2.2
A2 = -1.9
tau1 = 59
tau2 = 410

fit [50:1500] g(x) "ddi_nsyn200.curvs" u 1:2 via A1,tau1,A2,tau2

set origin 0,0.16
set label 1 '{/Times-Italic=12 n_{/Times-Roman=8 syn}}{/Times-Roman=12 = 200}' at screen 0.01,0.305 left
set arrow 2 from 1100,-3.0 to 1100,-2.0 nohead lw 2
set label 2 " 1 nA" at 1100,-2.5 left
set label 3 sprintf('{/Times-Italic=10 I} {/Times-Roman=10 = %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}} %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}}}', A1, tau1, A2, tau2) at screen 0.2,0.25
pl [0:1490][-3.6:0.36] "ddi_nsyn200.curvs" u 1:2 ls 2, g(x) lt 0 lw 1

# synpermit 500
A1 = -0.53
A2 = -2.9
tau1 = 112
tau2 = 546

fit [60:1500] g(x) "ddi_nsyn500.curvs" via A1,tau1,A2,tau2

set origin 0,-0.01
set label 1 '{/Times-Italic=12 n_{/Times-Roman=8 syn}}{/Times-Roman=12 = 500}' at screen 0.01,0.135 left
set arrow 2 from 1100,-3.3 to 1100,-2.3 nohead lw 2
set label 2 " 1 nA" at 1100,-2.8 left
set arrow 1 from 900,-3.3 to 1100,-3.3 nohead lw 2
set label 3 "200 ms" at 900,-3.55
set label 4 sprintf('{/Times-Italic=10 I} {/Times-Roman=10 = %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}} %4.2f e^{/Times-Italic=8 {/Symbol=8 \055}t {/Times-Roman=8 /%.0f}}}', A1, tau1, A2, tau2) at screen 0.2,0.07
pl [0:1490][-4.1:0.41] "ddi_nsyn500.curvs" u 1:2 ls 2, g(x) lt 0 lw 1
set noarrow 1

