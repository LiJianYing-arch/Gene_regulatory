#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: rm_redundancy1.pl
#      
#   	 USAGE: perl ./rm_redundancy.pl  infile
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: cotton-genome (cg), 
# ORGANIZATION: Group of Cotton Genetic Improvement
#      VERSION: 1.0
#      CREATED: 04/04/2014 05:41:20 PM
#     REVISION: ---
#===============================================================================

use utf8;
use strict;
use warnings;
use Data::Dumper;

my $input = shift ;
my @regions = () ;
my %hash = () ;

open my ($fh),"<",$input ;
while (<$fh>){
      chomp ;
      @regions = split ;
      my $key = $regions[0]."~".$regions[1]."~".$regions[5]."~".$regions[7] ;
      my $value = $regions[8]."~".$regions[2]."~".$regions[4]."=".$regions[6] ;
      push(@{$hash{"$key"}},$value) ;
}
while ((my $key1,my $value1) = each %hash){
         my $num = @{$value1} ;
	 print $key1,"\t",$num,"\t",join("\t",@{$value1}),"\n" ;
}
