#PBS -l nodes=1:ppn=8

#PBS -l walltime=200:00:00

#PBS -l mem=100gb # this change with the server

#PBS -A ibb3_a_g_bc_default

#PBS -j oe

## Sept 10 2018
# new genome location = /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01
# rerun of mpileup on newly sequenced samples
# only ran analyses on samples that had all MSAT primers work and were single infected samples
# sample numbers 13704, 13706, 13736, 13762, 13782, 13821, 13823, 13833, 14472

cd /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/

# name things
REF=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa

# index the reference
/storage/home/hgr5/ibb3_group/default/tools/bwa index $REF

exec < "symlist"
while read LINE
do
cd $LINE
    # create SAM file
    /storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/$LINE/*_R1.fastq /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/$LINE/*_R2.fastq > alignedsym.sam
    # do things with it
    ~/ibb3_group/default/tools/samtools view -bT $REF alignedsym.sam > alignedsym.bam
    # sort the BAM file
    ~/ibb3_group/default/tools/samtools sort -T ./alignedsym.sorted.bam -o alignedsym.sorted.bam alignedsym.bam
    # index sorted BAM file
    ~/ibb3_group/default/tools/samtools index -b alignedsym.sorted.bam
    # remove PCR duplicates
    ~/ibb3_group/default/tools/samtools rmdup alignedsym.sorted.bam nodupssym.bam
    # index the BAM
    ~/ibb3_group/default/tools/samtools index -b nodupssym.bam
    # count how many reads aligned
    ~/ibb3_group/default/tools/samtools flagstat nodupssym.bam > stats_sym.txt
    cd ../
done

# call SNPs using mpileup
~/ibb3_group/default/tools/samtools mpileup -ugAEf $REF -t AD,DP /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13704/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13706/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13736/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13762/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13782/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13821/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13823/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13833/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/14472/nodupssym.bam > ALLsympileup.bcf


# call variants
~/ibb3_group/default/tools/bcftools call -f GQ -vmO z --ploidy 1 -o ALLsympileup.vcf.gz ALLsympileup.bcf

# copy to fitti filder
cp ALLsympileup.vcf.gz /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/

echo meow

echo " "
echo "Job Ended at `date`"
