#after reading data, create data frame tbl 

#subject files
subjectTrain <- tbl_df(read.table(file.path(dataFile, "train", "subject_train.txt")))
subjectTest  <- tbl_df(read.table(file.path(dataFile, "test" , "subject_test.txt" )))

#activity files
activityTrain <- tbl_df(read.table(file.path(dataFile, "train", "Y_train.txt")))
activityTest  <- tbl_df(read.table(file.path(dataFile, "test" , "Y_test.txt" )))

#data files
dataTrain <- tbl_df(read.table(file.path(dataFile, "train", "X_train.txt" )))
dataTest  <- tbl_df(read.table(file.path(dataFile, "test" , "X_test.txt" )))




#1. Merge data sets and renaming variables


subjectAll <- rbind(subjectTrain, subjectTest)
setnames(subjectAll, "V1", "subject")

activityAll<- rbind(activityTrain, activityTest)
setnames(activityAll, "V1", "activityID")


dataAll <- rbind(dataTrain, dataTest)

# naming variables according to features
featuresData <- tbl_df(read.table(file.path(dataFile, "features.txt")))
setnames(featuresData, names(featuresData), c("featureID", "featureName"))
colnames(dataAll) <- featuresData$featureName

#for activity labels
activityLabels<- tbl_df(read.table(file.path(dataFile, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityID","activityName"))

# Merge columns
SubActAll<- cbind(subjectAll, activityAll)
dataAll <- cbind(SujActAll, dataAll)





#2. Extract measurements on mean and standard deviation

# extracting the mean and standard deviation from 'features'txt'

dataMeanStd <- grep("mean\\(\\)|std\\(\\)",featuresData$featureName,value=TRUE)

# measurements for the mean and standard deviation

dataMeanStd <- union(c("subject","activityID"), dataMeanStd)
dataAll<- subset(dataAll,select = dataMeanStd) 



#3. Descriptive activity names

#entering name of activity

dataAll <- merge(activityLabels, dataAll , by="activityID", all.x=TRUE)
dataAll$activityName <- as.character(dataAll$activityName)

# create dataAll with variable means

dataAll$activityName <- as.character(dataAll$activityName)
dataMean<- aggregate(. ~ subject - activityName, data = dataAll, mean) 
dataAll<- tbl_df(arrange(dataMean,subject,activityName)) #sorting



#4. Descriptive variable names

names(dataAll)<-gsub("std()", "SD", names(dataAll))
names(dataAll)<-gsub("mean()", "Mean", names(dataAll))
names(dataAll)<-gsub("^t", "time", names(dataAll))
names(dataAll)<-gsub("^f", "frequency", names(dataAll))
names(dataAll)<-gsub("Acc", "Accelerometer", names(dataAll))
names(dataAll)<-gsub("Gyro", "Gyroscope", names(dataAll))
names(dataAll)<-gsub("Mag", "Magnitude", names(dataAll))
names(dataAll)<-gsub("BodyBody", "Body", names(dataAll))



#5. Independdent, tidy data set with average of each activity and subject

write.table(dataAll, "TidyData.txt", row.name=FALSE)  #TidyData.txt will be saved in the working directory