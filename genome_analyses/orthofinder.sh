#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l walltime=48:00:00
#PBS -A open
#PBS -l mem=10gb
#PBS -j oe
#PBS -N of
#PBS -l feature=rhel7

cd $PBS_O_WORKDIR

conda activate base

./orthofinder -f ./symproteins/inputs_minus_c92 -t 8