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

ggline(data_long, 
       x = "group", 
       y = "value", 
       add = c("mean_se", "jitter"), 
       color = "group",
       ylab = "Value", 
       xlab = "Group")

# anova and linear modelling (regression)

aov1 <- aov(value ~ group, data_long)

summary(aov1)

lm1  <- lm(value ~ group, data_long)

summary(lm1)

# put both together

ggplot(data_long) +
  
  geom_jitter(aes(group, value, color = group))+
  geom_boxplot(aes(group, value, fill = group), color = 'black')+
  
  ggpubr::stat_compare_means(aes(group, value, color = group), 
                             paired = F 
                              )
