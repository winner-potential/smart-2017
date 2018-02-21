set style histogram gap 1.0
#set boxwidth 2.0 relative
set key autotitle columnheader
set style data histograms
set style fill pattern border

set datafile separator " "
set decimalsign '.'

unset border
set border 3

set terminal pdf size 10cm,6cm enhanced font 'Monospace,8' linewidth 1 rounded dashed
set output filename."_plot".".pdf"
myfont = "Monospace,10"

unset xlabel
unset ylabel
set bmargin 2.5
set label 1 "Amount of messages per second" at screen 0.5,0.03 center
set lmargin 10.0
set label 2 "mean response time [ms]" at screen 0.02,0.5 rotate by 90 center

groupsize=3.0

set style textbox opaque noborder

set multiplot layout 1,1 margins 0.1,0.98,0.1,0.98 spacing 0.00,0.05
    set key left top
    set key box linetype 1 linecolor '#000000' linewidth 2
    set key width +1
    set key spacing 1.5
    set key opaque
    unset xtics
    set xtics nomirror
    #unset ytics
    set ytics (1,10,100,1000,10000,100000) nomirror
    set logscale y 10
    set yrange [x0:x2]
    plot    filename using 2:xtic(1) lt -1, \
            filename using ($0-0.25):2:(sprintf("%1.0f",$2)) with labels offset 0,0.8 boxed notitle, \
            filename using 3:xtic(1) lt -1, \
            filename using ($0-0.00):3:(sprintf("%1.0f",$3)) with labels offset 0,0.8 boxed notitle, \
            filename using 4:xtic(1) lt -1, \
            filename using ($0+0.25):4:(sprintf("%1.0f",$4)) with labels offset 0,0.8 boxed notitle
