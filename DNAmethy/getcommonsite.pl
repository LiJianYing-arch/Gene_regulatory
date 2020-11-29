#!/usr/bin/perl -w
use strict;
my $mock=shift;
my $treat=shift;
my %mock_hash=();
my %treat_hash=();
open IN1,"<$mock";
my @tmp1="";
while(<IN1>){
	chomp;
	@tmp1=split;
	$mock_hash{"$tmp1[0]"}=$_;
}
open IN2,"<$treat";
my @tmp2="";
while(<IN2>){
	chomp;
	@tmp2=split;
	my $key =$tmp2[0];
	$treat_hash{"$key"}=$_;
	if(defined($mock_hash{"$key"})){
		print join ("\t"),$mock_hash{"$key"},"\t",$treat_hash{"$key"},"\n";
	}
}
