  #!/usr/bin/perl -w 
  use strict ;
   
  my $file1 = shift ;
  my $file2 = shift ;
   
  my %hash = () ;
  open IN1,"<",$file1 ;
  while(<IN1>){
      chomp ;
      my @regions = split ;
      $hash{"$regions[0]"} = $regions[1] ;
  }
  
  open IN2,"<",$file2 ;
  while (<IN2>){
      chomp ;
      my @regions = split ;
      if (defined $hash{"$regions[0]"}){
          print $regions[1],"\t",$regions[2],"\t",$regions[3],"\t",$regions[4],"\t",$regions[5],"\t",$regions[6],"\t",$regions[7],"\t",$hash{"$regions[0]"},"\n" ;
	    }
    }
