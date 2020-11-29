#!/usr/bin/perl -w
use strict;
my $number=shift;
my $file=shift;
my %hash=();
my @tmp="";
open IN1,"<$number";
while(<IN1>){
	chomp;
	@tmp=split;
	$hash{"$tmp[0]"}=0;
	}

open IN2,"<$file";
while(<IN2>){
	chomp;
	my @tmp1=split;
	if (defined($hash{"$tmp1[0]"}))	{
	$hash{"$tmp1[0]"}=$hash{"$tmp1[0]"}+($tmp1[1]/$tmp1[2]);
#	$hash{"$tmp1[0]"}= ($tmp1[1]/$tmp1[2]);
	}
		}

for (my $i=1;$i<101;$i++){
	print($hash{"$i"},"\n");
	}

