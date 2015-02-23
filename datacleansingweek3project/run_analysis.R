
require("data.table")
require("reshape2")

#setwd('C:\\Coursera\\DataScience\\Modules\\GettingAndCleaningData\\week3\\project')

# declare all files pre-hand
root = "./UCI HAR Dataset/"
filePath1 = paste(root,'activity_labels.txt',sep='')
filePath2 = paste(root,'features.txt',sep='')


# retrieve reference data 
activityLabels <- read.table(filePath1)[,2]
features <- read.table(filePath2)[,2]

### Test Data ###

# retrieve test data files
filePath3 = paste(root,'test/subject_test.txt',sep='')
filePath4 = paste(root,'test/y_test.txt',sep='')
filePath5 = paste(root,'test/X_test.txt',sep='')
testSubjects <- read.table(filePath3)
names(testSubjects) = "SubjectID" # give it a better column name
testY <- read.table(filePath4)
testX <- read.table(filePath5)

# Load activity labels
testY$ActivityLabel = activityLabels[testY[,1]]
names(testY)[1] <- "ActivityID"

# add names to the X data frame (features)
names(testX) = features

# identify the features we are interested on (mean and standard deviation features for each observation)
requiredFeatures <- grepl("mean|std", features)
testX <- testX[,requiredFeatures]

# combine test data files
testData <- cbind(testSubjects, testY, testX)

### Train Data ###

# retrieve train data files
filePath6 = paste(root,'train/subject_train.txt',sep='')
filePath7 = paste(root,'train/y_train.txt',sep='')
filePath8 = paste(root,'train/X_train.txt',sep='')
trainSubjects <- read.table(filePath6)
names(trainSubjects) = "SubjectID" # give it a better column name
trainY <- read.table(filePath7)
trainX <- read.table(filePath8)

# Load activity labels
trainY$ActivityLabel = activityLabels[trainY[,1]]
names(trainY)[1] <- "ActivityID"

# add names to the X data frame (features)
names(trainX) = features

trainX <- trainX[,requiredFeatures]

# combine train data files
trainData <- cbind(trainSubjects, trainY, trainX)

# merge both data sets
mergedData = rbind(testData, trainData)

# remove factors - allow ordering by SubjectID and ActivityID
i <- sapply(mergedData, is.factor)
mergedData[i] <- lapply(mergedData[i], as.character)
mergedData$SubjectID <- as.numeric(mergedData$SubjectID)
mergedData$ActivityID <- as.numeric(mergedData$ActivityID)
library(dplyr)
orderedMergedData <- arrange(mergedData,SubjectID,ActivityID)

# convert to data table (prevent strings to be taken as factors)
options(stringsAsFactors=FALSE)
dt <- data.table(orderedMergedData)
dt$ActivityLabel = factor(dt$ActivityLabel)

# group by subjectid and activityid, apply mean to the remaining columns
tidyData <- dt[,lapply(.SD,mean),by='SubjectID,ActivityID,ActivityLabel']

# save to file
write.table(tidyData, file = "./tidyData.txt")

