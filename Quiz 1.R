#Getting and Cleaning Data
#Quiz 1
#Question 1
#
#
filename<-"./Data/getdata_data_ss06hid.csv"
data<-read.csv(filename,as.is=T,na.strings())
sum(data$VAL>=24,na.rm=T)#53
#Question 2
table(data$FES,useNA="ifany")
#See MetaData - Each code has more then one meaning.
#Question 3
library(XLConnect)

filename<-"./Data/getdata_data_DATA.gov_NGAP.xlsx"
#data<- readWorksheetFromFile(filename, sheet=1,header=F,colTypes="numeric")
data<- readWorksheetFromFile(filename, sheet=1,header=F)
dat<-data[18:23,7:15]

dat$Col7<-as.numeric(dat$Col7)
dat$Col12<-as.numeric(dat$Col12)
sum(dat$Col7*dat$Col12,na.rm=T) 


#Question 4

library(XML)
library(RCurl)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
xData <- getURL(fileURL, ssl.verifypeer = FALSE)
doc <- xmlParse(xData)
data<-xmlToDataFrame(getNodeSet(doc,"//response/row/row/zipcode"))
sum(data==21231)
#Question 5
filename<-"./Data/getdata_data_ss06pid.csv"

#Question 5
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(tapply(DT$pwgtp15,DT$SEX,mean) )
system.time(tapply(DT$pwgtp15,DT$SEX,mean) )
mean(DT$pwgtp15,by=DT$SEX)
mean(DT$pwgtp15,by=DT$SEX)
mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
#End of Quiz
#git@github.com:biarchitect/GettingAndCleaningData.git




