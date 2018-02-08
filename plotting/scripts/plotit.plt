#mean after 120000 messages
reset

set datafile missing "NaN"
factorx = 1
factory = 1
stepsizex = 100
stepsizey = 10

filename="/home/flo/camel_time.txt"

unset border
set border 3

set key right top
set key box linetype 1 linecolor '#000000' linewidth 2
set key width +1
set key spacing 1.5

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output 'timeeval.pdf'

set xtics nomirror
set ytics nomirror

set xlabel "tool"
set ylabel "mean answer time on 200 MpS [ms]"
set grid ytics
set datafile separator ","

myfont = "Monospace,10"
set yrange[0:]

plot filename using 2:5 title "DeltaDb", \
filename using 2:6 title "DeltaAgg"
