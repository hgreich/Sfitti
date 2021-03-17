#!/bin/bash
#SBATCH --time=48:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "exc2_25"   # job name
#SBATCH --output "exc2_25"

echo "Time: $(date)"
start=$(date +%s)

source /central/groups/Bi160/tools/anaconda/etc/profile.d/conda.sh
conda activate /central/groups/Parker_lab/tools/anaconda

SPECIES=Sfitti

#cd /central/scratchio/sak3097/beetle/sfitti_gene_prediction/evidenceModeler/evidenceModeler_run

#### PART 2 EVM
## Combine partitions
#/central/scratchio/sak3097/beetle/evidencemodeler/EvmUtils/recombine_EVM_partial_outputs.pl \
#--partitions ${SPECIES}_partitions_list.out --output_file_name ${SPECIES}_evm.out

## convert output to GFF3 format
#/central/scratchio/sak3097/beetle/evidencemodeler/EvmUtils/convert_EVM_outputs_to_GFF3.pl \
#--partitions ${SPECIES}_partitions_list.out --output ${SPECIES}_evm.out \
#--genome /central/scratchio/sak3097/beetle/sfitti_gene_prediction/repeatMask/RM_output/AC_Sfitti_2.masked.fa

#find . -regex ".*${SPECIES}_evm.out.gff3" -exec cat {} \; > ../${SPECIES}_EVM.all.gff3

#echo
#echo
#echo "*** Converted EVM output to GFF3 format: ${SPECIES}__EVM.all.gff3 ***"

#mkdir evm_output2
#mv ./scaffold* ./evm_output2

/central/groups/Parker_lab/SheilaK/genome_assemblies/summarizeSupport.py ./evidenceModeler/evidenceModeler_run ${SPECIES} > ./evidenceModeler/${SPECIES}_evm_summary.txt

echo "Done."

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
