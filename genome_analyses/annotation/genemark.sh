#!/bin/bash
#SBATCH --time=120:00:00   # walltime
#SBATCH --ntasks=8   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "gm_25"   # job name
#SBATCH --output "gm_25"

echo "Time: $(date)"
start=$(date +%s)

SPECIES=Sfitti

#mv ./repeatMask/RM_output/AC_Sfitti_2.fa.masked ./repeatMask/RM_output/AC_Sfitti_2.masked.fa

#mkdir genemark
cd ./genemark

export PERL5LIB=/central/groups/Parker_lab/tools/anaconda/lib/site_perl/5.26.2

/central/groups/Parker_lab/tools/gm_et_linux_64/gmes_petap/gmes_petap.pl --ES --cores 8 --soft_mask 300000 \
--sequence /central/scratchio/sak3097/beetle/sfitti_gene_prediction/repeatMask/RM_output/AC_Sfitti_2.masked.fa

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
