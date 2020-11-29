======================================prediction_miRNA=======================================
perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/25dpa_filter50_signatures ./RNAfold/25dpa_structure.txt >prediction/25dpa_predictions 

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/20dpa_filter50_signatures ./RNAfold/20dpa_structure.txt >prediction/20dpa_predictions 

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/12dpa_filter50_signatures ./RNAfold/12dpa_structure.txt >prediction/12dpa_predictions 

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/7dpa_filter50_signatures ./RNAfold/7dpa_structure.txt >prediction/7dpa_predictions 

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/3dpa_filter50_signatures ./RNAfold/3dpa_structure.txt >prediction/3dpa_predictions  

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/fu3dpa_filter50_signatures ./RNAfold/fu3dpa_structure.txt >prediction/fu3dpa_predictions 

perl ~/MaojunWang/miRNA/miRDP1.3/miRDP.pl reMap/0dpa_filter50_signatures ./RNAfold/0dpa_structure.txt >prediction/0dpa_predictions 

=====================================rm_redundant and meet plant criterion======================
perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../0dpa_precursors.fa 0dpa_predictions 0dpa_nr_predictions 0dpa_filter_P_prediction 2>err.0 

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../fu3dpa_precursors.fa fu3dpa_predictions fu3dpa_nr_predictions fu3dpa_filter_P_prediction 2>err.fu3

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../3dpa_precursors.fa 3dpa_predictions 3dpa_nr_predictions 3dpa_filter_P_prediction 2>err.3 

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../7dpa_precursors.fa 7dpa_predictions 7dpa_nr_predictions 7dpa_filter_P_prediction 2>err.7

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../12dpa_precursors.fa 12dpa_predictions 12dpa_nr_predictions 12dpa_filter_P_prediction 2>err.12

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../20dpa_precursors.fa 20dpa_predictions 20dpa_nr_predictions 20dpa_filter_P_prediction 2>err.20

perl ~/MaojunWang/miRNA/miRDP1.3/rm_redundant_meet_plant.pl ../cotton.draft.genome.fa.len.lst ../25dpa_precursors.fa 25dpa_predictions 25dpa_nr_predictions 25dpa_filter_P_prediction 2>err.25 
