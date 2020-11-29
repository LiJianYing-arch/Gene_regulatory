#!/usr/bin/perl -w
use strict;

my $file1=shift; #.seq
my $file2=shift; # fa

open IN2,"<$file2";
my %hash_seq_id = ();
my $id = "";
while (<IN2>){
	chomp;
	if (/^>/){
		$id = $_;
	}else{
		push(@{$hash_seq_id{"$_"}}, $id);
	}
}
close IN2;

open IN1, "<$file1" or die "$!\n" ;
while (my $seq = <IN1>){
	chomp $seq;
	if (defined($hash_seq_id{"$seq"})){
		my %hash_tmp = map{$_ => 1} @{$hash_seq_id{"$seq"}};
              #  my %hash_tmp = @{$hash_seq_id{"$seq"}};
                #print $seq, "\t",keys %hash_tmp,"\n";	
                #print keys %hash_tmp,"\n";
	print $seq, "\t", join(";", keys %hash_tmp), "\n";
	#}else{
	#	print STDERR $seq, "\t ID not found\n";
	}
}
close IN1;
