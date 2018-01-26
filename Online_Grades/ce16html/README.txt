Online Grade Retrieval 2011
Daniel Hiranandani
dhiranan@soe.ucsc.edu
* Please keep this readme and the HTML footers intact when using this code *

Brief overview of this project at http://www.danielhira.com/2011/04/23/grade-retrieval-site/

Quick Notes:
 - When in doubt, files that should be accessible to the world are 644,
   directories are 755. Files that should NOT be accessible are 600.
 - index.cgi will automatically find and list files that should be displayed (lectures,
   quiz/lab/test score plots).
 - You will need to update some paths, email addresses, and class names. Grep
   for dhiranan and Winter/Winter/Spring.
 - downloadImages.sh downloads the slides for a specified lecture off of the
   UP site. createZip creates a zip of that specified directory and sets the
   permissions. downLecs.sh loops through the lectures that haven't been
   downloaded until it finds one that doesn't exist then stops. It knows which
   ones already exist by which lecture##.zip files exist in the same
   directory.
 - The Feedback stuff will email you anonymous feedback. Pretty
   straightforward.
 - Grades is self contained since it just retrieves whatever newGrades.pl
   outputs. There is a log file called site.log which shows how people try to
   log in. Useful to figure out why a person has issues accessing their
   grades.
 - Scores plots the grade distributions. This data is unfortunately manually entered into the *.dat files, and then plotScores.sh is run which crates gnuplot scripts and outputs the jpg files.
 - SecretCode generates animal names to match with student names. *New matches
   are made every time newAnimals.pl is run*. Eventually should be converted
   to store each user's data individually like the grades are now instead of
   storing all data in one .dat file.

Usage:
 - Manually add data to ___Scores.dat based on the Google Spreadsheet stats.
   Run PlotScores.sh to generate the graphs.
   Run newGrades.pl to generate individual user grades.
