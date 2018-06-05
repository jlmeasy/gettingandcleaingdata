##Getting and Cleaning Data

### After downloading the file, I did check the columns of X_test and X_train then compare it to the features column
### Load the datasets of activity and features
### Then I joined the activity labels with y_test and y_train so that I can display the description of activities in my tidy file
### Since the requirement is to get the mean and standard deviation columns, I extracted the columns position using grep
### Once done, I removed the extra characters in the columns that contains the mean and standard deviaton code
### I loaded the train and test data columns that has mean and standard deviation and combine the test subject, activities and the mean 
###   and standard deviation measures
### Then I row bind the test and train tables
### Melted and Dcasted the data and write it to a file named tidy