#!/bin/sh

# Setup counters that will increment the quiz/test/lab numbers
script="gnuplotCommands.p"

# Collect test info
#perl /soe/jlmathew/.html/ce80n/scores/gradeCounter.pl > testScores.dat

#for type in 'quiz' 'lab' 'test'
for type in 'quiz' 'lab' 
do
   echo "$type"
   num=1
   loop=1
   while [ $loop -eq 1 ]
   do
      # Check to see if the graph doesn't exist
      if [ ! -f "$type$num.jpg" ]
      then
         # This doesn't exist, create a gnuplot script to create it
         `/soe/jlmathew/.html/ce80n/scores/createGnuplotScript.sh $type $num`
         if `gnuplot $script`; then
            # Succeded in creating the plot, so make it readable
            `chmod 644 "$type$num.jpg"`

            # Next time we'll try to get the next plot 
            num=`expr $num + 1`
         else
            # Failed at creating the plot, assume no others exist
            loop=0

            # Delete the partially created one
            `rm "$type$num.jpg"`
         fi
      else
         num=`expr $num + 1`
      fi
   done
done
