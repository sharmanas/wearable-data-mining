## This R script prepares tidy data to be used for further analysis from
## the recordings of 30 subjects performing activities of daily living (ADL)
## while carrying a waist-mounted smartphone with embedded inertial sensors.
## Full description available at:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

rm(list=ls())

library(plyr)

downloadData = function() {
    ## Check for data directory and create if not found
    if(!file.exists("./data")) {
        dir.create("./data")
    }
    ## Download data
    if(!file.exists("./data/UCI HAR Dataset")) {
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipfile <- "./data/UCI_HAR_data.zip"
        download.file(fileURL, destfile=zipfile)
        unzip(zipfile, exdir="./data")
    }
}

mergeData = function() {
    ## Read individual files from test and training folders
    x.test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
    y.test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
    subject.test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
    x.train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
    y.train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
    subject.train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
    ## Merge test and training sets
    merged.x <- rbind(x.test, x.train)
    merged.y <- rbind(y.test, y.train)
    merged.subject <- rbind(subject.test, subject.train)
    ## Create a list of items to be retrieved later
    list(x=merged.x, y=merged.y, subject=merged.subject)
}

extractFunction = function(df) {
    ## Read features list file
    features <- read.table("data/UCI HAR Dataset/features.txt")
    ## Find mean and standard deviation columns
    col.mean <- sapply(features[, 2], function(x) grepl("mean()", x, fixed=TRUE))
    col.std <- sapply(features[, 2], function(x) grepl("std()", x, fixed=TRUE))
    ## Extract columns containing either mean() or std() from the data frame
    edf <- df[, (col.mean | col.std)]
    colnames(edf) <- features[(col.mean | col.std), 2]
    edf
}

nameActivities = function(df) {
    ## Use descriptive activity names to name the activities in the dataset
    colnames(df) <- "activity"
    df$activity[df$activity==1] = "WALKING"
    df$activity[df$activity==2] = "WALKING_UPSTAIRS"
    df$activity[df$activity==3] = "WALKING_DOWNSTAIRS"
    df$activity[df$activity==4] = "SITTING"
    df$activity[df$activity==5] = "STANDING"
    df$activity[df$activity==6] = "LAYING"
    df
}

bindData = function(x, y, subjects) {
    ## Combine mean-std values (x), activities (y) and subjects into one data frame
    cbind(x, y, subjects)
}

tidy = function(df) {
    ## Given X, y and subject values, create an independent tidy data set
    ## with the average of each variable for each activity and each subject
    tidyData <- ddply(df, .(subject, activity), function(x) colMeans(x[, 1:60]))
    tidyData
}

cleanData = function() {
    ## Download data
    downloadData()
    ## Read individual files and merge test and training datasets
    merged <- mergeData()
    ## Extract only mean and standard deviation measurements
    mstd <- extractFunction(merged$x)
    ## Name activities
    act <- nameActivities(merged$y)
    ## Use descriptive column name for subjects
    colnames(merged$subject) <- "subject"
    ## Combine data frames into one
    combined <- bindData(mstd, act, merged$subject)
    ## Create tidy dataset
    tidyData <- tidy(combined)
    str(tidyData)
    ## Write tidy dataset to text file
    write.table(tidyData, "UCI_HAR_tidy.txt", row.names=FALSE)
}
