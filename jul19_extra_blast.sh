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
cat /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.microadriaticum/sym_smic.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.tridacnidorum/2018_assembly/sym_tridac.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/ortho_analysis/Aten.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/ortho_analysis/Acerv.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/ortho_analysis/Apalm_v2.fa /storage/home/h/hgr5/ibb3_group/default/genome_resources/coral/ortho_analysis/Adig.fa > /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symNcoral.fa

# make the blast database
# use the ibb3 blast so the command works
cd /gpfs/group/ibb3/default/tools/ncbi-blast-2.6.0+/bin

./makeblastdb -in /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symNcoral.fa -dbtype nucl -out /storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/jul19_blast/symORcoral -parse_seqids

echo MEOW
echo " "
echo "Job Ended at `date`"

