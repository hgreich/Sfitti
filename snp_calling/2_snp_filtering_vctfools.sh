#PBS -l nodes=1:ppn=24

#PBS -l walltime=48:00:00

#PBS -l mem=120gb # this change with the server

#PBS -A open

#PBS -j oe

# new script to subset out HQ SNPs. this will allow for an 20% of "high quality" snps to be included in downstream selection outlier and popgen analyses
# also subsets out high quality snps with no missing data aka the "conservative" snp set

cd ~/scratch # do this in scratch because of memory issues
# only keep variants with quality score of 200 or higher
# snps
/gpfs/group/ibb3/default/tools/bcftools filter -i 'QUAL >= 200' --threads 8 -O v -o hq_snpALLsymSINGLE.vcf snpALLsymSINGLE.vcf

######### separation of max missing 80 snps and indels
export PERL5LIB=/storage/home/hgr5/vcftools_0.1.13/lib/perl5/site_perl/
# snp

#########
######### "high quality set"
#########
# only allows sites with less than 20% missing data, leads to ~58,000 snps
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf hq_snpALLsymSINGLE.vcf --max-missing 0.80 --kept-sites --recode-INFO-all --out allhqSNPmm80

# subset these snps into a new vcf
# name files
HQ=hq_snpALLsymSINGLE.vcf
BED=mm80_sites.bed

#vcftools
/gpfs/group/ibb3/default/tools/vcftools --vcf $HQ --bed $BED --remove-indels --out mm80HALLOWEENsubset --recode --keep-INFO-all

#########
######### "conservative set"
#########
# only allows sites with NO missing data, leads to ~6,000 snps
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf hq_snpALLsymSINGLE.vcf --max-missing 1.0 --kept-sites --recode-INFO-all --out nomiss

# subset these snps into a new vcf
# name files
HQ=hq_snpALLsymSINGLE.vcf
BED1=nomiss_sites.bed

#vcftools
/gpfs/group/ibb3/default/tools/vcftools --vcf $HQ --bed $BED1 --remove-indels --out NOMISSING_subset --recode --keep-INFO-all

echo meow
echo me0w
echo MEOW

echo " "
echo "Job Ended at `date`"
