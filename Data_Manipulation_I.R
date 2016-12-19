# Class Objectives:
# In this lesson you will learn how to:
#   1. Apply math to objects
#   2. Edit objects
#   3. Recode values and variable names
#   4. Change value's format type
#   5. Add new variables to objects
#   6. Order data by variables
#   7. Subset data
#   8. More exercises on sampling



getwd()
setwd("C:/Users/user/Desktop") # place your working directory into the folder which has youre
# data. I work with data that I put on the desktop so my directory
# is my desktop.

# The command read.csv allows you to read a .csv file into R and you can place the data into
# an object. 
alumni <- read.csv("Alumni_cleaned.csv")
View(alumni)

# Managing data, though it may seem simple and tedious, is among the most important parts of
# being able to analyze data. Think of programming like baking a cake. Managing the data is 
# getting all your ingredients ready to bake. Without every ingredient, you can't have your cake.
# When you manage your data (the ingredients), you are getting it ready to analyze (bake). 
# The final result (the cake) is only as good as the ingredients (cleaned data) that you have. 
# During this lesson you will learn how to begin cleaning, and looking at your data, for future
# analysis. 

###################

# In the last class, you learned how to find the mean of a string of numbers,
# let's find the mean of vector dates in your alumni dataframe.

# To specifiy a column of interest, use $
mean(alumni$Year)

# To add a new column to your data frame, just use $YourNewColumnName
alumni$newcolumn <- "hello!"


# Exercise: Create a new column that contains the product of adding ten years
# to every year in the year column

alumni$NewYear <- alumni$Year + 10


############
# Recoding values means making new values based on some condition of the old 
# value. For example if you have data on President Obama's public opinion poll 
# numbers, you can change the actual percentages of approval into categories. 
# You can change any number below 50% to say "Bad"and any number above 50% to
# say "good". The following example will show how to do this.

alumni$Year[alumni$Year < 1990] <- "This is an example"

# What the above code said is look at every row in the Year column, if the
# value is under 1990, change that value to the words in the quotations. 
# In more programming language, every value
# less than 1990 gets "This is an example"

# reload the alumni data because we played with variables
alumni <- read.csv("Alumni_cleaned.csv")

# You can use "logical operators" (see page 75 in your textbook) to recode
# some important logical operators follow
# <         Less than
# >         Greater Than
# <=        Less than or equal to
# >=        Greater than or equal to
# ==        Equal to
# !=        Not equal to
# x | y     Condition that meats either x or y condition

alumni$First <- as.character(alumni$First)
alumni$Location <- as.character(alumni$Location)                             
# This changes the format of this column to "character" which just means text. 
# We will get to this command soon.

##################
# Class exercise #
##################

# 1. Recode all years equal to 1990 to year 2000 in alumni data


# 2. Change the name in row 1 to your name, and the location in row 1, 
# to your home location.


# 3. Recode your name to the name "Harry Houdini"


################# New topic ###############
# You can use the names() function to see what the column names are called. You can also use this
# function to change the column names

names(alumni) # This says all column names in the object alumni
names(alumni)[1] # This says the name for the first column in the object alumni
names(alumni)[2:4] # This says the name for columns 2 to 4 in the object alumni

###################
# Class exercises #
###################

# 1. Change the first column to say "Name" in alumni data


# 2. Show the names of columns 1, 4, 5


################# New topic ###############
# R places values in many different formats (e.g. numeric, character, etc.). Sometimes you must
# change the format of the values to the one that you desire. For example, to do math you 
# must have numeric data. Changing formats is quite easy. See page 82 in your book for a full
# list of formats.

is.numeric(alumni$Year) # This asks whether the data in the column Year in the object alumni
# is numeric. It says "TRUE" which means that it is numeric
mean(alumni$Year)

is.character(alumni$Year) # This asks if the data is character. Character format means text

# The commands for changing format type is the same as testing them except they start with as.
# istead of is.

as.character(alumni$Year)
alumni$Year <- as.character(alumni$Year) # Remember that to save your changes you must tell R
# to do the command into your object

