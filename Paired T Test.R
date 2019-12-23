setwd("D:/Stats")

Data<- read.csv("Paired T Test.csv")

Data$Diff<- Data$JulSO-Data$AprSO

ud<- 0
D<-mean(Data$Diff)
n<- nrow(Data)

Sd<- sd(Data$Diff)/sqrt(n)

TStat<- (D-ud)/Sd

criticalValue<- qt(.05,df=n-1,lower.tail = FALSE)

pvalue<- pt(2.602,df=n-1,lower.tail = FALSE)


apply(Data[,2:4],2,mean)