
####We must first retrieve the data that we will be working with####
####In this case, it is contained in a zip folder####
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./MotionStudy.zip", method = "curl")

### R provides a built-in utility for unzipping compressed folders, and 
### we can remove the zipped directory once we've extracted its contents###
unzip("MotionStudy.zip")
file.remove("./MotionStudy.zip")

#### 1)Merges the training and the test sets to create one data set.
#### First, extract each test file into its own table###
test<- read.table("./UCI HAR Dataset/train/X_test.txt") %>%
        data.table()
testID <- read.csv("./UCI HAR Dataset/train/subject_test.txt") %>%
        data.table()
testActivity <- read.csv("./UCI HAR Dataset/train/y_test.txt") %>%
        data.table()
### tidy the main table so that each column represents a single observation




train<-read.csv("./UCI HAR Dataset/train/X_train.txt") %>%
        data.table()
trainID <- read.csv("./UCI HAR Dataset/train/subject_train.txt") %>%
        data.table()
trainActivity <- read.csv("./UCI HAR Dataset/train/y_train.txt") %>%
        data.table()


#### 2)Extracts only the measurements on the mean and standard deviation 
#####   for each measurement.

#### 3)Uses descriptive activity names to name the activities in the data set

#### 4)Appropriately labels the data set with descriptive variable names.

#### 5)From the data set in step 4, creates a second, independent tidy data set 
#####   with the average of each variable for each activity and each subject.