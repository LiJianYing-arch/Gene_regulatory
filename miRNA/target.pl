#!/usr/bin/perl -w
$file=shift;
open A,"<$file";
@fasta=<A>;
%hash=@fasta;
foreach $keys(sort keys %hash){
chomp $hash{$keys};
if($keys=~/^>(.*)/){
system("/data02/public_software/TargetFinder_1.6/targetfinder.pl -s $hash{$keys} -d /data02/public_data/cotton.draft.genome_v1/Gb.genome.annotation5/Gb.final.all.cDNA.rename.fa -q $1 >$1.txt");
 }
}
