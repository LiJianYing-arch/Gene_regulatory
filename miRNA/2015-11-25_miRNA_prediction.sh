miRNAs prediction pipeline
The raw reads were pre-processed by NGSQCtookit software to remove low quality reads (quality score, Q<20), trim adaptor sequence, reads smaller than 18 nt, and contamination formed by adaptor (Patel and Jain, 2012). Followed, the clean sequences were used to search the Rfam database to exclude rRNA, tRNA, snRNA and snoRNA. The remaining sRNAs were subjected to miRNA identification. The final clean data were mapped to G.hirsutum genome using bowtie, which allowed 200 multiple mapping positions and zero mismatch for each read (Zhang et al., 2015). We adopted structure-based annotation and probability-based annotation to predict miRNA loci by Paterson et al (Paterson et al., 2012). For structure-based annotation, the sequence were extracted the upstream and downstream 150 bp of the miRNA mapping site, naming "premiRNA_putative_seq" . Then a few steps, miRcheck was used to evaluate RNA secondary structures, filter protein-coding genes, and get the stem-loop structure from using RNAfold (Jones-Rhoades and Bartel, 2004). Followed, probability-based annotation, we then utilized miRDP to filter the putative precursors of the structure-based annotation. The cutoff value of the largest miRNA family size was set at 50 owing to the genome doubling of teraploid relative to diploid (Yang and Li, 2011). All the annotated mature miRNAs were searched against the miRBase21 to categorize into cotton conserved and novel miRNAs families using BLASTN (Kozomara and Griffiths-Jones, 2013). The puattive precursor were folded with Vienna RNA package (Hofacker, 2003). After eliminating miRNA reads from small sequencing datasets, the remaining were then regarded as siRNAs.
#================raw data processing==============
A:Adapter were discard by trimmomatic software
java -jar /home/genome/biosoft/Trimmomatic/trimmomatic-0.32.jar SE -threads 10 -phred33 cotton_${label}.fq.gz cotton_${label}_remove_adapter.fq ILLUMINACLIP:sRNA.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:1:10 MINLEN:16
B:Raw data were filtered by NGSQCToolKit software 
perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/QC/IlluQC.pl -se ../cotton_L4_remove_adapter.fq 5 5 -l 18 -s 20 -t 2 &

perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/Trimming/AmbiguityFiltering.pl -i IlluQC_Filtered_files/*filtered -c 0 -o L4_reads.fastq &

perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/Format-converter/FastqToFasta.pl -i L4_reads.fastq -o L4_reads.fa &
C：Reads length in 18nt to 26nt
awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; if (length(seq) <=26 && length(seq)>=18) {print header, seq}}' L4_reads.fa >ncRNA.fa &
D: obtain uniq reads
perl /data04/NCBI_SRA/Cotton_miRNA_degradome/SRA/collapse_reads.pl
ncRNA.fa>ncRNA_md.fa & 
E: clean reads alignment trRNA snRNA snoRNA
nohup bowtie -v 2 ../../trRNA/rtRNA -f L4_clean.fa -S L4_trRNA.sam >err>bowtie.err &
nohup blastall -p blastn -i ncRNA_L4_md.fa -d ~/JianyingLi/software/Rfam/Rfam.fasta -e 0.001 -m 8 -b 5 -v 5 -o zs_ncRNA.txt > err > blastn.err &
#=============== Structure-based annotation=======================
1. mapping clean reads to genome with no-mismatch (-v 0) and up to 100 matches (-a -m 100); 
eg: bowtie -p 10 -v 0 -a -m 200 ~/Public_data/TM-1_Genome/bowtie_2K/TM-1 -f $file.final.siRNA.fa $file.bwt
2.subtracting the upstream and downstream 150 bp of the miRNA mapping site, naming "premiRNA_putative_seq" 
eg: perl ~/scripts/miRNA-scripts/getMiRNAseqFromScaffold.pl -i $file_notrRNAsnRNA.fa.bwt -g
/public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.fa >$file_premiRNA_putative_seq.txt
3.formatting the "premiRNA_putative_seq" file for miRcheck software, and splitting the file
eg: perl ~/scripts/miRNA-scripts/get_Site.pl ../$file_notrRNAsnRNA.fa $file_premiRNA_putative_seq.txt >$file_For_miRcheck.fa
大小分割：split -b 500m $file _For_miRcheck.fa $file
行数分割：
split-l 3460000 /public/home/jyli/TasiRNA/SmallRNA/Clean/$file _For_miRcheck.fa $file
4.Running miRcheck
Note: modify "miRcheck.pm",246 lines RNAfold software path: /public/home/cotton/software/ViennaRNA-2.1.8/bin/RNAfold, and edit  script of "test_mircheck.pl" lib path /public/home/jyli/sofware/miRcheck
eg:perl /public/home/cotton/software/miRcheck/miRcheck_scripts/test_mircheck.pl $fileaa
5.parsing the miRcheck output to get the "true" "premiRNA_seq"
A: awk '{if ($2=="5prime" || $2=="3prime") print$1}'
${ID}.miRcheck_out.txt >${ID}.miRcheck_out.id

B: perl /public/home/jyli/scripts/getSeq_hash.pl -i ${ID}.miRcheck_out.id -f /public/home/jyli/miRNA_clean/TM_1_analysis/${ID}_premiRNA_putative_seq.txt -o ${ID}_miRcheck_out.fa 
6.filtering the protein-coding transcripts from the "premiRNA_seq", and get the putative precursors
blastall -p blastn -i ${ID}_miRcheck_out.fa -d
/public/home/jyli/Public_data/Cotton_CDS/GhGbGrGa_cds.fa -o ${ID}_vs_GbGrGa.out -e 1e-10 -v 1 -b 1 -a 18 
php /public/home/jyli/scripts/blast.sta.simple.php ${ID}_vs_GbGrGa.out
grep "NoHits" ${ID}_vs_GbGrGa.out.sta >${ID}.precusor
awk '{print $2}' ${ID}.precusor >${ID}.precusor.id
perl /public/home/jyli/scripts/getSeq_hash.pl -i ${ID}.precusor.id -f ${ID}_miRcheck_out.fa -o ${ID}.precusor.fa

=========================Probability-based annotation================
2015-11-25
7. "aln" files convert single ID
bowtie -p 5 -v 0 -a -m 200 H0-2.precusor -f /public/home/jyli/miRNA_clean/Clean/H0-2_notrRNAsnRNA.fa > H0-2.aln &
sed 's/_-_/\t/g' /public/home/jyli/TM-1_miRNA/L2_miRcheck/prediction/Precusor/H0-2.aln |sed 's/_+_/\t/g'|cut -f1,2 >1
sed 's/_-_/\t/g' /public/home/jyli/TM-1_miRNA/L2_miRcheck/prediction/Precusor/H0-2.aln |sed 's/_+_/\t/g'|cut -f4,6-8|sed 's/_/\t/g' >2
paste 1 2 >H0-2.new.aln

#===================miRDP prediction miRNAs loci=====================
8.convert_bowtie output to blast format
perl /public/home/jyli/software/miRDP1.3/convert_bowtie_to_blast.pl H0-2.new.aln /public/home/jyli/miRNA_clean/Clean/H0-2_notrRNAsnRNA.fa ~/Public_data/TM-1_Genome/tm_1_v01c01.fa > H0-2.bst
9.the process of obtaining candidate precursors
perl /public/home/jyli/software/miRDP1.3/excise_candidate.pl ~/Public_data/TM-1_Genom
e/tm_1_v01c01.fa H0-2.bst 250 >H0-2_precursors.fa & 
10.the process of exploring secondary structure of candidate precursors
cat  H0-2_precursors.fa| RNAfold --noPS > H0-2_structures &
11.filtering alignment by annotation
perl /public/home/jyli/software/miRDP1.3/filter_alignments.pl H0-2.bst -b /public/home/jyli/miRNA_clean/Clean/H0-2_notrRNAsnRNA.fa > H0-2_filtered.fa &
12.filter reads alignment precusors
mkdir bowtie-index
bowtie-build -f H0-2_precursors.fa bowtie-index/H0-2_precursors
bowtie -a -v 0 bowtie-index/H0-2_precursors -f H0-2_filtered.fa > H0-2_precursors.aln
13. convert_bowtie output to blast format
perl /public/home/jyli/software/miRDP1.3/convert_bowtie_to_blast.pl H0-2_precursor
s.aln H0-2_filtered.fa H0-2_precursors.fa > H0-2_precursors.bst
14.filtering the alignment and sorting
perl /public/home/jyli/software/miRDP1.3/filter_alignments.pl H0-2_precursors.bst 
-c 50|sort +3 -25 >H0-2_signatures
15.miRNA prediction using miRDP
perl /public/home/jyli/software/miRDP1.3/miRDP.pl H0-2_signatures H0-2_structur
es >H0-2_predictions
16. remove redundant and meet plant criterion
perl /public/home/jyli/software/miRDP1.3/rm_redundant_meet_plant.pl ~/Public_data/TM-1_Genome/tm_1_v01c01.fa.len.lst H0-2_precursors.fa H0-2_predictions H0-2_nr_predictions H0-2_filter_P_prediction &
17. annotation miRNA by BLASTN of the mature miRNA against known miRNAs deposited in miRBase21
eg: blastall -p blastn -i ${ID}_miRNA_seq.fa -d
/public/home/jyli/Public_data/miRNA_data/miRBase20/new.cotton.mature.fa -o ${ID}_miRNA_vs_miRBase20Cotton.out -e 0.001 -v 1 -b 1
