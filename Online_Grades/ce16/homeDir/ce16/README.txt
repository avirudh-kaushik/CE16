Online Grade Retrieval 2011
Daniel Hiranandani
dhiranan@soe.ucsc.edu
* Please keep this readme and the HTML footers intact when using this code *

Brief overview of this project at http://www.danielhira.com/2011/04/23/grade-retrieval-site/

Quick Notes:
 - Set filename for the CSV grade file and output path in newGrades.pl
 - Some paths/email addresses will need to be updates. Grep for dhiranan.
 - If gradesAvailable.dat doesn't exist, an error message appears for anyone accessing grades. This is to show a difference between no grades entered and no student recognized in the spreadsheet. Normal usage occurs when gradesAvailable.dat exists and has at least 600 permissions.
 - Some things like Final Letter Grade and Final Grade should be commented out
   in newGrades.pl until you want it exposed. Eventually planned to add flags
   to turn things like that on/off.
 - newGrades.pl stores all of the grade data before writing it to the hashed
   grade file. Not really necessary, but allows for more calculations like the
   Current Quiz Average vs. the Top Quiz Average.

Usage:
 - After setting the CSV filename and output path, just run ./newGrades.pl. It
   will output each student's grade data to the specified directory buried
   somewhere in your ~/.html/ directory. Updates happen by running the same
   script and automatically overwriting the existing data.
