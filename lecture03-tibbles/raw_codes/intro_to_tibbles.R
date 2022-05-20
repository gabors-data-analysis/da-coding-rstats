##############################
##                           ##
##    INTRO TO TIBBLES:      ##
##                           ##
##  a) Tibble as 'Data' var  ##
##  b) Indexing              ##
##  c) Simple functions      ##
##  d) Reset values,         ##
##      add rows and cols    ##
##  f) Merging tibbles       ##
##                           ##
##                           ##
###############################

# Clear environment
rm(list = ls())

# Package for today:
library(tidyverse)

#####
# a) Tibble as a 'Data' variable
#
# In tidyverse, data is stored in 'tibble':
#   this creates a special 'Data' variable:
#     it consists: rows    = observations
#                  columns = variables
#   there are certain rules of creating 'Data' variables!
#     - talk about these principles -> what is the 'tidy approach'?
#     see more: Gabors' Data Analysis book, Chapter 2.

# When creating a tibble data, you have to specify the name of rows 
#   and supply the same number of observations for each variable

df <- tibble(id=c(1,2,3,4,5,6),
             age=c(25,30,33,NA,26,38),
             grade=c("A","A+","B","B-","B+","A"))

# Check the data
View(df)


# Outlook:
# Heritage in R: 'data_frame' and 'data.frame'

# data_frame is an older version of tibble. 
#   It can be used similarly, but newer functions and manipulations with tidyverse functions 
#   are not supported, thus may cause a problem later.
df_old1 <- data_frame(id=c(1,2,3,4,5,6),
                      age=c(25,30,33,NA,26,38),
                      grade=c("A","A+","B","B-","B+","A"))

# data.frame is the built-in Data variable in R. It seems also nice, 
#   but tidyverse functions and manipulations will not work with them.
df_old2 <- data.frame(id=c(1,2,3,4,5,6),
                      age=c(25,30,33,NA,26,38),
                      grade=c("A","A+","B","B-","B+","A"))

# remove unnecessary variables
rm( df_old1, df_old2 )

# Fun fact: due to this heritage in many cases data variables are 
#   named as 'df' standing for data_frame variable.

#####
# b) Indexing in general
#
# the following indexing methods works in general, 
#   but we will focus on tibble variables.
# These are really handy and enables you to grasp in coding in general.

###
# b1) Indexing with integer values:
# as we have seen previously one can select certain elements, by using integer values.

# If you want to get the first column as a tibble variable
df[ 1 ]
# Or [,1] stands for 1st column all observations:
df[ , 1 ]
# If you want the second ROW, similarly you can use the following indexing:
df[ 2 , ]
# If you want to have a specific cell (observation and variable)
df[ 2 , 1 ]
# You can select multiple rows for multiple variables:
df[ 1:3 , c( 1 , 3 ) ]

# Note that all these still result in a tibble variable
# if you want specific values: aka vectors in with one R-object type"
#   use double '[[ ]]'

# e.g. df[[1]] will give you the first column
df[[1]]
# however df[[,1]] will not work...
df[[ ,1]]
# You can specify the row element as well
df[[1,1]]

# Select multiple element - not work
df[[ 1:3 , 1 ]]


# Using tibbles, enables you to use variable (column) names 
#     instead of 'hard core indexing': df$var_name == df[[column index]]

# Instead of df[[1]], one can call: 
df$id

# Double indexing aka cells are easily accessible:
# Lets find age of 3rd observation:
df$age[ 3 ]

# Indexing is not limited to one value, but can call multiple values or vectors:
# With simple indexing
df$age[ 1 : 3 ]

###
# b2) Indexing with logicals
# until now, we have used integer values, that fit to the dimensions of our objects 
#   - thus indexes which are grater than the dimensions of our variable or negative integers were invalid.
# It turns out one can use a logical vector instead of integer indexing.
#   - it has the advantage, that we can filter out via logical expressions certain elements.

# E.g. we can get the age of the observation, which has the id value of 3
df$age[ df$id == 3 ]
# Note: 
df$id == 3
# df$id must consist the same number of logical values (TRUE or FALSE) as df$age.
# this was not a requirement with integer indexing. However with logical indexing
#   you do not need to know the exact place of your value.

# A certainly more cumbersome indexing with logicals:
#   get the grade values for students with age between 25 (ge) and 35 (l)
df$grade[ df$age >= 25 & df$age < 35 ]

##
# Tasks:
#
# 1) Find the id of the observation's which has missing value for age
# 2) Find ids which has A or A+ as grade
# 3) Find the ages of these observations
# Extra: use the `which()` function to find these values instead
#     which function is handy if you are interested in the index values itself, but using logicals




###########
# c) Simple Functions
#
# Usually we are interested in some characteristics of the data

# sum of age
df$age[ 1 ] + df$age[ 2 ] + df$age[ 3 ]

# Usually there is an existing functions for such manipulations
# there is an easy help built in R
?sum
# and one can use this function easily:
sum( df$age[ 1 : 3 ] )

# What happens if there is a NA in the data?
sum( df$age )
# One can get rid of the NA if add a further argument to the function:
sum( df$age , na.rm = TRUE )
# With logical indexing
sum( df$age[ !is.na( df$age ) ] )
# Not to confuse with the logical indexing itself!
sum( !is.na( df$age ) )

