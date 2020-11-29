args <- commandArgs(TRUE)
indata <- args[1]
mydata <- read.table(indata,header=F)
size = dim(mydata)[1] ;
for (i in 1:size){
    count <- mydata[i,4]+mydata[i,5]
    p.value <- dbinom(mydata[i,4],count,0.006)
    if (p.value <= 1e-5){
        #outdata <- paste(i,p.value,sep="\t") ;
	outdata <-paste(mydata[i,1],mydata[i,2],mydata[i,3],mydata[i,4],mydata[i,5],mydata[i,6],mydata[i,7],sep=" ");
        print (outdata)
    }
}
