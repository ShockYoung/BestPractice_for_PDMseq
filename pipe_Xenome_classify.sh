#!/bin/bash
#$ -cwd
#$ -S /bin/bash

DataPath=$1
OutputPath=$2
IDXPath=$3
SAMPLE=$4

xenome classify -T 4 -P ${IDXPath}/idx --pairs --graft-name human --host-name mouse \
--output-filename-prefix $OutputPath$SAMPLE \
-i $DataPath$SAMPLE'_1.fq' -i $DataPath$SAMPLE'_2.fq'

awk '{if (NR % 4 == 1) print "@"$0; else if (NR % 4 == 3) print "+"$0; else print $0 }' $OutputPath$SAMPLE'_human_1.fastq' > $OutputPath$SAMPLE'_human_1.fq'
awk '{if (NR % 4 == 1) print "@"$0; else if (NR % 4 == 3) print "+"$0; else print $0 }' $OutputPath$SAMPLE'_human_2.fastq' > $OutputPath$SAMPLE'_human_2.fq'
