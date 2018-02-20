reset

middlingcommand="<awk 'BEGIN{}(NR<1){sum=0}{sum=sum+%s}(NR%%%s==0){print $1,sum/%s;sum=0}END{}' %s"
#sprintf(command,"$2","10","10.0","testdata.txt") using 1:2 with linespoints


set datafile separator " "
set decimalsign '.'
#set datafile missing "NaN"
factorx = 1
factory = 1
#stepsizex = 100
#stepsizey = 20

unset border
set border 3
if (setstuff != 0) {
    unset key
}else{
    set key right top
    set key box linetype 1 linecolor '#000000' linewidth 2
    set key width +1
    set key spacing 1.5
}

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output outputfilename
myfont = "Monospace,10"

unset xlabel
unset ylabel
set bmargin 2.5
set label 1 "time [s]" at screen 0.5,0.03
set lmargin 10.0
set label 2 "cpu load [%]" at screen 0.02,0.5 rotate by 90 center

xoffsets = ""
do for [i=1:words(files)] {
    stats word(files,i) using ($1*factorx)
    xoffsets = xoffsets." ".sprintf("%f",STATS_min)
}

set xtics nomirror
if (setstuff != 0) {
    unset ytics
}else{
    set ytics nomirror
}

set xrange[xlow:xhigh]
set xtics 150
#set yrange[0:150] 
set grid ytics
if (words(parts)>0){
    set multiplot layout words(parts)/2,1 margins 0.1,0.98,0.1,0.98 spacing 0.00,0.05
    unset border
    set border 2
    set xtics scale 0
    set format x ""
    set yrange [word(parts,1):word(parts,2)]
    plot for [i=1:words(labels)] sprintf(middlingcommand,"$".column,middling,middling,word(files, i)) \
    using ($1*factorx-(word(xoffsets,i)+0)):2 \
    title word(labels,i) with linespoints \
    pointtype word(symbols,i) lc rgb "black" font myfont
    
    do for [j=3:words(parts):2] {
        unset key
        unset border
        set border 3
        set format x "%1.0f"
        set xtics nomirror scale 1
        set ytics nomirror
        set yrange [word(parts,j):word(parts,j+1)]
        plot for [i=1:words(labels)] sprintf(middlingcommand,"$".column,middling,middling,word(files, i)) \
        using ($1*factorx-(word(xoffsets,i)+0)):2 \
        title word(labels,i) with linespoints \
        pointtype word(symbols,i) lc rgb "black" font myfont tc rgb "black"
    }
}

