#!/bin/perl -w 
use strict ;


my $file = shift ;

open IN,"<",$file ;
my %hash = () ;
while (<IN>){
	chomp ;
	my @regions = split ;
	push(@{$hash{"$regions[7]"}},[$regions[0],$regions[1],$regions[2],$regions[3],$regions[5],$regions[6]]);  
}

for my $miRNA (keys %hash){
	my @value = @{$hash{"$miRNA"}} ;
	my $num = @value ;
	print $miRNA,"\t",$num ;
	for my $tmp (@value){
		for (my $i=0; $i<=4; $i++){
			print "\t",$tmp->[$i] ;
		}
	}
	print "\n" ;
}
