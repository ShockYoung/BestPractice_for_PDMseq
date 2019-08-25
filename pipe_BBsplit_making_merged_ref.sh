#!/bin/bash 
#$ -cwd
#$ -S /bin/bash


DataPath=$1
SAMPLE=$2


MouseRef=/data/resource/reference/mouse/UCSC/mm10/BWAIndex/genome.fa
HumanRef=/data/resource/reference/human/UCSC/hg19/BWAIndex/genome.fa


/home/shockyoung/Documents/Tools/BBMap/bbsplit.sh \
	threads=8 \
	build=1 \
	ref_Mouse=$MouseRef \
	ref_Human=$HumanRef 
