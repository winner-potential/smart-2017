reset

set datafile missing "NaN"
factorx = 1
factory = 1
#stepsizex = 100
#stepsizey = 20

unset border
set border 3

set key right top
set key box linetype 1 linecolor '#000000' linewidth 2
set key width +1
set key spacing 1.5

set terminal pdf size 20cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output outputfilename

set xlabel "time [ms]"
set ylabel "response time [ms]"
set datafile separator " "
set decimalsign '.'

xoffsets = ""
do for [i=1:words(files)] {
    stats word(files,i) using ($2*factorx)
    xoffsets = xoffsets." ".sprintf("%f",STATS_min)
}

set xtics nomirror
#set grid xtics
#set xtics 0,1000,3000
set xrange [-1:2000]
set ytics nomirror
set grid ytics
#set ytics 0,20,120
set yrange [-10:]


myfont = "Monospace,10"

plot for [i=1:words(files)] word(files, i) \
using ($2*factorx-(word(xoffsets,i)+0)):($3-$2) \
title "db" with linespoints \
pointtype word(symbols,i) lc rgb "black" font myfont, \
word(files, i) \
using ($2*factorx-(word(xoffsets,i)+0)):($4-$2) \
title "avg" with linespoints \
pointtype word(symbols,i+1) lc rgb "black" font myfont

# pause -1

