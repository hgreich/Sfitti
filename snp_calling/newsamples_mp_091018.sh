#PBS -l nodes=1:ppn=8

#PBS -l walltime=200:00:00

#PBS -l mem=100gb # this change with the server

#PBS -A ibb3_a_g_bc_default

#PBS -j oe

# name things
REF=/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa

# index the reference
/storage/home/hgr5/ibb3_group/default/tools/bwa index $REF

### create BAM file for deeply sequenced Apalm-like Sfitti
cd /storage/home/hgr5/scratch/
# create SAM file
/storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF /storage/home/hgr5/ibb3_group/default/AP_AC_genome_seqs/Illumina/Apalm/rawReads/1012_bothruns_R1.fastq /storage/home/hgr5/ibb3_group/default/AP_AC_genome_seqs/Illumina/Apalm/rawReads/1012_bothruns_R2.fastq > sym_aligned.sam
# do things with itq
~/ibb3_group/default/tools/samtools view -bT $REF sym_aligned.sam > sym_aligned.bam
# sort the BAM file
~/ibb3_group/default/tools/samtools sort -T ./sym_aligned.sorted.bam -o sym_aligned.sorted.bam sym_aligned.bam
# index sorted BAM file
~/ibb3_group/default/tools/samtools index -b sym_aligned.sorted.bam
# remove PCR duplicates
~/ibb3_group/default/tools/samtools rmdup sym_aligned.sorted.bam sym_nodups.bam
# index the BAM
~/ibb3_group/default/tools/samtools index -b sym_nodups.bam
# count how many reads aligned
~/ibb3_group/default/tools/samtools flagstat sym_nodups.bam > sym_flagstat.txt

#### create bam file for "original samples"
### make BAMs from run1 samples

# make BAM files for all of the shallow cervi-sfitti
cd /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/

exec < "list"
while read LINE
do
    cd $LINE
    # create SAM file
    /storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF *_R1.fastq *_R2.fastq > aligned.sam
    # do things with it
    ~/ibb3_group/default/tools/samtools view -bT $REF aligned.sam > aligned.bam
    # sort the BAM file
    ~/ibb3_group/default/tools/samtools sort -T ./aligned.sorted.bam -o aligned.sorted.bam aligned.bam
    # index sorted BAM file
    ~/ibb3_group/default/tools/samtools index -b aligned.sorted.bam
    # remove PCR duplicates
    ~/ibb3_group/default/tools/samtools rmdup aligned.sorted.bam nodups.bam
    # index the BAM
    ~/ibb3_group/default/tools/samtools index -b nodups.bam
    # count how many reads aligned
    ~/ibb3_group/default/tools/samtools flagstat nodups.bam > stats.txt
    cd ../
done

# make BAM files for all of the shallow palm-sfitti
cd /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/
exec < "list"
while read LINE
do
    cd $LINE
    # create SAM file
    /storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF *_R1.fastq *_R2.fastq > aligned.sam
    # do things with it
    ~/ibb3_group/default/tools/samtools view -bT $REF aligned.sam > aligned.bam
    # sort the BAM file
    ~/ibb3_group/default/tools/samtools sort -T ./aligned.sorted.bam -o aligned.sorted.bam aligned.bam
    # index sorted BAM file
    ~/ibb3_group/default/tools/samtools index -b aligned.sorted.bam
    # remove PCR duplicates
    ~/ibb3_group/default/tools/samtools rmdup aligned.sorted.bam nodups.bam
    # index the BAM
    ~/ibb3_group/default/tools/samtools index -b nodups.bam
    # count how many reads aligned
    ~/ibb3_group/default/tools/samtools flagstat nodups.bam > stats.txt
    cd ../
done

