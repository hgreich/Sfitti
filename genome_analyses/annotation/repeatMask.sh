#!/bin/bash
#SBATCH --time=48:00:00  # walltime
#SBATCH --ntasks=4   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "rmask"   # job name
#SBATCH --output "rmask"

echo "Time: $(date)"
start=$(date +%s)

NAME=Sfitti

fastagrep="/central/groups/Parker_lab/tools/fastagrep.pl"
library="${NAME}-families.fa"

# keep these from the repeat library, remove the rest
echo "## Filtering repeat library"
cd ./repeatModel
$perl $fastagrep -f ./keep-these-headers.txt \
$library > filtered-${NAME}-library.fa
echo "$(grep -c '>' filtered-${NAME}-library.fa) sequences in filtered library"

cd ../
mkdir repeatMask
cd ./repeatMask

#combine repbase, mitetracker, and repeatmodeler
echo "## Combine repeat libraries"
cat /central/groups/Parker_lab/tools/RepeatMasker/util/repeatmasker.fa \
../repeatModel/filtered-${NAME}-library.fa \
 > ${NAME}.ALL.fa

echo "$(grep -c '>' ${NAME}.ALL.fa) sequences in full library"

#cluster families
echo "## Cluster repeat libraries"
/central/groups/Parker_lab/tools/MITE-Tracker/vsearch-2.7.1/bin/vsearch \
--cluster_fast ${NAME}.ALL.fa --threads 4 --strand both \
--clusters ${NAME}.clust_temp --iddef 1 --id 0.8 --uc out.uc --centroids ${NAME}.repeatlib.fa

echo "$(grep -c '>' ${NAME}.repeatlib.fa) sequences in clustered library"

mkdir TE_clusters
mv ${NAME}.clust_* ./TE_clusters

#RepeatMasker
echo "## Start RepeatMasker"
mkdir RM_output
/central/groups/Parker_lab/tools/RepeatMasker/RepeatMasker -engine ncbi -pa 4 -s -xsmall \
-lib ./${NAME}.repeatlib.fa \
-dir ./RM_output -poly -gff ../AC_Sfitti_2.fa

module load samtools/1.8

samtools faidx ../AC_Sfitti_2.fa

cp ../AC_Sfitti_2.fa.fai ../AC_Sfitti_2.fa.tsv

#summary script
perl /central/groups/Parker_lab/tools/RepeatMasker/util/buildSummary.pl  -species ${NAME} \
-genome ../AC_Sfitti_2.fa.tsv \
 -useAbsoluteGenomeSize ./RM_output/AC_Sfitti_2.fa.out > ./RM_output/${NAME}.out.detailed

#calculate the Kimura substitution level from the consensus sequence (history of TE accumulation in genome), CpG adjusted
#perl /central/groups/Parker_lab/tools/RepeatMasker/util/calcDivergenceFromAlign.pl -s ./RM_output/${NAME}.divsum ./RM_output/scaffolds.reduced_1k.filled.fa.cat.gz

#create a graph of the Repeat Landscape as a function of the percent of genome
#perl /central/groups/Parker_lab/tools/RepeatMasker/util/createRepeatLandscape.pl -g 80915005 -div ./RM_output/${NAME}.divsum > ./RM_output/${NAME}.html

echo "Time: $(date)"

end=$(date +%s)
runtime=$((end-start))

echo "Runtime was $runtime"
