#! /bin/bash
#SBATCH --job-name=RAXML-NG
#SBATCH -p normal
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=2 
#SBATCH --mem-per-cpu=8G
#SBATCH -e /scratch/cluster/weekly/raxml/job_27217/slurm_raxml.err
#SBATCH -o /scratch/cluster/weekly/raxml/job_27217/slurm_raxml.out

# job step 0 = jobid.0
# main clustering command
srun /software/Phylogeny/raxml-ng/0.9.0/bin/raxml-ng  --msa /scratch/cluster/weekly/raxml/job_27217/sequenceAlignment.fa --model GTR+FO+G  --opt-branches on --opt-model on --tree pars{50},rand{50} --all  --bs-trees 100 --force --threads 2 --prefix /scratch/cluster/weekly/raxml/job_27217/result  ; 

# job step 1 = jobid.1
# return bask result files
srun scp -r /scratch/cluster/weekly/raxml/job_27217/* raxml@$SLURM_SUBMIT_HOST:/scratch/local/weekly/raxml/job_27217 ;

# send remail with link about jobid.0
/home/raxml/bin/jobIsFinished.sh 27217 GQSFozjUIiZK hgreich16@gmail.com & 