#GetingAndCleaningData
#Quiz 4
#Question 1
library(downloader)
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
file<-"./Data/q4q1.csv"
download(url,mode="wb",dest=file)

if (file.exists(file)) {
  download.file(url,file) #may need modifying if binary etc
  library(tools)       # for md5 checksum
  sink("download_metadata.txt")
  print("Download date:")
  print(Sys.time() )
  print("Download URL:")
  print(url)
  print("Downloaded file Information")
  print(file.info(file))
  print("Downloaded file md5 Checksum")
  print(md5sum(file))
  sink()
}


x<-read.csv(file,as.is=T, na.strings=c("..",""),skip=4)
xnames<-names(x)
strsplit(xnames,"wgtp")
xnamessplit<-strsplit(xnames,"wgtp")
xnamessplit[123]
xnames[123]

#Question 2
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
file<-"./Data/q4q2.csv"
download(url,mode="wb",dest=file)
#gdp<-read.csv(file,as.is=T, na.strings=c("..",""),skip=4,strip.white=T)
gdp<-read.csv(file1,as.is=T,skip=4,na.strings="NA",strip.white=T)
gdp<-gdp[gdp$X !="" & gdp$X.1 !="",]
mean(as.numeric(gsub(",","",gdp$X.4[1:190])),na.rm=T)

#Question 3

grep("^United",gdp$X.3,value=T)

#Question 4
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
file<-"./Data/q4q4b.csv"
download(url,mode="wb",dest=file)
#cntry<-read.csv(file,as.is=T, na.strings=c("..",""),strip.white=T)
cntry<-read.csv(file,as.is=T)
x<-merge(gdp,cntry,by.x="X",by.y="CountryCode")
length(grep("*Fiscal year end: June 30*",x$Special.Notes,value=T))
#grep("*[Jj]une*",x$Special.Notes,value=T)

#Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 
x2012<-sampleTimes[year(sampleTimes)==2012]
length(x2012)
sum(wday(x2012)==2)