# call SNPs on hybrid-sfitti
cd /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/
exec < "list"
while read LINE
do
    cd $LINE
    #create SAM file
    /storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF *_R1.fastq *_R2.fastq > aligned.sam
    #do things with it
    ~/ibb3_group/default/tools/samtools view -bT $REF aligned.sam > aligned.bam
    #sort the BAM file
    ~/ibb3_group/default/tools/samtools sort -T ./aligned.sorted.bam -o aligned.sorted.bam aligned.bam
    #index sorted BAM file
    ~/ibb3_group/default/tools/samtools index -b aligned.sorted.bam
    #remove PCR duplicates
    ~/ibb3_group/default/tools/samtools rmdup aligned.sorted.bam nodups.bam
    #index the BAM
    ~/ibb3_group/default/tools/samtools index -b nodups.bam
    #count how many reads aligned
    ~/ibb3_group/default/tools/samtools flagstat nodups.bam > stats.txt
    cd ../
done

### make BAMs for the newly discovered 2nd run sequences
cd /storage/home/hgr5/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/

exec < "list"
while read LINE
do
    cd $LINE
    # create SAM file
    /storage/home/hgr5/ibb3_group/default/tools/bwa mem $REF *_R1.fastq *_R2.fastq > aligned_2ndrun.sam
    # do things with it
    ~/ibb3_group/default/tools/samtools view -bT $REF aligned_2ndrun.sam > aligned_2ndrun.bam
    # sort the BAM file
    ~/ibb3_group/default/tools/samtools sort -T ./aligned_2ndrun.sorted.bam -o aligned_2ndrun.sorted.bam aligned_2ndrun.bam
    # index sorted BAM file
    ~/ibb3_group/default/tools/samtools index -b aligned_2ndrun.sorted.bam
    # remove PCR duplicates
    ~/ibb3_group/default/tools/samtools rmdup aligned_2ndrun.sorted.bam nodups_2ndrun.bam
    # index the BAM
    ~/ibb3_group/default/tools/samtools index -b nodups_2ndrun.bam
    # count how many reads aligned
    ~/ibb3_group/default/tools/samtools flagstat nodups_2ndrun.bam > stats_2ndrun.txt
    cd ../
done

# merge the BAMs created from the 2 runs
### ACsym first
cd /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged

~/ibb3_group/default/tools/samtools merge -ur merged_Sample_4923.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_4923/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_4923/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_4927.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_4927/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_4927/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_4928.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_4928/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_4928/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_4959.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_4959/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_4959/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_4960.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_4960/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_4960/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13696.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13696/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13696/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13712.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13712/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13712/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13714.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13714/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13714/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13738.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13738/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13738/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13758.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13758/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13758/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13786.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13786/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13786/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13792.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13792/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13792/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13797.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13797/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13797/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13827.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13827/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13827/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13837.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13837/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13837/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13901.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13901/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13901/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13903.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13903/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13903/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13905.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13905/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13905/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13917.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13917/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13917/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13925.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13925/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/Sample_13925/nodups.bam


##### APsym
cd ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/

~/ibb3_group/default/tools/samtools merge -ur merged_Sample_1037.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_1037/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_1037/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_2655.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_2655/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_2655/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_2699.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_2699/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_2699/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_5524.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_5524/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_5524/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_6895.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_6895/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_6895/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13702.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13702/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13702/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13740.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13740/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13740/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13744.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13744/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13744/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13750.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13750/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13750/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13752.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13752/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13752/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13784.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13784/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13784/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13801.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13801/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13801/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13813.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13813/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13813/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13815.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13815/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13815/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13819.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13819/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13819/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13907.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13907/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13907/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13911.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13911/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13911/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13919.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13919/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13919/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13933.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13933/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13933/nodups.bam
~/ibb3_group/default/tools/samtools merge -ur merged_Sample_13939.bam ~/ibb3_group/default/shallow_genome_SNP_data/160802_7001126F_0150_AHMLJVBCXX/fastq/Sample_13939/nodups_2ndrun.bam ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/Sample_13939/nodups.bam

### regroup bams into one BAM file
cd ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/

