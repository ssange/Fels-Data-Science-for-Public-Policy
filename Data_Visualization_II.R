# install these packages 
install.packages("ggplot2")
install.packages("viridis")
install.packages("devtools")
devtools::install_github("ropensci/plotly")

# set your working directory


library(ggplot2)
library(plotly)
library(viridis)

schools <- read.csv("Philly_schools.csv")
View(schools)

# Class Objectives: In this lesson you will learn how to: 
# 1. How to get descriptive statistics for quantitative variables
# 2. Use ggplot2 to make graphs from your data 
# 3. Understand which graphs are best to use (this depends on the audience)

# The summary() function is an effective way to get basic descriptive statistics
# from your data
summary(schools$Enrollment)
summary(schools$Assaults)
summary(schools$Total_suspensions)


# The sapply function can apply a function across multiple pieces of data
# In the following code it is applying the summary function for the columns
# "Enrollment", "Assaults" and "Total_suspensions" in the dataset schools
sapply(schools[c("Enrollment", "Assaults", "Total_suspensions")], summary)

# Class exercises
# 1. Use sapply to find the mean of multiple columns (Choose columns you think
#    are interesting)
sapply(schools[c("Gifted_education", "Teacher_attendance", "Drugs")], mean)

# 2. Use sapply to find the standard deviation of multiple columns
#    (Choose columns you think are interesting)
sapply(schools[c("Gifted_education", "Teacher_attendance", "Drugs")], sd)

# 3. Use sapply to find quantiles of multiple columns
#    (Choose columns you think are interesting)
sapply(schools[c("Gifted_education", "Teacher_attendance", "Drugs")], quantile)


# Sometimes it is easier to put all of your chosen columns into a separate 
# object and use that object in your index. This results in cleaner code. 
myvars <- c("Enrollment", "Assaults", "Total_suspensions")
sapply(schools[myvars], summary)

#to check myvars
myvars
is(myvars)

# The aggregate command breaks data into subsets and then applies a function
# on those subsets. In this example, it splits the columns Enrollment, Assaults
# and Total Suspensions (Remember we made myvars object to contain those
# values) and then it finds the mean of that data
#when i want to know specific information about a subset of the data
aggregate(schools[myvars], by=list(School=schools$SCHOOL_LEVEL_NAME), mean)

# The by command is similar to aggregate. It has a slightly different visual
# output
by(schools[myvars], schools$SCHOOL_LEVEL_NAME, summary)
#let's see if this works:
aggregate(schools[myvars], by=list(School=schools$SCHOOL_LEVEL_NAME), summary)
#it does, but the "by" command in line 67 looks nicer. 

# Graphics are essentially the bridge between you, the data analyst, and
# your audience. Good graphics allow the audience to easily understand the
# story you data is saying. Your job while making graphics is to determine
# what story you want to tell (depending on what the data says), and
# tailoring your graphs to those that your chosen audience can understand.
# Understanding your audience is key. You must make your graph complex
# enough to accurately depict your data, but also simple enough that your
# audience understands it.

# As this lesson progresses we will discuss the pros and cons of various
# graphs.

# The graphing package we will use is called ggplot2. It is a very popular
# graphing package on R and can produce a great many types of graphs.
#chapter 19, and the script for 19 for extra help.
?ggplot

ggplot(data = schools, aes(x = Weapons)) + geom_bar()
# ggplot2 is the name of the package but ggplot is the function that
# graphs. It's weird but that's how it is.  Let's break down this code
# into it's pieces This is essentially the base code for a ggplot bar
# graph. It says what dataset to use, which data within that to use, and
# what type of graph to make 'data =' is the part which says which data to
# use.  geom_bar() tells it to make a barplot. There are lots of different
# plots it can make and they all use the same format of 'geom_' and then
# the graph type.

# HINT: The plus sign cannot start a new line in ggplot
ggplot(data = schools, aes(x = Weapons))
+geom_bar()  # This will not work

ggplot(data = schools, aes(x = Weapons)) + geom_bar()  # This will work

# Class Exercise 
# 1. What are the benefits of using this particular graph?
#This bar graph

# 2. What are the problems of using this particular graph?  


# 3. How can we improve this graph?

ggplot(data = schools, aes(x = Weapons)) + geom_bar()
# The grey is quite boring and hard to easily understand, lets add
# some color. To do this on barplots you add 'fill =' to the aes section
# with the variable you want to color by following the = Let's simply
# color in by polviews now so it would look like 'fill = polviews'

ggplot(data = schools, aes(x = Weapons, fill = SCHOOL_LEVEL_NAME)) + geom_bar()


# Class exercise 
# 1. Find a variable (column) that you are interested in and make a barplot of
#    the data


# this is a ugly chart
ggplot(schools, aes(x=SCHOOL_LEVEL_NAME, y=Weapons)) + geom_boxplot()

# recode the values to clean up the labels 
is.character(schools$SCHOOL_LEVEL_NAME)
schools$SCHOOL_LEVEL_NAME <- as.character(schools$SCHOOL_LEVEL_NAME)
schools$school_type <- NA
schools$school_type[schools$SCHOOL_LEVEL_NAME == "ELEMENTARY SCHOOL"] <-
  "Elementary"
schools$school_type[schools$SCHOOL_LEVEL_NAME == "MIDDLE SCHOOL"] <- 
  "Middle"
