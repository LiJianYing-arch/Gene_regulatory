#!/usr/bin/perl -w 
use strict ;

my $miSeq = shift ;
my $preSeq = shift ;
my @dom = ();
my %hash = ();
my $ID = "" ;
my $seq = "" ;
open IN1,"<$miSeq"  ;
while (<IN1>){
      chomp ;
      $seq = "" ;
      if (/^>(.*)/){
          $ID = $1 ;
      }else{
          $seq .= $_ ;
      }
      $hash{"$ID"} = $seq ;
}
my $preID = "" ;
my $title = "" ;
my $site = "" ;
open IN2,"<$preSeq" ;
while (<IN2>){
       chomp ;
       if (/^>(.*?)_x(.*?)_/){
          $title = $_ ;
          $preID = $1."_x".$2 ;
       }else{
          $site = index($_,$hash{"$preID"}) ;
	  $title =~ s/>//g ;
         print $title," ",$_," ",$hash{"$preID"}," ",$site,"\n" ;
       }
}
