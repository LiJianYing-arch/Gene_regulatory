#!/usr/bine/perl -w
use strict ;
use Getopt::Long ; 

my $input_id = "" ;
my $input_fa = "" ;
my $output_fa = undef ;

my $usage = <<__USAGE__ ;
##################################
# -i|--input_id :the intput of the id file 
# -f|--input_fa :the input of the fasta file 
# -o|--output :the output of the fasta[default STDOUT] 
##################################
__USAGE__
;

my $ok = GetOptions("i|input_id=s" => \$input_id,
					"f|input_fa=s" => \$input_fa,
					"o|output=s" => \$output_fa) ;

unless( $input_id && $input_fa ){
	die "no input id or input fasta\n $usage" ;
}					

my %seq_hash = () ;
my $seq_title = "" ;
my $seq = "" ;

if(defined($output_fa)){
	open STDOUT,">$output_fa" or die "can not open the file\n";
}

open IN1,"<$input_fa" or die "can not open the input fasta file \n" ;
open IN2,"<$input_id" or die "can not open the input seq-id file \n" ;

while(<IN1>){
	if(/^>(.*)\s*/){
		$seq = "" ;
		$seq_title = $1 ;
		if(/^>.*\s+\.*/){
			my @line = split ;
			$seq_title = $line[0] ;
			$seq_title =~ s/>// ;
		}
		while(<IN1>){
			if(/^>/){
				seek(IN1,-length($_),1) ;
				last ;
			}else{
				chomp ;
				$seq .= $_ ;
			}
		}
		$seq_hash{"$seq_title"} = $seq ;
	}
}

while(<IN2>){
	chomp ;
    my @regions = split ;
	print STDOUT ">",$_,"\n",$seq_hash{"$regions[0]"} ,"\n" ;
}
