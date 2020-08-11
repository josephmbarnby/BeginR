# INTRODUCTION TO TIDY DATA AND GGPLOT2 #

# This script is meant to work as an introduction to Tidy data and ggplot2 for data visualisation

# It assumes that you have some knowledge of R, such as loading data and viewing data.

# If you need an introduction to R, you might want to check out this first: https://github.com/josephmbarnby/BeginR/blob/master/RForBeginners.R

# In this exercise we will be using TidyTuesday data on European energy

#First, load and install tidy tuesday

install.packages('tidytuesdayR')
library(tidytuesdayR)

tuesdata <- tidytuesdayR::tt_load(2020, week = 32)

data <- tuesdata$energy_types #for this tutorial, we will use the first dataframe in the set

# Using DPLYR -------------------------------------------------------------

#DPLYR is a set of functions that allow the easy manipulation of a dataframe by passing
# it through a set of 'pipes' ..... 

# first, lets install and load the packages
install.packages('tidyverse')
library(tidyverse)

# it contains all you'll need for this tutorial

# next, lets learn about piping !

%>% # <- this is a pipe - you can stack functions after the pipe to process data.

  #check the example below to get a good idea of how this looks 
  
data %>% # <- first pipe to the pass the data through. 
  glimpse() # <- first function to apply. This particular one lets us look at the data structure

# you'll notice that you don't need to re-enter the dataframe name (in this case 'data')
# within the function we're passing it to. That's because DPLYR makes it so that all you need do
# is define the extra arguments you need to apply to the data

# we can just as easily use 'glimpse' on it's own without piping. See below:

glimpse(data) # it does the same thing as our piping. 

# While we can of course use functions seperately, if we want to use quite a few to clean our
# data, piping makes it easier to read and means that if you make a mistake you can go back
# and figure out in the pipe where things went wrong (which happens alot!)

#So, lets take our data, and pull together the last three columns so that they're in tidy format
# in this case, it'll mean applying the function 'gather' from the package 'tidyr' - check it out:

data %>%
    gather("Year", "Value", 5:7)  # now we can see the output in the console ->

# we have taken the last three columns and turned it into one 'year' column and
# one 'value' column for each. The rest of the data frame automatically rearranges
# itself to match the relationship between the new columns and the old columns.

#now, let save that to a new data frame
  
data_long <- data %>%
                gather("Year", "Value", 5:7)

# use '?dplyr' to explore more things you can do with your data!

# here is a useful cheat sheet for DPLYR https://github.com/rstudio/cheatsheets/blob/master/data-transformation.pdf

                            # exercise #

# Can you explore Dplyr to group by each country name and energy type,
# and create a new variable that adds the total value? Hint: this will use two functions in the pipe



# An anatomy of GGPLOT2 ---------------------------------------------------

# ggplot2 is a powerful package to visualise your data in unique and interesting ways

# here is an online tutorial to help introduce you to it's anatomy more fully, https://www.youtube.com/watch?v=h29g21z0a68
# or a static walkthrough (https://ggplot2.tidyverse.org/), 
# and hopefully give you some inspriation to try for yourself!

# in a nutshell ::

ggplot(data_long) + #this is where we put our data (the first level)
  
# a bit like piping, ggplot2 uses an addition sign '+' to indicate another level - 
# it's like sticking lego together
  
geom_bar(aes(x = type, y = Value, fill = Year), stat='identity', position = 'dodge') + # here we've added a 'geom'

# geoms are visual aesthetics to add layers to your plot. 
# you need to define which X and Y values you use within the 'aes()' brackets
# we've also added 'fill', which means that data will be coloured differently for each
# year in our data frame
  
# you can check out the list of different geoms by tying in 'geom_' to the line below and 
# looking at the list of geoms that pop up

stat_summary(aes(x = type, y = Value, fill = Year))+

# 'stat' is a little like geom, and infact calls 'geom' when it is run,
# but often is used to generate more mathematical functions on your data.
# In this case, we've asked it to calculate the mean count of each type of energy
  
coord_cartesian(ylim = c(0, 450000)) + # we use the 'coord' level to set our y axis limits
  #play around with the values in 'ylim = ()' to see what happens
  
  #coord functions can also do interesting things with the relationship between the X and Y axis.
  #for example, turn on the code below to flip the axes:
  
  #coord_flip()+

labs(x = 'Energy Type',
     y = 'Count',
     title = "Count of Each Energy Type") + # Here, we've defined our labels for each axis and title
  
facet_wrap(~ Year) + # we might also want to split our data up by another variable
  # here, we've split it up so that each year is in a seperate grid.
  # although, we might switch this off because the 'fill' function is already
  # depicting this for us. It also makes our x axis a little bunched up.
  # Switch off "facet_wrap()" with a '#'
  
theme_classic()

# finally we can add a 'theme' - this sets the clothing for our plot.
# check out different themes by typing in 'theme_' and seing what comes up to give the plot
# some different clothes.

# Your own data -----------------------------------------------------------

# try ggplot here wth some of your own data!
 
# here is a useful cheat sheet for GGPLOT2 https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf


