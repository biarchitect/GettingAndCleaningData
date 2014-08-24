---
title: "README.md"
author: "Todd H. Robinson"
date: "Sunday, August 24, 2014"
output: html_document
---
Coursera Course - Getting And Cleaning Data
======================

###Introduction

The purpose of this project is to demonstrate our ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
The tidy dataset is called Step5FinalDataset.txt

Here is how that dataset is created.
  
####Step 0 - Set the working Directory.
######The project was performed on a Windows machine. Windows conventions were therefore followed. To reproduce on other machines, set the mainddir and workdir to location of Samsung data.

maindir<-"C:/Users/trobinson/Documents/Coursera/GettingAndCleaningData"

setwd(maindir)
workdir<-"./Data//Project//UCI HAR Dataset//"
setwd(workdir)

####Step 1 - Get the data from train and Test and Merge them
######TRAIN - This represents training data. It appears its ioringal purpose was to provide a training data set for model development.

filetrainx<-".//train//X_train.txt"
train<-read.table(filetrainx,as.is=T)

filetrainsubj<-".//train//subject_train.txt"
trainsubj<-read.table(filetrainsubj,as.is=T)

######TEST - This represents data to test a developed model.
filetest<-".//test//X_test.txt"
test<-read.table(filetest,as.is=T)

filetestsubj<-".//test//subject_test.txt"
testsubj<-read.table(filetestsubj,as.is=T)

######Merge the two datasets. The two datasets have the same number and definition of columns. Therefore a simple row append using rbind is being used.

dfx<-rbind(train,test)

######Check of merge. The number of rows of each data set should match the number of rows of the combined dataset.
dim(train);dim(test);dim(dfx)
dim(train)[1]+dim(test)[1]==dim(dfx)[1]

####Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement.
###### Before we can subset the columns we need to know what they are. Therefore get the feature labels and apply them to the merged dataset.
######Step2.1 - Get the feature names so we know which are means and which are standard deviations. 
######Get Activity Labels
filenamelabels<-"./activity_labels.txt"
dfxlabels<-read.table(filenamelabels,as.is=T)

######Get feature/variable names
filenamefeatures<-"./features.txt"
dfxfeatures<-read.table(filenamefeatures,as.is=T)

######Only use the V2 variable which contains the names

dfxf<-dfxfeatures[,2]

######Replace default names with the actual variable names

names(dfx)<-dfxf

######Search for those columns that indicate they are Means or Standard deviations. 

dfxmeanIdx<-grep ("*[Mm]ean\\(\\)*",names(dfx))
dfxstdIdx<-grep ("*[Ss]td\\(\\)*",names(dfx))
dfx2<-cbind(dfx[,dfxmeanIdx],dfx[,dfxstdIdx])

######Check a few columns

sum(dfx$"tBodyAcc-mean()-X" == dfx2$"tBodyAcc-mean()-X") == dim(dfx)[1]
sum(dfx$"fBodyBodyGyroMag-std()" == dfx2$"fBodyBodyGyroMag-std()") == dim(dfx)[1]
sum(dfx$"fBodyBodyGyroJerkMag-mean()" == dfx2$"fBodyBodyGyroJerkMag-mean()") == dim(dfx)[1]
sum(dfx$"tBodyAccJerk-std()-Z" == dfx2$"tBodyAccJerk-std()-Z") == dim(dfx)[1]

######Checkpoint the work done thus far

df2<-dfx2

####Step 3 - Uses descriptive activity names to name the activities in the data set
######Get Activities - We need the 6 activities begin performed. They are in the "y" datasets. They have the same row dimensions as the train and test datasets. If we read them in in exactly they same order thena column binding can be used to associate the activity with the data.

filetrainy<-"./train//y_train.txt"
trainy<-read.table(filetrainy,as.is=T)

filetesty<-"./test//y_test.txt"
testy<-read.table(filetesty,as.is=T)

######Get Activity Labels

filenamelabels<-"./activity_labels.txt"
dfxlabels<-read.table(filenamelabels,as.is=T)
names(dfxlabels)<-c("ActivityNbr","Activity")

dfact<-rbind(trainy,testy)
names(dfact)<-"ActivityNbr"

dfactdesc<-merge(x=dfxlabels,y=dfact,by.x="ActivityNbr",by.y="ActivityNbr")

######Checkpoint the work done thus far

df5<-df2

df2<-cbind(dfactdesc$Activity,df2)
names(df2)[1]<-"Activity"

####Step 4 - Appropriately labels the data set with descriptive variable names. 
###### R sometimes has trouble with variable naming characters that have special R meaning. It is also difficult to read. Therefore remove parens, dashes and prettify the names into CamelCase.

names(df2)<-gsub("\\(","",names(df2))
names(df2)<-gsub("\\)","",names(df2))
names(df2)<-gsub("-m","M",names(df2))
names(df2)<-gsub("-s","S",names(df2))
names(df2)<-gsub("-","",names(df2))

####Step 5 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

filetrainsubj<-"./train//subject_train.txt"
trainsubj<-read.table(filetrainsubj,as.is=T)

filetestsubj<-"./test//subject_test.txt"
testsubj<-read.table(filetestsubj,as.is=T)

dfsubj<-rbind(trainsubj,testsubj)
names(dfsubj)<-"SubjectNbr"

######Add the columns for Activity and Subject

df5<-cbind(dfsubj,dfact,df5)
act<-sort(unique(df5$ActivityNbr))
subj<-sort(unique(df5$SubjectNbr))

df5avg<-matrix(rep(NA,68*1),nrow=1)
for (x in 1:length(subj)){for (y in 1:length(act)){df5avg<- rbind(df5avg,c(x,y,apply(df5[df5$SubjectNbr == x & df5$ActivityNbr == y,3:68],2,mean)))}}

######Get rid of NA row

df5avg<-df5avg[2:181,] 
df5avg<-as.data.frame(df5avg)

######checkpoint data frame

dfavg5.1<-df5avg

######Add a M - Mean to every column name

names(df5avg)[3:68]<-paste("M",names(df5avg[3:68]),sep="")

######Add a descriptive name for first two columns

names(df5avg)[1:2]<-c("SubjectNbr","ActivityNbr")

######Get rid of cluttering name parens

names(df5avg)<-gsub("\\(","",names(df5avg))
names(df5avg)<-gsub("\\)","",names(df5avg))

######Get rid of "-" and make CamelCase

names(df5avg)<-gsub("-m","M",names(df5avg))
names(df5avg)<-gsub("-s","S",names(df5avg))
names(df5avg)<-gsub("-","",names(df5avg))

######Write out df5avg 

write.table(df5avg,"./Step5FinalDataSet.txt",row.names=F,sep=",")

######Check result table

df33<-df5[df5$ActivityNbr==3&df5$SubjectNbr==3,]
df33avg<-apply(df33,2,mean)

######If all True then sum should equal number of Columns = 68

sum(df33avg==df5avg[df5avg$SubjectNbr==3 & df5avg$ActivityNbr==3,])