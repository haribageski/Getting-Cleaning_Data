setwd("C:/Users/hari/Documents/R/Getting and Cleaning Data/Class Project")

library(utils)
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
X_train<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_train<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",header=FALSE)


X_test<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",header=FALSE)
y_test<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",header=FALSE)
subject_test<-read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",header=FALSE)

activity <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",header=FALSE)
features <- read.table("getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt",header=FALSE)

install.packages("reshape")
library(reshape)
X <- rbind(X_train,X_test)
colnames(X) <- features[,2]
Y <- rbind(y_train,y_test)
colnames(Y) <- c("Activities")

subject <- rbind(subject_train,subject_test)
colnames(subject) <- c("Subject")
Merged <- cbind(subject,Y,X)

head(features)
features[7,]
mean_sd <- which(grepl("mean",features[,2]) | grepl("std",features[,2]))
Mean_sd <- cbind(Merged[,1:2],Merged[,2+mean_sd]) #The first two columns are not in "features"


#We need to substitute the column of Activities from numbers to Words...
Mean_sd$Activities <-activity[Mean_sd$Activities,2]

Grouped <- aggregate(Mean_sd[,3:81], by=list(Mean_sd$Activities,Mean_sd$Subject), FUN=mean)
colnames(Grouped)[1:2] <- c("Activity","ID")
Grouped