rm(list=ls())

#  Based on above paper: 
#  Brain tissue – why? 
#  Sample sizes:– why?  
#  What do the graphs mean? 
#  Why anovas? 
#  Is there a difference between a regression and an anova?

# installing libraries

install.packages('psych') # this will install a bunch of functions that we will want to use this session
install.packages("ggpubr") #visualisation tools

# loading libraries

library(tidyverse)
library(psych)
library(ggpubr)

# creating data (explain what the '<-' mean)

scz <- rnorm(n = 24, mean = 5.0, sd = 2) # schizophrenia
bip <- rnorm(n = 23, mean = 4.5, sd = 1) # bipolar
hcl <- rnorm(n = 23, mean = 5.0, sd = 1) # healthy control
dep <- rnorm(n = 19, mean = 5.5, sd = 1) # depression

data <- cbind(scz, bip, hcl, dep)
data <- as.data.frame(data)

data_long <- data %>% pivot_longer(1:4, names_to = "group", values_to = "value") 

# Plotting ----------------------------------------------------------------

# general plot of data spread
plot(data)

#box plot of data by group
ggplot(data_long) +  # you put the data frame you want to work on within the brackets in the first line here
  
  geom_boxplot(aes(group, value, fill = group), color = 'black') # this line is adding the box plots

# data distribution and mean +- SE of data
ggplot(data_long) + 
  
  geom_jitter(aes(group, value, color = group))+ # this line is adding the data points 
  stat_summary(aes(group, value), color = 'black') # this line is adding the mean and SD

# ANOVA and Linear Models -------------------------------------------------

aov1 <- aov(value ~ group, data_long) # this runs an anova

summary(aov1) #the summary function allows you to check your models results

lm1  <- lm(value ~ group, data_long) # this runs a linear model

summary(lm1)

# EXTRA # only include if there is time/ you want to
install.packages("broom")
broom::tidy(aov1) # this package is a tidy way to view your model results

# Add it both together ----------------------------------------------------

ggplot(data_long) +
  
  geom_jitter(aes(group, value, color = group))+
  geom_boxplot(aes(group, value, fill = group), color = 'black')+
  
  ggpubr::stat_compare_means(aes(group, value, color = group), 
                             paired = F 
                              )