# And there are many other functions....
# calculate the mean
mean( df$age , na.rm = TRUE )
# Standard deviation of age
sd( df$age , na.rm = TRUE )

##
# Task:
#
# 1) Compute the conditional mean and standard deviation of age
#       for students with grade lower or equal than B+
#   - what are the issues that you have encountered?
#   - what are the potential solutions? Name at least two of them!



#########
# d) Reset values, add new columns or rows
#
# In some cases you want to re-set/re-define certain values, due to:
#   1) error in data
#   2) imputing data
#

##
# Reset values:
# Lets assume that one of the students, with id==1 told us that his age was wrongly documented.
# It is easy to correct this mistake, by:
df$age[ df$id == 1 ] <- 40

##
# Add columns
# Next let us add a new variable, the gender of the students to the tibble
gender <- c("F","F","M","M","M","F")
# There are two ways to do it:
# 1) The simplest is to define a new variable:
df$gender <- gender
# this is easy, but has the disadvantage of rewriting the `gender` variable if it is already defined 
#   without any warning.
# 2) `add_column()` function recommended by tidyverse, and it will result in error if there is any problem
# e.g. the following will result in an error, as it is already exists
add_column( df , gender = gender )
# but with 'new' you can add it to our tibble.
df <- add_column( df , gender_new = gender )

# to remove a variable, we will use the `select()` function with a negation. 
#   This can be seen as a quasy-logical operation:
df <- select( df , -gender_new )

# Later we will discuss `select()` function more in details.
# Alternatively a base-R command is to replace with an empty vector: `df$gender_new <- c()`

##
# Add rows
# To add a new observation or raw, you can use `add_row()` function from tidyverse:
df <- add_row( df, id = 7, age = 25, grade = 'C+', gender = 'M' )
df
# Note: if variable is not supplied as input, it will be NA. 
#   Furthermore you can specify where to add the row with `.before = ` input command.
#   Adding multiple rows is possible, but not recommended because it's a bit hard to read

# Removing rows can be done via indexing. E.g. removing the added observation with id==7:
df <- df[df$id != 7 , ]
# Note that here coma and empty space is crucial otherwise it does not work.
# Again in lecture04-data-munging we will discuss it more in detail.

#####
# f) Merging two tibble
#
# Merging tibbles can be done in several way and there are many possible issues, 
#   thus it is a fairly complicated topic. 
# Here we only overview the main tools and the most common merging functions.
# For more see e.g.: Chapter 13 in Hadley's book: https://r4ds.had.co.nz/relational-data.html

##
# 1st case: same variables, but different observations

# We have an additional tibble with new observations
df_2 <- tibble(id=c(10,11,12,13,14,15),
               age=c(16,40,52,24,28,26),
               grade=c("C","A","B-","C+","B+","A-"),
               gender=c("F","F","M","M","M","F"))
df_2

# We would like to add this new data table to our original data table:
df_new <- rbind( df , df_2 )

# Note: rbind() works only, if all the columns are the same and does not care about duplicates in the data.
# this is the simplest and mostly used command.

# Alternatively, tidyverse offer several alternatives, here what can be used is called `full_join()`
# with full_join() it is essential, to list all variable names for the input argument 'by', 
#   as it will check along all these dimensions and will give an error or put a new variable.
full_join( df , df_2 , by = c("id", "age", "grade","gender") )


##
# 2nd case: add new columns (information)
df_lj <- tibble( id = c(1,3,5,10,12),
                 height = c(165,200,187,175,170) )

# Here we use rather the tidyverse function `left_join()`, as it 
# only retains rows, that are in `df_new`, and add the new information (columns) from df_lj
# here the input argument `by=` is essential, as it will only join variables, 
#   that are available in `df_new$id`.

df_new2 <- left_join( df_new , df_lj , by = "id" )
df_new2

# Alternatively you can use `cbind()`, but here it is not preferred as you need to have:
#   all observations with the same ordering!
#
# Note: right_join() will do the same but you have to reorder the inputs:
# `left_join( df_new1, df_lj,  by = "id" ) == right_join( df_lj , df_new1 , by = "id" )`



##
# Tasks:
#
# 1) Add a new variable to df_new2, and call it `df_new3` which has a variable with name 
#     'year = 2002' and 
#     'month = 9'.
#     For all students the year is 2002 and the month is 9.
#       Use left_join.
#

df_new3 <-

#
# 2) Create a new datatable `df_new4`, which extends the tibble df_new3 in the following way:
#   It repeats all the values that are in df_new3 with the following exceptions:
#     - age is age + 10
#     - year is 2012
#   Hint: use `rbind()`

aux_table <- 

df_new4 <- rbind( df_new3 , aux_table )
df_new4

####
# Long vs wide format
#
# `df_new4` is called the 'long format' and we consider this as the tidy approach!
#  In some cases the data is in wide format, hence we need to convert to long format.
#  In order to simulate this, let us first create a wide format from this tibble!

# wide format: use `spread()` function
wide_df <- spread( df_new4 , key = year , value = age )
wide_df

# Converting a wide-format back to long-format: use `gather()` function
long_df <- gather( wide_df , `2002`,`2012` , key = year, value = age )
long_df

# This is same as df_new4, but with different variable ordering...


