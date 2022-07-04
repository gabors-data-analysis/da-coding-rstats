##################################
##                              ##
##          Lecture 08          ##
##                              ##
##  Conditional Programming     ##
##                              ##
##                              ##
##################################


# Simple if-statement
x <- 5
if (x == 5){
  print('x is equal to 5')
}

# Create an if-else statement
x2 <- 4
if (x2 == 5){
  print('x2 is equal to 5')
} else{
  print('x2 is not equal to 5')
}

# Multiple if-else statement!
# play around with the value of x
x <- -5
if (x > 0){
  print('positive number')
} else if(x == 0){
  print('zero value')
} else{
  print('negative number')
}


#####
# Multiple conditions

# Multiple logical statements
y <- 10
if (x > 0 && y > 0){
  print('x and y are positive numbers')
} else{
  print('one of y or x is non-positive')
}

###
# Conditional with one vector
v <- c(0 , 1 , 10)

# First, let check if elements of v larger than 0
v > 0

# any or all functions 
if (any(v > 0)){
  print('We have at least one element in v, which is larger than zero!')
} else {
  print('All elements in v, are smaller than zero!')
}


### 
# Conditional with two or more vector
q <- c(2 , 0 , 8)

# use of single-operators
v | q > 0
v & q > 0

# At this point we can check the differences between single-operators and double-operators

v | q > 0
v || q > 0

# Using double-operators will imply `any()` for `||` and `all()` for `&&`:
(v || q > 0) == any(v | q > 0)
(v && q > 0) == all(v & q > 0)

# be careful, when using these operators with vectors, 
# as the results can be different if mixing these up, e.g.
v && q > 0
any(v & q > 0)

#####
# Using conditionals when creating new variables

# Import wms-management data
library(tidyverse)
wms <- read_csv('https://osf.io/uzpce/download')

# Method 1: use base-R commands
wms$firm_size <- NA_character_
wms$firm_size[ wms$emp_firm >= 1000 ] = 'large'
wms$firm_size[ wms$emp_firm < 1000 & wms$emp_firm >= 200 ] = 'medium'
wms$firm_size[ wms$emp_firm < 200 ] = 'small'

# Method 2: ifelse function
wms <- wms %>% mutate(firm_size2 = ifelse(emp_firm >= 1000 , 'large',
                                    ifelse(wms$emp_firm < 1000 & wms$emp_firm >= 200 , 'medium',
                                    ifelse(wms$emp_firm < 200, 'small', NA_character_)))) 

# Task: check they are the same:
all(wms$firm_size == wms$firm_size2, na.rm = T)

######
# Extra material


# Spacing and formatting

if (x > 5){ print(' x > 5') } else { print('x <= 5') }
# However, it is not recommended as it makes reading the code much harder.


# The xor() operator
# xor, which takes two logical value/vectors as inputs. 
xor(c(T,F,F,T),c(T,T,F,F))


# `switch` statement
type <- 'apple'
switch(type,
       apple = 'I love apple!',
       banana = 'I love banana!',
       orange = 'I love orange!',
       error('type must be either \'apple\',\'banana\', or \'orange\'')
)

# try different inputs for types which are not in the listed values!
