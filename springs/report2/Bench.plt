reset
set term push
set terminal epslatex color colortext
set output "mehhh.tex"

set termoption enhanced
set encoding utf8
set key left center
set datafile missing NaN

set logscale
set xlabel "n"
set yrange [0:1*10**10]



set ylabel "time in µs"


set key left top




plot "datahi.dat" u 1:2 w lines  title "dynamic", \
     "datalow.dat" u 1:2 w lines  title "non dynamic" ,\
     x*log(x) w lines title"$nlog(n)$", \
     2**x w lines title"$2^n$"

set output
set term pop

     

