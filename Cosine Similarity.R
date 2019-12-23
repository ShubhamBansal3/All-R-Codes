library(twitteR)
library(tidytext)
library(dplyr)
library(tm)
library(SnowballC)


url <- "http://www.rdatamining.com/data/rdmTweets-201306.RData"
download.file(url, destfile = "rdmTweets-201306.RData")

load(file = "rdmTweets-201306.RData")
tweets <- twListToDF(tweets)

tweets <- tweets %>% 
  mutate(text=gsub("(http|https).+$|\\n|&amp|[[:punct:]]","",text),
         rowIndex=as.numeric(row.names(.))) %>% 
  select(text,retweetCount,rowIndex)


docList <- as.list(tweets$text)
N.docs <- length(docList)

queryTerm<-"Java Programming"
my.docs <- VectorSource(c(docList, queryTerm))

my.corpus <- VCorpus(my.docs) %>% 
  tm_map(stemDocument) %>%
  tm_map(removeNumbers) %>% 
  tm_map(content_transformer(tolower)) %>% 
  tm_map(removeWords,stopwords("en")) %>%
  tm_map(stripWhitespace)

term.doc.matrix.stm <- TermDocumentMatrix(my.corpus,
                                          control=list(
                                            weighting=function(x) weightSMART(x,spec="ltc"),
                                            wordLengths=c(1,Inf)))

term.doc.matrix <- tidy(term.doc.matrix.stm) %>% 
  group_by(document) %>% 
  mutate(vtrLen=sqrt(sum(count^2))) %>% 
  mutate(count=count/vtrLen) %>% 
  ungroup() %>% 
  select(term:count)

docMatrix <- term.doc.matrix %>% 
  mutate(document=as.numeric(document)) %>% 
  filter(document<N.docs+1)

qryMatrix <- term.doc.matrix %>% 
  mutate(document=as.numeric(document)) %>% 
  filter(document>=N.docs+1)


searchRes <- docMatrix %>% 
  inner_join(qryMatrix,by=c("term"="term"),
             suffix=c(".doc",".query")) %>% 
  mutate(termScore=round(count.doc*count.query,4)) %>% 
  group_by(document.query,document.doc) %>% 
  summarise(Score=sum(termScore)) %>% 
  filter(row_number(desc(Score))<=10) %>% 
  arrange(desc(Score)) %>% 
  left_join(tweets,by=c("document.doc"="rowIndex")) %>% 
  ungroup() %>% 
  rename(Result=text) %>% 
  select(Result,Score,retweetCount) %>% 
  data.frame()