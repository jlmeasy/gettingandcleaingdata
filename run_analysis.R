library(plyr)
library(reshape2)

filename <- "getdata_proj_dataset.zip"

setwd("C:\\temp")

if (!file.exists(filename)) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,filename,method="curl")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip(filename)
}

#load the activity and features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_desc <- as.character(activitylabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
feature_desc <- as.character(features[,2])

#join activity_labels and y_test
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
names(y_test) <- c("id")
Y_act_labels <- read.csv("UCI HAR Dataset/activity_labels.txt",sep="",header = FALSE)
names(Y_act_labels) <- c("id","desc")
merge_test_act <- join(Y_act_labels,y_test,by="id")


#join activity_labels and y_train
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
names(y_train) <- c("id")
merge_train_act <- join(Y_act_labels,y_train,by="id")


#extract the columsn for mean and standard deviation and get its data
dataWanted <- grep(".*mean.*|.*std.*",features[,2])
dataWanted.headers <- features[dataWanted,2]
dataWanted.headers <- gsub("-mean","Mean",dataWanted.headers)
dataWanted.headers <- gsub("-std","Std",dataWanted.headers)
dataWanted.headers <- gsub("[-()]","",dataWanted.headers)

#load the datasets
trainData <- read.table("UCI HAR Dataset/train/X_train.txt")[dataWanted]
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainTable <- cbind(trainSubjects,merge_train_act,trainData)

testData <- read.table("UCI HAR Dataset/test/X_test.txt")[dataWanted]
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
testTable <- cbind(testSubjects,merge_test_act,testData)


#merge tables and add headers
all_data <- rbind(trainTable, testTable)
colnames(all_data) <- c("subject","activities",dataWanted.headers)

#turn activities and subjects into factors
all_data$activities <- factor(all_data$activities, levels = activitylabels[,1], labels = activitylabels[,2])
all_data$subject <- as.factor(all_data$subject)

all_data.melted <- melt(all_data, id = c("subject","activities"), na.rm = TRUE)
all_data.mean <- dcast(all_data.melted, subject + activities ~ variable, mean)

#write to a filename
write.table(all_data.mean,"tidy.txt", row.names = FALSE, quote = FALSE)