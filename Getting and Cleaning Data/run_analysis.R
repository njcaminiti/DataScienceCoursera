install.packages("data.table", "dplyr", "tidyr")
library(data.table, dplyr, tidyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./MotionStudy.zip")
unzip("MotionStudy.zip") 
file.remove("./MotionStudy.zip")

activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt")
feature_labels <- fread("./UCI HAR Dataset/features.txt")

testID <- fread("./UCI HAR Dataset/test/subject_test.txt",
                     col.names = "Subject", colClasses = "factor") %>%
                        mutate(Condition = as.factor("Test"))
testActivity <- fread("./UCI HAR Dataset/test/y_test.txt",
                           col.names = "Activity", colClasses = "factor")
testDat<- fread("./UCI HAR Dataset/test/X_test.txt")
colnames(testDat) = feature_labels$V2

TEST <- cbind(testID, testActivity, testDat) 
  row.names(TEST) = paste("Test", 1:2947, sep = "")
  rm(testActivity, testDat, testID)


trainID <- fread("./UCI HAR Dataset/train/subject_train.txt",
                      col.names = "Subject", colClasses = "factor") %>%
                        mutate(Condition = as.factor("Train"))
trainActivity <- fread("./UCI HAR Dataset/train/y_train.txt",
                            col.names = "Activity", colClasses = "factor")
trainDat<- fread("./UCI HAR Dataset/train/X_train.txt")
colnames(trainDat) = feature_labels$V2

TRAIN <- cbind(trainID, trainActivity, trainDat)
  row.names(TRAIN) = paste("Train", 1:7352, sep = "")
rm(trainActivity, trainDat, trainID)

ALL <- rbind(TEST, TRAIN) %>%
        as.data.table()

names(ALL) <- make.names(names(ALL), unique = TRUE, allow_ = TRUE)

Trimmed <- ALL %>%
        select(-contains("angle")) %>%
        select(Subject, Condition, Activity, 
               contains("mean.."), contains("std.."))

names(Trimmed) <- gsub("\\.\\.", "\\(\\)", names(Trimmed))
names(Trimmed) <- gsub("\\(\\)\\.", "\\(\\)\\-", names(Trimmed))

levels(Trimmed$Activity) <- as.character(activity_labels$V2) 

Final <- group_by(Trimmed, Subject, Activity) %>%
        select(-Condition) %>% 
        summarize_all(mean) %>%
        arrange(as.numeric(as.character(Subject)))
print(Final)        
View(Final)

