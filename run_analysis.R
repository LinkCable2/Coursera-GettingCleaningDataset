########## Getting and Cleaning Data Course Project ##########

#0.Downloading and Extract Data

    #url of the data
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

    #downloading and extracting data
    if (!file.exists("UCI HAR DATASET.zip")) {download.file(url, "UCI HAR DATASET.zip")}
    if (!file.exists("UCI HAR DATASET")) {unzip("UCI HAR DATASET.zip")}


#1.Merges the training and the test sets to create one data set.
    
    #reading files
    xtrain <- read.table("UCI HAR DATASET/train/X_train.txt")
    ytrain <- read.table("UCI HAR DATASET/train/Y_train.txt")
    subtrain <- read.table("UCI HAR DATASET/train/subject_train.txt")

    xtest <- read.table("UCI HAR DATASET/test/X_test.txt") 
    ytest <- read.table("UCI HAR DATASET/test/Y_test.txt") 
    subtest <- read.table("UCI HAR DATASET/test/subject_test.txt")

    features <- read.table("UCI HAR DATASET/features.txt")
    activitylabels <- read.table("UCI HAR DATASET/activity_labels.txt")
   

    #column names
    colnames(xtrain) <- features[,2]
    colnames(xtest) <- features[,2]
    colnames(ytrain) <- "activityId"
    colnames(ytest) <- "activityId"
    colnames(subtrain) <- "subjectId"
    colnames(subtest) <- "subjectId"
    colnames(activitylabels) <- c("Id", "activity")

    #merging datasets
    train <- cbind(ytrain, subtrain, xtrain)
    test <- cbind(ytest, subtest, xtest)
    data <- rbind(train, test)



#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
    meanstds <- grepl("mean|std|activityId|subjectId", colnames(data))
    data_meanstds <- data[, meanstds]



#3.Uses descriptive activity names to name the activities in the data set
    data_withactivitynames <- merge(x = data_meanstds, 
                                    y = activitylabels, 
                                    by.x = "activityId", 
                                    by.y = "Id")



#4.Appropriately labels the data set with descriptive variable names. 
    colnames <- gsub("\\(\\)", "", colnames(data_withactivitynames)) 
    colnames(data_withactivitynames) <- colnames



#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    tidydata <- aggregate(. ~subjectId + activity + activityId, data_withactivitynames, mean)
    tidydata <- tidydata[order(tidydata$subjectId, tidydata$activityId), ]
    write.table(tidydata, "tidydata.txt", row.names = F)

