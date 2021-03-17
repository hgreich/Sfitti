#!/bin/bash
#SBATCH --time=48:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "gff_25"   # job name
#SBATCH --output "gff_25"

echo "Time: $(date)"
start=$(date +%s)

source /central/groups/Bi160/tools/anaconda/etc/profile.d/conda.sh
conda activate /central/groups/Parker_lab/tools/anaconda

SPECIES=Sfitti

/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/gff3_file_to_proteins.pl ./evidenceModeler/${SPECIES}_EVM.all.gff3 \
./repeatMask/RM_output/AC_Sfitti_2.masked.fa prot > ./evidenceModeler/${SPECIES}.aa.fasta

sed 's/>/>Sfitti_/' ./evidenceModeler/${SPECIES}.aa.fasta > ./evidenceModeler/out

sed 's/\s.*$//' ./evidenceModeler/out > ./evidenceModeler/out2

mv ./evidenceModeler/out2 ./evidenceModeler/${SPECIES}.aa.fasta

rm ./evidenceModeler/out

/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/gff3_file_to_proteins.pl ./evidenceModeler/${SPECIES}_EVM.all.gff3 \
./repeatMask/RM_output/AC_Sfitti_2.masked.fa CDS > ./evidenceModeler/${SPECIES}.nuc.fasta

sed 's/>/>Sfitti_/' ./evidenceModeler/${SPECIES}.nuc.fasta > ./evidenceModeler/out

sed 's/\s.*$//' ./evidenceModeler/out > ./evidenceModeler/out2

mv ./evidenceModeler/out2 ./evidenceModeler/${SPECIES}.nuc.fasta

rm ./evidenceModeler/out

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
