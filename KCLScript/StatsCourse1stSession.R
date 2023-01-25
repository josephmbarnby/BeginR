rm(list=ls())

# pane layout 
# r script opening 
# This is an introductory stats course
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

install.packages('tidyverse') # this will install a bunch of functions that we will want to use 
install.packages('stats')

# loading libraries

library(tidyverse)
library(stats)

# creating data (explain what the '<-' mean)

healthy_controls1   <- rnorm(n = 8,  m = 2.55,sd = 1.93)
alzheimers_disease1 <- rnorm(n = 12, m = 0.5, sd = 0.53)

healthy_controls2   <- rnorm(n = 1000,  m = 2.55,sd = 1.93)
alzheimers_disease2 <- rnorm(n = 1000, m = 0.5, sd = 0.53)

# plotting

ggplot() +
  
  geom_density(aes(healthy_controls2))

# t.test with data

my_ttest2 <- t.test(x = healthy_controls2, 
                    y = alzheimers_disease2, 
                    paired = F)
my_ttest1
my_ttest2