##################################
#                                #
#          Lecture 03            #
#                                #
#    Introduction to tibble      #
#                                #
#     - Tibble as 'Data'         #
#         type of variable       #
#     - Indexing                 #
#     - Simple functions         #
#     - Reset values,            #
#         add rows and cols      #
#     - Wide vs long format      #
#     - Merging tibbles          #
#                                #
#                                #
##################################

# Clear environment
rm(list = ls())

# Package for today:
library(tidyverse)

#####
# a) Tibble as a 'Data' type of variable
#
# In tidyverse, data is stored in 'tibble':
#   this creates a special 'Data' variable:
#     it consists: rows    = observations
#                  columns = variables
#   there are certain rules of creating 'Data' type of variables!
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
# f) wide and long format
#
# We will use football data to practice the following manipulations
#   Note: there are some modification to the dataset for demonstartive purposes

rm( list = ls() )

# url for modified dataset
path_url <- "https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/lecture03-tibbles/data/"
# Football managers and played games
games  <- read_csv( paste0( path_url, "games.csv") )

##
# Wide format: from tidy to non-tidy format
#   in some rare cases it is useful to work with wide format:
wide_format <- pivot_wider( games , names_from = team , values_from = manager_games )


##
# Long-format:
#   however in most cases we work with tidy data, thus long-format:
#   note many dataset are in wide format, thus it is practical to know how to create a long-format
# To convert back to longer format:
# first we need a new variable, which contains the team names
name_teams  <- unique( games$team )
long_format <- pivot_longer( wide_format, name_teams , names_to = "team" , values_to = "manager_games")

##
# Task: 
#  Remove missing values, use is.na() function 
# and check with 'all_equal()' function if it is the same as games tibble


##
# Good-to-know: previously 'spread()' and 'gather()' functions were used
rm(wide_format,name_team,long_format)



####
# g) Merging two tibble
#
# Merging tibbles can be done in several way and there are many possible issues, 
#   thus it is a fairly complicated topic. 
# Here we only overview the main tools and the most common merging functions.
# For more see e.g.: Chapter 13 in Hadley's book: https://r4ds.had.co.nz/relational-data.html

# Get football managers and earned points via games
points <- read_csv(paste0( path_url, "points.csv") )


# Left-join by team, manager_id and manager_name:
#   games is the tibble which will get the new variables from points
#     if id variables are missing, it will be removed
lj <- left_join( games , points , by = c('team','manager_id','manager_name') )

# Right-join by team, manager_id and manager_name:
#   points is the tibble which will get the new variables from points
#     if id variables are missing, it will be removed
rj <- right_join( games , points , by = c('team','manager_id','manager_name') )

# Can check if they are the same or not
all_equal(lj,rj)
# Note: right_join and left_join is the same if you switch the first input in one of them

# Full-join will take all the possible observations and create an extend the tibble 
fj <- full_join( games , points , by = c('team','manager_id','manager_name') )

# Inner-join will take only values which are in both tibbles
ij <- inner_join( games , points , by = c('team','manager_id','manager_name') )


# Importance of the key-variables or identifiers:
# Case 1)
#   No unique identifier: create multiple new variables and observations
lj2 <- left_join( games , points , by = c('team') )
all_equal(lj,lj2)
# Case 2)
#   Unique identifier, but unmatched variable: create new variable
lj3 <- left_join( games , points , by = c('team','manager_id') )
all_equal(lj,lj3)

##
# Task:
#   try out 'semi_join()' and 'anti_join()' functions with proper identifiers
#   try out what happens if you change the order of input in both cases



##
# Good-to-know:
#   - in base R 'merge()' function is used for merging two data and the method must be defined in its input
#   - rbind() function is handy, if two datatable has the same variables (and ordering) 
#       and you want to add new rows (observations)
#   - cbind() is similar to rbind(), but now rows (or observations) are the same, but new variable(s) are added

