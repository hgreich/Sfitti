#PBS -l nodes=1:ppn=8

#PBS -l walltime=48:00:00

#PBS -l mem=120gb # this change with the server

#PBS -A open

#PBS -j oe

# THIS IS FOR TABLE S1

###########
# updated 08/08/2019, script created sept 28 2018
### run vcf stats on the new SNP analysis with all of the samples
# these samples are HQ (qual over 200 and mm80) and were subsetted to match the spring 2018 genotyping set of snps that were called with both snp callers. Coral contam scaffolds removed

# this is for figure S3

###########

# do this in scratch because of memory issues!!!
cd /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/contam_removal_08082019/stats_nocontam_08082019/

# name stuff
REF=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa
SNP=/storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/contam_removal_08082019/nocontam_subset_hqmm80_08082019.vcf
GFF=/storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/augustus_genePrediction/sfitti_augustus.gff3


export PERL5LIB=/storage/home/hgr5/vcftools_0.1.13/lib/perl5/site_perl/

#### VCFTOOLS
# link to vcftools manual: http://vcftools.sourceforge.net/man_latest.html
# vcf tools stats get the stats before separating out for quality
/storage/home/hgr5/vcftools_0.1.13/bin/vcf-stats $SNP -p snp_080819
# vcf tools stats Outputs the allele frequency for each site in a file with the suffix ".frq".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --freq --out snpfreq_080819
# vcf tools stats Generates a file containing the mean depth per site averaged across all individuals.
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --site-mean-depth --out snpsitemeandepth_080819
# vcf tools stats Generates a file containing the mean depth per individual.
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --depth --out snpdepth_080819
# vcf tools Calculates a simple summary of all Transitions and Transversions. The output file has the suffix ".TsTv.summary".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --TsTv-summary --out tstv_080819
# indvid frequency burden. This option calculates the number of variants within each individual of a specific frequency. The resulting file has the suffix ".ifreqburden".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --indv-freq-burden --out indv_frq_bur_080819
# RELATEDNESS. statistic based on the method of Yang et al, Nature Genetics 2010 (doi:10.1038/ng.608). Specifically, calculate the unadjusted Ajk statistic. Expectation of Ajk is zero for individuals within a populations, and one for an individual with themselves. The output file has the suffix ".relatedness".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --relatedness --out relatedness_080819
# RELATEDNESS2. relatedness statistic based on the method of Manichaikul et al., BIOINFORMATICS 2010 (doi:10.1093/bioinformatics/btq559). The output file has the suffix ".relatedness2".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --relatedness2 --out relatedness2_080819
# per site snp quality. as found in the QUAL column of the VCF file. This file has the suffix ".lqual".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --site-quality --out site_qual_080819
# missing by individual. The file has the suffix ".imiss".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --missing-indv --out mis_ind_080819
# missing by site. The file has the suffix ".lmiss".
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --vcf $SNP --missing-site --out mis_site_080819


# bcftools stats
/gpfs/group/ibb3/default/tools/bcftools stats --threads 4 -F $REF -s - $SNP > bcft_080819.stats

echo meow
echo me0w
echo MEOW

echo " "
echo "Job Ended at `date`"
