#!/bin/bash
#$ -S /bin/bash
#$ -cwd


DIR=/data/project/MouseReadFilter
HumanDIR=$DIR/3.aligned/unfiltered_hg19
MouseDIR=$DIR/3.aligned/unfiltered_mm10
OutputDIR=$DIR/3.aligned/filtered_Disambiguate

h=$1
m=$2
r=$3
s=$4

date

python /home/shockyoung/Documents/Tools/disambiguate/disambiguate.py \
-o $OutputDIR/ \
-d \
-a bwa \
$HumanDIR/$h'_'$m'_'$r'_'$s'.resorted.bam' \
$MouseDIR/$h'_'$m'_'$r'_'$s'.resorted.bam'

date


gatk --java-options "-Xmx8G" SortSam \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.resorted.disambiguatedSpeciesA.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.bam' \
--SORT_ORDER coordinate \
--VALIDATION_STRINGENCY LENIENT \
--CREATE_INDEX true


gatk --java-options "-Xmx8G" AddOrReplaceReadGroups \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.bam' \
--SORT_ORDER coordinate \
--RGLB MouseReadFilter \
--RGPL illumina \
--RGPU illumina \
--RGSM $h'_'$m'_'$r'_'$s \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT



gatk --java-options "-Xmx8G" MarkDuplicates \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.marked.bam' \
--METRICS_FILE $OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.marked.metrics' \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT



gatk --java-options "-Xmx8G" FixMateInformation \
--INPUT=$OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.marked.bam' \
--OUTPUT=$OutputDIR/$h'_'$m'_'$r'_'$s'.disambiguated.RGadded.marked.fixed.bam' \
--SORT_ORDER coordinate \
--VALIDATION_STRINGENCY SILENT \
--CREATE_INDEX true

