library(stringr)
library(ggplot2)

# from Dr. Drew Wham
# original script here https://github.com/DrewWham/Genetic-Structure-Tools

#function for extracting the cluster Probs, requires STR infile because STRUCTURE likes to chop off the ends of your sample names so I have to use your original file to get your original names
read.STR<-function(STR.in,STR.out){
  #read in data
  str<-read.table(STR.in,skip=1)	
  str.out<-readLines(STR.out, warn = FALSE)
  #the next part parses the structure outfile and grabs the q score part
  q.tab.id <- grep("Inferred ancestry of individuals:",str.out,
                   value=FALSE)
  num.ind <- grep("Run parameters:",str.out,
                  value=FALSE)+1
  num.ind<-str.out[num.ind]	 				 
  num.ind<-as.numeric(str_extract_all(num.ind,"[0-9.A-Za-z_]+")[[1]][1])
  q.end.id<-1+num.ind+q.tab.id		
  q.tab<-str.out[(q.tab.id+2):q.end.id]
  qs<-t(sapply(str_extract_all(q.tab,"[0-9.A-Za-z_]+"),as.character))
  qs<-qs[,c(2,5:dim(qs)[2])]
  qs<-data.frame(qs)
  nclust<- dim(qs)[2]-1
  #this part replaces the names with your original names
  qs[,1]<-str[,1]
  write.csv(qs,paste("k",nclust,".csv",sep=""),row.names=F)
}



#this function plots the structure plot, it takes the result of read.STR, it will also optionaly take a file to reorder the plot, if you dont already have one just reorder your outfile from above and save it
plotSTR<-function(Cluster.csv,plt.order=Cluster.csv){
  #I turn off warnings because it will tell you about duplicated factors below 
  oldw <- getOption("warn")
  options(warn = -1)
  #read data
  data<-fread(Cluster.csv)
  plt.order<-fread(plt.order)
  nclust<-dim(data)[2]-1
  #relabel the columns
  labs<-c("Sample",paste("Cluster",seq(1:nclust),sep=""))
  og.labs<-paste("X",seq(1:(nclust+1)),sep="")
  setnames(data,og.labs,labs)
  #reorder, this doesnt do anything if you dont supply an order file
  data<-data[match(plt.order$X1,data$Sample),]
  #remove duplicates, you shouldnt have duplicates anyway
  data<-data[!duplicated(data$Sample),]
  #I melt here to make the plotting easy
  mdata<-melt(data)
  names(mdata)<-c("Sample","Species","Probability")
  mdata$Sample<-factor(mdata$Sample,levels=data$Sample)
  #plot, you can change the palette to something else to explore other color themes
  ggplot(mdata,aes(x=Sample,y=Probability,fill=Species))+geom_bar(stat="identity",position="stack")+theme_classic()+ scale_fill_brewer(palette="Spectral")+theme(axis.text.x = element_text(size=12, angle = 90, hjust = 1,colour="black"))
  ggsave(paste("k",nclust,"STRplot.pdf",sep=""),width = 20, height = 9)
  options(warn = oldw)
}
