import argparse
import numpy

parser = argparse.ArgumentParser()
parser.add_argument('input', help='input file name with its path (TSV formatted output of GATK CollectAllelicCounts)')
args = parser.parse_args()


## Read HAMAlist ##

HAMAlist_file = open('HAMAlist.v002.vcf','r')
HAMAlist = {}

for HAMAlist_line in HAMAlist_file :

	if HAMAlist_line[0] == '#' : continue

	hama_col = HAMAlist_line.split('\t')
	hama_id = hama_col[0]+'.'+hama_col[1]+hama_col[3]+'>'+hama_col[4]

	HAMAlist.update({hama_col[0]+'.'+hama_col[1]:hama_col[3]+'>'+hama_col[4]})


## Estimate input file ##

input_file = open('%s'%args.input,'r')

HAMAF_list = []

for input_line in input_file :

	if input_line[0] == '@' : continue
	if input_line[:6] == 'CONTIG' : continue

	col = input_line.rstrip('\n').split('\t')

	pos = col[0]+'.'+col[1]
	base = col[4]+'>'+col[5]

	if pos in HAMAlist :
		if base == HAMAlist[pos] :
			HAMAF = float(col[3])/(float(col[2])+float(col[3]))
		else : continue
		HAMAF_list.append(HAMAF)
	else : continue

HAMAF_median = numpy.median(HAMAF_list)


## Print result ##

print ('## MouseContamEstimator v0.1-beta.1 ##')
print ('Input File:\t'+args.input.split('/')[-1])
print ('Number of HAMA:\t'+str(len(HAMAF_list)))
print ('Median of HAMAFs:\t'+str(HAMAF_median))

if len(HAMAF_list) < 120000 :
	print ('Estimated Mouse Contamination Ratio:\t The number of HAMA is insufficient to perform the estimation. (possibly no contamination of murine genome.)')
else :
	if (HAMAF_median/0.7396)*100 >= 100 :
		print ('Estimated Mouse Contamination Ratio:\t100 %')
	else :
		print ('Estimated Mouse Contamination Ratio:\t'+str(round((HAMAF_median/0.7396)*100,1))+' %')
