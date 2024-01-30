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
    !is.na(fossil_fuel_consumption) & !is.na(gdp),
    year == 2010
    )

cor(mydata_filtered$gdp, mydata_filtered$fossil_fuel_consumption)
plot(mydata_filtered$gdp, mydata_filtered$fossil_fuel_consumption)

# T-test for mean of one group
t.test(mydata_filtered$fossil_fuel_consumption)

# ANOVA for equality of means for two groups

#lets create some fake data (below)
my_sim <- data.frame(
  group1 = rnorm(100, mean = 0, sd = 2),
  group2 = rnorm(100, mean = 0, sd = 6)
  ) %>%
  pivot_longer(
    group1:group2, names_to = 'group', values_to = 'data'
  )

aov_1 <- aov(data ~ group, my_sim)
summary(aov_1)

# OLS regression
olsreg <- lm(gdp ~ fossil_fuel_consumption + per_capita_electricity, data = mydata_filtered)
summary(olsreg)


