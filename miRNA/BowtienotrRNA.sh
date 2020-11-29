label=L3
bowtie -v 2 ../../trRNA/rtRNA -f ${label}_nocollapse_clean.fa -S ${label}_trRNA.sam >bowtie
samtools view -bS ${label}_trRNA.sam >${label}_trRNA.bam
samtools view -bf 4 ${label}_trRNA.bam >${label}_sRNA.bam             
samtools view -h -o ${label}_sRNA.sam ${label}_sRNA.bam
grep -v @ ${label}_sRNA.sam > ${label}_v.sRNA.sam
cat ${label}_v.sRNA.sam | awk '{print ">"$1"\n"$10}' > ${label}_notrRNAsnRNA.fa
