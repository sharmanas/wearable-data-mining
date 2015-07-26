# wearable-data-mining

This repo explains how all of the scripts work to clean the accelerometer data obtained from Samsung Galaxy S smartphone and how they are connected.

## Introduction

The script run_analysis.R consists of individual functions, each accomplishing individual tasks, such as:

 1. Downloading the data from [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
 2. Merging test and training datasets
 3. Replacing activity values in the dataset with descriptive activity names
 4. Extracting only the measurements (features) on the mean and standard deviation for each measurement
 5. Appropriately labeling the columns with descriptive names
 6. Creating a second, independent tidy dataset with an average of each variable for each activity and each subject

Source the R file and run *cleanData* function to run the whole cleaning procedure. Refer CodeBook.md for description.
Note: This analysis requires prior installion of 'plyr' R-package.