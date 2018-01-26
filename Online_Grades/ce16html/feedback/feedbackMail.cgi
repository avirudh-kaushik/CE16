#!/usr/bin/perl

use CGI;

$query = new CGI;

$sendmail = '/usr/sbin/sendmail'; # where is sendmail?
$recipient = 'veenstra@soe.ucsc.edu'; # who gets the form data?
$sender = 'CE80N Feedback <veenstra@ucsc.edu>'; # who is the default sender?

$mailBody ="";

($sec,$min,$hour,$mday,$mon,$year,$wday, $yday,$isdst)=localtime(time);
$mailBody = sprintf("%4d-%02d-%02d %02d:%02d:%02d\n\n",$year+1900,$mon+1,$mday,$hour,$min,$sec);

$mailBody .= $query->param('feedbackText');


# send the email message
open(MAIL, "|$sendmail -oi -t") or die "Can't open pipe to $sendmail: $!\n";
print MAIL "To: $recipient\n";
print MAIL "From: $sender\n"; 
print MAIL "Subject: CMPE80N Class Feedback\n\n";
print MAIL "$mailBody";
close(MAIL) or die "Can't close pipe to $sendmail: $!\n";

print "Content-type: text/html\n\n";
print << "EOF";
<html>
<head>
<title>Submitted!</title>
</head>

<body>

<br><br>
<center><h2>Thanks! Your feedback was submitted successfully</h2>
<!-- <center><h2>Feedback is disabled when the course is not in session</h2></center> -->
<br>
<a href="http://www.soe.ucsc.edu/~veenstra/ce80n/">Click to return to the main page</a>
</center>
</body>
</html>
EOF
