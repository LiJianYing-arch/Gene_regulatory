#!/usr/bin/perl -w 
use strict ;

my @fafile = `ls *.fa` ;
for my $file (@fafile){
    chomp($file) ;
    if ($file =~/(.*?)_clean\.fa/){
	my $SRR = $1 ;
	my $newName = $SRR."_vs_tRNArRNAsnRNA.out" ;
	my $errfile = $SRR.".err" ;
	system("blastall -p blastn -i $file -d /data01/genome/MiaoYH_miRNA/All_tRNArRNAsnRNA.fa -o $newName -e 1e-3 -a 25 -v 1 -b 1 2> $errfile ") ;
    }
}
