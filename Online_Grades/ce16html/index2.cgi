#!/usr/bin/perl

use File::stat;
use Time::localtime;
use POSIX qw(strftime);

system( "sh /soe/avirudh/.html/ce16/siteCounter.sh");
#system( "sh /soe/dhiranan/.html/ce80n/downLecs.sh");

print "Content-type: text/html\n\n";
print << "EOF";
<HTML>
<HEAD>
<TITLE>CMPE 80N Winter 2016 Class Info</TITLE>
</HEAD>
<BODY>

<center><H2>CMPE 80N Winter 2016 Class Info</H2></center>
EOF

#<TABLE align="center" cellpadding="2">
#
#
#<!-- *** BEGIN Lecture Section *** -->
#<TR>
#<TD ALIGN="center"><STRONG>Lecture</STRONG></TD>
#<TD ALIGN="center"><STRONG>Date Collected</STRONG></TD>
#</TR>
#
#EOF
#
#$lectureLoop=1;
#$lectureNum=1;
#$options="";
#
#while ($lectureLoop)
#{
#   $lectureName=sprintf("lecture%02d.zip",$lectureNum);
#   $lectureNameB=sprintf("lecture%02db.zip",$lectureNum);
#   if (-e "$lectureName")
#   {
#      $date = ctime(stat($lectureName)->mtime);
#      $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='lecture%02d.zip'>Lecture %02d</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n",$lectureNum,$lectureNum, $date);
#   }
#   else
#   {
#      $lectureLoop=0;
#      if ($lectureNum == 1)
#      {
#         $options=sprintf("\t<TR>\n\t\t<TD align='center' colspan='2'>\n\t\t\tNo lectures yet\n\t\t</TD>\n\t</TR>\n");
#      }
#   }
#   
#   # Corner case if named unconventially
#   if (-e "$lectureNameB")
#   {
#      $date = ctime(stat($lectureNameB)->mtime);
#      $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='lecture%02db.zip'>Lecture %02db</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n",$lectureNum,$lectureNum, $date);
#   }
#
#   $lectureNum++;
#   # Lectures to skip over
#   #if ($lectureNum == 13)
#   #{
#   #   $lectureNum++;
#   #}
#}
#
#print << "EOF";
#$options
#
#</TABLE>
#<br>
#<!-- *** END Lecture Section *** -->
#EOF


$quizLoop=1;
$quizNum=1;
$options="";
while ($quizLoop)
{
   if ($quizNum <= 10)
   {
      $quizName=sprintf("scores\/quiz%d.jpg",$quizNum);
   }
   else
   {
      $quizLoop = 0;
      $quizName=sprintf("scores\/quizAll.jpg");
   }
   
   if (-e "$quizName")
   {
      $date = ctime(stat($quizName)->mtime);

      if ($quizNum <= 10)
      {
         $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='$quizName'>Quiz %02d</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n",$quizNum, $date);
      }
      else
      {
         $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='$quizName'>Quiz All</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n", $date);
      }
   }
   else
   {
      if ($quizNum == 1)
      {
         $options=sprintf("\t<TR>\n\t\t<TD align='center' colspan='2'>\n\t\t\tNo quiz grades yet\n\t\t</TD>\n\t</TR>\n");
      }
   }

   $quizNum++;
}

print << "EOF";
<!-- *** BEGIN Quiz Section *** -->
<TABLE align="center" cellpadding="2">

<TR>
<TD ALIGN="center"><STRONG>Quiz Statistics</STRONG></TD>
<TD ALIGN="center"><STRONG>Date Generated</STRONG></TD>
</TR>

$options
</TABLE>
<!-- *** END Quiz Section *** -->
<br>
EOF

#$labLoop=1;
#$labNum=1;
#$options="";
#while ($labLoop)
#{
#   $labName=sprintf("scores\/lab%d.jpg",$labNum);
#   if (-e "$labName")
#   {
#      $date = ctime(stat($labName)->mtime);
#      $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='$labName'>Lab %02d</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n",$labNum, $date);
#   }
#   else
#   {
#      $labLoop=0;
#      if ($labNum == 1)
#      {
#         $options=sprintf("\t<TR>\n\t\t<TD align='center' colspan='2'>\n\t\t\tNo lab grades yet\n\t\t</TD>\n\t</TR>\n");
#      }
#   }
#
#   $labNum++;
#}
#
#print << "EOF";
#<!-- *** BEGIN Lab Section *** -->
#<TABLE align="center" cellpadding="2">
#
#<TR>
#<TD ALIGN="center"><STRONG>Lab Statistics</STRONG></TD>
#<TD ALIGN="center"><STRONG>Date Generated</STRONG></TD>
#</TR>
#
#$options
#</TABLE>
#<!-- *** END Lab Section *** -->
#<br>
#EOF
#
#$testLoop=1;
#$testNum=1;
#$options="";
#while ($testLoop)
#{
#   $testName=sprintf("scores\/test%d.jpg",$testNum);
#   if (-e "$testName")
#   {
#      $date = ctime(stat($testName)->mtime);
#      $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='$testName'>Test %02d</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n",$testNum, $date);
#   }
#   else
#   {
#      $testLoop=0;
#      if ($testNum == 1)
#      {
#         $options=sprintf("\t<TR>\n\t\t<TD align='center' colspan='2'>\n\t\t\tNo test grades yet\n\t\t</TD>\n\t</TR>\n");
#      }
#   }
#
#   $testNum++;
#}
#
#print << "EOF";
#<!-- *** BEGIN Test Section *** -->
#<TABLE align="center" cellpadding="2">
#
#<TR>
#<TD ALIGN="center"><STRONG>Test Statistics</STRONG></TD>
#<TD ALIGN="center"><STRONG>Date Generated</STRONG></TD>
#</TR>
#
#$options
#</TABLE>
#<!-- *** END Test Section *** -->
#<br>
#EOF
#
#
#$options="";
#$finalGradesName=sprintf("scores\/finalGrades.jpg");
#if (-e "$finalGradesName")
#{
#   $date = ctime(stat($finalGradesName)->mtime);
#   $options=$options . sprintf("\t<TR>\n\t\t<TD align='center'>\n\t\t\t<a href='$finalGradesName'>Total Grades</a>\n\t\t</TD>\n\t\t<TD align='center'>%s</TD>\n\t</TR>\n", $date);
#}
#
#print << "EOF";
#<!-- *** BEGIN Final Grade Section *** -->
#<TABLE align="center" cellpadding="2">
#
#<TR>
#<TD ALIGN="center"><STRONG>Final Grade Statistics</STRONG></TD>
#<TD ALIGN="center"><STRONG>Date Generated</STRONG></TD>
#</TR>
#
#$options
#</TABLE>
#<!-- *** END Final Grade Section *** -->
#<br>


print << "EOF";
<br>
<p align="center"><a href="grades/">View your grades here</a></p>

<h5><i><center>Page and scripts created by Daniel Hiranandani 2011.
<br>Problems? Email <img src="emailAddress.png">, <a href="feedback/">or give anonymous feedback here</a></center></i></h5>


</BODY>
</HTML>
EOF

