# Project of the course Getting and Cleaning Data

*The description of the script **run_analysis.R** is also available (with more details) in the comments inside the file itself*

* **Make sure you have the *dplyr* package installed. I will use function such as mutate inside the script.**
* **Download and unzip the data set.**
* **Make sure the folder "UCI HAR Dataset" is in your workspace.**

* I will first read all the data and also the data for the subjects and the activities in separate variables.
* I add the subjects and activities to the two datasets containing the test data and the train data.
* I re-arrange the columns to make the subjects as first column and activities as second column.

* I will read the features.txt files.
* I change the names of the merged data, remembering to add the two names "subject" and "y" to the first two columns.

* I read the activities names.
* I index the activities names with the second column of the merged data in order to have a vector of activities with labels instead of numbers.
* I change the second column of merged data with the vector created in the last step.

* I recollect the names of merged data and use gsub() function to change the names in order to have more intuitive names.
* I change the names of merged data.

* I will group_by the data by subjects.
* I will group_by the data in the last step by activities. It is possible to group by the two variables in one step, but i used two steps in order to show the "add=TRUE" option of the group_by() function.

* I use the summarise_each function to summarise all the columns using the mean function. This last step creates the "tidydata" dataset.

* Optionally you can decomment the last line of the script to write the tidy data in the "tidydata.txt" file.
