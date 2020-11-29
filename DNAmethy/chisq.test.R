args <- commandArgs(TRUE)
indata <- args[1]
mydata <- read.table(indata,header=T)
size = dim(mydata)[1] ;
for (i in 1:size){
    count13 <- mydata[i,6]
    count14 <- mydata[i,13]
    if (count13 >=10 && count14 >=10){
        countmC13 <- mydata[i,8] + mydata[i,10] + mydata[i,12]
        countmC14 <- mydata[i,15] + mydata[i,17] + mydata[i,19]
        countunC13 <- count13 - countmC13 
        countunC14 <- count14 - countmC14
        data <- matrix(c(countmC13,countmC14,countunC13,countunC14),ncol=2)
        testResult <- chisq.test(data)
        Pvalue <- testResult$p.value 
        if (Pvalue != "NaN" && Pvalue <= 0.05){
            outdata <- paste(i,Pvalue,sep="  ") ;
            print (outdata)
        }
    }
}
