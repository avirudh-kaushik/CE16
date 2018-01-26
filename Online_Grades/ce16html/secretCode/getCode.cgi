#!/usr/bin/perl

use CGI;
use File::stat;
use POSIX qw(strftime);
use Digest::MD5 qw(md5 md5_hex md5_base64);

$inputFilename = "classCodes.dat";

# Set default responses
$success      = "No";
$errorCode    = "";

# Get random image from /images/ directory
opendir my($dh), "../grades/images";
my @images = readdir $dh;
closedir $dh;

# Get random image ignoring the first two files (. and ..)
$randomImage = int(rand(@images - 2)) + 2;

$query = new CGI;

# Get the user's input
$lastName = $query->param('lastName');
chomp($lastName);
$lastName =~ s/^\s+//;
$lastName =~ s/\s+$//;

$lastName = ucfirst($lastName);
if (!($lastName =~ /^[A-Z].*$/))
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
   # Set default grade response
   $studentCode = "No data available for [$lastName, $id] - <br>If your name and ID are correct then please email <a href='mailto:dhiranan\@soe.ucsc.edu'>dhiranan\@soe.ucsc.edu</a> with your name and ID because you're not in our list..";

   # Calculate hash for the user
   $studentKey = md5_hex($id . $lastName);
   chomp($studentKey);

   # Open grade data file and look for student's id
   open(inFile, "<" . $inputFilename);
   while ($line = <inFile>)
   {
      # '##' is the delimeter between key and data
      my @lineArray = split(/##/, $line);
      chomp(@lineArray);
      #print "$line : $studentKey\n";

      if ($lineArray[0] eq $studentKey)
      {
         # Found the student we're interested in
         $studentCode = $lineArray[1];
         $success = "Yes";
         break;
      }
   }

   close(inFile);
}

# Write to the log file with the entered data
system( "sh /soe/dhiranan/.html/ce80n/grades/siteCounter.sh '$lastName' '$id' '$success' '$errorCode'");

# See if the deadline has passed and hide teh code if it has
@timeData = localtime(time);
chomp(@timeData);
$min      = @timeData[1];
$hour     = @timeData[2];
$day      = @timeData[3];

if ($day > 03)
{
   $studentCode = "Secret Codes ended on 11/03/2011 at 6:00:00pm";
}
elsif ($day == 03)
{
   if ($hour >= 18)
   {
      $studentCode = "Secret Codes ended on 11/03/2011 at 6:00:00pm";
   }
}

$secretCode = "";
if ($errorCode eq "")
{
   $secretCode = "<h2>***&nbsp;&nbsp;&nbsp;<b>$studentCode</b>&nbsp;&nbsp;&nbsp;***</h2>";
}

# Print the HTML
print "Content-type: text/html\n\n";
print << "EOF";
<html>
<head>
<title>CE80N Secret Code</title>
</head>

<body>

<br><br>
<center><h2>Secret Code for [$lastName]:</h2>
<b><h2>$errorCode</h2></b>
<br>
$secretCode
<br>
<b>Random Image:</b>
<br>
<img src="../grades/images/@images[$randomImage]">
<br><br>
<a href="http://www.soe.ucsc.edu/~dhiranan/ce80n/">Click to return to the main page</a>
</center>
<h5><i><center>Page and scripts created by Daniel Hiranandani 2011.
<br>Problems? Email <img src="../emailAddress.png"></center></i></h5>
<br>
</body>
</html>
EOF
