## Script to clean two .csv files and finds the sum of tonnes of apples and oranges
## produced by the top ten politically stable countries

## Reads and cleans the apple and orange .csv table
aoraw<-read.csv("appleorange.csv",stringsAsFactors = FALSE,header=FALSE)
ao<-aoraw[3:700,]
names(ao)<-c("country","countrynumber","product","productnumber","tonnes","year")
ao[which(ao$country=="C\x99te d Ivoire"),'country']<-"Cote d'Ivoire"
ao$countrynumber<-as.integer(ao$countrynumber)
ao <- ao[ao$country!="Food supply quantity (tonnes) (tonnes)",]
ao <- ao %>% mutate(tonnes=parse_number(tonnes))
ao$year<-2009

## Creates two sorted dataframes: one for apples 'a' and one for oranges 'o'
a <- ao %>% filter(productnumber=="2617") %>% arrange(desc(tonnes))
o <- ao %>% filter(productnumber=="2611") %>% arrange(desc(tonnes))

## Reads and cleans the stability .csv
sraw <- read.csv("stability.csv",stringsAsFactors = FALSE,header=FALSE)
s <- sraw[6:960,]
names(s) <- c('country','countrynumber','factor','factornumber','score','unknown')
s <- s %>% filter(factor != "") %>% mutate(score=parse_number(score))
p <- s %>% filter(factornumber=='21032') %>% arrange(score)

## Sums the top ten stable country by produced tonnes of apples and oranges
sum(a[match(p$country[1:10],a$country),'tonnes'],na.rm=TRUE)
sum(o[match(p$country[1:10],ao$country),'tonnes'],na.rm=TRUE)

