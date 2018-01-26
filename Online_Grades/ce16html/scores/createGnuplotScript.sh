#!/bin/sh

if [ $# -ne 2 ]
then
   echo "Error in $0 - Invalid argument count"
   echo "Syntax: $0 [type(lab,quiz,test)] [number]"
   exit
fi

type=$1
num=$2
columnNum=`expr $num + 1`
script="gnuplotCommands.p"
scoresFile=$type"Scores.dat"
statsFile=$type"Stats.dat"
noStatsFile=0
addTrendlines=1

if [ -f $statsFile ]; then
   avg=`head -$num $statsFile | tail -1`
   avg=`echo $avg | sed 's///'`
else
   noStatsFile=1
fi

# Kludge "All" plot with column 11
if [ $num -eq 11 ]
then
   num="All"
#   columnNum=25
fi

echo "set term tgif" > $script
echo "set nokey" >> $script
echo "set title 'CMPE80N Spring 2015 $type#$num Scores'" >> $script

if [ $noStatsFile -eq 0 ]; then
   echo "set xlabel 'Scores, Average: $avg'" >> $script
else
   echo "set xlabel 'Scores'" >> $script
fi

echo "set ylabel 'Number of Students'" >> $script

#if [ $type -eq "lab" ]; then
#   echo "set xtics ('C' 1, 'B' 2, 'A' 3)" >> $script
#else
   echo "set xtics 1" >> $script
#fi

if [ $type -eq "test" ]; then
   echo "set title 'CMPE80N Spring 2015 Final Exam Scores'" >> $script
   echo "set xtics 0,10,114" >> $script
   echo "set ytics 1" >> $script
   addTrendlines=0
fi

if [ $type -eq "course" ]; then
   echo "set title 'CMPE80N Spring 2015 Course Scores'" >> $script
   echo "set xtics 0,10,100" >> $script
   echo "set ytics 1" >> $script
   addTrendlines=0
fi

echo "set output '$type$num.jpg'" >> $script
#echo "set style line 2 lt 2 lw 1000" >> $script
echo "set linestyle 2 lt 2 lw 1000" >> $script

if [ $addTrendlines -eq 1 ]; then
   echo "plot '$scoresFile' using 1:$columnNum with imp ls 2,\\" >> $script
   echo "'$scoresFile' using 1:$columnNum smooth bezier with lines" >> $script
else
   echo "plot '$scoresFile' using 1:$columnNum with imp ls 2" >> $script
fi

echo "" >> $script

