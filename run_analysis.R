library(dplyr)
#this script will perform analysis on training and test datasets by merging them into one

#################step1############################################################
#take the variable names from the features data and format them to remove special characters in names
features <- read.table("E:/datascience/getting_and_cleaning_data/UCI HAR Dataset/features.txt",skipNul = TRUE)
#features$V2 <- gsub("[-(),]","",features$V2)

#read the test data and assign the column names from features data
test <- read.table("E:/datascience/getting_and_cleaning_data/UCI HAR Dataset/test/X_test.txt",skipNul = TRUE)
names(test) <- features$V2

#read the training data and assign the column names from features data
train <- read.table("E:/datascience/getting_and_cleaning_data/UCI HAR Dataset/train/X_train.txt",skipNul = TRUE)
names(train) <- features$V2


#merge the train and test data to create a new dataset called activity
activity <- rbind(test,train)

###########################step3#################################################
#modifying names to remove the special characters using make.names

names(activity) <- make.names(names(activity),unique = TRUE)

###########################step2##################################################
#filtering measurements involving mean and standard deviation from dataset activity

meanM <- select(activity,contains("mean",ignore.case = TRUE))
stdM <- select(activity,contains("std",ignore.case = TRUE))
activity_meanstd <- cbind(meanM,stdM)

############################step4##################################################
#label the dataset with descriptive variable names
#getting the activity label data for training
train_label <- read.table("train/y_train.txt")
#getting the activity label data for test
test_label <- read.table("test/y_test.txt")
#getting subject label data for training
train_subject <- read.table("train/subject_train.txt")
#getting subject label data for test
test_subject <- read.table("test/subject_test.txt")
#combining both the labels
activity_label <- rbind(test_label,train_label)
subject_label <- rbind(test_subject,train_subject)
#merging the labels and adding it as columns  activity_code and subject_code to the dataset
activity_meanstd <- mutate(activity_meanstd,activity_code=activity_label$V1,subject_code=subject_label$V1)

############################step5###################################################

#grouping by activity and subject

df <- group_by(activity_meanstd,activity_code,subject_code)

#calculating the mean of variables based on each group
final_ds <- summarise_each(activity_meanstd,funs(mean))


