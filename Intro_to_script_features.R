##------------------------------ R Introduction -------------------------------
## Edited by JM Barnby; Nov 2022
## Tatiana Lau, March 2020
## Heavily lifted from Patrick Mair's R intro

## RStudio is a simple R editor. There is no need to use it at all, but it makes our
## R life simpler.
## Important keyboard shortcuts (it is not cool to use the mouse!)
## Ctrl + Enter --> send command from the editor window to the R console
## Ctrl + 2: Move the cursor from the editor window to the R console
## Ctrl + 1: Move the curson from the R console to the editor window


##------------------------------- R as calculator, basic objects --------------------------------
6+3
4*3

x <- 5                  ## store value in a variable "<-" means "assign"
x
schnitzel <- 5          ## you can use any arbitrary name (typically you use one that makes sense)
schnitzel
Schnitzel               ## R is case sensitive!

y <- 6 + 3              ## store result in a variable (R object).
y
x <- 2 + 5              ## the x from above is now getting overwritten
x
x + y
z <- x + y
z


##-------------------------------- Simple R functions ---------------------------------

## The most important function is help()
## call: help(name of the function you need support), or ?()
## What if you don't know the name of the function? --> google (or google search on CRAN)

help(log)  ## help files in R have a standardized structure
?log       ## does the same thing.

log(x = 5)    ## note that the base argument is set to a default value (natural logarithm)
reslog <- log(x = 5)
reslog

log(x = 5, base = 10)          ## changing default of argument base
log(5, 10)                     ## no need to write base, if I keep the order of arguments
log(base = 10, x = 5)          ## if I don't keep the order, write argument name


##----------------------------- Objects in R ------------------------------------

##--- Vectors: ordered set of elements of the same type
## The basic function to create a vector is c()
?c
c(1, 2, 3, 4, 5)

vec1 <- c(3, 2, 7, 4, 6)                       ## create a vector using c
vec1
vec2 <- 1:10                                   ## vector sequence 1 to 10 (convenience operator ":")
vec2
vec5 <- c("a", "b", "c")                       ## vector of characters
vec5

vec1
vec1[4]            ## subsetting (extracting) elements in vector using square brackets
## more on that in the first Lab

##--- Matrices: 2-dimensional array of elements of the same type
?matrix
mat1 <- matrix(1:10, ncol = 2)                 ## elements column-wise
mat1
mat1 <- matrix(1:10, ncol = 2, byrow = TRUE)   ## elements row-wise
mat1
mat2 <- t(mat1)                                ## transpose
mat2

##--- Data Frame: Basic structure to represent datasets,
## similar to matrix, but different types of variables are possible

df1 <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")  ## letters a...j
df2 <- 1:10                                    ## numbers 1 to 10
df3 <- 10:1
df1
df2
df3

df11 <- data.frame(df2, df3)                   #concatenate as data frame
df11

df12 <- data.frame(df1, df2, df3)
df12


##--- List: ordered set of components that may have different types; most flexbile
## basic data structure
df1
df2
vec1
mat1

list(df1, df2, vec1, mat1)     ## shopping bag: list of letters, vectors, matrix
list1 <- list(let = df1, seq = df2, vec = vec1, mat = mat1) ## lets assign some names to the list objects
list1
names(list1)

list1$let
list1$seq
list1$vec
list1$mat

## save(meddat, file = "/home/patrick/meddat.rda")  ## save as R data file
## load(file = "/home/patrick/meddat.rda")          ## load R data file

## Final note: Since packages are updated constantly, make sure that
## you always have the latest version installed. Therefore, occasionally do

# Accesing vector data: 4 approaches --------------------------------------


# let's assign a vector to work with:
vec1 <- c(6,3,2,4,8)  ## remember the vector name is arbitrary!

## Approach 1: another (positive, integer) vector

index1 <- c(2,5)

vec1[index1]

subvec1 <- vec1[index1]

## Approach 2: a logical (boolean) vector

# logical vectors consist of two values: TRUE and FALSE (T and F)
index2 <- c(TRUE, FALSE, FALSE, TRUE)

# they can be created easily using (in)equalities
5 == 4

vec1

vec1 > 2

index2 <- vec1 < 3

# this allows us to select all elements of vec1 that are less than 3
vec1[index2]  ## Pull out all the values in vec1 that correspond to the TRUE values in index2

# or more directly
vec1[vec1 < 3]

# if a logical index is shorter than the lenght of the vector being indexed
# it will apply to the first N elements and then keep all subsequent
index2 <- c(TRUE, FALSE, FALSE, TRUE)

vec1

index2

vec1[index2]

# you can use the "which" command to turn a logical index into a postive
# integer index:
which(index2)  ##which variables in this index are true?


## Approach 3: negative integers

# negative numbers can also be used to subset, however they
# yield all items *except* those selected
index3 <- c(-1, -3:-5)

index3

vec1[index3]

# this can be used to "remove" elements from a vector (i.e. I don't want the 1st, 3rd, 4th, and 5th positions), but only by
# overwriting the original vector

vec1

vec1 <- vec1[index3]

vec1

vec1 <- c(6,3,2,4,8)


## Approach 4: character vectors
# character vectors consist of letters, words, numbers, etc. *in quotes*

?class # the class function tells you a variable's data type

class("e")

class("I can write anything I like here!")

class("1") # note that a number in quotes is a character vector,

