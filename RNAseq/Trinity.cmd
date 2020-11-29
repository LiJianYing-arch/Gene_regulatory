========================================================Trinity=======================================================================Trinity.pl --seqType fq --JM 50G --left S9_R1.fq --right S9_R2.fq --SS_lib_type FR --output S9.out --CPU 15 --inchworm_cpu 15 --group_
pairs_distance 1000 --bflyCPU 15 & 
========================================================RSEM==========================================================================perl /data02/guest/JianyingLi/RNA-seq/software/trinityrnaseq_r2013-02-25/util/RSEM_util/run_RSEM_align_n_estimate.pl --transcripts ../S1.out/Trinity.fasta --seqType fq --SS_lib_type FR --left ../../ZLZ/Sample_ZLZ1/Sample1_Clean/S1_R1.fastq --right ../../ZLZ/Sample_ZLZ1/Sample1_Clean/S1_R2.fastq --thread_count 8 --prefix S1 >err>errlog &
========================================================Different expression==========================================================sed 's/NA/0/g' 1-9.counts.matrix > 1-9.counts.matrix_new
vi 1-9.counts.matrix_new    delete "ID"  #### must be matrix!!!!

perl /data02/guest/JianyingLi/RNA-seq/software/trinityrnaseq_r2013-02-25/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix 1
-9.counts.matrix_new --method DESeq --DESEQ_method blind --DESEQ_sharingMode fit-only --DESEQ_fitType local --output SSS.new > errr > 
errrlog &
=====================DE1-9=========================
perl /data02/guest/JianyingLi/RNA-seq/software/trinityrnaseq_r2013-02-25/Analysis/DifferentialExpression/merge_subclusters.pl S1.lengt
h S9.length >S19
==================================================
perl /data02/guest/JianyingLi/RNA-seq/software/trinityrnaseq_r2013-02-25/Analysis/DifferentialExpression/run_TMM_normalization_write_F
PKM_matrix.pl --matrix 1-9.counts.new.matrix --lengths S19  >err>errlog &
====================DE12-56=======================
perl /data02/guest/JianyingLi/RNA-seq/software/trinityrnaseq_r2013-02-25/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix t
ranscripts.counts.matrix.new --method DESeq --samples_file samples_described.txt --DESEQ_method blind --DESEQ_sharingMode fit-only --D
ESEQ_fitType local --output test_out >log 2>errlog &
=================================================
