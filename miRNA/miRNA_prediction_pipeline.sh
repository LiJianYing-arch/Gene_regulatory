=====================================Raw data pre-processing=====================================================
1. eliminating low quality reads, trimming 3'-adapter and 5'adapter_contaminants, and filtering too small and polyA reads ;

2. transferring Fastq to FastA file ;

3. excluding tRNA, rRNA, snRNA and snoRNA (blastn e-value 0.001) ; 

=====================================Structure-based annotation===================================================4. mapping clean reads to genome with no-mismatch (-v 0) and up to 100 matches (-a -m 100);
   eg: a. bowtie -S -p 16 -v 0 -a -m 200 /data02/Cotton_RNA_SEQ/Bowtie_index/cotton.draft.genome \ 
           -f $file --al $file.aligned --un $file.unaligned $file.sam 
       b. bowtie -p 20 -v 0 -a -m 200 /data02/Cotton_RNA_SEQ/Bowtie_index/cotton.draft.genome -f $file $file.bwt 

5. subtracting the upstream and downstream 150 bp of the miRNA mapping site, naming "premiRNA_putative_seq" ; 
   eg: perl getMiRNAseqFromScaffold.pl -i mapping_Gb/0dpa_clean_No-tRNA-rRNA-snRNA.fa.bwt \ 
       -g /data01/genome/Gb_transcriptome/new_cotton.draftgenome.fa >0DPA_premiRNA_putative_seq.txt &

6. formatting the "premiRNA_putative_seq" file for miRcheck software, and splitting the file;
   eg: perl get_Site.pl 0dpa_clean_No-tRNA-rRNA-snRNA.fa 0DPA_premiRNA_putative_seq.txt >0dpa_For_miRcheck.fa &

       split -l 692000 ../0dpa_For_miRcheck.fa Fzo & 

7. Running miRcheck ;
   eg: perl -e '{my $a="Fzoaa"; while($a lt "Fzoap"){my $file = $a; \
       system("perl /home/genome/MaojunWang/miRNA/miRcheck/test_mircheck.pl $file
        >$file\.miRcheck_out\.txt 2>err\.$file\.miRcheck_out.txt &"); $a++}}'  2>err &

8. parsing the miRcheck output to get the "true" "premiRNA_seq" ;
   eg: a. awk '{if ($2=="5prime" || $2=="3prime") print$1}' 0dpa_miRcheck_out.txt > 0dpa_miRcheck_out.id 
       b. perl ~/MaojunWang/Gb_biology/getSeq_hash.pl -i 0dpa_miRcheck_out.id -f \ 
          ../0DPA_premiRNA_putative_seq.txt -o 0dpa_miRcheck_out.fa &

9. filtering the protein-coding transcripts from the "premiRNA_seq", and get the putative precursors ;
   eg: blastall -p blastn -i 0dpa_miRcheck_out.fa -d ../GbGr_transcriptPrimaryOnly.fa \ 
       -o 0dpa_vs_GbGr.out -e 1e-10 -v 1 -b 1 -a 8 2>err.blast &

=======================================Probability-based annotation==============================================
10. mapping the clean reads to the putative precursors from the output of step 9 ;
   eg: bowtie -p 5 -v 0 -a -m 200 ../0dpa_precursors -f ./new_0dpa_clean_No-tRNA-rRNA-snRNA.fa >0dpa.aln 

11. get the structure information for the putative precursors using RNAfold ;
   eg: cat 0dpa_precursors.fa | RNAfold -noPS >0dpa_structures.txt

12. convert_bowtie output of step 10 to blast format ;
   eg: a. perl ~/MaojunWang/miRNA/miRDP1.3/convert_bowtie_to_blast.pl 0dpa.aln \
          new_0dpa_clean_No-tRNA-rRNA-snRNA.fa ../0dpa_precursors.fa >0dpa.bst

13. filtering the alignment and sorting of step 12 (-c set the cutoff of the largest miRNA family) ;
    eg: perl ~/MaojunWang/miRNA/miRDP1.3/filter_alignments.pl 0dpa.bst -c 50  |sort +3 -25 >0dpa_filter50_signatures & 
       
14. miRNA prediction using miRDP ;
    eg: perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/0dpa_filter50_signatures \
          ./RNAfold/0dpa_structure.txt >0dpa_predictions 

15. remove redundant and meet plant criterion ;
    eg: perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst \
        ../0dpa_precursors.fa 0dpa_predictions 0dpa_nr_predictions 0dpa_filter_P_prediction 2>err.0dpa

16. annotation miRNA by BLASTN of the mature miRNA against known miRNAs deposited in miRBasee (e-value 0.001) ;
=============================================THE END==================================================================
