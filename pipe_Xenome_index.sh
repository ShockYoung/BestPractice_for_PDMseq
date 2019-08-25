#!/bin/bash
#$ -cwd
#$ -S /bin/bash

DataPath=$1
OutputPath=$2
IDXPath=$3
SAMPLE=$4

xenome index \
-T 8 \
-G /data/resource/reference/human/UCSC/hg19/BWAIndex/genome.fa \
-H /data/resource/reference/mouse/UCSC/mm10/BWAIndex/genome.fa \
-P $IDXPath/idx
