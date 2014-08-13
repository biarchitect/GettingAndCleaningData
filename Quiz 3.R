#Getting and Cleaning Data
#Quiz 3
rm(list=ls())
#Question 1
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
x<-read.csv(file=url)

agriculturalLogical<-(x$ACR==3 & x$AGS == 6)
which(agriculturalLogical)[1:3]
@Question 2

library(jpeg)
library(downloader)

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download(url,mode="wb",dest="./Data/q3q2.jpg")
file<-"./Data/q3q2.jpg"
x<-readJPEG(file,native=T)
x80<-quantile(x,probs=c(0,0.20,0.80))[3]
x30<-quantile(x,probs=c(0,0.30,0.70))[2]
c(x30,x80)

#Question 3

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
file1<-"./Data/q3q3_gdp.csv"
download(url,mode="wb",dest=file1)
gdp<-read.csv(file1,as.is=T,skip=4,na.strings="NA",strip.white=T)
gdp<-gdp[gdp$X !="" & gdp$X.1 !="",]


url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
file2<-"./Data/q3q3_cntry.csv"
download(url,mode="wb",dest=file2)
cntry<-read.csv(file2,as.is=T)
sum(complete.cases(match(gdp$X,cntry$CountryCode)))
sort(as.numeric(gdp$X.1),decreasing=T)[13]
gdp[gdp$X.1==178,]

#Question 4
x<-merge(gdp,cntry,by.x="X",by.y="CountryCode")

x4.a<-mean(as.numeric(x[x$Income.Group == "High income: OECD",2]))
x4.b<-mean(as.numeric(x[x$Income.Group == "High income: nonOECD",2]))
c(x4.a,x4.b)


#Question 5
library(Hmisc)
x$q<-cut2(as.numeric(x$X.1),g=5)
table(x$q,x$Income.Group)
table(x$q,x$Income.Group)[1,5]