/gpfs/group/ibb3/default/tools/bamaddrg/bamaddrg -b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_4923.bam -s Sample_4923 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_4927.bam -s Sample_4927 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_4928.bam -s Sample_4928 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_4959.bam -s Sample_4959 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_4960.bam -s Sample_4960 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13696.bam -s Sample_13696 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13712.bam -s Sample_13712 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13714.bam -s Sample_13714 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13738.bam -s Sample_13738 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13758.bam -s Sample_13758 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13786.bam -s Sample_13786 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13792.bam -s Sample_13792 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13797.bam -s Sample_13797 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13827.bam -s Sample_13827 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13837.bam -s Sample_13837 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13901.bam -s Sample_13901 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13903.bam -s Sample_13903 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13905.bam -s Sample_13905 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13917.bam -s Sample_13917 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/ACsym/merged/merged_Sample_13925.bam -s Sample_13925 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_1037.bam -s Sample_1037 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_2655.bam -s Sample_2655 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_2699.bam -s Sample_2699 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_5524.bam -s Sample_5524 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_6895.bam -s Sample_6895 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13702.bam -s Sample_13702 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13740.bam -s Sample_13740 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13744.bam -s Sample_13744 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13750.bam -s Sample_13750 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13752.bam -s Sample_13752 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13784.bam -s Sample_13784 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13801.bam -s Sample_13801 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13813.bam -s Sample_13813 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13815.bam -s Sample_13815 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13819.bam -s Sample_13819 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13907.bam -s Sample_13907 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13911.bam -s Sample_13911 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13919.bam -s Sample_13919 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13933.bam -s Sample_13933 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/APsym/merged/merged_Sample_13939.bam -s Sample_13939 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1302/nodups.bam -s 1302 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1303/nodups.bam -s 1303 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/13764/nodups.bam -s 13764 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/13778/nodups.bam -s 13778 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/13799/nodups.bam -s 13799 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/13807/nodups.bam -s 13807 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/13913/nodups.bam -s 13913 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1667/nodups.bam -s 1667 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1834/nodups.bam -s 1834 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1835/nodups.bam -s 1835 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1837/nodups.bam -s 1837 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/1839/nodups.bam -s 1839 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/3070/nodups.bam -s 3070 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/3071/nodups.bam -s 3071 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/4062/nodups.bam -s 4062 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/5993/nodups.bam -s 5993 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/6779/nodups.bam -s 6779 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/6791/nodups.bam -s 6791 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/8867/nodups.bam -s 8867 \
-b ~/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/hybrid/8939/nodups.bam -s 8939 > allbam01182018.bam

######### Sept 10 2018
# new genome location = /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01
# rerun of mpileup on newly sequenced samples
# only ran analyses on samples that had all MSAT primers work and were single infected samples
# sample numbers 13704, 13706, 13736, 13762, 13782, 13821, 13823, 13833, 14472

cd /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/

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

#### call the SNPS
# make sure to include sept 2018 new samples, deep apalm bam, and allbam
~/ibb3_group/default/tools/samtools mpileup -ugAEf $REF -t AD,DP /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13704/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13706/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13736/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13762/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13782/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13821/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13823/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/13833/nodupssym.bam /gpfs/group/ibb3/default/shallow_genome_SNP_data/newHybrids_180702/18068-01/14472/nodupssym.bam /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/allbam01182018.bam /gpfs/group/ibb3/default/AP_AC_genome_seqs/Illumina/Apalm/rawReads/sym_nodups.bam > ALLsympileup.bcf

# call variants
~/ibb3_group/default/tools/bcftools call -f GQ -vmO z --ploidy 1 -o ALLsympileup.vcf.gz ALLsympileup.bcf
gunzip ALLsympileup.vcf.gz

# remove samples with multiple infections
export PERL5LIB=/storage/home/hgr5/vcftools_0.1.13/lib/perl5/site_perl/
/storage/home/hgr5/vcftools_0.1.13/bin/vcftools --remove /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/snpstuff_02272018/single_infect_SNPs/remove --vcf ALLsympileup.vcf --recode --out ALLsymSINGLEmp.vcf
 mv ALLsymSINGLEmp.vcf.recode.vcf ALLsymSINGLEmp.vcf

#########
######### separate out SNPs
/gpfs/group/ibb3/default/tools/bcftools view -O v --threads 8 -m2 -M2 -v snps -o snpALLsymSINGLE.vcf ALLsymSINGLEmp.vcf

# for good luck
echo meow

echo " "
echo "Job Ended at `date`"
