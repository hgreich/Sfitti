#!/bin/bash
#SBATCH --time=48:00:00   # walltime
#SBATCH --ntasks=10   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "run_25"   # job name
#SBATCH --output "run_25"

echo "Time: $(date)"
start=$(date +%s)

SPECIES=Sfitti

cd /central/scratchio/sak3097/beetle/sfitti_gene_prediction/evidenceModeler/evidenceModeler_run

module load parallel/20180222

parallel --jobs 10 < ${SPECIES}_commands.list

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"

