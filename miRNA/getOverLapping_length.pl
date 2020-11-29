#!/usr/bin/perl -w 
use strict ;

my $file1 = shift ;
my $file2 = shift ;
my $len = shift ;

open IN1,"<",$file1 ;
my $seq_title1 = "" ;
my $seq1 = "" ;
my %hash1 = () ;
while (<IN1>){
    chomp ;
    if(/^>(.*)\s*/){
	$seq_title1 = $1 ;
    }else{
	$seq1 .= $_ ;
    }
    my $size = length($seq1) ;
    if ($size == $len){
	$hash1{"$seq1"} = $seq_title1 ;
    }
    $seq1 = "" ;
}

open IN2,"<",$file2 ;
my $seq_title2 = "" ;
my $seq2 = "" ;
my %hash2 = () ;
while (<IN2>){
    chomp ;
    if(/^>(.*)\s*/){
	$seq_title2 = $1 ;
    }else{
	$seq2 .= $_ ;
    }
    my $size = length($seq2) ;
    if ($size == $len){
	$hash2{"$seq2"} = $seq_title2 ;
    }
    $seq2 = "" ;
}

for my $tmpseq (keys %hash1){
    if (defined $hash2{"$tmpseq"}){
	print $tmpseq,"\t",$hash1{"$tmpseq"},"\t",$hash2{"$tmpseq"},"\n" ;
    }
}
