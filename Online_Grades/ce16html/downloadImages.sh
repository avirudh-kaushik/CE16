#!/bin/sh

if [ $# -ne 1 ]
then
   echo "Error in $0 - Invalid Argument Count"
   echo "Syntax: $0 [LectureNumber]"
   exit
fi

# Setup counters that will increment the download numbers
lectureNum=$1
slideNum=0
inkNum=1
wbNum=0
subNum=0
loopSlides=1
loopInks=1
loopWhiteboards=1
loopSubmissions=1
lastWhiteboardSeen=0

# Setup URL info that will be static
# Usage: $urlPrefix$slidePrefix-$slideNum-$inkNum.$slideExt
urlPrefix=http:\/\/up.soe.ucsc.edu\/classrooms\/F11CE80n\/lectures\/Lecture$lectureNum\/

# Manual version. Why was it ever named this way!?!?!?!
#urlPrefix=http:\/\/up.soe.ucsc.edu\/classrooms\/F11CE80n\/lectures\/ReviewLecture\/

# Lecture Slides
slidePrefix=slides\/sl
slideExt=png

# Whiteboards associated with the slides
whiteboardPrefix=slides\/wb
whiteboardExt=png

# Submission charts
submissionPrefix=submissions\/ss
submissionExt=png

# Setup wget options - one for testing if a file exists, one for downloading files
wgetDownload="wget -v -N -nd -w 0.5"
wgetTest="$wgetDownload --spider"

# Make download directory, don't give error if it already exists
mkdir -p lecture$lectureNum

# Set the local download directory
cd lecture$lectureNum


while [ $loopSlides -eq 1 ]
do
  loopInks=1
  inkNum=0

   # Check to see if there is a slide for this number, if so, look for inks
   if `$wgetTest $urlPrefix$slidePrefix-$slideNum-$inkNum.$slideExt`; then
      # Now loop through ink versions until we find the last one
      while [ $loopInks -eq 1 ]
      do
         if `$wgetTest $urlPrefix$slidePrefix-$slideNum-$inkNum.$slideExt`; then
            # This one exists, so look for the next one
            inkNum=$(($inkNum+1))
         else
            # They don't exist anymore, so we need to check if ANY inks exist
            #if [ $inkNum -eq 1 ]; then
            #   # This was the first, so download the non-ink version
            #   `$wgetDownload $urlPrefix$slidePrefix-$slideNum.$slideExt`;
            #else
               # Download the last valid ink num
               inkNum=$(($inkNum-1))
               `$wgetDownload $urlPrefix$slidePrefix-$slideNum-$inkNum.$slideExt`;
            #fi
            loopInks=0
         fi
      done
   else
      # This slide does not exist, so assume we are out of slides
      loopSlides=0

      # If this was the first slide, then we know the lecture doesn't exist yet
      if [ $slideNum -eq 0 ]; then
         exit -1
      fi
   fi

   slideNum=$(($slideNum+1))
done
# Now loop through whiteboard numbers to find any
loopWhiteboards=1
wbNum=0

while [ $loopWhiteboards -eq 1 ]
do
 loopInks=1
 inkNum=0
 
 if `$wgetTest $urlPrefix$whiteboardPrefix-$wbNum-$inkNum.$whiteboardExt`; then
    # This whiteboard does exist, now find the last ink iteration for it
    lastWhiteboardSeen=$wbNum

    while [ $loopInks -eq 1 ]
    do
       if `$wgetTest $urlPrefix$whiteboardPrefix-$wbNum-$inkNum.$whiteboardExt`; then
          # This one exists, so look for the next one
          inkNum=$(($inkNum+1))
       else
          # They don't exist anymore, so download the last valid ink num
          inkNum=$(($inkNum-1))
          `$wgetDownload $urlPrefix$whiteboardPrefix-$wbNum-$inkNum.$whiteboardExt`;
          loopInks=0
       fi
    done

    # Now we will look for the next whiteboard
    wbNum=$(($wbNum+1))
 else
    if [ $wbNum -eq 0 ]; then
       # There's a possibility the whiteboard number is something else, so try the hail mary (check the last known whiteboard number+1)
       wbNum=$(($lastWhiteboardSeen+1))
    else
       # No whiteboards exist for this slide, so stop checking for them
       loopWhiteboards=0
    fi
 fi
done

# Download Submission charts
loopSubmissions=1
subNum=0;
inkNum=0;

while [ $loopSubmissions -eq 1 ]
do
   # Check to see if there is a submission slide for this number and attempt to download it
   if `$wgetDownload $urlPrefix$submissionPrefix-$subNum-$inkNum.$submissionExt`; then
      # Got the submission so increase the counter and try the next one
      subNum=$(($subNum+1))
   else
      # This slide does not exist, so we are out of submission slides
      loopSubmissions=0
   fi
done

exit 0

