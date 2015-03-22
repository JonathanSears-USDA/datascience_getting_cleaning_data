XTrain <- XTest <- NULL
yTrain <- yTest <- NULL
runAnalysis <- function() {
  # Getting and extracting data [or manually donwload/extract to working dir]

    filePath <- function(...) { paste(..., sep = "/") }

  downloadData <- function() {
    url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    downloadDir <- "data"

    zipFile <- filePath(downloadDir, "dataset.zip")
    if(!file.exists(zipFile)) { download.file(url, zipFile, method = "auto") }

    dataDir <- "UCI HAR Dataset"
    if(!file.exists(dataDir)) { unzip(zipFile, exdir = ".") }

    dataDir
  }

  dataDir <- downloadData()

  # 1. Merges the training and the test sets to create one data set.

  readData <- function(path) {
    read.table(filePath(dataDir, path))
  }

  # Reading and cacheing XTrain and XTest data:
  if(is.null(XTrain)) { XTrain <<- readData("train/X_train.txt") }
if(is.null(XTest))  { XTest  <<- readData("test/X_test.txt") }
  merged <- rbind(XTrain, XTest)

  featureNames <- readData("features.txt")[, 2]
  names(merged) <- featureNames

  # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  # Limit to columns with feature names matching mean() or std():
  matches <- grep("(mean|std)\\(\\)", names(merged))
  limited <- merged[, matches]

  # 3. Uses descriptive activity names to name the activities in the data set
  # Getting activity data and mapping to new names:
  yTrain <- readData("train/y_train.txt")
  yTest  <- readData("test/y_test.txt")
  yMerged <- rbind(yTrain, yTest)[, 1]

  activityNames <-
    c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
activities <- activityNames[yMerged]

  # 4. Appropriately labels the data set with descriptive variable names. 
  # Changing t to Time, f to Frequency, mean() to Mean and std() to StdDev:
  names(limited) <- gsub("^t", "Time", names(limited))
  names(limited) <- gsub("^f", "Frequency", names(limited))
  names(limited) <- gsub("-mean\\(\\)", "Mean", names(limited))
  names(limited) <- gsub("-std\\(\\)", "StdDev", names(limited))
  # Removing naming errors from orig. feat. names (i.e. extra hyphens, BodyBody):
  names(limited) <- gsub("-", "", names(limited))
  names(limited) <- gsub("BodyBody", "Body", names(limited))

  # Adding activities and subjects with new names:
  subjectTrain <- readData("train/subject_train.txt")
  subjectTest  <- readData("test/subject_test.txt")
  subjects <- rbind(subjectTrain, subjectTest)[, 1]

  tidy <- cbind(Subject = subjects, Activity = activities, limited)

  # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(plyr)
  # Outputting col means for all cols except Subject and Activity:
  limitedColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
  tidyMeans <- ddply(tidy, .(Subject, Activity), limitedColMeans)
  names(tidyMeans)[-c(1,2)] <- paste0("Mean", names(tidyMeans)[-c(1,2)])

  # Writing file
  write.table(tidyMeans, "tidyMeans.txt", row.names = FALSE)

  # and returning data
  tidyMeans
}

# to check if tidyMeans.txt was formatted/readable ok
checkData <- function() {
  read.table("tidyMeans.txt", header = TRUE)
}


