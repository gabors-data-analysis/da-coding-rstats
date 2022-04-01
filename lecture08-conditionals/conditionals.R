#####
## Conditionals

rm( list = ls() )

# Case 1)
x <- -5
if ( x > 0 ){
  print( "positive number")
} else if( x == 0 ){
  print( "zero value")
} else{
  print('negative number')
}

## Case 2 - multiple conditions
y <- 10
if ( x > 0 && y > 0 ){
  print("x and y are positive numbers")
} else{
  print("one of y or x is non-positive")
}

## Case 3 - conditionals with vectors
v <- c( 0 , 1 , 10 )
q <- c( 1 , 2 , 3 )
if ( all( v > 0 | q > 0 ) ){
  #print("one of v or q value-pairs is larger than 0")
} else{
  print("one of both of v or q value-pairs is not larger than 0")
}




