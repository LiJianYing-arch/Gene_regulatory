perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/QC/IlluQC.pl -se ../cotton_L4_remove_adapter.fq 5 5 -l 18 -s 20 -t 2 &

perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/Trimming/AmbiguityFiltering.pl -i IlluQC_Filtered_files/*filtered -c 0 -o L4_reads.fastq &

perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/Format-converter/FastqToFasta.pl -i L4_reads.fastq -o L4_reads.fa &

awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; if (length(seq) <=26 && length(seq)>=18) {print header, seq}}' L4_reads.fa >ncRNA.fa &

perl /data04/NCBI_SRA/Cotton_miRNA_degradome/SRA/collapse_reads.pl ncRNA.fa>ncRNA_md.fa & 

nohup bowtie -v 2 ../../trRNA/rtRNA -f L4_clean.fa -S L4_trRNA.sam >err>bowtie.err &

nohup blastall -p blastn -i ncRNA_L4_md.fa -d ~/JianyingLi/software/Rfam/Rfam.fasta -e 0.001 -m 8 -b 5 -v 5 -o zs_ncRNA.txt > err > blastn.err &
