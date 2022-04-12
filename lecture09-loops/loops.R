###############
##  CLASS 5  ##
##  LOOPS    ##
###############

rm( list = ls() )

# Case 1) purest form of a for loop
for ( i in 1 : 5 ){
  print( i )
}

# Case 2) 
for ( i in seq( 50 , 58 ) ){
  print( i )
}

# Case 3) 
for ( i in c(10,9,-10,8) ){
  print( i )
}

# Play around with lists
for ( i in list( 2 , 'a' , TRUE , sqrt( 2 ) ) ){
  print( i )
}

# Create a loop which gives the cumulative sum:
v <- c( 10 , 6 , 5 , 32 , 45 , 23 )
cs_v <- v
for ( i in 2 : length( v ) ){
  cs_v[ i ] <- cs_v[ i - 1 ] + cs_v[ i ]
}
v
cs_v
cumsum( v )

# Also good to know
seq_along( v )

cs_v2 <- 0
for ( i in seq_along( v ) ){
  cs_v2 <- cs_v2 + v[ i ]
}
cs_v2

# Task check if all the elements in cs_v is the same as
# the cumsum( v ) function and if it is true
#  print out Good job! otherwise: there is a mistake!

if ( all( cs_v == cumsum( v ) ) ){
  print( "Good job!" )
} else {
  print( "There is a mistake!")
}

## Measure CPU time
# install.packages("devtools")
# library( devtools )
# devtools::install_github("jabiru/tictoc")
install.packages("tictoc")
library(tictoc)

iter_num <- 10000

# Sloppy way to do loops:
tic("Sloppy way")
q <- c()
for ( i in 1 : iter_num ){
  q <- c( q , i )
}
toc()

# Proper way
tic("Good way")
r <- double( length = iter_num )
for ( i in 1 : iter_num ){
  r[ i ] <- i
}
toc()

##
# While loop
x <- 0
while ( x < 10 ) {
  x <- x + 1
  print( x )
}
x

# Instead use a for loop with break
max_iter <- 10000
x <- 0
flag <- FALSE
for ( i in 1 : max_iter ){
  if ( x < 10 ){
    x <- x + 1 
  } else{
    flag <- TRUE
    break
  }
}
x
if ( flag ) {
  print("Successful iteration!")
}else{
  print("Did not satisfied stopping criterion!")
}