schools$school_type[schools$SCHOOL_LEVEL_NAME == "HIGH SCHOOL"] <- 
  "High School"
schools$school_type[schools$SCHOOL_LEVEL_NAME == 
                      "CAREER AND TECHNICAL HIGH SCHL"] <- "Tech"
# check your work
table(schools$school_type)

# a prettier chart
ggplot(schools, aes(x=school_type, y=Weapons)) + geom_boxplot()

ggplot(schools, aes(x=school_type, y=Weapons)) + 
  geom_boxplot(fill="cornflowerblue")

ggplot(schools, aes(x=school_type, y=Weapons)) + 
  geom_boxplot(fill="cornflowerblue") +
  geom_point()


# Class exercise 
# 1. Find a variable (column) that you are interested in and a factor variable
# to make boxplot by categories of the factor variable


# ggplot allows you to add labels and titles quite easily
ggplot(schools, aes(x=school_type, y=Weapons)) + 
  geom_boxplot(fill="cornflowerblue") +
  geom_point() +
  labs(title = "Philadephia Schools Weapon Violations by School Type",
       x = "School Type", y = "# of Weapon Violations")

# you can look at the density of the observations
ggplot(schools, aes(x=Weapons, fill=school_type)) +  geom_density(alpha=.3)

ggplot(schools, aes(x=Weapons, fill=school_type)) +  geom_density(alpha=.3) +
  labs(title = "Philadephia Schools Weapon Violations by School Type",
       x = "School Type", y = "# of Weapon Violations")
#X AXIS SHOULD READ WEAPON, not school type


# To add titles and labels you use '+ lab()' within the ggplot command.
# title = 'example title' x = 'label for x-axis' y = 'label for y-axis'

# Class exercise: 
# 1. Make a graph using the school data
# 2. Add a title
# 3. Add a x-axis label 
# 4. Add a y-axis label
# 5. Explain why the type of graph you choose is the best type for your given
#    data and audience (chose an audience)



###### Scatterplots ######

# The next major kind of graph is a scatterplot. They look like dots on a
# graph and you can use them to see the relationship between two numerical
# groups. Because they require two numerican variables, we will use a new
# dataset. This dataset is the entire sex offender registry from Missouri.
# What we will be looking at is a relationship between the age of the
# victim and the age of the offender at the offense date.

names(schools)
ggplot(data = schools, aes(x = Enrollment, y = Weapons)) + geom_point()


# You can use plotly to make an interestive graph that shows the value of each
# point. The code is very similar to ggplot. The text part says what you want
# to display on each dot. In quotes is the word and following the comma is
# the column you want the value from.
# "<br>" is code that says make a line break so it is easier to read
# mode = "markers" makes it a scatterplot.
plot_ly(data = schools, x = Enrollment, y = Weapons,
        text = paste("School: ", SCHOOL_NAME_1,
                     "<br>",
                     "School Level:", SCHOOL_LEVEL_NAME),
        mode = "markers")
layout(hovermode = "closest")

# You can also color it by categories in one column
plot_ly(data = schools, x = Enrollment, y = Weapons, color = SCHOOL_LEVEL_NAME,
        text = paste("School: ", SCHOOL_NAME_1,
                     "<br>",
                     "School Level:", SCHOOL_LEVEL_NAME),
        mode = "markers")
layout(hovermode = "closest")


# The code is very similar to making a barplot, the difference is that
# scatterplots require an Y-axis variable in addition to the X-axis
# variable. Also instead of geom_bar it is geom_point. Much of the rest of
# the code will remain the same.

# Class Exercise 
# 1. Make a scatterplot comparing two variables (two columns)
# 2. Add a title 
# 3. Add a x-axis label 
# 3. Add a y-axis label 
# 4. What does this graph tell you? e.g. Is there a positive correlation 
#    between the two variables?
# 5. Make it interactive using plot_ly

# You can color the dots in by variables. Instead of barplots, where you
# used fill =, you use color =
ggplot(data = schools, aes(x = Enrollment, y = Weapons, color = 
                             school_type)) + geom_point()

# If the dots are too small, you can adjust the size using "size = "
# inside the geom_point() parentheses.

ggplot(data = schools, aes(x = Enrollment, y = Weapons, color = 
                             school_type)) + geom_point(size = 2.5)


# Be careful that you don't make the graph hard to read when resizing. 

# If you want to color everything the same, instead of a variable name,
# you need to move the color = into the geom_point() parentheses. If you
# want to color everything blue, write the word blue in quotes in the
# parentheses of geom_point() like so geom_point('blue')
ggplot(data = schools, aes(x = Enrollment, y = Weapons)) + 
  geom_point(color = "blue") 



# ggplot has many statistical tools. One example is geom_smooth which 
# creates a line of best fit in the data. 
# method = "lm" - means it uses a linear model
# se = FALSE - means it doesn't show the 95% confidence interval
# See what happens when you remvove "se = FALSE" from the command

ggplot(data = schools, aes(x = Enrollment, y = Weapons)) +  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

ggplot(data = schools, aes(x = Enrollment, y = Weapons)) +  geom_point() +
  geom_smooth(method = "lm")

# In this lesson you: 
# 1. Made barplots and scatterplots using ggplot() 
# 2. Began discussing which graphs are appropriate for the given audience 