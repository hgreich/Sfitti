#!/bin/bash
#SBATCH --time=120:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "aug"   # job name
#SBATCH --output "aug"

echo "Time: $(date)"
start=$(date +%s)

SPECIES=Sfitti

export AUGUSTUS_CONFIG_PATH=/central/scratchio/sak3097/beetle/augustus-3.2.3/config

#mkdir augustus
cd ./augustus

#create new config for a new species
/central/scratchio/sak3097/beetle/augustus-3.2.3/scripts/new_species.pl --species=${SPECIES}

#run locally
cat  /central/scratchio/sak3097/beetle/sfitti_gene_prediction/augustus/BUSCO/augustus_output/training_set.db | perl -pe 's/LOCUS\s*\S*/"LOCUS      " . ($. + 1)/ge' > \
/central/scratchio/sak3097/beetle/sfitti_gene_prediction/augustus/BUSCO/augustus_output/UniqueSet.gb

# change 200 to 50% of your trainingset (grep -c "LOCUS" file)
/central/scratchio/sak3097/beetle/augustus-3.2.3/scripts/randomSplit.pl \
/central/scratchio/sak3097/beetle/sfitti_gene_prediction/augustus/BUSCO/augustus_output/UniqueSet.gb 10

#training augustus
/central/scratchio/sak3097/beetle/augustus-3.2.3/bin/etraining --species=${SPECIES} ./BUSCO/augustus_output/UniqueSet.gb.train

#run augustus on test set
/central/scratchio/sak3097/beetle/augustus-3.2.3/bin/augustus --species=${SPECIES} ./BUSCO/augustus_output/UniqueSet.gb.test > UniqueSet.gb.test.predictions

# parameters adjusted (https://github.com/TimothyStephens/Dinoflagellate_Annotation_Workflow/tree/master/doc)
# run augustus on full genome
/central/scratchio/sak3097/beetle/augustus-3.2.3/bin/augustus --AUGUSTUS_CONFIG_PATH=/central/scratchio/sak3097/beetle/augustus-3.2.3/config --gff3=on \
--softmasking=1 --species=${SPECIES} --protein=on --outfile=${SPECIES}_augustus.gff3 \
/central/scratchio/sak3097/beetle/sfitti_gene_prediction/repeatMask/RM_output/out.fa

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
