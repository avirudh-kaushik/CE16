#!/usr/bin/perl

use CGI;

$outputFile="feedback.log";
$query = new CGI;

open(outFile, ">>$outputFile");
print outFile "**********************************\n";

($sec,$min,$hour,$mday,$mon,$year,$wday, $yday,$isdst)=localtime(time);
printf outFile "%4d-%02d-%02d %02d:%02d:%02d\n",$year+1900,$mon+1,$mday,$hour,$min,$sec;

foreach $field (sort ($query->param))
{
   foreach $value ($query->param($field))
   {
      print outFile "$field: $value\n\n"
   }
}
print outFile "**********************************\n\n";
close(outFile);

print "Content-type: text/html\n\n";
print << "EOF";
<html>
<head>
<title>Submitted!</title>
</head>

<body>

<br><br>
<center><h2>Thanks! Your feedback was submitted successfully</h2>
<br>
<a href="http://www.soe.ucsc.edu/~dhiranan/ce80n/">Click to return to the main p
age</a>
</center>
</body>
</html>
EOF
