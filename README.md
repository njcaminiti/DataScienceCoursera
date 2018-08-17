## This is a demonstration of basic data wrangling in R.

The UCI dataset contains Human Activity Recognition data gathered using smartphone accelerometer and gyroscope functionality. 
This data, contained in 24 raw text files, represents 561 features measured over 10,000 observations. (over 5.5 million individual measurements)    

__*Raw datasets with descriptions are located within the UCI folder and subfolders*__

__run_analysis.R__ processes the UCI data and outputs a subset of this data in a 'tidy', analysis-friendly format: __FinalTidy.txt__


### 1) SETTING THE STAGE
Lines 1 & 2 Ensure that we have installed and loaded the R packages required to run our analysis.

Lines 4-6 retrieve and unzip the dataset.  Once the files are extracted, the zipped folder can be deleted (line 7).

We will need descriptive labels for our data, and these are provided in the two files we are reading from in lines 9 and 10.  These labels will be applied to our data tables once they are constructed.  For now we just set them aside.

---------------------------------------------------------
### 2) GETTING AND CLEANING OUR DATA
Each file from test data (subject ID, activities, and actual measurements respectively) is read into its own table (lines 12-17).  fread() automatically separates each row of text into columns, but Col and Row names need to be created manually, since they are not included in the data as presented.  We set our subject and activity variables as factors so that we can performed grouped analyses later on.  The feature labels that we extracted earlier are applied in line 18.

We now have three tables, each of which contains a chunk of the "test" data.  These chunks are combined into the comprehensive "TEST" table in line 20, each observation is given a unique identifier in line 21.  Once combined, the three component chunks are cleared from the workspace in line 22.

(This sequence is repeated for the "train" data in lines 25-35)

The TRAIN and TEST data are merged into a master "ALL" table in lines 37/38

----------------------------------------------------------
### 3) TRIMMING IT DOWN TO SIZE

We want only the measurements on the mean [ending in mean()] and standard deviation [ending in std()] for each measurement, so we are going to work some regex magic to make this happen.

** Line 40: names(ALL) <- make.names(names(ALL), unique = TRUE, allow_ = TRUE) **  Because of the high incidence of non-alphanumeric characters in our column names, we need to take this extra step to convert them to a format that R can understand.  If we skip this step, we will run into problems when we try to use our dplyr functions.  We can (and will) undo this step later.
What this step does essentially is to take special characters in variable names such as parentheses and dashes, and replaces them with non-special dots.

Lines 42-45 execute a sequence of two dplyr manipulations which a) remove unwanted features (the "angle" features), and b) selects only the mean() and std() features from those that remain.
**Trimmed <- ALL %>%**
        **select(-contains("angle")) %>%**
        **select(Subject, Condition, Activity,**
               **contains("mean.."), contains("std..")) **

*Note we are searching for "mean.." and "std..", not mean() and std().  This is because, as mentioned earlier, we had to temporarily reformat our column names in order to make dplyr work.*

Now that we have our "Trimmed" data subset, we can go back and return the column names to their original state by using gsub() in lines 47-48

The only step remaining before we do our actual analysis is to replace our non-descriptive activity labels with descriptive ones.  This is accomplished in line 50.

--------------------------------------
### 4) THE WRAP UP
Now we have only our relevant data, and we are tasked to create a second, independent tidy data set with the average of each variable [grouped by] each activity and each subject.

*we could accomplish this via a sequence of manual calculations, but we learned previously that such grouped analyses are made easy in R.*

So in order to **Establish groupings and calculate means by Subject and Activity$**, we can simply use the group_by() and summarize() functions built into the dplyr package, which is precisely what we do in lines 52-54.
Line 55 simply arranges the data according to subject ID to make it "prettier".

Finally, lines 56/57 displays the final dataset in two different ways, and line 58 writes this new dataset to a .txt file, with each entry separated by a single space [which is the default behavior for write.table()].
