set term jpeg
set nokey
set title 'CMPE80N Spring 2018 Total Final Grade Scores'
set xlabel 'Scores'
set ylabel 'Number of Students'
set xtics 1
set xtics 0,10,100
set output 'finalGrades.jpg'
set style line 2 lt 2 lw 1000
plot 'finalGrades.dat' using 1:2 with imp ls 2

