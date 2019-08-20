#PBS -l nodes=1:ppn=6

#PBS -l walltime=600:00:00 #Time to run, our max limit is 24hrs

#PBS -l mem=100gb # this change with the server

#PBS -A ibb3_a_g_sc_default

#PBS -j oe

# copied from halloween 2018 script. updated 8 aug 2019. redo because some snps were removed due to coral contamination

# attempt at bayescan with genotyping SNPs
# used default parameters from BayeScan 2.0 manual http://cmpg.unibe.ch/software/BayeScan/files/BayeScan2.0_manual.pdf
## UPDATE - INPUT FILES INCLUDE POPULATION INFO
## THIS IS FOR ORGANIZING BY HOST

# input file is made locally with PGDSpider_2.1.1.5

cd /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/bayescan/aug2019/loc/

/storage/home/hgr5/ibb3_group/default/tools/BayeScan2.1/source/bayescan_2.1 loc_aug19.txt -snp -od /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/bayescan/aug2019/loc/ -o loc_aug19 -out_pilot -out_freq


echo MEOW MEOW MEOW


echo " "
echo "Job Ended at `date`"
