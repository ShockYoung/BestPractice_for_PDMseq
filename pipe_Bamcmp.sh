#!/bin/bash
#$ -cwd
#$ -S /bin/bash

DIR=/data/project/MouseReadFilter

HumanDIR=$DIR/3.aligned/unfiltered_hg19
MouseDIR=$DIR/3.aligned/unfiltered_mm10
OutputDIR=$DIR/3.aligned/filtered_Bamcmp

h=$1
m=$2
r=$3
s=$4


samtools sort -n -o $HumanDIR/$h'_'$m'_'$r'_'$s'.resorted.bam' $HumanDIR/$h'_'$m'_'$r'_'$s'.bam'
samtools sort -n -o $MouseDIR/$h'_'$m'_'$r'_'$s'.resorted.bam' $MouseDIR/$h'_'$m'_'$r'_'$s'.bam' 

date

/home/ejyoung90/bamcmp-master/build/bamcmp -n \
-1 $HumanDIR/$h'_'$m'_'$r'_'$s'.resorted.bam' \
-2 $MouseDIR/$h'_'$m'_'$r'_'$s'.resorted.bam' \
-a $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.humanOnly.sam' \
-A $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.humanBetter.sam' \
-s match

date

samtools merge $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.bam' $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.humanOnly.sam' $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.humanBetter.sam'


gatk --java-options "-Xmx8G" SortSam \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.bam' \
--SORT_ORDER coordinate \
--VALIDATION_STRINGENCY LENIENT \
--CREATE_INDEX true


gatk --java-options "-Xmx8G" AddOrReplaceReadGroups \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.bam' \
--SORT_ORDER coordinate \
--RGLB MouseReadFilter \
--RGPL illumina \
--RGPU illumina \
--RGSM $h'_'$m'_'$r'_'$s \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT



gatk --java-options "-Xmx8G" MarkDuplicates \
--INPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.marked.bam' \
--METRICS_FILE $OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.marked.metrics' \
--CREATE_INDEX true \
--VALIDATION_STRINGENCY SILENT



gatk --java-options "-Xmx8G" FixMateInformation \
--INPUT=$OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.marked.bam' \
--OUTPUT=$OutputDIR/$h'_'$m'_'$r'_'$s'.bamcmp.sorted.RGadded.marked.fixed.bam' \
--SORT_ORDER coordinate \
--VALIDATION_STRINGENCY SILENT \
--CREATE_INDEX true


