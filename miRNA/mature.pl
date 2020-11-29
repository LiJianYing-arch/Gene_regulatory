#!/us/bin/perl -w 
use strict;

my %hash = ();
my @domain =();
my $id = shift;
my $annotation = shift;
my $tmp = "";

open IN1, "<$annotation";
while (<IN1>){
	chomp;
	@domain = split;
	$hash{$domain[0]} = $_;
}

open IN2,"<$id";
while (<IN2>){
	chomp;
	my @regions = split (/\t/,$_);
	if ($regions[8] =~ /(.*?)-(\w+);/){    #mature 
		$tmp = $1;
	}
	if (defined $hash{$tmp}){
	print join("\t",@regions),"\n" ;
	}
}

