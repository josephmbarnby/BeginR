
#rm(list=ls())

# Introduction ---------------------------------------------------------

# This is an R Script
# R is a programming language that has been widely adopted in science, technology, engineering, and buisiness

# It is an ESSENTIAL language to learn (also python) if you want to adopt open science practices, or
# even put yourself ahead for a career outside of science.

# It is a recipe for all of the interesting analyses and plot you will make
# It is totally shareable with anyone else who has 'R' so they can reproduce your work

# The best analogy for R is that it's a little like Lego - you add pieces together and bolt on sections
# to create a larger piece of work.

# Cheatsheet for shortcuts etc. ----------------------------------------- <- Pressing 'Command + Shift + R' will do this

# <- this mark will allow you to make a comment on a script

# Holding 'alt' will allow you to select text or numbers across lines

# Pressing 'Command + Return" or "Command + R" will allow you to run a line of code.

# Pressing 'Command + a" followed by 'Command + R/Return' will tell R to run the whole script.

# Libraries ---------------------------------------------------------------

library() # <- This is a function. It allows you to run a set of instructions on whatever you put inside the brackets ()
          # This particular function allows you to load something called a 'library'.

          # A library is a set of functions stored in a list. You can see these lists by checking their documentation
          # online, for example, go to this link "https://cran.r-project.org/web/packages/psych/psych.pdf"

          # Within this link you will see a package called 'Psych' - it is a list of function that allows you to perform
          # some interesting analyses, like t.tests, correlations, and principal component analysis.

          # The difference between this and SPSS is that you can see exactly what each function does, and 
          # allows others to quickly reproduce and build upon your analysis/plotting pipeline.

          # R also allows you to customise packages, and load unique packages, to do some custom and interesting
          # things with data that you can't do with SPSS.

install.packages("psych") # Here we're going to run this function called 'install packages' 
                          # It tells R that you want to search on the open repository for a package
                          # called 'psych' and install it.
                          # Press 'command + return' on this line to run it.

install.packages("readr")
install.packages("stats")

 ### ACTIVITY ### 

# Can you download a package called 'ggplot2' using the tools we've just discussed?"

 ###          ###

library(psych) # Next we're going to run this line of code to tell R to load the package we've just downloaded.
library(readr)
library(stats)

### ACTIVITY ### 

# Can you load the package called 'ggplot2' using the tools we've just discussed?

library(ggplot2)

###          ###

# Loading Data ------------------------------------------------------------

setwd('YOUR PATHNAME HERE') # This is a telling R to open a path in your computer to save all of our files,
                            # and also where to load data from, e.g. something like:
                            # '/Users/josephbarnby/Dropbox/'

# Now we're going to load some data 

### ACTIVITY ### 

# Can you set a pathname to a new folder you've just created on your desktop?

###          ###

# This line of code is telling R to go online and retrieve some data for us

astronauts <- read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-14/astronauts.csv')

#     This ^  (<-) is an operator telling R to save the whatever is on the right hand side into a new object on the left

# Of course, if you didn't want to load data online, you can load data from the directory you just set like this:

dummydata <- read.csv("MyDataHere.csv")

# Exploring data ----------------------------------------------------------

head(astronauts)    # This function will give you the first five rows of the dataframe
tail(astronauts)
str(astronauts)     # This function will tell you the object type of each dataframe
names(astronauts)   # This function will tell you the column names of the dataframe
summary(astronauts) # This function will tell you the mean and quartiles of each variable in your dataframe
describe(astronauts)# This function is the same as 'summary' but uses a different backend to tabulate it differently.

astronauts$military_civilian # The '$' symbol next to a dataframe will only retrieve the column you select for the dataframe
astronauts[9]     # You can also do this using the '[]' operator next to the data frame to select a column number
astronauts$hours_mission
astronauts[20]

# Cleaning data -----------------------------------------------------------

# We want to remove all those pesky NA values, missing rows, or rename some variables
# Let me breakdown what i'm doing here:
# 1. the 'which' function tells R that you only want to select a particular part of a dataframe
# 2. Within the 'which' function, i've called a function called 'is.na' which tells me if there 
# are any NA values in the object I place within the curly brackets.
# 3. Next to the 'is.na' function, i've added '!', which means I want only to select values that 
# _aren't_ NA values from the data frame.
# 4. Finally, i've added all of this inside the '[]' operator to tell R that I want to select a 
# specific subset of the dataframe.

astronauts_adjusted <- astronauts[which(!is.na(astronauts$number)),]

# This is telling R that I want to rename the first columns of my data to "ID" 

colnames(astronauts_adjusted)[1] <- "ID"
colnames(astronauts_adjusted)[1]

# This is telling R that I want to rename "M" to "male' within the 'sex' column

astronauts[which(astronauts$sex=='male'),]$sex          <- "M"
astronauts[which(astronauts$sex=='female'),]$sex        <- "F"
astronauts$sex

# Running a t.test --------------------------------------------------------

t.test(astronauts$year_of_birth, astronauts$hours_mission)

# Making a plot -----------------------------------------------------------

plot(astronauts$year_of_birth, astronauts$hours_mission) # This plot is a bit gross

# Try to make a new plot with the package 'ggplot2' you've just downloaded

ggplot(data = astronauts) + 
  geom_point(aes(year_of_birth, hours_mission, color = year_of_birth)) # remove these hashtags (lines 136 + 137) and replace it with
                                                                       # '+' to make the plot look really fancy :)
 
# Take the hashtags away from all the lines below this line too (lines 142-149) using the 'alt' shortcut (but keep the hashtag on this line)

  #geom_smooth(aes(year_of_birth, hours_mission), method = 'lm')+

  #xlab("Year of Birth")+
  #ylab("Hours On Mission")+
  #labs(title = "As astronauts were born later they were able to go on more missions",
  #     subtitle = "n = 1277")+
  #  
  #theme_bw()


