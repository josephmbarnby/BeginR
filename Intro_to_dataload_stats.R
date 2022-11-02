# Introduction to R
# Edited by JM Barnby; Nov 2022
# Copyright 2013 by Ani Katchova

# Set working directory to where csv file is located
# setwd("C:/Econometrics/Data")

# # Read in with tidytuesdayR package
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-02-22')
tuesdata <- tidytuesdayR::tt_load(2022, week = 8)

freedom  <- tuesdata$freedom

# Or read in the data manually
freedom <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-22/freedom.csv')

mydata  <- freedom

# Read the data from local
mydata  <- read.csv('downloads/freedom.csv')

# List the variables
names(mydata)

# Show first lines of data
head(mydata)
mydata[1:10,]

# Access a variable
mydata$CL

# Descriptive statistics
summary(mydata$CL)
sd(mydata$CL)
length(mydata$CL)
summary(mydata$PR)
sd(mydata$PR)

# Frequency tables
table(mydata$CL)
table (mydata$CL, mydata$PR)

# Correlation among variables
cor(mydata$CL, mydata$PR)

# T-test for mean of one group
t.test(mpg, mu=20)

# ANOVA for equality of means for two groups
anova(lm(mpg ~ factor(foreign)))

# OLS regression - mpg (dependent variable) and weight, length and foreign (independent variables)
olsreg <- lm(mpg ~ weight + length + foreign)
summary(olsreg)
# summary(lm(mpg ~ weight + length + foreign))
