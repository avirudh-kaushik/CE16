#!/usr/bin/perl

use File::stat;
use Time::localtime;
use POSIX qw(strftime);

$dateFilename = "/soe/avirudh/ce16/dateFile.dat";

# Get the date that the grades were last updated
open (dateFile, "<" . $dateFilename);
$date = <dateFile>;
close (dateFile);
chomp($date);


print "Content-type: text/html\n\n";
print << "EOF";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Class Grades for CMPE16 Winter 2018</title>

<script language="javascript" type="text/javascript">

</script>

</head>

<body>
<br />
<br />
<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><b>Get Class Grades for CMPE16 Winter 2018</b></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <form id="form" name="form" method="post" action="getGrades.cgi">
  <tr>
    <td align="center">Last Name: <input name="lastName" type="text" size="30" maxlength="50" placeholder="last name" />
    <br />
    Student ID: <input name="id" type="password" size="30" maxlength="50" placeholder="7 digits of student id" />
    </td>
  </tr>
  <tr>
    <td align="center"></td>
  </tr>
  <tr>
    <td align="center"></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center">
      <input type="submit" name="submit" id="submit" value="Submit" />
    </td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center">Grades Last Updated: <i>$date</i></td>
  </tr>
  <tr>
    <td align="center"><a href="faq.html">Frequently Asked Questions</a></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><!--<h5>Last Name is first-letter capitalized (multiple or hyphenated last names must also be capitalized).<br />-->
      Student ID is 7 digits and only numbers.<br />
      <br />
    Example for John Smith, ID -W1234567<br />
    Last Name: Smith, Student ID: 1234567</h5></td>
  </tr>
  </form>
</table>
<h5><i><center>Page and scripts created by Daniel Hiranandani 2011. Maintained by Avirudh Kaushik
<br>Problems? Email your Instructor 

</body>
</html>

EOF

