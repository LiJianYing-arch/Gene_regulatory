#!/bin/bash 

for file in `ls *.fa`
do
bowtie -p 15 -v 0 -a -m 200 /data02/Cotton_RNA_SEQ/Bowtie_index/cotton.draft.genome -f $file $file.bwt 
done
exit
