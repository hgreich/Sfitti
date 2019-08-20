# update aug 19, contam.rm snp set
install.packages("ParallelStructure",lib="/storage/home/hgr5/scratch/",repos="http://R-Forge.R-project.org")
library(ParallelStructure, lib.loc="/storage/home/hgr5/scratch/")
system('mkdir results')
parallel_structure(structure_path='/gpfs/group/ibb3/default/tools/Structure/bin/',joblist='joblist.txt',n_cpu=8, outpath='./results/', infile="aug19_str_infile", numinds=48, numloci=58538, label=1, popdata=1, popflag=0, locdata=0, phenotype=0, markernames=1, onerowperind=0, phaseinfo=0, phased=0, recessivealleles=0, missing=-9, ploidy=1, noadmix=0, linkage=0, usepopinfo=0, locprior=0, inferalpha=1, alpha=1.0, popalphas=0, unifprioralpha=1, alphamax=10.0, alphapropsd=0.025, freqscorr=1, onefst=0, fpriormean=0.01, fpriorsd=0.05, inferlambda=0, lambda=1.0, computeprob=1, ancestdist=0, startatpopinfo=0, metrofreq=10, updatefreq=1,printqhat=1,plot_output=1)
