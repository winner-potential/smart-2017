reset

middlingcommand="awk   'BEGIN{amount=%s;count=0}\
                        (NR<1){sum=0}{val=%s;\
                        if(val>0){sum=sum+val;count=count+1}}\
                        (count%%amount==0){print $2,sum/amount;sum=0;count=0}END{}'"

set datafile missing "NaN"
factorx = 1
factory = 1
#stepsizex = 100
#stepsizey = 20

unset border
set border 3

set key left top
set key box linetype 1 linecolor '#000000' linewidth 2
set key width +1
set key spacing 1.5
set key opaque

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output outputfilename

set xlabel "time [ms]"
set ylabel "response time [ms]"
set datafile separator " "
set decimalsign '.'

xoffsets = ""
do for [i=1:words(files)] {
    stats "<sort -k2 ".word(files,i) using ($2*factorx)
    xoffsets = xoffsets." ".sprintf("%f",STATS_min)
}

set xtics nomirror
#set grid xtics
#set xtics 0,1000,3000
#set xrange [-1:3]
set ytics nomirror
set grid ytics
#set ytics 0,20,120
#set yrange [-10:]


myfont = "Monospace,10"

plot for [i=1:words(files)] "<sort -k2 ".word(files,i)." | ".sprintf(middlingcommand,middling,"$3-$2") \
using ($1*factorx-(word(xoffsets,i)+0)):($2) \
title "Database" with lines \
lt 1 dt (5,5) lc rgb "black", \
for [i=1:words(files)] "<sort -k2 ".word(files,i)." | ".sprintf(middlingcommand,middling,"$4-$2") \
using ($1*factorx-(word(xoffsets,i)+0)):($2) \
title "Aggregation" with lines \
lt 1 lc rgb "black", \
for [i=1:words(files)] "<sort -k2 ".word(files,i) \
using ($2*factorx-(word(xoffsets,i)+0)):(($3-$2<0) ? -1000 : NaN) \
title "Error" with linespoints \
pointtype word(symbols,i+2) lc rgb "black" font myfont
#for [i=1:words(files)] "<sort -k2 ".word(files,i) \
#using ($2*factorx-(word(xoffsets,i)+0)):(($4-$2<0) ? -1000 : NaN) \
#title "AGGError" with linespoints \
#pointtype word(symbols,i+3) lc rgb "black" font myfont

# pause -1

