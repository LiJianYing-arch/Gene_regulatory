perl getOverLapping.pl H0-1_notrRNAsnRNA.fa H0-2_notrRNAsnRNA.fa >H0-1_vs_H0-2 # common
sed 's/_x/\t/g' H0-1_vs_H0-2 |awk '{total += $3}END{print total}'              #Rep1 Raw reads
sed 's/_x/\t/g' H0-1_vs_H0-2 |awk '{total += $5}END{print total}'              #Rep2 Raw reads
perl getOverLapping_length.pl H0-1_notrRNAsnRNA.fa H0-2_notrRNAsnRNA.fa 24 >L1L2-24 # getoverlap 24nt
