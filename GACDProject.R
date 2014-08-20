#Project
#Step 0 Get data sets.

rm(list=ls())
library(downloader)

mainDir<-getwd()
subDir<-"./Data"
dir.create(file.path(mainDir, subDir),showWarnings=F)
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(url,mode="wb",dest="./Data/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")


#Step 1.Combine the training and the test sets to create one data set.
#TRAIN
filetrainx<-"./Data//Project//UCI HAR Dataset//train//X_train.txt"
train<-read.table(filetrainx,as.is=T)

filetrainy<-"./Data//Project//UCI HAR Dataset//train//y_train.txt"
trainy<-read.table(filetrainy,as.is=T)

filetrainsubj<-"./Data//Project//UCI HAR Dataset//train//subject_train.txt"
trainsubj<-read.table(filetrainsubj,as.is=T)

#TEST

filetest<-"./Data//Project//UCI HAR Dataset//test//X_test.txt"
test<-read.table(filetest,as.is=T)

filetesty<-"./Data//Project//UCI HAR Dataset//test//y_test.txt"
testy<-read.table(filetesty,as.is=T)

filetestsubj<-"./Data//Project//UCI HAR Dataset//test//subject_test.txt"
testsubj<-read.table(filetestsubj,as.is=T)

dfx<-rbind(train,test)
dim(train)[1]+dim(test)[1]==dim(dfx)[1]
dfact<-rbind(trainy,testy)
names(dfact)<-"ActivityNbr"
dfsubj<-rbind(trainsubj,testsubj)
names(dfsubj)<-"SubjectNbr"





# 
#Get Activity Labels
filenamelabels<-"./Data//Project//UCI HAR Dataset//activity_labels.txt"
dfxlabels<-read.table(filenamelabels,as.is=T)

#Get feature/variable names
filenamefeatures<-"./Data//Project//UCI HAR Dataset//features.txt"
dfxfeatures<-read.table(filenamefeatures,as.is=T)

#Only use the V2 variable whcih contains the names
dfxf<-dfxfeatures[,2]
#Replace default names with the actual variable names
names(dfx)<-dfxf


#Step 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
dfxmeanIdx<-grep ("*[Mm]ean\\(\\)*",names(dfx))
dfxstdIdx<-grep ("*[Ss]td\\(\\)*",names(dfx))
dfx2<-cbind(dfx[,dfxmeanIdx],dfx[,dfxstdIdx])
sum(dfx$"tBodyAccJerk-std()-Z" == dfx2$"tBodyAccJerk-std()-Z") == dim(dfx)[1]







#Step 3.Uses descriptive activity names to name the activities in the data set


df2<-dfx2
#Step 4.Appropriately labels the data set with descriptive variable names. 
names(df2)<-gsub("\\(","",names(df2))
names(df2)<-gsub("\\)","",names(df2))
names(df2)<-gsub("-m","M",names(df2))
names(df2)<-gsub("-s","S",names(df2))
names(df2)<-gsub("-","",names(df2))

#Add the columns for Activity and Subject
df2<-cbind(dfsubj,dfact,df2)


#Step 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

act<-sort(unique(df2$ActivityNbr))
subj<-sort(unique(df2$SubjectNbr))
avgs<-matrix(rep(NA,180*68),nrow=180)

# for (x in 1:length(act)){for (y in 1:length(subj)){avgdf2<- rbind(avgdf2,c(x,y,apply(df2[df2$ActivityNbr == x & df2$SubjectNbr == y,3:68],2,mean)))}}
# 
# avgdf<-as.data.frame(avgdf)

avgdf2<-matrix(rep(NA,68*1),nrow=1)
for (x in 1:length(subj)){for (y in 1:length(act)){avgdf2<- rbind(avgdf2,c(x,y,apply(df2[df2$SubjectNbr == x & df2$ActivityNbr == y,3:68],2,mean)))}}
avgdf2<-avgdf2[2:181,]
avgdf2<-as.data.frame(avgdf2)



names(avgdf2)[1]<-"ActivityNbr"
names(avgdf2)[2]<-"SubjectNbr"
#avgdf<-t(as.matrix(avgs,ncol=68))


# 
# dir.create(file.path(mainDir, subDir),showWarnings=F)
# filenamex<-"./Data//Project//UCI HAR Dataset//train//X_train.txt"
# filenamelabels<-"./Data//Project//UCI HAR Dataset//activity_labels.txt"
# filenamefeatures<-"./Data//Project//UCI HAR Dataset//features.txt"
# dfxlabels<-read.table(filenamelabels,as.is=T)
# 
# #if (!file.exists(filename)){download}
# dfx<-read.table(filenamex)
# filenamey<-"./Data//Project//UCI HAR Dataset//train//y_train.txt"
# dfy<-read.table(filenamey)
# #Bind the activity performed with the measurement.
# df<-cbind(dfy,dfx)
# names(df)[1:2]<-c("ActivityNbr","V1")
# names(dfxlabels)<-c("ActivityNbr","Activity")
# dfm<-merge(x=df,y=dfxlabels,by="ActivityNbr")
# table(dfm$V1,dfm$Activity)




