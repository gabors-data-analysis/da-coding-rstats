##########################
## INDEXING W TIBBLE    ##
##   AND MERGING        ##
##      CLASS 2         ##
##       CEU            ##
##########################

rm(list = ls())

# Create a data-frame
library(tidyverse)

# Create a simple data_frame
df <- data_frame(id=c(1,2,3,4,5,6),
                 age=c(25,30,33,NA,26,38),
                 grade=c("A","A+","B","B-","B+","A"))

# Note that data_frame is depriciated in tidyverse, 
# hence we will use tibble instead...
# (But I show you, because in many cases data_frame is still used!)
df <- tibble(id=c(1,2,3,4,5,6),
             age=c(25,30,33,NA,26,38),
             grade=c("A","A+","B","B-","B+","A"))

# Check the dataset
View(df)

#####
## Indexing in data-frame:
# If you want to have the first column:
df[ 1 ]
# Or [,1] stands for 1st column all values
df[ , 1 ]
# If you want the second row, similarly
df[ 2 , ]
# If you want to have a specific value cell:
df[ 2 , 1 ]
# Note that all these still give 'list' values, 
# if you want specific values:
#   use double [[]]
# e.g. df[[1]] will give you the first column
df[[1]]
# however df[[,1]] will not work...
df[[ ,1]]
# Specify the row element as well
df[[1,1]]
# Select multiple element - not work
df[[1:3,1]]

# Using tibbles (or data_frame), enables you to use variable (column) names 
#     instead of 'hard core indexing': df$var_name == df[[column index]]

# Instead of df[[1]], one can call: 
df$id

# Double indexing aka cells are easily accessible:
# Lets find age of 3rd observation:
df$age[ 3 ]
# Or one can use logical expressions as well to get certain values:
df$age[df$id==3]

# Indexing is not limited to one value, but can call multiple values or vectors:
# With simple indexing
df$age[ 1 : 3 ]
# Or with logicals: get the grade values for students with age between 25 (ge) and 35 (l)
df$grade[ df$age >= 25 & df$age < 35 ]

##
# Tasks:
#
# 1) Find the id of the observation's which has missing value for age
# 2) Find ids which has A or A+ as grade
# Extra: use the `which()` function to find these values instead
#     which function is handy if you are interested in the index values itself.
df$id[ is.na( df$age ) ]
df$id[ df$grade == 'A' | df$grade == 'A+' ]
# which function
?which
which( is.na( df$age ) )
which( !is.na( df$age ) )
df$id[ which( df$grade == 'A' | df$grade == 'A+' ) ]
df$age[ which( df$grade == 'A' | df$grade == 'A+' ) ]

####
# SIMPLE FUNCTIONS
#
# Usually we are interested in some characteristics of the dataset

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
logID <- df$grade == "B+" | df$grade == 'B' | df$grade == 'B-' | df$grade == 'C'
new_group <- df$age[ logID ]
mean( df$age[ logID ] , na.rm = TRUE )
sd( df$age[ logID ] , na.rm = TRUE ) 
# What happens if using NOT A or A+
logNID <- !(df$grade == "A" | df$grade == "A+")

#
df$age[ 1 ] <- 40

#####
## Merging two data tables
#

##
# 1st case: add new observations
# We have an additional dataset with new observations
df_fj <- tibble(id=c(10,11,12,13,14,15),
                age=c(16,40,52,24,28,26),
                grade=c("C","A","B-","C+","B+","A-"),
                gender=c("F","F","M","M","M","F"))
df_fj

# We would like to add this new data table to our original data table:
# full_join will retain all the information
df_new <- full_join( df , df_fj , by = c("id", "age", "grade") )
df_new
# note that gender is missing from the first dataset!

# In case you are adding new observations and there are no new columns you can use:
rbind( df , df_fj[ , 1 : 3 ] )

##
# 2nd case: add new columns (information)
df_lj <- tibble( id = c(1,3,5,10,12),
                 height = c(165,200,187,175,170) )

# left_join only retains information, which are available at df_new 
#   and add the new information in df_lj
df_new2 <- left_join( df_new , df_lj , by = "id" )
df_new2


##
# Tasks:
#
# 1) Add a new variable to df_new2, and call it `df_new3` which has a variable with name 'year'.
#     For all students the year is 2002. Use left_join (soon we will cover an easier way to add a simple variable).
#     Hint: check the `rep()` function. This will help you to avoid writing in '2002' 12 times!
#
df_new3 <- left_join( df_new2 , tibble( id = df_new2$id ,
                                        year = rep( 2002 , 12 ) 
                                        ) , 
                      by = "id" )
df_new3
#
# 2) Create a new datatable `df_new4`, which extends the datatable df_new3 in the following way:
#   It repeats all the values that are in df_new3 with the following exceptions:
#     - age is age + 10
#     - year is 2012
#   Hint: use `rbind()` and you can make a shortcut by using the specific variables such as `df_new3$id`, ect.

aux_table <- tibble( id = df_new3$id , 
                     age = df_new3$age + 10 ,
                     grade = df_new3$grade ,
                     height = df_new3$height,
                     year = df_new3$year + 10,
                     gender = df_new3$gender ) 

df_new4 <- rbind( df_new3 , aux_table )
df_new4


# `df_new4` is called the 'long format' and we consider this as the tidy approach!
#  In some cases the data is in wide format, hence we need to convert to long format.
#  In order to simulate this, let us first create a wide format from this datatable!

# wide format:
wide_df <- spread( df_new4 , key = year , value = age )
wide_df

# Converting a wide-format back to long-format:
long_df <- gather( wide_df , `2002`,`2012` , key = year, value = age )
long_df

# This is same as df_new4, but with different variable ordering...



##
# EXTRA:
#   Alternatively if you would like to retain only observations, which has a height value,
#   you shall use the right_join or can use left_join but change the orders of the datasets
right_join( df_new , df_lj , by = "id" )
left_join( df_lj , df_new , by = "id")
# Note the ordering of the columns changes.

##
# Additional information and practice:
# Chapter 9

