reset
set term push
set terminal epslatex color colortext
set output "treemapb.tex"

set termoption enhanced
set encoding utf8
set key left center
set datafile missing NaN


set xlabel "n"
    
set ylabel "time in µs"


set key left top




plot "benchitree.dat" u 1:2 w lines  title "add", \
     "benchitree.dat" u 1:3 w lines  title "lookup", \
     "benchitree.dat" u 1:4 w lines  title "remove", \
     "benchimap.dat" u 1:2 w lines  title "add(Map)", \
     "benchimap.dat" u 1:3 w lines  title "lookup(Map)", \
     "benchimap.dat" u 1:4 w lines  title "remove(Map)"

set output
set term pop

     

