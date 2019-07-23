#PBS -l nodes=1:ppn=36

#PBS -l walltime=48:00:00 #Time to run, our max limit is 24hrs

#PBS -l mem=100gb # this change with the server

#PBS -A open

#PBS -j oe


### july 18 2019
# this is an extra round of blasting. making databases of other symbiodinium assemblies (tridac, microadriaticum) and acropora (palmata, cervicornis, digitifera, hyacinthis, something else) as an extra layer supporting that the sfitti scaffolds are infact symbiopals and not coralfiends

# move to the new subdirectory
cd /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/

# load modules
module spider gcc/5.3.1
module spider ncbi-blast/2.6.0

# make one big fastafile
cat /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.microadriaticum/sym_smic.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.tridacnidorum/2018_assembly/sym_tridac.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/Ahyacinthus_v1/Ahyan.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/Atenuis_v1/Aten.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/Adig_NCBI/NCBI_assembly/Adig.fa /storage/home/h/hgr5/ibb3_group/default/genome_annotation/Acerv_assemblies/Acerv.fa /storage/home/hgr5/ibb3_group/default/genome_annotation/Apalm_dovetail_assemblies/acropora_palmata_18May2018_0a5M3.masked.fa > /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symNcoral.fa

# make the blast database
# use the ibb3 blast so the command works
cd /gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin

./makeblastdb -in /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symNcoral.fa -dbtype nucl -out /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral -parse_seqids

/gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin/blastn -task megablast -query /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa -db /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral -evalue 1e-5 -max_target_seqs 1 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral_max1.out

/gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin/blastn -task megablast -query /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/AC_Sfitti_2.fa -db /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral -evalue 1e-5 -max_target_seqs 3 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle' -out /gpfs/group/ibb3/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral_max3.out

# make into a text file
symORcoral_max1.out > symORcoral_max1.txt
symORcoral_max3.out > max3.txt

# smic abbrev for V2 = Smic.scaffold
# stridac abbrev for V2 = scaffold
# Adig abbrev for V2 = NW_
# Ahyan abbrev for V2 = flattened
# Aten abbrev for V2 = Sc
# Apalm abbrev for V2 = Sc0a5M3
# Acerv abbrev for V2 = Segkk

# filter using awk, could also count using grep -c (gets same results)
# using the maxout1 file
awk '/scaffold/ {print $2}' symORcoral_max1.txt > stridac.txt # pulls out column 2 matches that are smic & tridac
awk '/NW_/ {print $2}' symORcoral_max1.txt > adig.txt # pulls out column 2 matches that are Adig... spoiler alert, there are none
awk '/flattened/ {print $2}' symORcoral_max1.txt > ahyan.txt # pulls out column 2 matches that are Ahyan... spoiler alert, there are none
awk '/Sc/ {print $2}' symORcoral_max1.txt > aten.txt # pulls out column 2 matches that are Aten and Apalm, there are 57, all are apalm
awk '/Segkk/ {print $2}' symORcoral_max1.txt > acerv.txt # pulls out column 2 matches that are Acerv, there are 57

# get all of the coral contam output into one text file
# useful link: http://www.theunixschool.com/2012/05/awk-match-pattern-in-file-in-linux.html
# maxout3
awk '$2 ~ /NW|flattened|Sc|Sc0a5M3|Segkk/{print}' max3.txt > coral_contam_max3.txt
grep -n size coral_contam_max3.txt # 5918 lines
# maxout1
awk '$2 ~ /NW|flattened|Sc|Sc0a5M3|Segkk/{print}' symORcoral_max1.txt > coral_contam_max1.txt
grep -n size coral_contam_max1.txt # 114 lines

echo MEOW
echo " "
echo "Job Ended at `date`"

