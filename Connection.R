library("RPostgres",   lib.loc="~/R/R-3.5.1/library")
library("RPostgreSQL", lib.loc="~/R/R-3.5.1/library")

drv <- dbDriver("PostgreSQL")
pconn_rsql <- dbConnect(drv,  
                        host = "redshift.goibibo.com",
                        port = 5439,
                        user = "ishan_anand1",
                        password = "7EHE74GgkTdnGIMMTKPCA",
                        dbname = "goibibo")


