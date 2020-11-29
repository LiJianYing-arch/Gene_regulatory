label=L6
perl /home/genome/biosoft/NGSQCToolkit_v2.3.3/Format-converter/FastqToFasta.pl -i cotton_${label}_remove_adapter.fq -o cotton_${label}.fa & 

perl /data04/NCBI_SRA/Cotton_miRNA_degradome/SRA/collapse_reads.pl cotton_${label}.fa >cotton_${label}_collapse.fa &

perl ~/MaojunWang/script/seq.len.pl cotton_${label}_collapse.fa &

awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; if (length(seq) <=26 ) {print header, seq}}' cotton_L4_collapse.fa >L4_clean.fa &

# cut -f 2 cotton_${label}_collapse.fa.len.lst |sort |uniq -c >cotton_${label}_collapse.fa.len.lst.sta &

# awk '{print $1,"\t",$2}' cotton_${label}_collapse.fa.len.lst.sta >${label}.txt

# awk '{print $2}' cotton_L3_collapse.fa.len.lst|sort|uniq -c|awk '{print $1,"\t",$2}'>tmp
