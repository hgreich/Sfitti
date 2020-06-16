#!/bin/bash
#PBS -l nodes=1:ppn=12
#PBS -l walltime=48:00:00
#PBS -A open
#PBS -l mem=100gb
#PBS -j oe
#PBS -N augAT

cd $PBS_O_WORKDIR

##Run AUGUSTUS v 3.2.3 with Apalm config from BUSCO
/gpfs/group/ibb3/default/tools/augustus --species=Sfitti --outfile=sfitti_augustus.gff --cds=on --codingseq=on ../AC_Sfitti_2.fa

##Pull out the fasta sequences
/gpfs/group/ibb3/default/tools/augustus-3.2.3/scripts/getAnnoFasta.pl --seqfile=../AC_Sfitti_2.fa sfitti_augustus.gff 
