nohup blastall -p blastn -i ncRNA_L4_md.fa -d ~/JianyingLi/software/Rfam/Rfam.fasta -e 0.001 -m 8 -b 1 -v 1 -o zs_ncRNA.txt > err > blastn.err &

rfam_scan.pl -blastdb /public/home/jyli/Public_data/miRNA_data/Rfam/Rfam.fasta /public/home/jyli/Public_data/miRNA_data/Rfam/Rfam.cm genome.fasta -o rfam.gff3

