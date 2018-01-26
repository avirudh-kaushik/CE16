set term tgif
set nokey
set title 'CMPE80N Spring 2015 lab#2 Scores'
set xlabel 'Scores, Average: 0.00'
set ylabel 'Number of Students'
set xtics 1
set title 'CMPE80N Spring 2015 Final Exam Scores'
set xtics 0,10,114
set ytics 1
set title 'CMPE80N Spring 2015 Course Scores'
set xtics 0,10,100
set ytics 1
set output 'lab2.jpg'
set linestyle 2 lt 2 lw 1000
plot 'labScores.dat' using 1:3 with imp ls 2

