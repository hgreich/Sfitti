
# aug 8 2019. this script has been updated to use vcf with coral contam removed (this removed only a 2409 snps). need to rerun everything

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
install.packages("labeling",lib="/storage/home/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/R/", repos="https://CRAN.R-project.org/")

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

dat <- read.table("/storage/home/h/hgr5/ibb3_group/default/genome_resources/Symbiodinium/S.fitti/newsamples_092018/mm80_nov18/contam_removal_08082019/transposed_nocontam_aug12.txt", check.names = FALSE, header = T, row.names = 1)

my <- df2genind(dat, ploidy = 1, sep = "")
obj2 <- as.genclone(my)

cols <- c("skyblue2","#C38D9E", '#E8A87C',"darkcyan","#e27d60") # colors used on the poster

set.seed(999)
theTree <- obj2 %>%
  aboot(dist = provesti.dist, sample = 100, tree = "nj",
        cutoff = 50, quiet = TRUE) %>%
  ladderize() # organize branches by clade
plot.phylo(theTree, label.offset = 0.0125,cex=0.7,
           font=2, lwd=6)
add.scale.bar(length = 0.1, cex=.65) # add a scale bar showing 5% difference.
nodelabels(theTree$node.label, cex=.6, adj = c(1.5, -0.1), frame = "n", font=3,
           xpd = TRUE)

# write the newick output
write.tree(theTree, file = "TREE_aug19_nocontam", digits = 20, tree.names = FALSE)

#### 1% threshold
xdis<-provesti.dist(obj2)
mlg.filter(obj2, distance= xdis) <- 0.01 #threshold 0.01 copied from SAK
m <- mlg.table(obj2, background=TRUE, color=TRUE)
# save the plot
#ggsave(m, "thresh01.png")
#save_plot("thres01.png", m, base_aspect_ratio = 1.5)


#### 5% threshold
xdis<-provesti.dist(obj2)
mlg.filter(obj2, distance= xdis) <- 0.05 #threshold 0.05 experiment
n <- mlg.table(obj2, background=TRUE, color=TRUE)
#save_plot("thres05.png", n, base_aspect_ratio = 1.5)

#### 10% threshold
xdis<-provesti.dist(obj2)
mlg.filter(obj2, distance= xdis) <- 0.1 #threshold 0.1 experiment
o <- mlg.table(obj2, background=TRUE, color=TRUE)
#save_plot("thres1.png", o, base_aspect_ratio = 1.5)

ind <- mlg.id(obj2)
#ind

### 1% threshold
mlg.crosspop(obj2)

#H = shannons index, G = stoddart & taylors index aka inverse simpsons index, lambda = simpsons index, E5 = evenness
#### 1% threshold
diversity_stats(m)
#### 5% threshold
diversity_stats(n)
#### 10% threshold
diversity_stats(o)

### genotype curve
# Genotype accumulation curves are useful for determining the minimum number of loci necessary to discriminate between individuals in a population. This function will randomly sample loci without replacement and count the number of multilocus genotypes observed.

genotype_curve(obj2, sample = 100,  quiet = TRUE, thresh = 1, plot = TRUE)

# summary statistics per loci
geno_simpson <- locus_table(obj2, index = "simpson", lev = "genotype")
geno_simpson
geno_shannon <- locus_table(obj2, index = "shannon", lev = "genotype")
geno_shannon
geno_invsimpson <- locus_table(obj2, index = "invsimpson", lev = "genotype")
geno_invsimpson
