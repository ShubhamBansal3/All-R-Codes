library(dplyr)
getwd()

setwd("D:/R Functions/Pareto")

Data<- read.csv("Pareto.csv")

List<- split(Data, Data[,2])

Pareto<- function(DataParam)
{

Summary<- group_by(DataParam,DataParam[,1])%>%summarise(.,Summ=sum(RoomNights))%>%arrange(.,desc(Summ))

colnames(Summary)[1]<- "Group"

Total<- sum(Summary$Summ)

Summary$Pareto<- cumsum(Summary$Summ)

Summary$Pareto_Perc<- round((Summary$Pareto/Total)*100,2)

return(Summary)

}

SummList<- lapply(List,Pareto)

Len<- length(SummList)



DataFinal<- data.frame()

for(i in 1:Len){
  
  if(nrow(data.frame(SummList[[i]]))!=0){
    Data<- data.frame(SummList[[i]])
    Data$Name<- names(SummList)[i]
  }
  
  DataFinal<- rbind(DataFinal,Data) 
  
}

write.csv(DataFinal,"Output.csv")