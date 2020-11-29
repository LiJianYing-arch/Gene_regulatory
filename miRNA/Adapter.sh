label=L1
base=AGTCAA
cat ${label}_${base}_L001_R1_00* > cotton_${label}.fq.gz
java -jar /home/genome/biosoft/Trimmomatic/trimmomatic-0.32.jar SE -threads 10 -phred33 cotton_${label}.fq.gz cotton_${label}_remove_adapter.fq ILLUMINACLIP:sRNA.fa:2:30:10 LEADING:10 TRAILING:10 SLIDINGWINDOW:1:10 MINLEN:16
