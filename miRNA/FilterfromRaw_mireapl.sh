###split mature and precursor from mireap Raw file
grep 'mature'  mireap-SRR5138524.gff > mireap-SRR5138524.mature.gff
grep 'precursor' mireap-SRR5138524.gff > mireap-SRR5138524.precursor.gff


###Delete the 3p and 5p
cut -f9 mireap-SRR5138524.mature.gff | sed -e 's/;/\t/g' -e 's/ID=//g' -e 's/-/\t/g' | cut -f2 | sort | uniq -c | awk '{if($1==1)print 
$2}' |sed 's/^/ID=SRR5138524-/g' > mireap-SRR5138524.mature.1
cut -f9 mireap-SRR5138524.mature.gff | sed -e 's/;/\t/g' -e 's/ID=//g' -e 's/-/\t/g' | cut -f2 | sort | uniq -c | awk '{if($1==2)print 
$2}' |sed 's/^/ID=SRR5138524-/g' > mireap-SRR5138524.mature.2

###generated new GTF file
perl mature.pl mireap-SRR5138524.mature.gff mireap-SRR5138524.mature.1  > mireap-SRR5138524.mature.new.gff
perl precursor.pl mireap-SRR5138524.precursor.gff mireap-SRR5138524.mature.1 > mireap-SRR5138524.precursor.new.gff

### Selection reads  > 10 per library
sed -e 's/;/\t/g' -e 's/Count=//g' mireap-SRR5138524.mature.new.gff |awk '{OFS="\t"}{if($11 >= 10)print}' |cut -f9  |sed -e 's/-5p//g' 
-e 's/-3p//g'  > mireap-SRR5138524.mature.read10.id

###generated final GTF file
perl precursor.pl mireap-SRR5138524.precursor.new.gff mireap-SRR5138524.mature.read10.id   > mireap-SRR5138524.precursor.final.gff
perl mature.pl mireap-SRR5138524.mature.new.gff mireap-SRR5138524.mature.read10.id   > mireap-SRR5138524.mature.final.gff

###generated gff
paste mireap-SRR5138524.mature.final.gff mireap-SRR5138524.precursor.final.gff |awk '{OFS="\t"}{print $1,$3,$4,$5,$7,$10,$13,$14,$9}' >
 SRR5138524.final.gff

chmod +x SRR5138524.final.gff

