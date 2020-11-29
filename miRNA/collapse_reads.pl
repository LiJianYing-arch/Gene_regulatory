#!/usr/bin/perl -w 
use strict ;

my $file = shift ;
my %hash = () ;

open IN,"<",$file ;
while (<IN>){
    chomp ;
    if (/^[ATCG]/){
	if (defined $hash{"$_"}){
	    $hash{"$_"} += 1 ;
	}else{
	    $hash{"$_"} = 1 ;
	}
    }
}

my $wide = 8 ;
my $num = 1 ;
for my $key ( sort {$hash{$b} <=> $hash{$a}} keys %hash) {
    my $tag = sprintf("%0*d",$wide,$num) ;
    my $name = ">t".$tag."_x".$hash{"$key"} ;
    print $name,"\n",$key,"\n" ;
    $num++ ;
}
