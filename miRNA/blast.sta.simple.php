<?php

	$filename=$argv[1] ;

	$str="";
	$strseq="";
	$strwrite="";
	$slen=0;
	$boolseq=0;
	$boolcol=0;
	$i=0;
	$matchsum=0;
	
	$snoLength=9;
	
	$lineLength=10240;
	
	$str_col_title='Match_No'."\t".'Query'."\t".'Q_Length'."\t".'Subject'."\t".'S_Length'."\t".'Score_Bits'."\t".'Score'."\t".'E_Value'."\t".'Identities'."\t".'Identities'."\t".'Identities'."\t".'Positives'."\t".'Positives'."\t".'Positives'."\t".'Gaps'."\t".'Gaps'."\t".'Gaps'."\t".'Frame'."\n";

	$handle=fopen(getcwd().'/'.$filename,'r') or die("It's failure to open file");
	
	$sta=fopen(getcwd().'/'.$filename.'.sta','a+');

	fwrite($sta,$str_col_title);
	
    while (!feof($handle)) {
		$str= fgets($handle,$lineLength);
		if (substr(ltrim(rtrim($str)),0,6)=="Query="){
			$i=0;
			//$sno= substr(ltrim(rtrim($str)),6,$snoLength);
			$sno= substr(ltrim(rtrim($str)),7);
			//print $sno."<br>";

			$boolseq=1;			
			
			//there are more than one line of sequence name
			while($boolseq){
				$str= fgets($handle,$lineLength);
				if(substr(trim($str),strlen(trim($str))-8)=='letters)'){
					$boolseq=0;
					preg_match ('/(\d+)\s+/', $str, $match);
					$slen=$match[1];
					$strwrite=$sno."\t".$slen;
					//echo $strwrite."\n";
					}
				else{
					$sno=$sno.trim($str);
				
						if (substr(trim($sno),1,3)=='CO0'){
							$sno=substr($sno,0,$snoLength); //only need short contigs sequence describtion
							}
						
					}
				}
			}

		if(trim($str)=="***** No hits found ******"){
			$strwrite="0"."\t".$strwrite."\t"."NoHits";
			fwrite($sta,$strwrite."\n");
			$matchsum=$matchsum+1;
			}

		if ((substr(trim($str),0,1))==">"){
			$i=$i+1;
			$boolcol=1;
			$strseq=substr(trim($str),1);

			//there are more than one line of sequence name
			while ($boolcol){
				$str=trim(fgets($handle,$lineLength));

				if(substr($str,0,6)=="Length"){
					$boolcol=0;
					//Length = 7172
					preg_match ('/\=\s+(\d+)/', $str, $match);
					$strseq=$strseq."\t".$match[1];
					}
				else{
					$strseq=$strseq.trim($str);
					}
				}

			$str=trim(fgets($handle,$lineLength));  //read a null line
			$str=trim(fgets($handle,$lineLength));

			//Score =  119 bits (60), Expect = 2e-23
			//using the position to read the strings
			
			/*$pos1 = strpos ($str, "Score = ");
			$pos2 = strpos ($str, "bits (");
			$pos3 = strpos ($str, "), ");
			$pos4 = strpos ($str, "Expect =");
			$strseq=$strseq."\t".substr($str,$pos1+strlen("Score = "),$pos2-strlen("Score = "));
			$strseq=$strseq."\t".substr($str,$pos2+strlen("bits ("),$pos3-$pos2-strlen("bits ("));
			$strseq=$strseq."\t".substr($str,$pos4+strlen("Expect ="));
			*/

			//Score =  119 bits (60), Expect = 2e-23
			//Score =  83.2 bits (204), Expect(2) = 6e-20
			//Score =  448 bits (1153), Expect = e-125,   Method: Compositional matrix adjust.
			//Score = 55.8 bits (133), Expect = 2e-08
			// Score =  224 bits (571), Expect = 3e-59
			//print $str."\n";
			
			preg_match ('/=(.*)bits\s+\((\d+)\),\s+Expect.*\s+\=\s+(\S+)(,|.*)/',$str,$match);	
			
			//print_r($match);die();
	
			$strseq=$strseq."\t".$match[1]."\t".$match[2]."\t".$match[3];
			
			$str=trim(fgets($handle,$lineLength));
			
			//Identities = 404/473 (85%), Gaps = 3/473 (0%)
			//Identities = 32/61 (52%), Positives = 40/61 (65%), Gaps = 2/61 (3%)
			if (preg_match ('/\s+\=\s+(\d+)\/(\d+)\s\((\d+)\%.*=\s+(\d+)\/(\d+)\s+\((\d+)\%.*=\s+(\d+)\/(\d+)\s+\((\d+)\%/',$str,$match) ){
				$strseq=$strseq."\t".$match[1]."\t".$match[2]."\t".$match[3]."%\t".$match[4]."\t".$match[5]."\t".$match[6]."%\t".$match[7]."\t".$match[8]."\t".$match[9]."%"; }
			elseif(preg_match ('/\s+\=\s+(\d+)\/(\d+)\s\((\d+)\%.*=\s+(\d+)\/(\d+)\s+\((\d+)\%/',$str,$match) ){
				$strseq=$strseq."\t".$match[1]."\t".$match[2]."\t".$match[3]."%\t".$match[4]."\t".$match[5]."\t".$match[6]."%\t"."\t"."\t"; }
			else
				{
				preg_match ('/\s+\=\s+(\d+)\/(\d+)\s\((\d+)\%/',$str,$match);
				$strseq=$strseq."\t".$match[1]."\t".$match[2]."\t".$match[3]."%\t"."\t"."\t"."%\t"."\t"."\t";}

			//print_r($match);

			$str=trim(fgets($handle,$lineLength));
			//Frame = +1
			if (preg_match ('/.*\=(.*)/',$str,$match)){			
				$strseq=$strseq."\t".$match[1];
				}

			fwrite($sta,$i."\t".$strwrite."\t".$strseq."\n");

			}

		/*//read the column of the blast result
		if(substr(ltrim(rtrim($str)),0,43)=="Sequences producing significant alignments:"){
			$str= fgets($handle);
			for($i=1;$i<=9; $i++) {
				if(!feof($handle)){
					$str= fgets($handle);
					if( ((substr(trim($str),0,1))==">") or (strlen(trim($str))==0) ){
						$i=10;
						}
					else{
						fwrite($sta,$i."\t".$strwrite."\t".$str);
						}
					}
				}
			}
		*/

	}

	fclose($handle);
	fclose($sta);
	echo "It's OK!";

?>
