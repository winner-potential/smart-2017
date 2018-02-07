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

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output 'cpu.pdf'

set xlabel "time [s]"
set ylabel "cpu load [%]"
set datafile separator " "
set decimalsign '.'

xoffsets = ""
do for [i=1:words(files)] {
    stats word(files,i) using ($1*factorx)
    xoffsets = xoffsets." ".sprintf("%f",STATS_min)
}

set xtics nomirror
set grid xtics
#set xtics 0,1000,3000
#set xrange [0:100]
set ytics nomirror
set grid ytics
#set ytics 0,stepsizey,250
#set yrange [-0.1:0.5]


myfont = "Monospace,10"

#set arrow 1 from 0,0 to 10,10 lc rgb "black" nohead

#set arrow 2 from 1720,0 to 1720,250 lc rgb "black" nohead

#set arrow 3 from 2470,0 to 2470,250 lc rgb "black" nohead

plot for [i=1:words(labels)] word(files, i) \
using ($1*factorx-(word(xoffsets,i)+0)):column \
title word(labels,i) with linespoints \
pointtype word(symbols,i) lc rgb "black" font myfont

# pause -1

#command line to call
#gnuplot -e "column=10; files='/scripts/cpu_8.txt /scripts/cpu_36.txt';labels='aaa bbb';symbols='▽ ▲'" plotcpu.plt 

#symbols
#+ ▽ ▲ ◆ ●

