#!/bin/sh

# Setup counters that will increment the download numbers
lectureNum=1
loopLectures=1


while [ $loopLectures -eq 1 ]
do
   if [ $lectureNum -lt 10 ]; then
      lectureNumFormatted="0"$lectureNum
   else
      lectureNumFormatted=$lectureNum
   fi

   # Check to see if there is a zip archive for this lecture
   if [ ! -f "lecture$lectureNumFormatted.zip" ]
   then
      # This lecture does not exist, so try to download it
      if `/soe/dhiranan/.html/ce80n/downloadImages.sh $lectureNumFormatted`; then
         # Now the folder exists, create the zip
         `/soe/dhiranan/.html/ce80n/createZip.sh "lecture$lectureNumFormatted"`
      else
         if `/soe/dhiranan/.html/ce80n/downloadImages.sh $lectureNum`; then
            mv lecture$lectureNum lecture$lectureNumFormatted

            `/soe/dhiranan/.html/ce80n/createZip.sh "lecture$lectureNumFormatted"`
         else
            # The lecture doesn't exist yet
            loopLectures=0
            rmdir lecture$lectureNum
            rmdir lecture$lectureNumFormatted
         fi
      fi
   fi

   lectureNum=$(($lectureNum+1))
done

