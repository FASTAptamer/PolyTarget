#!/usr/bin/env perl


use Getopt::Long;   ## Core Perl module for command line options/arguments

## use diagnostics;
## use warnings;
## use strict;

my $start = time;           ## Starts program execution timer
my $infile;                 ## Variable for input file
my $outfile;                ## Variable for output file
my $defined_edit_distance;  ## Variable (integer) for user-defined edit distance
my $help;                   ## true/false variable for help screen
my $quiet;                  ## true/false to suppress standard output

                                           ## Take command line arguments for...
GetOptions (    "infile=s" => \$infile,    ## ... input file
                "outfile=s" => \$outfile,  ## ... output file
                "distance=i" => \$defined_edit_distance,  ## ... edit distance
                "help" => \$help,          ## ... help screen
                "quiet" => \$quiet);       ## ... supress standard output

if ($help){         ## Prints help screen if $help returns as true
print <<"HELP";
	
--------------------------------------------------------------------------------
                              coenrich_cluster
--------------------------------------------------------------------------------

Usage: coenrich_cluster [-h] [-i INFILE] [-o OUTFILE] [-d #] [-q]

    [-h]            = Help screen.
    [-i INFILE]     = Input file from coenrich_map. REQUIRED.
    [-o OUTFILE]    = Output file. REQUIRED.
    [-d]            = Edit distance for clustering sequences. REQUIRED.
    [-q]            = Quiet mode.  Suppresses standard output of file I/O, numb-
                      er of clusters, cluster size and execution time.

HELP
exit;
}


##########################################	
## Open input file or exit with warning  #
##########################################

open (INPUT, '<', $infile) or die 
"\nCould not open input file or no input file was specified.\nSee help documentation [-h], README, or User's Guide for program usage.\n";

##########################################
## Open output file or exit with warning #
##########################################

open (OUTPUT, '>', $outfile) or die 
"\nCould not open output file or no input file was specified.\nSee help documentation [-h], README, or User's Guide for program usage.\n";

###############################################
## Exit with warning if no distance specified #
###############################################

unless ($defined_edit_distance) { 
die "\nNo edit distance specified.\nSee help documentation [-h], README, or User's Guide for program usage.\n"; }

my @sequence_and_info;   ## Array to contain each FASTA entry individually
my $entries;             ## Variable to keep track of the number of entries

while (<INPUT>){                             ## Reads through entire input file
    if ($_ =~ /(\w+\t\d+\t\d+\t\d+\t\d+.*\d*\t\d+\t\d+\t\d+)/){    ## Regex for coenrich format
        push @sequence_and_info, $1;         ## Add each matched entry to array
            $entries++;                          ## Increase entry count by 1
    }
}


close INPUT;  ## Closes input file

unless ($quiet){  ## Unless -q option is invoked, print this warning and summary
    print "\nTotal number of sequences to cluster: $entries.\n";
    print "\nCluster\tUnique Sequences\n";
}

print OUTPUT "Sequence\tScore\tRank\tReads\tRPM\tCluster (Rd 14)\tRank in Cluster (Rd 14)\tEdit Distance (Rd 14)\tCluster\tRank in Cluster\tEdit Distance\n";

my $current_cluster = 1;  ## This variable defines what cluster we're working on 

iterate(@sequence_and_info);  ## Sends array with sequence entries to subroutine

###############################################
##   SUBROUTINE THAT BEGINS TO PROCESS FILE   #
## One iteration generates a single cluster   #
## and then repeats w/  unclustered sequences #
## for next cluster                           #
###############################################

sub iterate {
    my ( $top_entry, @entries ) = @_; ## Takes "seed sequence" and remaining entries 
    my @keepers; ## Array to store unclustered entries
    my @current_seq_info = split /\t/, $top_entry; 
    ## Splits entry into sequence, score, rank, reads, RPM, etc.
    my $cluster_rank = 1; ## Defines that seed sequence is ranked #1
	
	foreach (@current_seq_info) {
  		print OUTPUT "$_\t";
	}
	
	print OUTPUT "$current_cluster\t$cluster_rank\t0\n";
	
	my $current_cluster_reads = $current_seq_info[3]; ## Take reads to tally cluster size
	my $current_cluster_rpm = $current_seq_info[4]; ## Take RPM to tally cluster size in RPM

    for (@entries) { ## for each entry left in array send to calculate distance 
    	my @comparison_seq_info = split /\t/, $_; ## Split entry into metrics and sequence
    	my $comparison_seq_reads = $comparison_seq_metrics[3];  ## Take reads to tally cluster size
    	my $comparison_seq_rpm = $comparison_seq_metrics[4];  ## Take RPM to tally cluster size
        my $distance = levenshtein( $current_seq_info[0], $comparison_seq_info[0] );
        ## sends comparison sequence to compare against current seed sequence, returns distances
        if ( $distance > $defined_edit_distance ) { ## If distance is greater than defined
            push @keepers, $_;  ## Add to array for comparison in next iteration
        }
        elsif ( $distance <= $defined_edit_distance ){ ## If distance is less than or equal to defined
        	$cluster_rank++;  ## Increment the cluster rank
        	$current_cluster_reads += $comparison_seq_reads; ## Add reads to cluster reads tally
        	$current_cluster_rpm += $comparison_seq_rpm;  ## Add RPM to cluster RPM tally
        	print OUTPUT "$comparison_seq_info[0]\t$comparison_seq_info[1]\t$comparison_seq_info[2]\t$comparison_seq_info[3]\t$comparison_seq_info[4]\t$comparison_seq_info[5]\t$comparison_seq_info[6]\t$comparison_seq_info[7]\t";
        	print OUTPUT "$current_cluster\t$cluster_rank\t$distance\n";
        }
    }

    unless ($quiet) { print "$current_cluster\t$cluster_rank\n"; }
    ## Display cluster number, number of unique sequences, reads and RPM
    $current_cluster++; ## Increment cluster number prior to next cluster

    if (@keepers) { ## Subroutine within subroutine for sequences that are unclustered
        iterate(@keepers);
    }
}

my $duration = time - $start; ## Calculates how much time has elapsed since start

unless ($quiet) { ## Displays summary report unless -q is invoked
    print "\nInput file: \"$infile\".\n";
    print "Output file: \"$outfile\".\n";
    print "Execution time: $duration s.\n"; 
}

#############################################################################
## The subroutines below calculates the Levenshtein edit distance for the   #
## current "seed" sequence and the comparison sequence that are sent to it  #
#############################################################################

sub levenshtein {
	my ($s1, $s2) = @_;
	my ($len1, $len2) = (length $s1, length $s2);
	
	return $len2 if ($len1 == 0);
	return $len1 if ($len2 == 0);
	
	my %mat;
	
	for (my $i = 0; $i <= $len1; ++$i){
		for (my $j = 0; $j <= $len2; ++$j){
			$mat{$i}{$j} = 0;
			$mat{0}{$j} = $j;
		}
		$mat{$i}{0} = $i;
	}
	
	my @ar1 = split(//, $s1);
	my @ar2 = split(//, $s2);

	for (my $i = 1; $i <= $len1; ++$i){
		for (my $j = 1; $j <= $len2; ++$j){
			my $cost = ($ar1[$i-1] eq $ar2[$j-1]) ? 0 : 1;
			$mat{$i}{$j} = min([$mat{$i-1}{$j} + 1,
			$mat{$i}{$j-1} + 1,
			$mat{$i-1}{$j-1} + $cost]);
		}
	}
    return $mat{$len1}{$len2};
}

sub min
{
    my @list = @{$_[0]};
    my $min = $list[0];

    foreach my $i (@list)
    {
        $min = $i if ($i < $min);
    }

    return $min;
}
