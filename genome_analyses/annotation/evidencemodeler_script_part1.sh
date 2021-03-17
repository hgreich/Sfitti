#!/bin/bash
#SBATCH --time=48:00:00   # walltime
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)
#SBATCH --nodes=1   # number of nodes
#SBATCH --mem-per-cpu=10G   # memory per CPU core
#SBATCH -J "exc_25"   # job name
#SBATCH --output "exc_25"

echo "Time: $(date)"
start=$(date +%s)

source /central/groups/Bi160/tools/anaconda/etc/profile.d/conda.sh
conda activate /central/groups/Parker_lab/tools/anaconda

SPECIES=Sfitti

#mkdir evidenceModeler
cd evidenceModeler
#mkdir input_gffs

#fix genemark
#/central/groups/Parker_lab/tools/funannotate-1.5.1/util/genemark_gtf2gff3.pl ../genemark/genemark.gtf > ./input_gffs/genemark-ES.gff3

#/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/gff3_gene_prediction_file_validator.pl ./input_gffs/genemark-ES.gff3

#fix augustus 
#/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/misc/augustus_GFF3_to_EVM_GFF3.pl ../augustus/${SPECIES}_augustus.gff3 > ./input_gffs/${SPECIES}_augustus.gff3

#/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/gff3_gene_prediction_file_validator.pl ./input_gffs/${SPECIES}_augustus.gff3

#create gene prediction gff
#cat ./input_gffs/${SPECIES}_augustus.gff3 ./input_gffs/genemark-ES.gff3 > ./input_gffs/gene_prediction.gff3

#fix gemoma output
#/central/groups/Parker_lab/tools/evidencemodeler/EvmUtils/misc/augustus_GFF3_to_EVM_GFF3.pl ../gemoma_combine/filtered_predictions.gff > ./input_gffs/${SPECIES}_gemoma.gff3

#sed 's/Augustus/GeMoMa/' ./input_gffs/${SPECIES}_gemoma.gff3 > ./input_gffs/${SPECIES}_gemoma_evm.gff3

#rm ./input_gffs/${SPECIES}_gemoma.gff3

#### PART 1 EVM
## partition genome by contig
mkdir evidenceModeler_run
cd evidenceModeler_run

/central/scratchio/sak3097/beetle/evidencemodeler/EvmUtils/partition_EVM_inputs.pl \
--genome ../../repeatMask/RM_output/AC_Sfitti_2.masked.fa \
--gene_predictions ../input_gffs/gene_prediction.gff3 \
--protein_alignments ../input_gffs/${SPECIES}_gemoma_evm.gff3 \
--segmentSize 100000 --overlapSize 10000 --partition_listing ${SPECIES}_partitions_list.out

## Generate the command list
/central/scratchio/sak3097/beetle/evidencemodeler/EvmUtils/write_EVM_commands.pl \
--genome ../../repeatMask/RM_output/AC_Sfitti_2.masked.fa \
--weights /central/groups/Parker_lab/SheilaK/genome_assemblies/weights_illuminaOnly.txt \
--gene_predictions ../input_gffs/gene_prediction.gff3 \
--protein_alignments ../input_gffs/${SPECIES}_gemoma_evm.gff3 \
--output_file_name ${SPECIES}_evm.out \
--partitions ${SPECIES}_partitions_list.out >  ${SPECIES}_commands.list

echo "Time: $(date)"
end=$(date +%s)
runtime=$((end-start))
echo "Runtime was $runtime"
