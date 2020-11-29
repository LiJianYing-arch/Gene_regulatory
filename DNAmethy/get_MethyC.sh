#!/bin/bash
#PBS -N parseMethyC
#PBS -l nodes=1:ppn=1
#PBS -l walltime=480:00:00
#PBS -o parse_log
#PBS -e errlog
#PBS -q batch

echo "Start at"
date

cd $PBS_O_WORKDIR

for ID in ML01 ML02 ML03 ML04 ML05 ML06
do
    mkdir Tmp_${ID}
    awk '{if ($4+$5>=3) print}' ${ID}_mappingGh_extractor/Sample_${ID}_merged_bismark_bt2_pe.CX_report.txt >${ID}_MethyC_3depth.txt
    cd Tmp_${ID}
    split -l 10000000 ../${ID}_MethyC_3depth.txt
    for id in `ls`
    do
        R --no-save --slave < ../binom-test.R >${id}_result.txt --args $id
        cat -n $id >${id}.raw
        sed 's/"//g' ${id}_result.txt |awk '{OFS="\t"}{print $2,$3}' >${id}_result.txt.new
        perl ../getEvalue.pl ${id}_result.txt.new ${id}.raw >${id}_parse.txt
    done
    cat *_parse.txt >../${ID}_MethyC_3depth_binorm.txt
    cd ..
    awk '{if ($4/($4+$5) >=0.25) print}' ${ID}_MethyC_3depth_binorm.txt >${ID}_MethyC_3depth_binorm_0.25.txt
done

echo "End at:"
date
