## Getting and Cleaning Data Course
## Final Project (Week 4 Assignment), June 2016
## Coursera

## 0. Setup
setwd("/Users/rrbaker/Sites/_edu/coursera_r/coursera_gettingcleaningdata")

read.table("features.txt", skip=FALSE)[,2] -> train_features
read.table("train/subject_train.txt", skip=FALSE) -> train_subject
read.table("train/X_train.txt", skip=FALSE) -> train_x 
read.table("train/y_train.txt", skip=FALSE) -> train_y 
read.table("test/X_test.txt", skip=FALSE) -> test_x
read.table("test/y_test.txt", skip=FALSE) -> test_y 
read.table("test/subject_test.txt", skip=FALSE) -> test_subject 
read.table("activity_labels.txt", skip=FALSE) -> test_labels

labels <- test_labels
names(labels) <- c("Code","Description")

## 1. Let's merge some data (test and training sets)

cbind(train_subject,train_y,train_x) -> train_x
cbind(test_subject,test_y,test_x) -> test_x
data_merged <- rbind(train_x,test_x)
names(data_merged) <- c("subject","activity",as.character(train_features))


## 2. Extract only the measurements on the mean and standard deviation for each measurement.

# find it
grepl("mean()",names(data_merged),fixed=T) -> mean_cols
grepl("std()",names(data_merged),fixed=T) -> std_cols

cols<-mean_cols|std_cols
cols[1:2] <- c(1,1)
data_merged<-data_merged[,as.logical(cols)]


## 3. Uses descriptive activity names to name the activities in the data set

data_merged$activity <- actions$Description[as.numeric(data_merged$activity)] 
gsub('_','',data_merged$activity) -> data_merged$activity #cleanup
gsub('_','',data_merged$activity) -> data_merged$activity

## 4. Appropriately labels the data set with descriptive variable names.
# gsub("BodyBody","",names(data_merged)) -> names(data_merged) # cleanup


## 5. Export some data

require(plyr)

# generate summarized data
data_summarized<-ddply(data_merged,.(subject,activity),function(x) colMeans(x[,3:length(names(x))]))

# cleanup 
names(data_summarized) <- tolower(names(data_summarized))
names(data_summarized) <- gsub("[\\(\\)|-]","",names(data_summarized))

# Final test
data_summarized

# Export to file
write.table(data_summarized, file="tidyData.txt",row.name=FALSE)
