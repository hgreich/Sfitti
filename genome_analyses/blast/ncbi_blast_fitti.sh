#!/bin/bash
#PBS -l nodes=1:ppn=6
#PBS -l walltime=48:00:00
#PBS -A open
#PBS -l mem=32gb
#PBS -j oe
#PBS -N blast_nr
#PBS -t 11-13

cd $PBS_O_WORKDIR

/gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin/blastp -query /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/chunks_fitti/AC_Sfitti_2.part-${PBS_ARRAYID} -db /gpfs/group/ibb3/default/Blast_Databases/BLASTX_nucleotide_to_protein_Database/nr/nr -evalue 1e-5 -max_target_seqs 5 -max_hsps 1 -num_threads 6 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out ~/scratch/ncbi_results_sfitti/sfitti_ncbi.${PBS_ARRAYID}.out
