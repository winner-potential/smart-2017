# for java
# timestamp S0C S1C S0U S1U EC EU OC OU MC MU CCSC CCSU YGC YGCT FGC FGCT GCT
# sum over          S0U S1U    EU    OU    MU      CCSU (everything in KB)
# for nodejs
# heapused (in B)
reset

# cleaning memory.json to timestamp - heapUsed - format in kB
# {split($1,a,":");gsub("}","",a[5]);gsub(",\"time\"","",a[4]);print a[5]/1000,a[4]}
wellformnode="{split($1,a,\":\");gsub(\"}\",\"\",a[5]);gsub(\",\\\"time\\\"\",\"\",a[4]);printf \"%%f %%f\\n\",int(a[5]/1000.0),a[4]/1024.0}"
# cleaning mem.txt to timestamp - usedmemory - format in kB
# {print $1,$4+$5+$7+$9+$11+$13}
wellformjava="{print $1,$4+$5+$7+$9+$11+$13}"

wellform="<awk 'BEGIN{node=0}{if(index(FILENAME, \"memory\") != 0){node=1}}"."{if(node==1)".wellformnode."else".wellformjava."}' %s"

middlingcommand="awk 'BEGIN{}(NR<1){sum=0}{sum=sum+$2}(NR%%%s==0){print $1,sum/%s;sum=0}END{}'"

#set datafile missing "NaN"
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
set key opaque

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output outputfilename
myfont = "Monospace,10"

unset xlabel
unset ylabel
set bmargin 2.5
set label 1 "time [s]" at screen 0.5,0.03
set lmargin 10.0
set label 2 "memory used [kB]" at screen 0.02,0.5 rotate by 90 center

set datafile separator " "
set decimalsign '.'

xoffsets = ""
do for [i=1:words(files)] {
    stats sprintf(wellform,word(files, i)) using ($1*factorx)
    xoffsets = xoffsets." ".sprintf("%f",STATS_min)
}
set xtics nomirror
set ytics nomirror
set grid ytics
#set format y "%1.0t{/Symbol \327}10^{%L}"
set format y "%1.0e"
set xrange[xlow:xhigh]
set xtics 150
set grid xtics

if (words(parts)>0){
    set multiplot layout words(parts)/2,1 margins 0.1,0.98,0.1,0.98 spacing 0.00,0.05 
    unset border
    set border 2
    set xtics scale 0
    set format x ""
    set yrange [word(parts,1):word(parts,2)]
    set ytics 1000000
    plot for [i=1:words(labels)] sprintf(wellform,word(files, i))." | ".sprintf(middlingcommand,middling,middling) \
    using ($1*factorx-(word(xoffsets,i)+0)):($2) \
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
        set ytics 100000
        plot for [i=1:words(labels)] sprintf(wellform,word(files, i))." | ".sprintf(middlingcommand,middling,middling)\
        using ($1*factorx-(word(xoffsets,i)+0)):2 \
        title word(labels,i) with linespoints \
        pointtype word(symbols,i) lc rgb "black" font myfont tc rgb "black"
    }
}

