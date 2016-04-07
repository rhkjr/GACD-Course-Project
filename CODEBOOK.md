EXPERIMENTAL DESIGN AND BACKGROUND
==================================

The data were obtained from the following study:


Human Activity Recognition Using Smartphones Dataset
Version 1.0
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit� degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

From the original study documents:

*The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

This project seeks to process the test and train data sets from the study and produce two tidy data output files, described below.


RAW DATA
========

The raw data files and documentation were downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Details on the data can be found in the original study documentation in the zip download.

For this project, the following files were used:

|table|description|
|:---:|:---:|
|X\_test.txt|the test data|
|y\_test.txt|the activity codes for the test data|
|subject\_test.txt|list of subjects by id|
|X\_train.txt|the training data|
|y\_train.txt|the activity codes for the training data|
|subject\_train.txt|list of subjects by id|
|activity\_labels.txt| list of activity codes and their descriptions
|features.txt|the variable names for the test and training data|

Notes: 
------
 * Features are normalized and bounded within [-1,1].  
 * Units for gyroscopic measurements are radians/second.
 * Units for other measurements are in gravity units (g).
 * Data from the 128 column Inertial Signals sets were not used


License:
--------
From the original study:

*Use of this dataset in publications must be acknowledged by referencing the following publication:*

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012**

*This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.**

*Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.**


PROCESSED DATA
==============

The processed data comprises two output tables:  
 1. tidyDF  
 2. summaryDF  

These tables are created using the R script "run_analysis.R".  The script was run in Windows 8 using R version 3.2.3, and was executed multiple times to ensure the same output was produced.

It is assumed the data files are to be unzipped in the working directory.  The path to the data is therefore ".\UCI HAR Dataset"

The algorithm for the R script follows:

	1. Load data from the files  
	2. Merge the test and train data sets  
	3. Include only columns that have a mean() of std() statistic  
	4. Add the activity codes and subject ids from their respective files  
	5. Tidy the data: split the 66 key/value pair variables into their atomic parts  
	6. Change the activity codes to their text descriptions  
	7. Create a summary table that averages each measruement by activity and subject  
	8. Write the summary table to summaryDF.csv and the tidy table to tidyDF.csv  



tidyDF
-------

There are 561 variables included in the test and train test data.  The tidyDF table includes only the variables that have a mean or standard deviation statistic.

This reduces the variable count to 66, comprised of a mean standard deviation statistic for each of 33 feature variables.

Each of the 33 variables are a key/value pair.  Each key is comprised of three atomic parts: a measurement type, a statistic and, for those measurements with an XYZ component, an axis.

These key/value pairs were transformed into three atomic parts and a value.  

For example,  

|  tbodyAcc-mean()-X  |
|:--------------:|
| 0.234533310  |


becomes:  

|  measuretype  |  statistic   |  axis  |  value   |
|:--------------:|:--------------:|:-----------:|:--------:|
| "tbodyACC"| "mean"| "X"| 0.234533310|

  

The activity codes and subject ids were appended to the data set from their respective tables.  The activity codes were replaced by the activity descriptions provided.  For example, "1" becomes "WALKING".

The resulting tidyDF table has 6 variables and 679,734 observations:


|  column name  |  description   |  data type  |  range   |
|:--------------:|:--------------:|:-----------:|:--------:|
| activity| activity during sensor readings| character| "WALKING", "WALKING\_UPSTAIRS",  "WALKING_DOWNSTAIRS","SITTING",  "STANDING","LAYING"|
| subject id    | id of the study participant | integer | 1 - 30 |
|measuretype| type of sensor measurement|character|see y_test.txt for a full list of activity codes|
|statistic|the statistic measured|character|"mean" or "std"|
|axis|axial direction measured by sensor|character|"X","Y","Z", or NULL|
|value|the quantity of the measuretype.  Units are radians/sec for gyro measurements, gravitational units (g) for all others|numeric| bound to (-1.000000000,1.000000000)|




summaryDF
------------
The summaryDF uses the tidyDF table as input.

The data are grouped by activity, subjectid, measuretype, statistic and axis.  The mean for each group is computed.

NOTE: the instructions for grouping and summarizing can be interpreted several ways.  I interpreted "the average of each variable" to mean the three atomic parts of each variable should be distinct.  So the mean and standard deviation of a feature would be averaged separately.  As would the X,Y, and Z measurements.

The summary DF table contains 6 variables and 11,880 observations:

|  column name  |  description   |  data type  |  range   |
|:--------------:|:--------------:|:-----------:|:--------:|
| activity| activity during sensor readings| character| "WALKING", "WALKING\_UPSTAIRS",  "WALKING_DOWNSTAIRS","SITTING",  "STANDING","LAYING"|
| subject id    | id of the study participant | integer | 1 - 30 |
|measuretype| type of sensor measurement|character|see y_test.txt for a full list of activity codes|
|statistic|the statistic measured|character|"mean" or "std"|
|axis|axial direction measured by sensor|character|"X","Y","Z", or NULL|
|mean|the mean of each subgroup's quantity of the measuretype. Units are radians/sec for gyro measurements, gravitational units (g) for all others|numeric| bound to (-1.000000000,1.000000000)|
