#!/bin/bash

#This is command to search for the name of the Quarter
#And replace it with the name of the Current Quarter.

find . -type f -exec sed -i 's/Winter/Winter/g' {} +

#This is the Command to Find and replace a Year
#Comment this out if the year remains the same

find . -type f -exec sed -i 's/2017/2018/g' {} +


