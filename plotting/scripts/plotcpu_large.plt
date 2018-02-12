reset

counter = 0

min(a,b) = a >= b ? b : a
samples(n) = min(int($0), n)
avg_data = ""

sum_n(data, n) = ( n <= 0 ? 0 : word(data, words(data) - n) + sum_n(data, n - 1))
#counter= (counter==middling) ? 0 : counter+1, 
avg(x, n) = (avg_data = sprintf("%s %f", (int($0)==0)?"":avg_data, x), sum_n(avg_data, samples(n))/samples(n)) 

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
set output outputfilename
myfont = "Monospace,10"

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
set ytics nomirror
set grid ytics
if (words(parts)>0){
    set multiplot layout words(parts), 1
    set xrange [*:word(parts,1)]
    plot for [i=1:words(labels)] word(files, i) \
    using ($1*factorx-(word(xoffsets,i)+0)):column \
    title word(labels,i) with linespoints \
    pointtype word(symbols,i) lc rgb "black" font myfont
    
    do for [j=2:words(parts)] {
        unset key
        unset xlabel
        unset ylabel
        set xrange [word(parts,j-1):word(parts,j)]
        plot for [i=1:words(labels)] word(files, i) every middling \
        using ($1*factorx-(word(xoffsets,i)+0)):(avg(column(column),middling)) \
        title word(labels,i) with linespoints \
        pointtype word(symbols,i) lc rgb "black" font myfont tc rgb "black"
    }
}else{
    set xrange [*:*]
    plot for [i=1:words(labels)] word(files, i) \
    using ($1*factorx-(word(xoffsets,i)+0)):column \
    title word(labels,i) with linespoints \
    pointtype word(symbols,i) lc rgb "black" font myfont
}

