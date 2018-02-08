reset

filenamewso2 = "/home/flo/WSO2_summary_ram_20170223_c.txt"
filenamecamel = "/home/flo/Camel_summary_ram_20170227_c.txt"
filenamenodered = "/home/flo/NodeRed_summary_ram_20170227_c.txt"
set datafile missing "NaN"
factorx = 1
factory = 1
stepsizex = 100
stepsizey = 10

unset border
set border 3

set key left top
set key box linetype 1 linecolor '#000000' linewidth 2
set key width +1
set key spacing 1.5

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output 'rameval.pdf'

set xlabel "time [s]"
set ylabel "memory consumption [kB]"
set grid ytics
set datafile separator " "

#unset xtics

set xtics nomirror
stats filenamewso2 using ($1*factorx)
xoffsetwso2 = STATS_min
stats filenamecamel using ($1*factorx)
xoffsetcamel = STATS_min
stats filenamenodered using ($5*factorx)
xoffsetnodered = STATS_min

set xrange [0:]
#set xtics STATS_min,stepsize,STATS_max
#set format x "%5.3f"

set ytics nomirror
#stats filename using (($4-$2)*factory)
#ymin = STATS_min
#ymax = STATS_max
ymin = 0
ymax = 100000
set yrange [ymin:]
#set ytics  0,stepsizey,ymax
#set format y "%1.0f"
#set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 pi -1 ps 1.5
set pointintervalbox 0.5

myfont = "Monospace,10"

set arrow 1 from 1010,0 to 1010,900000 lc rgb "black" nohead

set arrow 2 from 1650,0 to 1650,900000 lc rgb "black" nohead

set arrow 3 from 2450,0 to 2450,900000 lc rgb "black" nohead

plot filenamewso2 using ($1*factorx-xoffsetwso2):28 title "wso2"  \
with linespoints pi 1 pointtype "△" lc rgb "black" font myfont, \
filenamecamel using ($1*factorx-xoffsetcamel):28 title "camel"  \
with linespoints pointtype "▲" lc rgb "black" font myfont, \
filenamenodered using ($5*factorx-xoffsetnodered):6 title "nodered"  \
with linespoints pointtype "▼" lc rgb "black" font myfont
