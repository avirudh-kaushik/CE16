#!/bin/sh

if [ $# -ne 1 ]
then
   echo "Error in $0 - Invalid Argument Count"
   echo "Syntax: $0 [inputFolderName]"
   exit
fi

inputName=$1
outputName=$1

zip -r $inputName $outputName
chmod 644 $outputName.zip

