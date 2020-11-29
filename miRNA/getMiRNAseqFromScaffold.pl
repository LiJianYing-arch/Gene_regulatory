#!/usr/bin/perl -w
use strict ;
use Getopt::Long ;
        
my $genome= "" ;
my $loci_input = "" ;
my $ok = GetOptions("i|input=s" => \$loci_input,
					"g|genome=s" => \$genome) ;

unless( $genome && $loci_input ){
	die "error \n" ;
}
open IN1,"<$genome" or die "can not open the file\n" ;
my %seq_hash= () ;
while(<IN1>){
    if(/^>(.*)\s*/){
	my $seq_scaffold = "" ;
	my $seq_title = $1 ;
	while(<IN1>){
	    if(/^>/){
		seek(IN1,-length($_),1) ;
		last ;
	    }else{
		chomp ;
		$seq_scaffold .= $_ ;
	    }
	}
	$seq_hash{"$seq_title"} =$seq_scaffold;
    }
}
open IN2,"<$loci_input" or die "can not open the file \n" ;	
	
while(<IN2>){
     chomp; 
     my @tmp= split;
     my $source=$tmp[2] ;
     my $strand = $tmp[1];
     my $start = "" ;
    if ($tmp[3]-150 >=0){
	$start = $tmp[3]-150;
    }else{
	   $start = 0 ;
    }
     my $end = "" ;
    if ($tmp[3] + length($tmp[4])+ 150 <= length($seq_hash{$source})){
        $end = $tmp[3] + length($tmp[4])+ 150;
    }else{
	$end = $tmp[3] + length($tmp[4])+ length($seq_hash{$source})-($tmp[3] + length($tmp[4]));
    }
    my $seq = $seq_hash{$source};
    my $name = ">$tmp[0]"."_"."$tmp[1]"."_"."$tmp[2]"."_"."$tmp[3]" ;
    my $name_seq = "" ;
    if ($strand =~ /\+/){
        $name_seq = substr($seq,$start,$end-$start) ;
    }elsif( $strand =~ /\-/ ){
        $name_seq = substr($seq,$start,$end-$start) ;
	$name_seq = reverse $name_seq ;
	$name_seq = lc $name_seq ;
        $name_seq =~ s/a/T/g ;
        $name_seq =~ s/t/A/g ;
        $name_seq =~ s/g/C/g ;
        $name_seq =~ s/c/G/g ;
    }
    print $name, "\n",$name_seq, "\n" ;
}
