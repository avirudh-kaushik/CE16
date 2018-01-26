#!/usr/bin/perl

use File::stat;
use POSIX qw(strftime);
use Digest::MD5 qw(md5 md5_hex md5_base64);

$inputFilename   = "CMPE80n_Winter11.csv";
$inputAnimals    = "animals.csv";
$outFilename     = "classCodes-new.dat";

my @animals;

open (inFile, "<". $inputFilename) or die("Can't open file");
open (inAnimals, "<". $inputAnimals) or die("Can't open file");
open (outFile, ">" . $outFilename) or die("Can't open file");

while ($line = <inAnimals>)
{
   my @newAnimals;

   @newAnimals = split(/,/, $line);
   chomp(@newAnimals);
   push(@animals, \@newAnimals);
   print "add @newAnimals[0], @newAnimals[1]\n";
}

$numStudents = 0;
while ($line = <inFile>)
{
   if ($numStudents >= 0)
   {
      my $studentKey;
      my @studentInfo = split(/,/, $line);
      chomp(@studentInfo);

      $id           = $studentInfo[0];
      $lastName     = $studentInfo[3];
      $firstName    = $studentInfo[1];

      if ($id eq "")
      {
         # No ID known, so make a random ID to prevent accessing the student's grade with only
         #  the last name. Also should prevent collisions between two potential students neither
         #  having known IDs. 
         $id = int(rand(10000000));
      }

      # Print the student's info so there is some feedback
      $studentKey = md5_hex($id . $lastName);
      print $id . ", " . $lastName . ", " . $firstName . ": " . $studentKey . "\n";

      # Choose an animal for the student
      my $animal;
      my $randNum;
      my $targetLetter;

      $randNum = int(rand(2));
      #$targetLetter = substr($lastName, 1, 1);
      $targetLetter = substr($firstName, 1, 1);
      $targetLetter = ord($targetLetter) - ord("a");

      $animal  = @animals[$targetLetter]->[$randNum];
      chomp($animal);

      print outFile "$studentKey## $animal\n";
   }
   $numStudents++;
}

close inFile;
close outFile;

