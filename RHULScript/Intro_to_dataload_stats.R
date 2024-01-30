# Introduction to R
# Edited by JM Barnby; Jan 2024
# Copyright 2013 by Ani Katchova

# Set working directory to where csv file is located
# setwd("C:/Econometrics/Data")

# # Read in with tidytuesdayR package
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2023-06-06')
fuel_23  <- tuesdata$`owid-energy`

# Or read in the data manually
fuel_23 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-06-06/owid-energy.csv')

mydata  <- fuel_23

# Read the data from local
mydata  <- read.csv('downloads/fuel_23.csv')

# List the variables
names(mydata)

# Show first lines of data
head(mydata)
mydata[1:10,]

# Access a variable
mydata$gdp

# Descriptive statistics
summary(mydata$gdp)

length(mydata$gdp)
summary(mydata$fossil_fuel_consumption)
sd(na.omit(mydata$fossil_fuel_consumption))

# Frequency tables
table(mydata$gdp)
table(mydata$gdp, mydata$country)

# Correlation among variables
install.packages('tidyverse')
library(tidyverse)

mydata_filtered <- mydata %>%
  filter(
    # the next line asks to remove all NA values for fossil fuel consumption
    # AND (&) gdp. The returned data frame will be conditional on these two logical
    # statements
    !is.na(fossil_fuel_consumption) & !is.na(gdp),
    # This is asking that we only take the year 2010
    year == 2010
    # If we wanted multiple years we could switch on the line below
    # and turn off the line above
    # year %in% c(2009, 2010, 2011, 2012)
    )

#ask R to perform a simple correlation (this will not display the data)
cor(mydata_filtered$gdp, mydata_filtered$fossil_fuel_consumption)

#ask R to show you a plot of the two columns against eachother
plot(mydata_filtered$gdp, mydata_filtered$fossil_fuel_consumption)

# T-test for mean of one group
t.test(mydata_filtered$fossil_fuel_consumption)

# ANOVA for equality of means for two groups

#Our df doesn't have a categorical variables, so lets create some
#fake data (below) to practice

my_sim <- data.frame(
  #first lets create two groups with random data.
  #the funtion 'rnorm' asks R to sample 'n' times from a normal distribution with
  #a 'mean' of X and an 'sd' of Y.
  group1 = rnorm(n = 100, mean = 0, sd = 2),
  group2 = rnorm(n = 100, mean = 0, sd = 6)
  ) %>%
  #Because the anova function wants two arguments (one continuous and one categorical)
  #we need to make our dataframe 'long' rather than 'wide'. This is what the below line
  #is asking R to perform.

  #The first argument is which columns we want to use, the second it the name of the
  #first new created column, and the second is the name of the second column.
  pivot_longer(
    group1:group2, names_to = 'group', values_to = 'data'
  )

#run an anova
aov_1 <- aov(data ~ group, my_sim)

#see a summary of the results (including a p value)
summary(aov_1)

# OLS regression
olsreg <- lm(gdp ~ fossil_fuel_consumption + per_capita_electricity, data = mydata_filtered)
summary(olsreg)


