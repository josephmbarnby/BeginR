rm(list=ls())

# Based on above paper: 
#   Brain tissue – why? 
#   Sample sizes: AD (n=12) and NCs (n=8) – why?  
#   What do tables mean? 
#   What do graphs / figures mean? (suggested questions / activities only) 
# Section 2.5.: “Statistical analysis: Differences were analyzed by the use of independent-samples t-test.” 
# Why independent?  Why a t-test? 
#   What are statistics? 
#   SPSS; and especially R. 

# installing libraries

install.packages('psych') # this will install a bunch of functions that we will want to use this session
install.packages("ggpubr") #visualisation tools

# loading libraries

library(tidyverse)
library(psych)
library(ggpubr)

# creating data (explain what the '<-' mean)

scz <- rnorm(n = 24, mean = 5.0, sd = 2)
bip <- rnorm(n = 23, mean = 4.5, sd = 1)
hcl <- rnorm(n = 23, mean = 5.0, sd = 1)
dep <- rnorm(n = 19, mean = 5.5, sd = 1)

data <- cbind(scz, bip, hcl, dep)
data <- as.data.frame(data)

data_long <- data %>% pivot_longer(1:4, names_to = "group", values_to = "value")

# plotting

plot(data)

ggboxplot(data_long, 
          x = "group", 
          y = "value", 
          color = "group", 
          ylab = "value", 
          xlab = "group")

# anova and linear modelling (regression)

aov1 <- aov(value ~ group, data_long)

summary(aov1)

lm1  <- lm(value ~ group, data_long)

summary(lm1)
