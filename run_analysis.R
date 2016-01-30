#Script able to create the tidy data set

#In order to run the script correctly, you need to:

#1 - have "dplyr" package installed
#2 - have downloaded and unzipped the data from the URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#3 - make sure the workspace where you are running this script contain the folder "UCI HAR Dataset"


library(dplyr)


#read data
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
sbjtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
sbjtest <- read.table("./UCI HAR Dataset/test/subject_test.txt")


#add subject and y variable to xtest and xtrain
sbjtestV1 <- sbjtest$V1
sbjtrainV1 <- sbjtrain$V1
ytestV1 <- ytest$V1
ytrainV1 <- ytrain$V1
xtest <- mutate(xtest, sbj=sbjtestV1, y=ytestV1)
xtrain <- mutate(xtrain, sbj=sbjtrainV1, y=ytrainV1)


#merge the data
mergeddata <- merge(xtest, xtrain, all=TRUE)
#re-arrange the columns in order to have the subjects and the activities as the first two columns
mergeddata <- mergeddata[,c(c(562,563),1:561)]


#select the columns with "mean" or "std" string
names_data <- read.table("./UCI HAR Dataset/features.txt")
names_data <- names_data$V2
names_data <- as.character(names_data)
#add the "sbj" and "y" names for the first two columns
names_data <- c(c("sbj","y"), names_data)
#change the names of mergeddata columns
colnames(mergeddata) <- names_data
#select columns with "mean" or "std" word
#remember to add the first two columns ("sbj" and "y") or they will be excluded by the selection
mergeddata <- mergeddata[,c(c(1,2),grep("(*[Mm]ean*)|(*[Ss]td*)", names_data))]


#change the activity names
activity_vector <- mergeddata$y
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- activity_labels$V2
activity_labels <- as.character(activity_labels)
#index the vector of labels with the vector of activities in numbers
activity_vector_with_labels <- activity_labels[activity_vector]
mergeddata <- mutate(mergeddata, y=activity_vector_with_labels)


#descriptive variable names
#make some changes to the names of the variables
new_names <- names(mergeddata)
new_names <- tolower(new_names)
new_names <- gsub("^sbj$","subject",new_names)
new_names <- gsub("^y$","activity",new_names)
new_names <- gsub("-",".",new_names)
new_names <- gsub("_",".",new_names)
new_names <- gsub(",",".",new_names)
new_names <- gsub(" ",".",new_names)
#fixed=TRUE make the gsub function does not confuse "()" with a regular expression
new_names <- gsub("()","",new_names, fixed=TRUE)
new_names <- gsub("fbody","frequency.body",new_names)
new_names <- gsub("tbody","time.body",new_names)
new_names <- gsub("tgravity","time.gravity",new_names)
new_names <- gsub("gyro",".gyroscope",new_names)
new_names <- gsub("acc",".accelerometer",new_names)
new_names <- gsub("bodybody","body",new_names)
#change a particular error that i saw in the variable name: "angle(tBodyAccJerkMean),gravityMean)"
#i will remove the first ")" (i use "sub" function instead of "gsub" in order to select only the first parenthesis)
new_names[83] <- sub(")","",new_names[83])
#change the names
colnames(mergeddata) <- new_names

#grouping by subject
by_subject <- group_by(mergeddata, subject)
#grouping by activity
#adding "add=TRUE" option in order to not override the "by subject" group
by_subject_and_activity <- group_by(by_subject, activity, add=TRUE)
#tidy data
tidydata <- summarise_each(by_subject_and_activity, "mean")


#optionally write the tidydata in a txt file
#write.table(tidydata, file="./tidydata.txt", row.names=FALSE)
