#!/usr/bin/perl

use File::stat;

$outFilename       = "scores.dat";
$numHeaderLines    = 1;
$delimiter         = ",";
$numArguments      = 3;

if ($#ARGV != ($numArguments - 1))
{
   print "Usage: 'scoreCount [inputFilename] [numberOfColumnToCountOccurences] [includeNonNumerics]'\n";
   print "Ex: 'scoreCount file.dat 9 1' Counts column 9 with only numeric values\n";
   print "Ex: 'scoreCount file.dat 1 0' Counts column 1 including non-numeric values\n";
   exit;
}

$inputFilename      = $ARGV[0];
$interestedColumn   = $ARGV[1];
$includeNonNumeric  = $ARGV[2];

my %scores;
$minScore = 0;
$maxScore = 100;

# Initialize the hash to contain 0 elements for all possible scores
for ($i = $minScore; $i < $maxScore; $i++)
{
   $scores{$i} = 0;
}

open (inFile, "<". $inputFilename) or die("Can't open file");
open (outFile, ">" . $outFilename) or die("Can't open file");

$numStudents = 0;
while ($line = <inFile>)
{
   if ($numStudents >= $numHeaderLines)
   {
      my @studentInfo = split(/$delimiter/, $line);
      my $numElements = @studentInfo;

      chomp(@studentInfo);

      my $key = $studentInfo[$interestedColumn];

      # Include non-numerics if desired, otherwise must be numeric
      if ($includeNonNumeric || $key =~ /^\d+$/)
      {
         # Add this score to the hash by incrementing that bin's counter
         $scores{$studentInfo[$interestedColumn]}++;
         #print "@studentInfo, score: $studentInfo[$interestedColumn]\n";
      }
   }
   $numStudents++;
}

# Add a min score entry to help gnuplot scale the X axis
print outFile "$minScore 0\n";

# Print all the real score entries
foreach $value (sort keys %scores)
{
   # Don't print scores with 0 tests that achieved that score
   if ($scores{$value} > 0)
   {
      print "$value $scores{$value}\n";
      print outFile "$value $scores{$value}\n";
   }
}

# Add a max score entry to help gnuplot scale the X axis
print outFile "$maxScore 0\n";

close inFile;
close outFile;

