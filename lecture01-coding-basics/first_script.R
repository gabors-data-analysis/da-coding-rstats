##################################
#                                #
#          Lecture 01            #
#                                #
#    Introduction to coding      #
#                                #
#     - R-objects                #
#     - Variables                #
#     - Built in functions       #
#     - Vectors                  #
#     - Indexing                 #
#     - Special values           #
#     - Lists                    #
#                                #
#                                #
##################################


##
# R-objects:

# Character
myString <- 'Hello world!'

# Convention to name your variables
my_fav_var <- 'bla'
myFavVar <- 'bla'
# Rarely use long names such as
my_favourite_variable <- 'bla'


# We can define numeric R-objects:
a <- 2
b <- 3

# And do mathematical operations:
a+b-(a*b)^a

c <- a + b
d <- a*c/b*c

# Or create logical R-object:
a == b
2 == 3
(a + 1) == b
# negation:
a != b

# other logical operators for multiple statement
2 == 2 & 3 == 2
2 == 2 | 3 == 2

##
# Functions:

# Remove variables from work space
rm(d)
# or calculate square root:
sqrt(4)
# if not sure what a function does:
?sqrt

##
# Type of R-objects:
typeof(myString)
typeof(a)

# Numeric values: integer and double
num_val  <- as.numeric(1.2)
doub_val <- as.double(1.2)
int_val  <- as.integer(1.2)
typeof(num_val)

# Decide what type a variable has:
is.character(myString)
is.logical(2==3)
is.double(doub_val)
is.integer(int_val)
is.numeric(doub_val)
is.numeric(int_val)
is.integer(doub_val)
is.double(int_val)

##
# Create vectors
v <- c(2,5,10)
# Operations with vectors
z <- c(3,4,7)

v+z
v*z
a+v

# Number of elements
num_v <- length(v)
num_v

# Create vector from vectors
w <- c(v,z)
w
length(w)
# R is case-sensitive: gives an error
length(W)

# Note: be careful w operation
q <- c(2,3)
v+q
v+c(2,3,2)

# Indexing with vectors: goes with []
v[1]
v[2:3]
v[c(1,3)]

# Fix the addition of v+q
v[1:2] + q 


## Special variables/values/issues:
null_vector <- c()
# NaN value
nan_vec <- c(NaN,1,2,3,4)
na_vec <- c(NA,1,2,3,4)
nan_vec + 3
# Inf values
inf_val <- Inf
5/0
# Rounding issues
sqrt(2)^2  == 2
# and fix it:
round(sqrt(2)^2) == 2


####
# Lists
my_list  <- list('a',2,0==1)
my_list2 <- list(c('a','b'),c(1,2,3),sqrt(2)^2==2)

# indexing with lists:
# you get the list's value - still a list (typeof(my_list2[1]))
my_list2[1]
# you get the vector's value - it is a character (typeof(my_list2[[1]]))
my_list2[[1]]
# you get the second element from the vector
my_list2[[1]][2]
