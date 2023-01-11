# Introduction to R
# Edited by JM Barnby; Jan 2023

# Set working directory to where csv file is located
# setwd("C:/Econometrics/Data")

# # Read in with tidytuesdayR package
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!
#
install.packages(c('tidytuesdayR', 'tidyverse'))
library(tidytuesdayR)
library(tidyverse)

tuesdata <- tidytuesdayR::tt_load('2022-11-29')
tuesdata <- tidytuesdayR::tt_load(2022, week = 48)

worldcups  <- tuesdata$worldcups
wcmatches  <- tuesdata$wcmatches

# Or read in the data manually
wcmatches <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/wcmatches.csv')

worldcups <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/worldcups.csv')

mydata   <- wcmatches

# Read the data from local
mydata  <- read.csv('downloads/freedom.csv')

# List the variables
names(mydata)

# Show first lines of data
head(mydata)
mydata[1:10,]

# Access a variable
mydata$home_score

# Descriptive statistics
summary(mydata$home_score)
sd(mydata$home_score)
length(mydata$home_score)

# Frequency tables
table(mydata$home_score)
table(mydata$home_score, mydata$away_score)

# Correlation among variables
cor(mydata$home_score, mydata$away_score)
cor.test(mydata$home_score, mydata$away_score)

# T-test for mean of home vs away
t.test(mydata$home_score, mydata$away_score)

#### LETS DO THE ABOVE BUT WITH THE TIDY VERSE
#### For that we need to introduce this -> %>%
#### This is a pipe. It allows the chaining of functions:

mydata %>%
  filter(country == 'France') %>%
  dplyr::select(home_score) %>%
  na.omit() %>%
  summary()

# We can also use the native R operator to
# do the same thing -> |>

mydata |>
  select(home_score) |>
  summary()

# ANOVA for days of the week
newdata <- mydata %>%
  mutate(TotalGoals = home_score + away_score)

aov(TotalGoals ~ dayofweek, data = newdata)
aov1 <- aov(TotalGoals ~ dayofweek, data = newdata) %>%
  summary()

# OLS regression
newdata2 <- mydata %>%
  pivot_longer(home_score:away_score, names_to = 'Location', values_to = 'Score')

olsreg <- lm(
  Score ~ Location + dayofweek,
  newdata2
  )

summary(olsreg)
