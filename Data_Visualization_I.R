install.packages("ggplot2")
install.packages("plotly")
library(ggplot2)
library(plotly)

schools <- read.csv("Philly_schools.csv")

# Class Objectives: In this lesson you will learn how to: 1. Use ggplot2
# to make graphs from your data 2. Understand which graphs are best to use
# (this depends on the audience)

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
?ggplot

ggplot(data = schools, aes(x = Weapons)) + geom_bar()
# ggplot2 is the name of the package but ggplot2 is the function that
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


# ggplot allows you to add labels and titles quite easily
ggplot(data = schools, aes(x = Weapons, fill = SCHOOL_LEVEL_NAME)) + 
  geom_bar() + labs(title = "Philadephia School System Weapon Violations")

# To add titles and labels you use '+ lab()' within the ggplot command.
# title = 'example title' x = 'label for x-axis' y = 'label for y-axis'

# Class exercise: 
# 1. Make a barplot using the school data
# 2. Add a title
# 3. Add a x-axis label 
# 4. Add a y-axis label
# 5. Make your plot interactive using plotly



###### Scatterplots ######

# The next major kind of graph is a scatterplot. They look like dots on a
# graph and you can use them to see the relationship between two numerical
# groups. Because they require two numerican variables, we will use a new
# dataset. This dataset is the entire sex offender registry from Missouri.
# What we will be looking at is a relationship between the age of the
# victim and the age of the offender at the offense date.


ggplot(data = schools, aes(x = Average_salary, y = Weapons)) + geom_point()

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

# You can color the dots in by variables. Instead of barplots, where you
# used fill =, you use color =
ggplot(data = schools, aes(x = Average_salary, y = Weapons, color = 
                          SCHOOL_LEVEL_NAME)) + geom_point()

# If the dots are too small, you can adjust the size using "size = "
# inside the geom_point() parentheses.

ggplot(data = schools, aes(x = Average_salary, y = Weapons, color = 
                             SCHOOL_LEVEL_NAME)) + geom_point(size = 2.5)

# Be careful that you don't make the graph hard to read when resizing. 

# If you want to color everything the same, instead of a variable name,
# you need to move the color = into the geom_point() parentheses. If you
# want to color everything blue, write the word blue in quotes in the
# parentheses of geom_point() like so geom_point('blue')
ggplot(data = schools, aes(x = Weapons, y = Average_salary)) + 
       geom_point(color = "blue") 



# ggplot has many statistical tools. One example is geom_smooth which 
# creates a line of best fit in the data. 
# method = "lm" - means it uses a linear model
# se = FALSE - means it doesn't show the 95% confidence interval
# See what happens when you remvove "se = FALSE" from the command

ggplot(data = schools, aes(x = Average_salary, y = Weapons)) +  geom_point() +
  geom_smooth(method = "lm", se = FALSE)



# In this lesson you: 
# 1. Made barplots and scatterplots using ggplot() 
# 2. Began discussing which graphs are appropriate for the given audience 
