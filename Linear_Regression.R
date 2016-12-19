# install these packages 
install.packages("ggplot2")
install.packages("viridis")
install.packages("devtools")
install.packages("Hmisc")
install.packages("effects")
devtools::install_github("ropensci/plotly")
install.packages("car")
install.packages("texreg")


# set your working directory
getwd()
setwd("C:/Users/nellim/Dropbox/Fels") 

library(ggplot2)
library(viridis)
library(readstata13) # to read stata data file saved in version 13

# bring in the data 
acs <- read.dta13("C:/Users/nellim/Dropbox/Fels/acsphillylaborforce.dta")
names(acs)

###################
# Data management #
###################

# rename variables for better graphic and summary tables
acs$Race <- acs$raceth
acs$Sex <- acs$sex
acs$Education <- acs$educ_year
acs$Degree <- acs$education
acs$Occupation <- acs$gen_occ
acs$Industry <- acs$ind_cat5
acs$Income <- acs$incwage
acs$Managers <- acs$leader_cat
acs$Age <- as.numeric(acs$age)

# label your variable using Hmisc package
library(Hmisc)
label(acs$Income) <- "Income from wages"
label(acs$Education) <- "Years of schooling"
label(acs$Managers) <- "Managerial Positions"
label(acs$Occupation) <- "Major Occupational Categories"
label(acs$Industry) <- "Major Industrial Categories"

# drop observations with no income
library(dplyr)
acs <- filter(acs, Income > 0)


# Class Objectives: In this lesson you will learn how to: 
# 1. estimate OLS regression models
# 2. Use ggplot2 to make graphs from your data 

###########
# Outcome #
###########
#look at our outcome variable: income from wages
summary(acs$Income)

# select some explanatory variables 
myvars <- c("Sex", "Race", "Age", "Education", "Occupation", "Industry")
sapply(acs[myvars], summary)

####################
# comparing groups #
####################
# income difference between males and females

library(plyr)
mytable1 <- ddply(acs, c("Sex"), summarize, 
                  MeanIncome = mean(Income),
                           n = length(Income))
mytable1$diff <- mytable1$MeanIncome - mytable1$MeanIncome[1]
mytable1$diff_percent <- mytable1$diff/mytable1$MeanIncome[1]
mytable1

ggplot(mytable1, aes(x=Sex, y=MeanIncome)) +
  geom_bar(stat="identity", width=0.5)

# you can look at the density of the observations
ggplot(acs, aes(x=Income)) +  geom_density()
ggplot(acs, aes(x=Income, fill=sex)) +  geom_density(alpha=.3)

# change set up option
options(scipen = 100000)
ggplot(acs, aes(x=Income, fill=sex)) +  geom_density(alpha=.3)

ggplot(acs, aes(x=log(Income), fill=sex)) +  geom_density(alpha=.3)

# you can look at the diferences using boxplot 
ggplot(acs, aes(x=Sex, y=Income)) + geom_boxplot()+ 
  scale_y_continuous(breaks=seq(0, max(acs$Income), 40000))

# Regression is just a pivot table
fit <- lm(Income ~ Sex, data=acs)
summary(fit)
mytable1

fit <- lm(log(Income) ~ Sex, data=acs)
summary(fit)
mytable1

# Income differencs among racial and ethnic groups

mytable2 <- ddply(acs, c("Race"), summarize, 
                 MeanIncome = mean(Income),
                 n = length(Income))
mytable2$diff <- mytable2$MeanIncome - mytable2$MeanIncome[1]
mytable2$diff_percent <- mytable2$diff/mytable2$MeanIncome[1]
mytable2

ggplot(mytable2, aes(x=Race, y=MeanIncome)) +
       geom_bar(stat="identity")

ggplot(acs, aes(x=Income, fill=raceth)) +  geom_density(alpha=.3)

ggplot(acs, aes(x=Race, y=Income)) + geom_boxplot() + 
  scale_y_continuous(breaks=seq(0, max(acs$Income), 40000))

# Regression is just a pivot table
fit2 <- lm(Income ~ as.factor(Race), data=acs)
summary(fit2)
mytable2

fit2 <- lm(log(Income) ~ as.factor(Race), data=acs)
summary(fit2)
mytable2

############################################
# Association with a quantitative variable #
############################################
# Scatterplots 

