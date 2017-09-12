##install packages if needed
#install.packages("dplyr", "data.table", "tidyr")
#library(dplyr, data.table, tidyr)

###We must first retrieve the data that we will be working with
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, destfile="./MotionStudy.zip")
#unzip("MotionStudy.zip") 
#file.remove("./MotionStudy.zip")

### We will need these to label our data once we've extracted it 
activity_labels <- fread("./UCI HAR Dataset/activity_labels.txt")
feature_labels <- fread("./UCI HAR Dataset/features.txt")

#### First, read each test file into its own table###
### fread() automatically separates each row of text into columns,
### but col and row names need to be created manually in this case.
### factor mutations here are to make data manipulation easier later on
testID <- fread("./UCI HAR Dataset/test/subject_test.txt",
                     col.names = "Subject", colClasses = "factor") %>%
                        mutate(Condition = as.factor("Test"))
testActivity <- fread("./UCI HAR Dataset/test/y_test.txt",
                           col.names = "Activity", colClasses = "factor")
testDat<- fread("./UCI HAR Dataset/test/X_test.txt")
colnames(testDat) = feature_labels$V2

### Combine three "test*" tables into one master "TEST" table w/ row names
TEST <- cbind(testID, testActivity, testDat) 
  row.names(TEST) = paste("Test", 1:2947, sep = "")
###cleanup
  rm(testActivity, testDat, testID)

###repeat the same process with the training data, making sure that column
###names match up exactly.  Row names and "condition" distinguish from test
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

###  TASK 1: Merges the training and the test sets to create one data set.
ALL <- rbind(TEST, TRAIN) %>%
        as.data.table()
### Because of the high incidence of non-alphanumeric characters in our column
### names, we need to take an extra step to convert them to a format that R
### can understand.  If we skip this step, we will not be able to properly
### use our dplyr functions.  I beleive we can undo this later
names(ALL) <- make.names(names(ALL), unique = TRUE, allow_ = TRUE)

### TASK 2: Extracts only the measurements on the mean 
### and standard deviation for each measurement.
Trimmed <- ALL %>%
        select(-contains("angle")) %>%
        select(Subject, Condition, Activity, 
               contains("mean.."), contains("std.."))

### Now that we have our data subset, we can go back and return the column
### names to their original state
names(Trimmed) <- gsub("\\.\\.", "\\(\\)", names(Trimmed))
names(Trimmed) <- gsub("\\(\\)\\.", "\\(\\)\\-", names(Trimmed))

### TASK 3: Uses descriptive activity names to 
### name the activities in the data set
levels(Trimmed$Activity) <- as.character(activity_labels$V2) 
#######################################################

### TASK 4 was done during the creation of the dataset

### TASK 5: From the data set in step 4, creates a second, independent tidy  
### data set with the average of each variable for each activity 
### and each subject.

### Establish groupings and calculate means by Subject and Activity 
Final <- group_by(Trimmed, Subject, Activity) %>%
        select(-Condition) %>% 
        summarize_all(mean) %>%
        arrange(as.numeric(as.character(Subject)))
        
View(Final)

