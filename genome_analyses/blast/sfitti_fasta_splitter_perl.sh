#PBS -l nodes=1:ppn=8

#PBS -l walltime=48:00:00 #Time to run, our max limit is 24hrs

#PBS -l mem=100gb # this change with the server

#PBS -A open

#PBS -j oe

# March 13, 2018

#cd  /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/

#cp AC_Sfitti_2.fa /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/chunks_fitti/

cd  /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/chunks_fitti/

# used fasta-splitter.pl script to split genome into 40 chunks
/storage/home/hgr5/ibb3_group/default/tools/perl perl --n-parts 40 /storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa

mv AC_Sfitti_2.part* ./chunks_fitti/

echo meow

echo " "
echo "Job Ended at `date`"
