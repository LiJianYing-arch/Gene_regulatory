#2------------------------1-fiter----------------------------
java -jar /public/home/cotton/software/Trimmomatic/trimmomatic-0.32.jar PE -threads 1 -phred33 -trimlog ${ID}_trim.log ../Raw_reads/${ID}_1.fastq ../Raw_reads/${ID}_2.fastq ./${ID}_1.clean.fastq ./${ID}_1.unpaired.fastq ./${ID}_2.clean.fastq ./${ID}_2.unpaired.fastq ILLUMINACLIP:/public/home/cotton/software/Trimmomatic/adapters/TruSeq3-PE.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:20 MINLEN:50
rm -f ${ID}_1.unpaired.fastq ${ID}_2.unpaired.fastq ${ID}_trim.log
#2------------------------2-mapping----------------------------
/public/home/jyli/software/tophat-2.0.13.Linux_x86_64/tophat2 -p 2 -G /public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.all.gff3 -o ${ID}_mapping_Gh /public/home/jyli/Public_data/TM-1_Genome/tm_1 ../clean/${ID}_1.clean.fastq ../clean/${ID}_2.clean.fastq
#3------------------------3-cufflinks----------------------------
cufflinks -p 5 -G /public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.gene.gff3 -b /public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.fa -u -o ${ID}_expression ../Tophat/${ID}_mapping_Gh/accepted_hits.bam
#4------------------------4-cuffdiff-----------------------------
cuffmerge -p 10 -g /public/home/jyli/Public_data/TM-1/tm_1_v01c01.gene_2k_Raw.gff3 -s /public/home/jyli/Public_data/TM-1_Genome/tm_1v01c01.fa -o merge89_76 assemble.txt

cuffdiff -o diff89-76_out -b /public/home/jyli/Public_data/TM-1_Genome/tm_1_v01c01.fa -p 10 -L C1,C2, -u merge89_76/merged.gtf C1_R1_SRR1363518_mapping_Gb/accepted_hits.bam,C1_R2_SRR1363519_mapping_Gb/accepted_hits.bam C2_R1_SRR1363516_mapping_Gb/accepted_hits.bam,C2_R2_SRR1363517_mapping_Gb/accepted_hits.bam

