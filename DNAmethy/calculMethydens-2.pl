#!/usr/bin/perl -w
use strict;
my $number=shift;
my $file=shift;
my %hash=();
my %hash_number=();
my @tmp="";
open IN1,"<$number";
while(<IN1>){
	chomp;
	@tmp=split;
	$hash{"$tmp[0]"}=0;
	$hash_number{"$tmp[0]"} +=1;
	}

open IN2,"<$file";
while(<IN2>){
	chomp;
	my @tmp1=split;
	if (defined($hash{"$tmp1[1]"}))	{
	$hash{"$tmp1[0]"}=$hash{"$tmp1[0]"}+($tmp1[1]/$tmp1[2]);
#	$hash{"$tmp1[0]"}= ($tmp1[1]/$tmp1[2]);
	}
		}

for (my $i=1;$i<209;$i++){
	print($hash{"$i"}/$hash_number{"$i"},"\n");
	}
