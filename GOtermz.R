
setwd("/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")

# install packages
#install.packages("poppr",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("dendextend",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("ape",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("dplyr",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("adegenet",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("ade4",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("crayon",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("ggplot2",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("cowplot",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("withr",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")
#install.packages("labeling",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")

# load them
library("withr", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("crayon", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("ggplot2", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("ade4", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("adegenet", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("dendextend", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("ape", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("dplyr", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("poppr", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("cowplot", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")
library("labeling", lib.loc="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/")


# read in the tremble for GO file
t <- read.table("/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/trembl_for_go.txt", header = T)

# read in the uniprot GO terms
u <- read.table("/storage/home/hgr5/scratch/uniprot_goTerms.txt", header=FALSE, sep = "\t",quote = "")

# join stuff using merge function
go <- merge(t, u, by.x = "Trembl_Hit", by.y = "V1")

write.table(go, "sfitti_go_terms_trembl.txt", sep="\t", quote=FALSE, row.names=FALSE)
