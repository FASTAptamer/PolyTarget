#!/usr/bin/env perl
## Written by KKA, Sept. 10th, 2014
## This script is designed to identify and score sequences that coenrich across
## PolyTarget selection trajectories. Input files should be in simple format and
## contain only those seqs that enriched or were newly/highly sampled from each 
## population, separated by a newline. 
use strict;
use diagnostics;
use warnings;
use Getopt::Long;
#-------------------------------------------------------------------------------
## command line flags
my $help;   
my $file_nc;
my $file_hxb2;
my $file_r277k;
my $file_94cy;
my $file_93th;
my $file_mvp;
my $file_tan1b;
my $file_eho;
my $file_out;
#-------------------------------------------------------------------------------
## command line options
GetOptions ( "nc=s" => \$file_nc,
             "hxb2=s" => \$file_hxb2,
             "r277k=s" => \$file_r277k,
             "94cy=s" => \$file_94cy,
             "93th=s" => \$file_93th,
             "mvp=s" => \$file_mvp,
             "tan1b=s" => \$file_tan1b,
             "eho=s" => \$file_eho,
             "outfile=s" => \$file_out,
             "help" => \$help);
#-------------------------------------------------------------------------------
## print help screen
if (defined $help){   
    print <<"HELP";
	
--------------------------------------------------------------------------------
Usage: coenrich.pl --nc [FILE] --hxb2 [FILE] --r277k [FILE] --94cy [FILE] 
                   --93th [FILE] --mvp [FILE] --tan1b [FILE] --eho [FILE]
                   --outfile [FILE] --help
--------------------------------------------------------------------------------

HELP
exit;
}
#-------------------------------------------------------------------------------
## open input files, create hash variables for sequence (key) & score (value)
open (FILE_nc, '<', $file_nc) or die
"\nCould not open input file nc, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_nc;

while (<FILE_nc>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_nc{$sequence} = 0.1;
  }
}

close FILE_nc;
#-------------------------------------------------------------------------------
open (FILE_hxb2, '<', $file_hxb2) or die
"\nCould not open input file hxb2, or no input file was specified.\n
See help documentation [-h] for program usage.\n";

my %hash_hxb2;

while (<FILE_hxb2>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_hxb2{$sequence} = 1;
  }
}

close FILE_hxb2;

#-------------------------------------------------------------------------------	
open (FILE_r277k, '<', $file_r277k) or die
"\nCould not open input file r277k, or no input file was specified.\n
See help documentation [-h] for program usage.\n";

my %hash_r277k;

while (<FILE_r277k>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_r277k{$sequence} = 10;
  }
}

close FILE_r277k;
#-------------------------------------------------------------------------------
open (FILE_94cy, '<', $file_94cy) or die
"\nCould not open input file 94cy, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_94cy;

while (<FILE_94cy>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_94cy{$sequence} = 100;
  }
}

close FILE_94cy;
#-------------------------------------------------------------------------------
open (FILE_93th, '<', $file_93th) or die
"\nCould not open input file 93th, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_93th;

while (<FILE_93th>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_93th{$sequence} = 1000;
  }
}

close FILE_93th;
#-------------------------------------------------------------------------------
open (FILE_mvp, '<', $file_mvp) or die
"\nCould not open input file mvp, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_mvp;

while (<FILE_mvp>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_mvp{$sequence} = 10000;
  }
}

close FILE_mvp;
#-------------------------------------------------------------------------------
open (FILE_tan1b, '<', $file_tan1b) or die
"\nCould not open input file tan1b, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_tan1b;

while (<FILE_tan1b>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_tan1b{$sequence} = 100000;
  }
}

close FILE_tan1b;
#-------------------------------------------------------------------------------
open (FILE_eho, '<', $file_eho) or die
"\nCould not open input file eho, or no input file was specified.\n
See help documentation [-h] for program usage.\n";	

my %hash_eho;