ggplot(data = acs, aes(x = Education, y = Income)) + geom_point() +
  stat_smooth(method=lm)

ggplot(data = acs, aes(x = Education, y = Income)) + geom_point() +
  stat_smooth(method=loess)

# Listing 8.1 - Simple linear regression
fit <- lm(Income ~ Education, data=acs)
summary(fit)

plot(acs$Education,acs$Income,
     main="Education on Income", 
     xlab="Education (in years)", 
     ylab="Income (in $)")
# add the line of best fit
abline(fit)

# Listing 8.2 - Polynomial regression
acs$Education_sq <- acs$Education*acs$Education
fit2 <- lm(Income ~ Education + Education_sq, data=acs)
summary(fit2)
plot(acs$Education,acs$Income,
     main="Education on Income", 
     xlab="Education (in years)", 
     ylab="Income (in $)")
lines(acs$Education,fitted(fit2)) # something is wrong

xmin <- min(acs$Education)
xmax <- max(acs$Education)

predicted <- data.frame(Education=seq(xmin:xmax))
predicted$Education_sq <- predicted$Education^2

predicted$Income <- predict(fit2, predicted)

sp <- ggplot(acs, aes(x=Education, y=Income)) +
  geom_point()
sp + geom_line(data=predicted, size=1) +   stat_smooth(method=lm) 

acs$Education11 <- ( acs$Education - 11 )
acs$Education11[ acs$Education11<0 ] <- 0

acs$Education16 <- ( acs$Education - 16 )
acs$Education16[ acs$Education16<0 ] <- 0
fit3 <- lm(Income ~ Education + Education11 + Education16, data=acs)
summary(fit3)

xmin <- min(acs$Education)
xmax <- max(acs$Education)

predicted2 <- data.frame(Education=seq(xmin:xmax))
predicted2$Education11 <- ( predicted2$Education - 11 )
predicted2$Education11[ predicted2$Education11<0 ] <- 0

predicted2$Education16 <- ( predicted2$Education - 16 )
predicted2$Education16[ predicted2$Education16<0 ] <- 0

predicted2$Income <- predict(fit3, predicted2)

sp <- ggplot(acs, aes(x=Education, y=Income)) +
      geom_point()
sp + geom_line(data=predicted2, size=1)  +   stat_smooth(method=lm)    


# Listing 8.3 - Examining bivariate relationships
acsbivariate <- as.data.frame(acs[,c("Income", "Education", "age")])
cor(acsbivariate)
library(car)
scatterplotMatrix(acsbivariate, spread=FALSE, smoother.args=list(lty=2),
                  main="Scatter Plot Matrix")

# association between age and income
acs$Age_sq <- acs$Age*acs$Age
fit4 <- lm(Income ~ Age + Age_sq, data=acs)
summary(fit4)

# Listing 8.4 - Multiple linear regression
fit5 <- lm(Income ~ Education + Education11 + Education16 + 
             Age + Age_sq, data=acs)
summary(fit5)

###########################
# Putting it all together #
###########################

fit6 <- lm(Income ~ Sex + Race, data=acs)
summary(fit6)

fit7 <- lm(Income ~ Sex + Race + Education + Education11 + Education16 + 
             Age + Age_sq, data=acs)
summary(fit7)

fit8 <- lm(Income ~ Sex + Race + Education + Education11 + Education16 + 
             Age + Age_sq + Managers, data=acs)
summary(fit8)


######################
# checking the model #
######################
# save the predicted values
acs$predIncome <- predict(fit8, acs)

# looking at prediction errors
ggplot(data=acs,aes(x=Income,y=predIncome)) +
  geom_point(alpha=0.2,color="black") +
  geom_smooth(aes(x=predIncome, y=Income),color="black") +
  geom_line(aes(x=Income, y=Income),color="blue",linetype=2) +
  scale_x_continuous(limits=c(min(acs$Income),300000)) +
  scale_y_continuous(limits=c(min(acs$predIncome),max(acs$predIncome)))

ggplot(data=acs,aes(x=predIncome,
                      y=predIncome-Income)) +
  geom_point(alpha=0.2,color="black") +
  geom_smooth(aes(x=predIncome,
                  y=predIncome-Income),
              color="black")

# looking at the model fit
fit8
plot(fit8)

library("texreg")
screenreg(list(fit8,fit7,fit6,fit5))

