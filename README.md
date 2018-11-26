# Poly-Target Coenrichment Analysis Scripts

Please cite the following paper and the FASTAptamer paper if you utilize these tools in anyway:

- ###### **"Poly-Target Selection Identifies Broad-Spectrum RNA Aptamers"**
  - Molecular Therapy — Nucleic Acids. 2018. DOI: 10.1016/j.omtn.2018.10.010
  - Khalid K. Alam, Jonathan L. Chang, Margaret J. Lange, Phuong D.M. Nguyen, Andrew W. Sawyer & Donald H. Burke

- ###### **"FASTAptamer: A Bioinformatic Toolkit for High-Throughput Sequence Analysis of Combinatorial Selections."** 
  - Molecular Therapy — Nucleic Acids. 2015. 4, e230; DOI: 10.1038/mtna.2015.4
  - Khalid K. Alam, Jonathan L. Chang & Donald H. Burke


The three Perl scripts included in this repository are built upon the FASTAptamer platform and are designed to identify, map, and cluster sequences which coenrich across divergent selection trajectories originating from the same initial library. No external modules or dependencies, apart from a Perl 5.8+ interpreter, are required to run these scripts.


## polytarget_coenrich.pl

polytarget_coenrich.pl is designed to take simple input files (a single sequence entry per line) corresponding to each selection trajectory (Nitrocellulose, HXB2, R277K, 94CY, 93TH, MVP, TAN1B, EHO). Input files were generated by scrapping FASTAptamer-Enrich files for sequences that had an aggregate reads per million of 10 from the Round 14 and Round 17 populations.

Each sequence is then searched for its appearance among each selection trajectory and assigned the following value if it's found.

>Nitrocellulose = 0.1
>HXB2 = 1
>R277K = 10
>94CY = 100
>93TH = 1000
>MVP = 10000
>TAN1B = 100000
>EHO = 1000000

These values are summed for each sequence and output to a tab-separated file with each line containing a unique sequence and it's coenrichment score. For example, a sequence with a score of 1001011.1 is found to be enriched in all populations except TAN1B, MVP and 94CY.

## polytarget_coenrich_map.pl

This script is designed to take files processed with polytarget_coenrich.pl and fastaptamer_enrich as inputs. It outputs a simple output file that lists, for each sequence, it's score and Round 14 Rank/Reads/RPM/Cluster Rank/Cluster Edit Distance.  This "mapping" feature helps to trace back coenriched sequences to the original starting library.

## polytarget_coenrich_cluster.pl

This script takes an input file processed with polytarget_coenrich_map.pl and outputs a file that generates new clusters for the set of coenriched sequences. 
