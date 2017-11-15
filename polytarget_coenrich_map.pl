#!/usr/bin/env perl

use strict;
use warnings;
use diagnostics;

use Getopt::Long;

my $coenrich_fh; ## Variable for coenriched input file
my $reference_fh;## Variable for reference population input file
my $output_fh;   ## Variable for output file
my $help;        ## true/false variable for help screen

                                        ## Takes command line input for...
GetOptions (    "coenrich=s" => \$coenrich_fh,  ## ... coenriched input file
                "reference=s" => \$reference_fh,## ... reference pop. input file
                "output=s" => \$output_fh,  	## ... output file
                "help" => \$help);          	## ... help screen

if (defined $help){    ## Prints help screen
    print <<"HELP";
    
	"coenrich=s" => \$coenrich_fh,  ## ... coenriched input file
    "reference=s" => \$reference_fh,## ... reference pop. input file
    "output=s" => \$output_fh,  	## ... output file
    "help" => \$help);          	## ... help screen

HELP
exit;
}

open (COENRICH, '<', $coenrich_fh) or die
"\nCould not open coenrich input file, or no input file was specified.\n
See help documentation [-h], README, or User's Guide for program usage.\n";	

my %coenriched_hash; ## Hash variable for coenriched file

while (<COENRICH>){
	if ($_ =~ /(\w+)\t(\d+)/){
		my $coenriched_sequence = $1;
		my $binary_score = $2;
		$coenriched_hash{$coenriched_sequence} = $binary_score;
	}
}		

close COENRICH;

open (REFERENCE, '<', $reference_fh) or die
"\nCould not open reference population input file, or no input file was specified.\n
See help documentation [-h], README, or User's Guide for program usage.\n";	

my %ref_pop_hash; ## Hash variable for reference population

$/ = ">";       ## Sets default record separator to > instead of \n for clustered
				## population file only.
				
while (<REFERENCE>){
    if ($_ =~ /(\d+-\d+-\d+\.?\d*-\d+-\d+-\d+)\n(\S+)/){			
        my $sequence_metrics = $1;
        my $sequence = $2;
        $ref_pop_hash{$sequence} = $sequence_metrics;
    }
}

close REFERENCE;

open (OUTPUT, '>', $output_fh) or die
"\nCould not open output file or no output file was specified.\n
See help documentation [-h], README, or User's Guide for program usage.\n";	

print OUTPUT "Sequence\tScore\tRank\tReads\tRPM\tCluster\tRank in Cluster\tEdit Distance\n";

for my $seqs (keys %coenriched_hash){  
	print OUTPUT "$seqs\t$coenriched_hash{$seqs}\t";
	if ($ref_pop_hash{$seqs}){
		print " - ";
		my $seq_match = $ref_pop_hash{$seqs};
	    delete $ref_pop_hash{$seqs};           
    	my @seq_match_split = split /-/, $seq_match;  
   	 	my $rank = $seq_match_split[0];
    	my $reads = $seq_match_split[1];
    	my $rpm = $seq_match_split[2];
    	my $cluster = $seq_match_split[3];
		my $cluster_rank = $seq_match_split[4];
		my $edit_distance = $seq_match_split[5];
		print OUTPUT "$rank\t$reads\t$rpm\t$cluster\t$cluster_rank\t$edit_distance\n";
	}
	else {
		print OUTPUT "\n";
	}
}

close OUTPUT;