class(1) # but a number without quotes is a numeric vector

# longer character vectors (like numerics) are created using c()
vec2 <- c("dogs","cats","birds","snakes","llamas")

# vectors of any class (numeric, logical, character, etc) can be named
# a named vector has a character string associated with each value

?names # the names function serves two purposes:

names(vec1) <- vec2 # assigning names to a vector (or other data type)

names(vec1) # or to see the names already assigned to a vector

names(vec2) # calling this for an unnamed vector yields nothing

# once a vector is named, the names can be used like positive integers to
# select particular elements

vec1[c("cats","llamas")]


# Accessing non-vector data -----------------------------------------------

# many of the approaches above also apply to other types of data
# (e.g. matrices, arrays and dataframes), however there are some exceptions


## matrices
# the main difference between matrix and vector indexing is that matrices
# require two indices because they are 2D, i.e. m[row,column]

mat1 <- matrix(seq(1,100,2),5,10) # create a 5x10 matrix

mat1[3,6] # extract the element in the 3rd row, 6th column

mat1[,2:3] # extract the entire 2nd and 3rd columns

mat1[c(1,5),] # extract the 1st and fifth rows

# index within an index:
# extract the row with a 4th column value of 27
mat1[mat1[,3]==27,] # this combines positive integer and logical indexing

# negative integers:
mat1[-2,-3] # matrix without 2nd row or 3th column


## arrays
# arrays are a less commonly used data type similar to matrix
# unlike matrices, arrays can have any number of dimensions
# this may make them convenient for 3D (e.g. fMRI) data
arr1 <- array(1:20,c(2,2,5))  ##this creates an array of 5 matrices of 2x2 with numbers from 1 to 20

arr1

# a 2D array *is* a matrix
class(array(c(6,7,8,6),c(2,2)))

# arrays can be accessed in all the same ways as matrices
# of course now multiple dimensions are required:
arr1[2,1,3]

## dataframes
# dataframes can be created from matrices
dat1 <- as.data.frame(mat1)  ##as.***** converts everything in one form into a different form

dat1 # note that rows and columns are automatically named

dat1["4",c("V3","V7")]

colnames(dat1)<-c("a","b","c","d","e","f","g","h","i","j")
rownames(dat1)<-c("sub1","sub2","sub3","sub4","sub5")
dat1 #but we can still rename them

# we can also use the '$' sign to select columns by name
dat1$a  ## $ symbol is for variables. in R, the variables of a dataframe are only in columns

# variables in dataframes have their own classes
class(dat1$number)

# factors are an important kind of dataframe variable
# all categorical variables (such conditions in an experiment) should be
# factor variables - if they are not, this can produce mislead results
# making a new factor is easy:
raw = c(0,1,1,0,0)
sex = factor(raw, labels = c("male","female"))
dat1 = cbind(dat1,sex)  ##add new columns
dat1
levels(dat1$sex)

## lists
# lists are very general type of data which can store other types
# the outputs of many functions are stored in lists
list1 = list(vec1,mat1,arr1,dat1)
list1

# lists can be named like other data types
names(list1)<-c("vec","mat","arr","dat")

# and accessed using those names with the '$' symbol
list1$vec

# lists can also store other lists!
list2 = list(list1,vec2)
list2

# using single bracket [] indexing on a list will yield a (sub)list
list1[1:2]
class(list1[1:2])

# using double bracket [[]] indexing will return an element
list1[[2]]
class(list1[[2]])
list1[[1:2]] # however this only works for single elements of the list

# exercise: provide the 3rd element in column "d" of dat in list1

# Changing data -----------------------------------------------------------

# indexing can be used to produce subsets of data as a new object
vec1
index1
vec3 <- vec1[index1]

# it can also be used to change the values in old objects
vec1[index1] <- 10
vec1

# objects can also be completely overwritten
vec3 <- vec1
vec3

# this works for other types of indexing too
dat1$a
dat1$a = 5
dat1$a

# appending happens automatically
vec3[6] <- 15
vec3

# with multiple elements too
vec3[7:10] <- c(24,16,8,6)
vec3

# if the index to be appended is not contiguous, NAs result
vec3[15] <- 100

# vectors can be combined easily through the c() function
c(c(1,2,3),c(4,5,6))

# but combining matrices or dataframes with c() yields vectors. c is ONLY for making vectors
matrix(4,2,2)
c(matrix(4,2,2),matrix(5,2,2))

# rbind() and cbind() combine matrices and dataframes by row and
# column respectively, but only if they have appropriate dimensions
rbind(matrix(4,2,2),matrix(5,2,2))

cbind(matrix(4,2,2),matrix(5,2,2))

cbind(matrix(4,2,2),matrix(5,3,3))

# most data types can be easily changed to other types
as.matrix(vec1)
as.data.frame(vec1)
as.matrix(dat1)
as.vector(mat1)

# and variable types can also be changed within dataframes
str(dat1)  ##tells you what type of variable is in each row
dat1$a <- as.factor(dat1$a)
str(dat1)

# don't convert factors to numeric directly
as.numeric(dat1$a)

# this synatx works better:
as.numeric(levels(dat1$a))[dat1$a]  ##takes the 5 in quotation marks and changes it to a 5, then changes dat1 back into that

# some other conversions are particularly sensible either
as.logical(vec1) # (all values other than 0 = TRUE)

# always check your data (e.g. using str) after manipulation!!!
