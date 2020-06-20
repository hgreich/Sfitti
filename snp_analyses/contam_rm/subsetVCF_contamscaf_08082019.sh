#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l walltime=48:00:00
#PBS -A open
#PBS -l mem=100gb
#PBS -j oe

# update aug 8 2019, orig - october 31 2018
# new script to subset out snps from 151 scaffolds with coral contam. this will remove 2409 snps.

cd /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/contam_removal_08082019/

# unzip the vcf

# name files
VCF=/storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/halloweenmm80.vcf
BED=/storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/contam_removal_08082019/contam_08082019.bed

#vcftools
# snps
# this version excludes the contam snps in the bed file
/gpfs/group/ibb3/default/tools/vcftools --vcf $VCF --exclude-bed $BED --remove-indels --out nocontam_subset --recode --keep-INFO-all

# rename the new vcf
cp nocontam_subset.recode.vcf nocontam_subset_hqmm80_08082019.vcf

echo meow
echo me0w
echo MEOW

echo " "
echo "Job Ended at `date`"