mean(alumni$Year) # Notice how when you changed the type to character you are unable to do math
# on the data.

alumni[order(alumni$Year)[1:10],]

# The order() function says to order the data. By default the order is ascending (smallest to 
# largest, or alphabetically). You can specify what you want to order by. The previous
# command said to order the first 10 items object alumni by the Year. This means that it
# rearranged the data in so it is chronoligical, earliest year first, most recent year last. 

alumni[order(alumni$Year, alumni$Name)[1:10],] # This orders it by both the year and the name.

###################
# Class exercises #
###################

# 1. Change all Year data to numeric format in alumni data


# 2. Make a new object that contains only the first 10 years, and then make them character format


# 3. Make a new object of the first 100 rows, ordered by year.


# 4. Reorder the data from question 3 to be in descending order (most recent year first)


################# New topic ###############
# The nrow() function tells you how many rows are in your object
nrow(alumni)

# You can create a new column in the object by saying that this new column gets your desired
# data

nrow(alumni)
alumni$count <- 1:nrow(alumni)
view(alumni)

##################
# Class Exercise #
##################

# 1. Explain in words what each line in the above code does. 


################# New topic ###############
# Oftentimes it is easier to create new objects containing only the data you are interested in,
# this is called subsetting - Making new objects from old objects. Think of the old object
# as your kitchen pantry. When you subset, you are taking only the ingredients you need
# and leaving the rest. 
# You have already been subsetting when you made the new ordered object
# Lets work with that subsetted object and subset it some more.

new_alumni$Date <- NULL # To "drop", or delete" a column say that the column gets NULL. Null
# will remove the column

new_alumni_2 <- data.frame(new_alumni$Name)
# Using data.frame() makes the new object into a data frame. Data frames contain columns and rows

variables <- c("Name", "Location")
new_alumni_2 <- alumni[variables]
# This says to make an object with the values "Name" and "Location" (remember, those are our
# column names). The next line says to make a new object with columns that match the values
# in the object variables

new_alumni_2 <- alumni[c(alumni$Name, alumni$Location),] # This does the same as the last command
# but is written out more

variables <- names(alumni) %in% c("Names", "Location")
new_alumni_2 <- alumni[!variables]

# The above code says to make an object, called variables, that looks if columns have names matching
# "Names" and Locations". The next line says to create a new object with all columns except
# those matching the names in "variables". Remember that the ! symbol means not in R. 
# != means not equal to

# You can use the subset() function to subset.

subset_alumni <- subset(alumni, Year < 1975 & Year > 1955,
                        select = c(Name, Location, Year))

subset_alumni <- subset(alumni, Year == 2000 | Year == 1975)

###################
# Class exercises #
###################

# 1. Explain in words what the first command does


# 2. Explain in words what the second command does


################# New topic ###############
# The function sample() lets you take samples from the data
?sample

sample(1:100, size = 5, replace = FALSE)
sample(1:100, size = 5, replace = FALSE)
sample(1:100, size = 5, replace = FALSE)
sample(1:100, size = 5, replace = FALSE)
sample(1:100, size = 5, replace = FALSE)

# sample() takes a random sample of the data and will produce a new result each time. It is 
# R's version of pulling names out of a hat.

sample(alumni$Name, size = 5, replace = TRUE)

presidents <- c("Washington", "Lincoln", "Clinton", "Eisenhower", "Reagan", "Bush", 
                "George W. Bush", "Obama", "Grant", "Kennedy", "Johnson")

sample(presidents, size = 10000, replace = TRUE)
table(sample(presidents, size = 10000, replace = TRUE))

###################
# Class exercises #
###################

# 1. Take a sample, without replacement, of presidents 5 times


# 2. Take a sample, with replacement, of presidents 10000 times


# 3. Summarize how many time each president was selected in question 2


# In this lesson you learned how to:
#   1. Apply math to objects
#   2. Edit objects
#   3. Recode values and variable names
#   4. Change value's format type
#   5. Add new variables to objects
#   6. Order data by variables
#   7. Subset data
#   8. More exercises on sampling
