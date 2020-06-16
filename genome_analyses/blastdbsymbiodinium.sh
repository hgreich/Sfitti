#PBS -l nodes=1:ppn=1

#PBS -l walltime=24:00:00 #Time to run, our max limit is 24hrs

#PBS -l pmem=64gb

#PBS -j oe


cd /gpfs/home/hgr5/raw

module load blast/2.2.26 
module load blast+/2.2.26 

makeblastdb -in ~/raw/zoox.fa -dbtype nucl -out ~/raw/symbiodinium -parse_seqids

echo " "
echo "Job Ended at `date`"
