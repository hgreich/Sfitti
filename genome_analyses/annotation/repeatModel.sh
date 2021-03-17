#!/bin/bash
#SBATCH --time=120:00:00   # walltime
#SBATCH --ntasks=6   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=8G   # memory per CPU core
#SBATCH -J "rmod2"   # job name
#SBATCH --output "rmod2"

echo "Time: $(date)"
start=$(date +%s)

#mkdir repeatModel
cd ./repeatModel

##Make database for RepeatModeler and RepeatMasker
#/central/groups/Parker_lab/tools/RepeatModeler-open-1.0.11/BuildDatabase -engine ncbi \
#-name "Sfitti" ../AC_Sfitti_2.fa

#RepeatModeler
#/central/groups/Parker_lab/tools/RepeatModeler-open-1.0.11/RepeatModeler -engine ncbi -pa 5 -database Sfitti

#echo "## Searching censor..."

#censor
#/central/groups/Parker_lab/tools/censor-4.2.29/bin/censor.ncbi ./Sfitti-families.fa -s -lib dia '-p 6'

#pull out the matches with the highest score for each family
#sort -k 1,1 -k 11,11 -r -n Sfitti-families.fa.map | sort -u  -k1,1 > Sfitti_cen_uniq.map

#convert to tab-delimited
#sed "s/ \+/\t/g" Sfitti_cen_uniq.map > out
#mv out Sfitti_cen_uniq.map

#echo "$(wc -l < Sfitti_cen_uniq.map) hits"

library="Sfitti-families.fa"
blastdbcmd="/central/groups/Parker_lab/tools/ncbi/ncbi-blast-2.7.1+/bin/blastdbcmd"
blastoutfile="Sfitti_repeats_blastReport.txt"
db="/central/groups/Parker_lab/tools/ncbi/nr/nr"
fastagrep="/central/groups/Parker_lab/tools/fastagrep.pl"

echo "## Blast nr database..."

#blast repeat families against beelte protein database
/central/groups/Parker_lab/tools/blastx -query $library -db $db -evalue 1e-5  \
-max_hsps 1 -num_threads 6 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' \
-out $blastoutfile

#get unique hits
echo "## Filtering for top scoring hit"
grep -v '^#' $blastoutfile \
       | sort -k 1,1n -k12,12gr -k 11,11g \
       | sort -u  -k1,1 > uniq.blast.txt
echo "$(wc -l < uniq.blast.txt) hits for all elements"

#pull out headers from the repeat model families file
grep ">" Sfitti-families.fa > Sfitti-head.txt

sed 's/>//' Sfitti-head.txt > Sfitti_head2.txt

sed 's/\s.*$//' Sfitti_head2.txt > Sfitti_head3.txt

rm Sfitti-head.txt
rm Sfitti-head2.txt

module load R/3.6.1

Rscript ../repeatTable_merge.R Sfitti_head3.txt uniq.blast.txt Sfitti_cen_uniq.map

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
