#!/usr/bin/perl

use CGI;
use File::stat;
use Time::localtime;
use POSIX qw(strftime);
use Digest::MD5 qw(md5 md5_hex md5_base64);

$inPath                  = "/soe/avirudh/ce16/homeDir/ce16/gradeData/";
$dateFilename            = "/soe/avirudh/ce16/homeDir/ce16/dateFile.dat";
$gradesAvailableFilename = "/soe/avirudh/ce16/homeDir/ce16/gradesAvailable.dat";

# Set default responses
$success      = "No";
$errorCode    = "";

# Get random image from /images/ directory
opendir my($dh), "images";
my @images = readdir $dh;
closedir $dh;

# Get random image ignoring the first two files (. and ..)
$randomImage = int(rand(@images - 2)) + 2;

$query = new CGI;

# Get the date that the grades were last updated
open (dateFile, "<" . $dateFilename);
$date = <dateFile>;
close (dateFile);
chomp($date);

# Get the user's input
$lastName = $query->param('lastName');
chomp($lastName);
$lastName =~ s/^\s+//;
$lastName =~ s/\s+$//;

$lastName = ucfirst($lastName);
#if (!($lastName =~ /^[A-Z].*$/))
if ((!($lastName =~ /^[A-Z].*$/)) || ($lastName =~ /^[A-Z]+$/))
{
   $errorCode .= " *Last Name is INVALID* ";
}

# Get the user's input
$id = $query->param('id');
chomp($id);
$id =~ s/^\s+//;
$id =~ s/\s+$//;

if (!($id =~ /^\d{7}$/))
{
   $errorCode .= " *ID is INVALID* ";
}

# Only open the grade file if we had valid inputs
if ($errorCode eq "")
{
   # Calculate hash for the user
   $studentKey = md5_hex($id . $lastName);
   chomp($studentKey);

   # Check to see if student's grade data file exists
   $inFilename = $inPath . $studentKey . ".dat";
   if (-e $inFilename)
   {
      open (inFile, "<" . $inFilename);
      $line = <inFile>;
      chomp($line);

      $studentGrade = $line;
      $success = "Yes";
   }
   else
   {
      if (-e $gradesAvailableFilename)
      {
         $studentGrade = "Student with Lastname: '$lastName', and ID: '$id' was not found in grading spreadsheet (i.e. We might not have your student ID, or you might not be logging in correctly).<br>Check the Frequently Asked Questions page for more information.";
      }
      else
      {
         $studentGrade = "No grades available yet, check back later.";
      }
      $success = "No";
   }

   close(inFile);
}

# Write to the log file with the entered data
system( "sh /soe/avirudh/.html/ce16/grades/siteCounter.sh '$lastName' '$id' '$success' '$errorCode'");

# Print the HTML
print "Content-type: text/html\n\n";
print << "EOF";
<html>
<head>
<title>CE16 Class Grades</title>
</head>

<body>

<br><br>
<center><h2>Grades for [$lastName] as of $date:</h2>
<b><h2>$errorCode</h2></b>
<table width="80%" border="1" cellpadding="3" cellspacing="0" align="center">
$studentGrade
</table>
<br><p><a href="faq.html">Frequently Asked Questions</a></p>
<b>Random Image:</b>
<br>
<img src="images/@images[$randomImage]">
<br><br>
<a href="javascript:location.reload(true)">Click here to reload this page</a>
<br>
<a href="http://www.soe.ucsc.edu/~avirudh/ce16/">Click to return to the main class page</a>
</center>
<h5><i><center>Page and scripts created by Daniel Hiranandani 2011. Maintained by Avirudh Kaushik.
<br>Problems? Email Your Instructor</center></i></h5>
<br>
</body>
</html>
EOF
