#!/bin/bash 
#$ -cwd
#$ -S /bin/bash


DataPath=$1
SAMPLE=$2

OutputPath=/data/project/MouseReadFilter/1.raw/filtered_BBsplit



/home/shockyoung/Documents/Tools/BBMap/bbsplit.sh \
	threads=4 \
	build=1 \
	in=$DataPath/${SAMPLE}_1.fq \
	in2=$DataPath/${SAMPLE}_2.fq \
	basename=$OutputPath/${SAMPLE}_%_#.fq
