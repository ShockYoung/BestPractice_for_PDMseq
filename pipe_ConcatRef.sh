#! /bin/bash
#$ -S /bin/bash
#$ -cwd

# basic argument
PROJECT=$1
AlignedPath=$2
Candidate=$3
INPUT=$4
DIR=$5
SCRIPT=$DIR/script/tool_ConcatRef
ID=${INPUT%%.bam*}

# print start time
date

# 1. Extract hg19 aligned reads

for ((i=1;i<23;i++));
do
	chr=chr$i.hg19
	chr_list="$chr_list $chr"
done

samtools view -b $AlignedPath$INPUT chrM.hg19 $chr_list chrX.hg19 chrY.hg19 > $AlignedPath$ID.hg19.bam
samtools index $AlignedPath$ID.hg19.bam $AlignedPath$ID.hg19.bai


# 2. Replace BAM header

samtools view -H $AlignedPath$ID.hg19.bam | sed -e 's/SN:\(chr[0-9MXY]\).hg19/SN:\1/' -e 's/SN:\(chr[0-9][0-9]\).hg19/SN:\1/' | samtools reheader - $AlignedPath$ID.hg19.bam > $AlignedPath$ID.hg19.reheadered.bam
samtools index $AlignedPath$ID.hg19.reheadered.bam $AlignedPath$ID.hg19.reheadered.bai


# 3. Remove remained RNEXT mm10 reads

samtools view -h $AlignedPath$ID.hg19.reheadered.bam | awk -F '\t' '{ if (index($2,"mm10")==0 && index($7,"mm10")==0) print $0 }' | samtools view -bS - > $AlignedPath$ID.ConcatRef.bam
samtools index $AlignedPath$ID.ConcatRef.bam $AlignedPath$ID.ConcatRef.bai


# print end time
date
