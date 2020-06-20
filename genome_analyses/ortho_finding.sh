#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l walltime=200:00:00
#PBS -A ibb3_a_g_sc_default
#PBS -l mem=10gb
#PBS -j oe
#PBS -N of

cd $PBS_O_WORKDIR

module purge
module load gcc/5.3.1
module load ncbi-blast/2.6.0

export PATH=$PATH:/gpfs/group/ibb3/default/tools/mcl/bin/:/gpfs/group/ibb3/default/tools/fastme-2.1.5/bin/

/gpfs/group/ibb3/default/tools/OrthoFinder-2.2.1/orthofinder -f /gpfs/group/ibb3/default/genome_resources/Symbiodinium/orth_analysis_sym2/orthofinder/input_files -t 8

# input files: A3_pep  Sfitti_pep      Sgore_pep       Skawa_pep       Smicro_pep      Sminu_pep       symC_pep
