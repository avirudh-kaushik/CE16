#!/usr/bin/perl

use File::stat;
use Time::localtime;
use POSIX qw(strftime);
use Digest::MD5 qw(md5 md5_hex md5_base64);

# Setup I/O files and paths
$inputFilename   = "Grades.csv";
$outPath         = "/soe/avirudh/ce16/homeDir/ce16/gradeData/";
$dateFilename    = "dateFile.dat";

# Zero-based column numbers for the various graded items in the Google
# Spreadsheet
$firstTestScore  = 26;
$lastTestScore   = 25;	# Using $firstTestScore - 1 disabled test info.
$firstQuizScore  = 5;
$lastQuizScore   = 14;
$firstLabScore   = 16;
$lastLabScore    = 25;

# Number of lines to ignore in the CSV
$numIgnoredLines = 2;

open (inFile, "<". $inputFilename) or die("Can't open file");

# Write the datestamp for the grade file - keep track of how new these grades are
open (dateFile, ">" . $dateFilename) or die("Can't open file");
system("chmod 644 \"$inputFilename\"");
$date = ctime(stat($inputFilename)->mtime);
system("chmod 600 \"$inputFilename\"");
print dateFile "$date";
close (dateFile);

$numStudents = 0;
while ($line = <inFile>)
{
   if ($numStudents >= $numIgnoredLines)
   {
      my $gradeTitleLine;
      my $studentGradeLine;
      my $studentKey;

      my @quizScores;
      my @labScores;
      my @testScores;

      my @studentInfo = split(/,/, $line);
      my $numElements = @studentInfo;

      chomp(@studentInfo);

      # Grab data from the array of input, should probably have stored these zero-based
      #  column numbers above so that they're not magic numbers.
      $id           = $studentInfo[0];
      $firstName    = $studentInfo[1];
      $lastName     = $studentInfo[3];
      $letterGrade  = $studentInfo[31];
      $finalGrade   = $studentInfo[32];
      $quizAverage  = $studentInfo[15];
      $topQuizzes   = $studentInfo[27];
      $labAverage   = $studentInfo[26];


      if ($id eq "")
      {
         # No ID known, so skip this student's info.
         next;
      }

      # Print the student's info so there is some feedback to the screen
      $studentKey = md5_hex($id . $lastName);
      print $id . ", " . $lastName . ", " . $firstName . ": " . $studentKey . "\n";
      
      # Create output file for this student and protect its permissions
      my $outFilename = $studentKey . ".dat";
      open (outFile, ">" . $outPath . $outFilename) or die("Can't open file");
      system("chmod 600 $outPath$outFilename");

      $currentItem = $firstTestScore;
      while ($currentItem < $numElements && $currentItem >= $firstTestScore && $currentItem <= $lastTestScore)
      {
         # We have test score data
         if ($studentInfo[$currentItem] eq "")
         {
            # Removed adding a default 0 because now we keep track of "no score" with a dash
            #push(@testScores, 0);
         }
         else
         {
            #print "add test: $studentInfo[$currentItem]\n";
            push(@testScores, $studentInfo[$currentItem]);
         }
         $currentItem++;
      }
      
      $currentItem = $firstQuizScore;
      while ($currentItem < $numElements && $currentItem >= $firstQuizScore && $currentItem <= $lastQuizScore)
      {
         # We have quiz score data
         if ($studentInfo[$currentItem] eq "")
         {
            # Removed adding a default 0 because now we keep track of "no score" with a dash
            #print "add quiz: 0*\n";
            #push(@quizScores, 0);
         }
         else
         {
            #print "add quiz: $studentInfo[$currentItem]\n";
            push(@quizScores, $studentInfo[$currentItem]);
         }
         $currentItem++;
      }
      
      $currentItem = $firstLabScore;
      while ($currentItem < $numElements && $currentItem >= $firstLabScore && $currentItem <= $lastLabScore)
      {
         # We have lab score data
         if ($studentInfo[$currentItem] eq "")
         {
            # Removed adding a default 0 because now we keep track of "no score" with a dash
            #push(@labScores, "-");
         }
         else
         {
            #print "add lab: $studentInfo[$currentItem]\n";
            push(@labScores, $studentInfo[$currentItem]);
         }
         $currentItem++;
      }

      # Clear the variable that we'll store our output in
      $gradeTitleLine   = "<tr>";
      $studentGradeLine = "<tr>";
     
      # Run through the various arrays and construct the output HTML. This
      #  certainly doesn't need to be done in two passes (build arrays then output)
      #  but it allows for more logic to be done on the scores if we wanted to do
      #  some math in here before outputting instead of doing the calculations in
      #  the grading spreadsheet (like how we do the top quiz score calculation below).
      for ($i = 0; $i < @quizScores ; $i++)
      #for ($i = 0; $i < (@quizScores-1); $i++)
      {
         $gradeTitleLine .= "<td align='center'><a href='../scores/quiz" . ($i+1) . ".jpg' target='_blank'>Quiz #" . ($i+1) . "</a></td align='center'>";
         $studentGradeLine .= "<td align='center'>$quizScores[$i]</td align='center'>";
      }

#         $gradeTitleLine .= "<td align='center'><a href='../scores/quiz" . ($i+1) . ".jpg' target='_blank'>Extra Credit"  . "</a></td align='center'>";
#         $studentGradeLine .= "<td align='center'>$quizScores[$i]</td align='center'>";

      for ($i = 0; $i < @labScores; $i++)
      {
         $gradeTitleLine .= "<td align='center'><a href='../scores/lab" . ($i+1) . ".jpg' target='_blank'>HW  #" . ($i+1) . "</a></td align='center'>";
         $studentGradeLine .= "<td align='center'>$labScores[$i]</td align='center'>";
      }
      
      for ($i = 0; $i < @testScores; $i++)
      {
         # Only one test - the final, so we'll just call it the final
         $gradeTitleLine .= "<td align='center'><a href='../scores/test" . ($i+1) . ".jpg' target='_blank'>Final Exam</a></td align='center'>";
         $studentGradeLine .= "<td align='center'>$testScores[$i]</td align='center'>";
      }

      $numQuizzes = @quizScores;
      # Check to see if we have average quiz score data and enough quizzes to calculate the average
      if ($quizAverage eq "#NUM!")
      {
         # No average grade in the spreadsheet, ignore this case
      }
      elsif ($numQuizzes >= $topQuizzes)
      {
         #print "quizAverage: $quizAverage\n";
         $gradeTitleLine .= "<td align='center'>Top Quiz Average (Top $topQuizzes Scores)</td align='center'>";
         $studentGradeLine .= "<td align='center'>$quizAverage / 10</td align='center'>";
      }
      else
      {
         # Instead, we can calculate out current average
         #$currentQuizAverage = 0;
         #$currentQuizAverage = $quizAverage;
         #for ($i = 0; $i < @quizScores; $i++)
         #{
         #   %#$currentQuizAverage += $quizScores[$i];
         #}

         #$currentQuizAverage = sprintf("%.2f", $currentQuizAverage / @quizScores);
         $currentQuizAverage = sprintf("%.2f", $quizAverage );
         $gradeTitleLine .= "<td align='center'>Current Quiz Average</td align='center'>";
         $studentGradeLine .= "<td align='center'>$currentQuizAverage / 100</td align='center'>";
      }

      $numLabs = @labScores;
      # Check to see if we have average lab score data
      if ($labAverage eq "#NUM!")
      {
         # No average grade in the spreadsheet, ignore this case
      }
      elsif (@labScores > 0)
      {
         # Instead, we can calculate out current average
         #$labAverage = 0;
         #for ($i = 0; $i < @labScores; $i++)
         #{
         #   $labAverage += $labScores[$i];
         #}

         #$labAverage = sprintf("%.2f", $labAverage / @labScores);
         $labAverage = sprintf("%.2f", $labAverage );
         $gradeTitleLine .= "<td align='center'>Current HW Average</td align='center'>";
         $studentGradeLine .= "<td align='center'>$labAverage / 10</td align='center'>";
      }

#       if (!($finalGrade eq ""))
#       {
#          #print "finalGrade: $finalGrade\n";
#          $gradeTitleLine .= "<td align='center'><a href='../scores/finalGrades.jpg' target='_blank'>Total Grade</a></td align='center'>";
#          $studentGradeLine .= "<td align='center'>$finalGrade</td align='center'>";
#       }
#
#       if (!($letterGrade eq ""))
#       {
#          #print "letterGrade: $letterGrade\n";
#          $gradeTitleLine .= "<td align='center'>Final Letter Grade</td align='center'>";
#          $studentGradeLine .= "<td align='center'>$letterGrade</td align='center'>";
#       }

      print outFile "$gradeTitleLine $studentGradeLine\n";
      close outFile;
   }
   $numStudents++;
}

close inFile;

