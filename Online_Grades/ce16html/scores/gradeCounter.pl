#!/usr/bin/perl

use Fcntl;

my %gradeHash;
my $line;
my $i;

for ($i = 0; $i <= 100; $i++)
{
   $gradeHash{$i} = 0;
}

open(GRADES, "rawData.dat");
while ($line = <GRADES>)
{
   chomp($line);
   if ($line)
   {
      if ($line > 0)
      {
         $gradeHash{$line} += 1;
      }
   }
}
close(GRADES);

print 0 . "\t" . 0 . "\n";

foreach $key (sort keys %gradeHash)
{
   if ($gradeHash{$key} > 0)
   {
      print $key . "\t" . $gradeHash{$key} . "\n";
   }
}

