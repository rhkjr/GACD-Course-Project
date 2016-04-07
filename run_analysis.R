# run_analysis.R
#
# This script loads data from the UCI HARD Dataset, processes it, and produces two out put files
#
# The source data comes from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# See CODEBOOK.txt for more details
#
# The processing steps are as follows:
#    1) Load data from the files
#    2) Merge the test and train data sets
#    3) Include only columns that have a mean() of std() statistic
#    4) Add the activity codes and subject ids from their respective files
#    5) Tidy the data: split the 66 key/value pair variables into their atomic parts
#    6) Change the activity codes to their text descriptions
#    7) Create a summary table that averages each measruement by activity and subject
#    8) Write the summary table to summaryDF.csv and the tidy table to tidyDF.csv
#


library(tidyr)
library(dplyr)

# 1) Load data from the files
testDF <- read.table("./UCI HAR Dataset/test/X_test.txt")            # read in the data files
trainDF <- read.table("./UCI HAR Dataset/train/X_train.txt")

testAct <- read.table("./UCI HAR Dataset/test/y_test.txt")           # read in the corresponding activity data files
trainAct <- read.table("./UCI HAR Dataset/train/y_train.txt")

testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")

actCodes <- read.table("./UCI HAR Dataset/activity_labels.txt")      # get the activity codes table
cNames <- read.table("./UCI HAR Dataset/features.txt",header=FALSE)  # read the file containing the column names


# 2) Merge the test and train data sets
totalDF <- bind_rows(testDF,trainDF)       
totalAct <- bind_rows(testAct,trainAct)
totalSub <- bind_rows(testSub,trainSub)


# 3) Include only columns that have a mean() of std() statistic
cIndex <- grep("mean\\(\\)|std\\(\\)",cNames[,2],value=FALSE)     # reduce to names with mean() or std() in title, return index
totalDF <- totalDF[,cIndex]           # reduce the data frame to include just the mean and std columns

names(totalDF) <- cNames[cIndex,2]      # set the data frame names to the values from the column names file


# 4) Add the activity codes and subject ids from their respective files
names(totalAct) <- "activitycode"       # name the totalAct column
names(actCodes) <- c("activitycode","activity")  # name the activity code table columns
names(totalSub) <- "subjectid"           # name the subject table column

totalDF <- bind_cols(totalSub,totalDF)      # add the subjectid column to the front of the DF
totalDF <- bind_cols(totalAct,totalDF)      # add the activity column to the front of the DF


#  5) Tidy the data: split the 66 key/value pair variables into their atomic parts
#   first, use gather to bust up columns as follows
#   fBodyGyro-std()-Y   ->   messyname, value 
tidyDF <- gather(totalDF,messyname,value,-activitycode, -subjectid)  #be sure to exclude activity in first column

#   Next, use separate to break messyname into 3 columns:
#    measuretype("fBodyGyro"),   stat("std"),   axis("Y")
tidyDF <- separate(tidyDF,messyname,c("measuretype","statistic","axis"))


#  6) Change the activity codes to their text descriptions
tidyDF <- merge(actCodes,tidyDF,by.x="activitycode",by.y="activitycode",all=TRUE)
tidyDF <- tidyDF[,-1]       # drop the first column (activity code)


#  7) Create a summary table that averages each measurement by activity and subject
summaryDF <- group_by(tidyDF, activity, subjectid, measuretype, statistic, axis)
summaryDF <- summarize(summaryDF,mean=mean(value))


#  8) Write the summary table to summaryDF.txt and tidyDF to tidyDF.txt
write.table(tidyDF,"tidyDF.txt", row.names=FALSE)
write.table(summaryDF,"summaryDF.txt", row.names=FALSE)




