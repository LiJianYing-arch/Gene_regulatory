#-------start genome convernt--
bismark_genome_preparation --path_to_bowtie /public/home/cotton/software/bowtie2-2.2.4/ --bowtie2 --verbose ./

#-------bismark mapping--------
#eg: paired
bismark /public/home/jyli/Public_data/TM-1_Genome/DNA_methy/ --bowtie2 --non_directional -N 1 -L 30 -p 15 -1 /public/home/jyli/DNA_methy/Clean/T01/T01_merge_1.fq -2 /public/home/jyli/DNA_methy/Clean/T01/T01_merge_2.fq -o T01_mapping
#eg: unpaired 
zcat T0_1.unpaired.fastq.gz T0_2.unpaired.fastq.gz | gzip - > T0_un_merge.fastq.gz &
bismark /public/home/jyli/Public_data/TM-1_Genome/DNA_methy/ --boT0ie2 --non_directional -N 1 -L 30 -p 15 /public/home/jyli/DNA_methy/Clean_new/T0_un_merge.fastq.gz -o T0_un_mapping

#------bismark extractor-------
bismark_methylation_extractor -p --no_overlap --ignore_r2 3 --ignore 5 --bedGraph --comprehensive --counts --scaffolds --buffer_size 200G --multicore 15 --cytosine_report --CX_context --genome_folder /public/home/jyli/Public_data/TM-1_Genome/DNA_methy/ ./T01.clean.merge.sam


