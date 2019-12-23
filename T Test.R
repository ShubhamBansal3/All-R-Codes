setwd("D:/Stats")

NonVDI<- read.csv("NonVDI_Jul_SO.csv")

VDI<- read.csv("VDI_Jul_SO.csv")

mean(NonVDI$stockouts)

t.test(VDI$stockouts,NonVDI$stockouts,alternative = "g",var.equal = FALSE)