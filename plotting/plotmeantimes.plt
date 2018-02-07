#mean after 120000 messages
reset

set datafile missing "NaN"
factorx = 1
factory = 1
stepsizex = 100
stepsizey = 10

filename="/home/flo/timedata.txt"

unset border
set border 3

set key left top
set key box linetype 1 linecolor '#000000' linewidth 2
set key width +1
set key spacing 1.5
set key opaque

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output 'timeevalagg.pdf'

set format y "%5.0f";
set xtics nomirror
set ytics nomirror

set xlabel "messages per second"
set ylabel "mean answer time [ms]"
set grid ytics
set datafile separator " "

myfont = "Monospace,10"
set style data histogram
set style histogram cluster gap 1
set style fill pattern border
set yrange[0:100]

set multiplot layout 2, 1
set yrange[50:1000]
unset xlabel
unset xtics
unset border
set border 2
set ylabel ' '
plot filename using 3:xtic(1) title "Apache Camel" lc rgb "black",  \
           '' using 4         title "Node-RED" lc rgb "black", \
           '' using 2         title "WSO2" lc rgb "black",
unset key
set border 3
set xtics nomirror
set ytics nomirror

set xlabel "messages per second"
set ylabel "mean answer time [ms]" offset 0,5,0
set grid ytics
set datafile separator " "

myfont = "Monospace,10"
set style data histogram
set style histogram cluster gap 1
set style fill pattern border
set yrange[0:50]
plot filename using 3:xtic(1) title "Apache Camel" lc rgb "black",  \
           '' using 4         title "Node-RED" lc rgb "black", \
           '' using 2         title "WSO2" lc rgb "black",
unset multiplot
