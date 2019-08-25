#!/bin/bash
#$ -cwd
#$ -S /bin/bash

DIR=/data/project/MouseReadFilter

HumanDIR=$DIR/3.aligned/unfiltered_hg19
MouseDIR=$DIR/3.aligned/unfiltered_mm10
OutputDIR=$DIR/3.aligned/filtered_StrictFiltering

h=$1
m=$2
r=$3
s=$4

samtools view -F 4 $MouseDIR/$h'_'$m'_'$r'_'$s'.bam' | cut -f1 | sort -u > $MouseDIR/'unfiltered_mm10_'$h'_'$m'_'$r'_'$s'_readID.txt'

gatk --java-options "-Xmx8G" FilterSamReads \
--INPUT $HumanDIR/$h'_'$m'_'$r'_'$s'.RGadded.marked.fixed.bam' \
--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.RGadded.marked.fixed.strictfiltered.bam' \
--READ_LIST_FILE $MouseDIR/'unfiltered_mm10_'$h'_'$m'_'$r'_'$s'_readID.txt' \
--FILTER excludeReadList \
--CREATE_INDEX true

#gatk  FilterSamReads \
#--INPUT $HumanDIR/$h'_'$m'_'$r'_'$s'.RGadded.marked.realigned.fixed.bam' \
#--OUTPUT $OutputDIR/$h'_'$m'_'$r'_'$s'.RGadded.marked.realigned.fixed.NM0mm10.bam' \
#--READ_LIST_FILE $MouseDIR/'NM0_'$h'_'$m'_'$r'_'$s'_readID.txt' \
#--FILTER includeReadList \
#--CREATE_INDEX true
