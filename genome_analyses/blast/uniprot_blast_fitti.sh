#!/bin/bash
#PBS -l nodes=1:ppn=2
#PBS -l walltime=48:00:00
#PBS -A open
#PBS -l mem=32gb
#PBS -j oe
#PBS -N blast_sp
#PBS -t 0-9

cd $PBS_O_WORKDIR

/gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin/blastp -query /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/chunks_fitti/AC_Sfitti_2.part-${PBS_ARRAYID} -db /gpfs/group/ibb3/default/Blast_Databases/BLASTX_nucleotide_to_protein_Database/Uniprot/uniprot -evalue 1e-5 -max_target_seqs 5 -max_hsps 1 -num_threads 2 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out ~/scratch/uniprot_results_sfitti/sfitti_uniprot.${PBS_ARRAYID}.out

