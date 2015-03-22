# Tidied Data from the Human Activity Recognition Using Smartphones (UCI HAR) Dataset

To transform the initial dataset:
1. Test and Train datasets were merged and subject identifiers and activity labels were ingested, creating a single data set. 

2. Activity IDs were translated into meaningful text headings. The Mean and Standard-Deviation variables were retained and then summarized as mean for each subject/activity pair. The data are in "wide" format with each subject/activity pair as a single row, and each measurement as a single column.

3. The tidy output dataset is 'tidyMeans.txt' and can be read into R with 'read.table("tidyMeans.txt", header = TRUE)'. 

For details of variables see 'CodeBook.md'. The basic naming convention is:

  Mean{timeOrFreq}{measurement}{meanOrStd}{XYZ}

where 

'timeOrFreq' represents either Time or Frequency, i.e. if measurement was from the time or frequency domain

'measurement' is one of the original measurement features

'meanOrStd' is either Mean or StdDev, indicating whether the measurement was a mean or standard deviation variable

'XYZ' is one of X or Y or Z, indicating the axis along which the measurement was taken (or blank).