while (<FILE_eho>){
  if ($_ =~ /(\w+)/){			
    my $sequence = $1;
    $hash_eho{$sequence} = 1000000;
  }
}

close FILE_eho;
#-------------------------------------------------------------------------------
## open output file and print header
open (OUTPUT, '>', $file_out) or die
"\nCould not open output file, or no output file was specified.\n
See help documentation [-h] for program usage.\n";

print OUTPUT "Sequence\tScore\n";
#-------------------------------------------------------------------------------
## Iterate through each hash and find matches across other hashes - increase 
## score when found and print results for only those seqs that have a match
for my $sequence_in_nc (keys %hash_nc){  
  my $score_nc = $hash_nc{$sequence_in_nc};    
  delete $hash_nc{$sequence_in_nc};   
  if ($hash_hxb2{$sequence_in_nc}){    
    $score_nc += $hash_hxb2{$sequence_in_nc};
    delete $hash_hxb2{$sequence_in_nc};}    
  if ($hash_r277k{$sequence_in_nc}){    
    $score_nc += $hash_r277k{$sequence_in_nc};
    delete $hash_r277k{$sequence_in_nc};}
  if ($hash_94cy{$sequence_in_nc}){    
    $score_nc += $hash_94cy{$sequence_in_nc};
    delete $hash_94cy{$sequence_in_nc};}
  if ($hash_93th{$sequence_in_nc}){    
    $score_nc += $hash_93th{$sequence_in_nc};
    delete $hash_93th{$sequence_in_nc};}
  if ($hash_mvp{$sequence_in_nc}){    
    $score_nc += $hash_mvp{$sequence_in_nc};
    delete $hash_mvp{$sequence_in_nc};}
  if ($hash_tan1b{$sequence_in_nc}){    
    $score_nc += $hash_tan1b{$sequence_in_nc};
    delete $hash_tan1b{$sequence_in_nc};}
  if ($hash_eho{$sequence_in_nc}){    
    $score_nc += $hash_eho{$sequence_in_nc};
    delete $hash_eho{$sequence_in_nc};}
  if ($score_nc > 0.1){
    print OUTPUT "$sequence_in_nc\t$score_nc\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_hxb2 (keys %hash_hxb2){  
  my $score_hxb2 = $hash_hxb2{$sequence_in_hxb2};    
  delete $hash_hxb2{$sequence_in_hxb2};      
  if ($hash_r277k{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_r277k{$sequence_in_hxb2};
    delete $hash_r277k{$sequence_in_hxb2};}
  if ($hash_94cy{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_94cy{$sequence_in_hxb2};
    delete $hash_94cy{$sequence_in_hxb2};}
  if ($hash_93th{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_93th{$sequence_in_hxb2};
    delete $hash_93th{$sequence_in_hxb2};}
  if ($hash_mvp{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_mvp{$sequence_in_hxb2};
    delete $hash_mvp{$sequence_in_hxb2};}
  if ($hash_tan1b{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_tan1b{$sequence_in_hxb2};
    delete $hash_tan1b{$sequence_in_hxb2};}
  if ($hash_eho{$sequence_in_hxb2}){    
    $score_hxb2 += $hash_eho{$sequence_in_hxb2};
    delete $hash_eho{$sequence_in_hxb2};}
  if ($score_hxb2 > 1){
    print OUTPUT "$sequence_in_hxb2\t$score_hxb2\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_r277k (keys %hash_r277k){  
  my $score_r277k = $hash_r277k{$sequence_in_r277k};    
  delete $hash_r277k{$sequence_in_r277k};      
  if ($hash_94cy{$sequence_in_r277k}){    
    $score_r277k += $hash_94cy{$sequence_in_r277k};
    delete $hash_94cy{$sequence_in_r277k};}
  if ($hash_93th{$sequence_in_r277k}){    
    $score_r277k += $hash_93th{$sequence_in_r277k};
    delete $hash_93th{$sequence_in_r277k};}
  if ($hash_mvp{$sequence_in_r277k}){    
    $score_r277k += $hash_mvp{$sequence_in_r277k};
    delete $hash_mvp{$sequence_in_r277k};}
  if ($hash_tan1b{$sequence_in_r277k}){    
    $score_r277k += $hash_tan1b{$sequence_in_r277k};
    delete $hash_tan1b{$sequence_in_r277k};}
  if ($hash_eho{$sequence_in_r277k}){    
    $score_r277k += $hash_eho{$sequence_in_r277k};
    delete $hash_eho{$sequence_in_r277k};}
  if ($score_r277k > 10){
    print OUTPUT "$sequence_in_r277k\t$score_r277k\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_94cy (keys %hash_94cy){  
  my $score_94cy = $hash_94cy{$sequence_in_94cy};    
  delete $hash_94cy{$sequence_in_94cy};      
  if ($hash_93th{$sequence_in_94cy}){    
    $score_94cy += $hash_93th{$sequence_in_94cy};
    delete $hash_93th{$sequence_in_94cy};}
  if ($hash_mvp{$sequence_in_94cy}){    
    $score_94cy += $hash_mvp{$sequence_in_94cy};
    delete $hash_mvp{$sequence_in_94cy};}
  if ($hash_tan1b{$sequence_in_94cy}){    
    $score_94cy += $hash_tan1b{$sequence_in_94cy};
    delete $hash_tan1b{$sequence_in_94cy};}
  if ($hash_eho{$sequence_in_94cy}){    
    $score_94cy += $hash_eho{$sequence_in_94cy};
    delete $hash_eho{$sequence_in_94cy};}
  if ($score_94cy > 100){
    print OUTPUT "$sequence_in_94cy\t$score_94cy\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_93th (keys %hash_93th){  
  my $score_93th = $hash_93th{$sequence_in_93th};    
  delete $hash_93th{$sequence_in_93th};      
  if ($hash_mvp{$sequence_in_93th}){    
    $score_93th += $hash_mvp{$sequence_in_93th};
    delete $hash_mvp{$sequence_in_93th};}
  if ($hash_tan1b{$sequence_in_93th}){    
    $score_93th += $hash_tan1b{$sequence_in_93th};
    delete $hash_tan1b{$sequence_in_93th};}
  if ($hash_eho{$sequence_in_93th}){    
    $score_93th += $hash_eho{$sequence_in_93th};
    delete $hash_eho{$sequence_in_93th};}
  if ($score_93th > 1000){
    print OUTPUT "$sequence_in_93th\t$score_93th\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_mvp (keys %hash_mvp){  
  my $score_mvp = $hash_mvp{$sequence_in_mvp};    
  delete $hash_mvp{$sequence_in_mvp};      
  if ($hash_tan1b{$sequence_in_mvp}){    
    $score_mvp += $hash_tan1b{$sequence_in_mvp};
    delete $hash_tan1b{$sequence_in_mvp};}
  if ($hash_eho{$sequence_in_mvp}){    
    $score_mvp += $hash_eho{$sequence_in_mvp};
    delete $hash_eho{$sequence_in_mvp};}
  if ($score_mvp > 10000){
    print OUTPUT "$sequence_in_mvp\t$score_mvp\n";}
}
#-------------------------------------------------------------------------------
for my $sequence_in_tan1b (keys %hash_tan1b){  
  my $score_tan1b = $hash_tan1b{$sequence_in_tan1b};    
  delete $hash_tan1b{$sequence_in_tan1b};      
  if ($hash_eho{$sequence_in_tan1b}){    
    $score_tan1b += $hash_eho{$sequence_in_tan1b};
    delete $hash_eho{$sequence_in_tan1b};}
  if ($score_tan1b > 100000){
    print OUTPUT "$sequence_in_tan1b\t$score_tan1b\n";}
}
#-------------------------------------------------------------------------------

close OUTPUT;