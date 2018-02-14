reset

middlingcommand="<awk 'BEGIN{}(NR<1){sum=0}{sum=sum+%s}(NR%%%s==0){print $1,sum/%s;sum=0}END{}' %s"
#sprintf(command,"$2","10","10.0","testdata.txt") using 1:2 with linespoints

check=middling
a1 = 0
c1 = 0
a2 = 0
c2 = 0
a3 = 0
c3 = 0
a4 = 0
c4 = 0
a5 = 0
c5 = 0
getAmount(n) = (ret = NaN, ret=(n==1) ? a1 : ret,ret=(n==2) ? a2 : ret,ret=(n==3) ? a3 : ret,ret=(n==4) ? a4 : ret,ret=(n==5) ? a5 : ret,ret)
getCount(n) = (ret = NaN, ret=(n==1) ? c1 : ret,ret=(n==2) ? c2 : ret,ret=(n==3) ? c3 : ret,ret=(n==4) ? c4 : ret,ret=(n==5) ? c5 : ret,ret)
setAmount(n,x) = (a1=(n==1) ? x : a1,a2=(n==2) ? x : a2,a3=(n==3) ? x : a3,a4=(n==4) ? x : a4,a5=(n==5) ? x : a5)
setCount(n,x) = (c1=(n==1) ? x : c1,c2=(n==2) ? x : c2,c3=(n==3) ? x : c3,c4=(n==4) ? x : c4,c5=(n==5) ? x : c5)
recmean(x,i) = (amount=getAmount(i),count=getCount(i),ret = NaN, amount=amount+x, count = count + 1, ret=(count==check) ? amount/count : ret, amount=(count==check) ? 0 : amount, count=(count==check) ? 0:count, amount=setAmount(i,amount),count=setCount(i,count),ret)

counter = 0
min(a,b) = a >= b ? b : a
samples(n) = min(int($0), n)
avg_data = ""

sum_n(data, n) = ( n <= 0 ? 0 : word(data, words(data) - n) + sum_n(data, n - 1))
#counter= (counter==middling) ? 0 : counter+1, 
avg(x, n) = (avg_data = sprintf("%s %f", (int($0)==0)?"":avg_data, x), sum_n(avg_data, samples(n))/samples(n)) 

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
        plot for [i=1:words(labels)] sprintf(middlingcommand,"$".column,middling,middling,word(files, i)) \
        using ($1*factorx-(word(xoffsets,i)+0)):2 \
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

