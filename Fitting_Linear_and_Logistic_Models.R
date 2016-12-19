# install these packages if you haven't already
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


# Class Objectives: In this lesson you will learn how to: 
# 1. checking model performance
# 2. regression models with interactions
# 3. non-linear regression models 


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

# linear spline 

acs$Education11 <- ( acs$Education - 11 )
acs$Education11[ acs$Education11<0 ] <- 0

acs$Education16 <- ( acs$Education - 16 )
acs$Education16[ acs$Education16<0 ] <- 0

# association between age and income
acs$Age_sq <- acs$Age*acs$Age

# drop observations with no income
library(dplyr)
acs <- filter(acs, Income > 0)


######################
# checking the model #
######################
fit8 <- lm(Income ~ Sex + Race + Education + Education11 + Education16 + 
             Age + Age_sq + Managers, data=acs)
summary(fit8)


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


#################################
# Regressions with interactions #
#################################

library(car)
# Listing 8.3 - Examining bivariate relationships
states <- as.data.frame(state.x77[,c("Murder", "Population", 
                                     "Illiteracy", "Income", "Frost")])
View(states)
cor(states)
scatterplotMatrix(states, spread=FALSE, smoother.args=list(lty=2),
                  main="Scatter Plot Matrix")


# Listing 8.4 - Multiple linear regression
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
summary(fit)


# Listing 8.5 - Mutiple linear regression with a significant interaction term
fit <- lm(mpg ~ hp + wt + hp:wt, data=mtcars)
summary(fit)

library(effects)
plot(effect("hp:wt", fit,, list(wt=c(2.2, 3.2, 4.2))), multiline=TRUE)



########################
# Gender gap in income #
########################
# main effect
fit <- lm(Income ~ Sex, data=acs)
summary(fit)

fit <- lm(log(Income) ~ Sex, data=acs)
summary(fit)

# interaction effect
fit2 <- lm(Income ~ Sex + Education + Sex:Education, data=acs)
summary(fit2)
library(effects)
plot(effect("Sex:Education", fit2,, list(Sex=c("Male", "Female"))), multiline=TRUE)

# interaction effect with nonlinear effect of education
fit3 <- lm(Income ~ Sex*poly(Education,2) + poly(Age,2), data=acs)
summary(fit3)
plot(effect("Sex*poly(Education,2)", fit3,, list(Sex=c("Male", "Female"))), multiline=TRUE)

########################
# Racial gap in income #
########################
acs.race <- filter(acs, Race=="W-NH" | Race=="B-NH")
# main effect
fit4 <- lm(Income ~ as.factor(Race), data=acs.race)
summary(fit4)

# interaction effect
fit5 <- lm(Income ~ Race + Education + Race:Education, data=acs.race)
summary(fit5)
plot(effect("Race:Education", fit5,, 
            list(Race=c("W-NH", "B-NH"))), 
            multiline=TRUE)

# interaction effect with nonlinear effect of education
fit6 <- lm(Income ~ Race*poly(Education,2) + poly(Age,2), data=acs.race)
summary(fit6)
plot(effect("Race*poly(Education,2)", fit6,, list(Sex=c("W-NH", "B-NH"))), multiline=TRUE)

########################
# Identifying outliers #
########################

# Listing 8.4 - Multiple linear regression
states <- as.data.frame(state.x77[,c("Murder", "Population", 
                                     "Illiteracy", "Income", "Frost")])
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
summary(fit)

library(car)
outlierTest(fit)

#  Identifying high leverage points
hat.plot <- function(fit) {
  p <- length(coefficients(fit))
  n <- length(fitted(fit))
  plot(hatvalues(fit), main="Index Plot of Hat Values")
  abline(h=c(2,3)*p/n, col="red", lty=2)
  identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}
hat.plot(fit)

# Identifying influential observations

# Cooks Distance D
# identify D values > 4/(n-k-1) 
cutoff <- 4/(nrow(states)-length(fit$coefficients)-2)
plot(fit, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")


################################
# outliers in Philly's schools #
################################
schools <- read.csv("Philly_schools.csv")
#View(schools)
schools$School_type <- as.factor(schools$SCHOOL_LEVEL_NAME)
schools$Name <- schools$SCHOOL_NAME_1
row.names(schools) <- schools$Name # attach school's name to observations

fit <- lm(Total_suspensions ~ Enrollment + School_type + Teacher_attendance +
            Gifted_education, data=schools)
summary(fit)

# Identifying influential observations

library(car)
outlierTest(fit)

#  Identifying high leverage points
hat.plot <- function(fit) {
  p <- length(coefficients(fit))
  n <- length(fitted(fit))
  plot(hatvalues(fit), main="Index Plot of Hat Values")
  abline(h=c(2,3)*p/n, col="red", lty=2)
  identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}
hat.plot(fit)

# Cooks Distance D
# identify D values > 4/(n-k-1) 
cutoff <- 4/(nrow(schools)-length(fit$coefficients)-2)
plot(fit, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")

# Influence Plot
library(car)
influencePlot(fit, id.method="identify", main="Influence Plot", 
              sub="Circle size is proportial to Cook's Distance" )


##########################
# Non-linear regressions #
##########################

## Logistic Regression

# get summary statistics
data(Affairs, package="AER")
summary(Affairs)
table(Affairs$affairs)

# create binary outcome variable
Affairs$ynaffair[Affairs$affairs > 0] <- 1
Affairs$ynaffair[Affairs$affairs == 0] <- 0
Affairs$ynaffair <- factor(Affairs$ynaffair, 
                           levels=c(0,1),
                           labels=c("No","Yes"))
table(Affairs$ynaffair)

# fit full model
fit.full <- glm(ynaffair ~ gender + age + yearsmarried + children + 
                  religiousness + education + occupation +rating,
                data=Affairs,family=binomial())
summary(fit.full)
# rating = numeric self-rating of their marriage (1=very unhappy to 5=very happy)

# fit reduced model
fit.reduced <- glm(ynaffair ~ age + yearsmarried + religiousness + 
                     rating, data=Affairs, family=binomial())
summary(fit.reduced)

# compare models
anova(fit.reduced, fit.full, test="Chisq")

# interpret coefficients
coef(fit.reduced)
exp(coef(fit.reduced))

# calculate probability of extramariatal affair by marital ratings
testdata <- data.frame(rating = c(1, 2, 3, 4, 5),
                       age = mean(Affairs$age),
                       yearsmarried = mean(Affairs$yearsmarried),
                       religiousness = mean(Affairs$religiousness))
testdata$prob <- predict(fit.reduced, newdata=testdata, type="response")
testdata

# calculate probabilites of extramariatal affair by age
testdata <- data.frame(rating = mean(Affairs$rating),
                       age = seq(17, 57, 10), 
                       yearsmarried = mean(Affairs$yearsmarried),
                       religiousness = mean(Affairs$religiousness))
testdata$prob <- predict(fit.reduced, newdata=testdata, type="response")
testdata


