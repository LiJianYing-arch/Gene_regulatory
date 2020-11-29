for ID in GSM699075
do
#------ require precusor----------------------
awk '{if ($2=="5prime" || $2=="3prime") print$1}' ${ID}.miRcheck_out.txt >${ID}.miRcheck_out.id

perl /public/home/jyli/scripts/getSeq_hash.pl -i ${ID}.miRcheck_out.id -f /public/home/jyli/TasiRNA/SmallRNA/Clean/${ID}_premiRNA_putative_seq.txt -o ${ID}_miRcheck_out.fa 

blastall -p blastn -i ${ID}_miRcheck_out.fa -d /public/home/jyli/Public_data/Cotton_CDS/GhGbGrGa_cds.fa -o ${ID}_vs_GhGbGrGa.out -e 1e-10 -v 1 -b 1 -a 5 

php /public/home/jyli/scripts/blast.sta.simple.php ${ID}_vs_GhGbGrGa.out

grep "NoHits" ${ID}_vs_GhGbGrGa.out.sta >${ID}.precusor

awk '{print $2}' ${ID}.precusor >${ID}.precusor.id

perl /public/home/jyli/scripts/getSeq_hash.pl -i ${ID}.precusor.id -f ${ID}_miRcheck_out.fa -o ${ID}.precusor.fa
#-------New mkdir(Probability-based annotation)-----------------
mkdir Precusor

cd Precusor

bowtie-build ../${ID}.precusor.fa ${ID}.precusor

bowtie -p 5 -v 0 -a -m 200 ${ID}.precusor -f /public/home/jyli/TasiRNA/SmallRNA/Clean/GSM699075_vs_tRNArRNAsnRNA_nohits.fa > ${ID}.aln

cat ../${ID}.precusor.fa | RNAfold --noPS > ${ID}_structures.txt

#-------miRDP prediction----------------
perl /public/home/jyli/software/miRDP1.3/convert_bowtie_to_blast.pl ${ID}.aln /public/home/jyli/TasiRNA/SmallRNA/Clean/GSM699075_vs_tRNArRNAsnRNA_nohits.fa ../${ID}.precusor.fa >${ID}.bst

perl /public/home/jyli/software/miRDP1.3/filter_alignments.pl ${ID}.bst -c 50 |sort +3 -25 >${ID}_filter50_signatures

perl /public/home/jyli/software/miRDP1.3/miRDP.pl ${ID}_filter50_signatures ${ID}_structures.txt >${ID}.prediction

perl /public/home/jyli/software/miRDP1.3/rm_redundant_meet_plant.pl /public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.fa.len.lst ../${ID}.precusor.fa ${ID}.prediction ${ID}_nr_predictions ${ID}_filter_P_prediction

perl /public/home/jyli/scripts/rm_redundancy.pl ${ID}_filter_P_prediction >${ID}_miRNA-precursor_noRedundant.txt

done
