#!/usr/bin/env perl

use strict;
my ($infile) = @ARGV;

open (IN,$infile) || die "can't open file: $!\n";
open (OUT,">".$infile.".len.lst");

my $id; my %id_seq;my $seqno; my $seqlen; my $totallen;

while(<IN>){
	chomp;
	if (/^>(\S+)/){
		$seqno++;
		if ($seqno>1){
			$seqlen=length($id_seq{$id});
			$totallen+=$seqlen;
			print OUT "$id\t$seqlen\n";
		}
		$id=$1;
	}else{
		$id_seq{$id}.=$_;
	}
}

$seqlen=length($id_seq{$id});
$totallen+=$seqlen;
print OUT "$id\t$seqlen\n";

close OUT;
close IN;

print "Average lenth:".$totallen/$seqno."\n";
