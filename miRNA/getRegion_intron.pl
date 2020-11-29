#!/usr/bin/perl
use strict;
my $file1 = shift ; #gff3
my $file2 = shift ; #locus
   
my %hash_gff = () ;
open IN1,"<$file1" or die "$!";
while (<IN1>){
	chomp;
	my @domain = split ;
	push(@{$hash_gff{"$domain[0]"}->{$domain[8]}},[$domain[2],$domain[3],$domain[4],$domain[6]]);
}

open IN2, "<$file2" or die "$!";
while (<IN2>){
	chomp;
	my @array = split ;
	  if (defined $hash_gff{"$array[0]"}){
      	  my @geneID = keys %{$hash_gff{"$array[0]"}} ;
		for  my $id (@geneID){
		my @CDSs = @{$hash_gff{"$array[0]"}->{$id}} ;
			for my $t (@CDSs){
			my $start = $t->[1] ; 
			my $end = $t->[2] ; 
		if ($array[1] >= $start && $array[2] <= $end ){                           
#	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","regionsInCDS","\n" ; 
	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","inintron","\n" ;
		}elsif ($array[1] <= $start && $array[2] >= $start && $array[2] <=$end){
#	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","regionsleftPartial","\n" ;
	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","exon-intron","\n" ;
		}elsif ($array[1] >= $start && $array[1] <= $end && $array[2] >= $end){
#	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","regionsRightPartial","\n" ; 
	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","exon-intron","\n" ;
		}elsif ($array[1] <= $start && $array[2] >= $end){
#	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","regionsCoverPartial","\n" ;
	print $id,"\t",join("\t",@array),"\t",$t->[3],"\t","Coverintron","\n" ;
		}else{
 				}		
			}	
		}
	}
}
	
              
