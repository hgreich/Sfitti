#PBS -l nodes=1:ppn=20

#PBS -l walltime=48:00:00 #Time to run, our max limit is 24hrs

#PBS -l mem=100gb # this change with the server

#PBS -A open

#PBS -j oe

## April 10, 2018

cd /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/snpstuff_02272018/single_infect_SNPs/

### export perl to solve eventual problems
export PERL5LIB=/storage/home/hgr5/vcftools_0.1.13/lib/perl5/site_perl/

# name things
MP=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/deepAPalm_merged_mpileup02172018.vcf
FREE=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/freebayes_02232018.vcf
REF=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa

# remove multiple infection samples from freebayes & mpileup
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --remove remove --vcf $MP --recode --out MP_single_all.vcf
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --remove remove --vcf $FREE --recode --out FREE_single_all.vcf

echo meow

echo " "
echo "Job Ended at `date`"

