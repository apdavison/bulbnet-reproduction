# scalebar.gnu
# the following variables should be set in the gnu file prior to loading this:
# sbxs -- start of x-scalebar
# sbx  -- length of x-scalebar
# sbys -- start of y-scalebar
# sby  -- length of y-scalebar
# sblt -- line type for scalebar
# sblw -- line width for scalebar

set arrow 1000 from sbxs,sbys to sbxs+sbx,sbys nohead lt sblt lw sblw
set arrow 1001 from sbxs,sbys to sbxs,sbys+sby nohead lt sblt lw sblw
sbxlx = sbxs
sbxly = (sbys-0.3*sby)
sbylx = sbxs+0.1*sbx
sbyly = sbys+0.5*sby

# then add two commands like
# set label 1000 "200 ms" at sbxlx,sbxly
# set label 1001 "10 mV" at sbylx,sbyly
