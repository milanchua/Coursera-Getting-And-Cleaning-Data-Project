#download zip file
if(!file.exists("./data")){dir.create("./data")}
file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file,destfile="./data/Dataset.zip")

# unzip dataset
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#read dataset tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#colnames
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"


# Merges the training and the test sets to create one data set.
#merge
mergeTrain <- cbind(y_train, subject_train, x_train)
mergeTest <- cbind(y_test, subject_test, x_test)
mergeAll <- rbind(mergeTrain, mergeTest)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
#extract measurements
columns <- colnames(mergeAll)

mean_std <- (grepl("activityId" , columns) | 
                   grepl("subjectId" , columns) | 
                   grepl("mean.." , columns) | 
                   grepl("std.." , columns) 
)

setMeanAndStd <- mergeAll[ , mean_std == TRUE]

# Uses descriptive activity names to name the activities inthe data set
#descriptive variable names
setActivityNames <- merge(setMeanAndStd, activityLabels,
                              by.x='activityId', by.y = 'V1',
                              all.x=TRUE)

# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
tidyData <- aggregate(. ~subjectId + activityId, setActivityNames, mean)
tidyData <- tidyData[order(tidyData$subjectId, tidyData$activityId),]
  
write.table(tidyData, "Tidy Data Set.txt", row.name=FALSE)
