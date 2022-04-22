#####################
##  Random numbers ##
##    and          ##
##  Functions      ##
#####################

# Clear memory and load packages
rm(list=ls())
library(tidyverse)

#######
# Random numbers
#   Random numbers are often used in data science:
#     - get a random (sub)-sample
#     - bootstrapping
#     - other 'stochastic' optimization or 
#     - in some estimation (typically with ML)
#

# Keys for random numbers:
#   1) Theoretical distribution - from what kind of distribution should it sample
#       a) Actually it is a hard problem computationally 
#           -> methods implemented are pretty good, but not perfect (pseudo random methods)
#   2) Reproducible
#       a) If you estimate something which uses random numbers you should allow for the 'key'
#       b) In some cases this does not matter, the result 'averages out'
#

# 1) case uniform distribution random sampling
n <- 10
x <- runif( n , min = 0 , max = 10 )
x

# 2) Set the seed for the computer for rng
set.seed(123)
x <- runif( n , min = 0 , max = 10 )

rm( x , n )


# Play around with no
n <- 10000
y <- rnorm( n , mean = 1 , sd = 2 )
df <- tibble( var1 = y )
ggplot( df , aes( x = var1 ) ) +
  geom_histogram( aes( y = ..density.. ) , fill = 'navyblue') +
  stat_function( fun = dnorm , args = list( mean = 1 , sd = 2 ) ,
                 color = 'red' , size = 1.5 )

# There are some other type of distributions:
#   rbinom, rexp ,rlnorm, etc.

# Random sampling from a dataset/variable:
# Sample_1 is without replacement
sample_1 <- sample( y , 1000 , replace = FALSE )
# Sample_2 with replacement -> useful for bootstrapping
sample_2 <- sample( y , 1000 , replace = TRUE )


################
## FUNCTIONS ###
######

# 1) simplest case - calculate the mean
my_fun <- function( x ){
  sum_x <- sum( x )
  sum_x / length( x )
}
# Use this function
my_fun( y )
# You can save the output of the function
mean_y <- my_fun( y )

# 2) Calculate mean and standard deviation with checking inputs
my_fun2 <- function( x ){
  stopifnot( is.numeric( x ) )
  sum_x <- sum( x )
  sum_x / length( x )
  sd_x <- sd( x )
}
# Check the output
what_y <- my_fun2( y )
what_y

# 3) Control for output
my_fun3 <- function( x ){
  sum_x <- sum( x )
  mean_x <- sum_x / length( x )
  sd_x <- sd( x )
  return( mean_x )
}
# Check the output
my_fun3( y )

# 4) Multiple output
my_fun4 <- function( x ){
  sum_x <- sum( x )
  mean_x <- sum_x / length( x )
  sd_x <- sd( x )
  out <- list( "sum" = sum_x , "mean" = mean_x , "sd" = sd_x )
  return( out )
}
# Check the output
out4 <- my_fun4( y )
out4$sum

# 5) Multiple input
my_CI_fun <- function( x , CI = 0.95 ){
  # mean of x
  mean_x <- mean( x , na.rm = TRUE ) 
  # standard deviation
  sd_x <- sd( x , na.rm = TRUE )
  # number of observations in x
  n_x <- sum( !is.na( x ) )
  # Calculate the theoretical SE for mean of x
  se_mean_x <- sd_x / sqrt( n_x )
  # Calculate the CI
  if ( CI == 0.95 ){
    CI_mean <- c( mean_x - 2*se_mean_x , mean_x + 2*se_mean_x )
  } else if ( CI == 0.99 ){
    CI_mean <- c( mean_x - 2.6*se_mean_x , mean_x + 2.6*se_mean_x )
  } else {
    stop("No such CI implemented, use 0.95 or 0.99")
  }
  out <- list("mean"=mean_x,"CI_mean" = CI_mean )
  return( out )
}
# Get some CI values
my_CI_fun( y , CI = 0.95 )
my_CI_fun( y )
my_CI_fun( y , CI = 0.99 )
my_CI_fun( y , CI = 0.98 )

##########
# Sampling distribution
set.seed(100)
X <- runif( 10000 , min = 0 , max = 2 )
#
# Write a function which creates the sampling distributions for:
# - for the mean ( mu )
# - 1st t-statistics where H0: mu = 1 (( mu - 1 )/SE(mu))
# - 2nd t-statistics where H0: mu = 0 ( mu /SE(mu))
#
# In the function you should add inputs as:
#   x - vector
#   rep_num <- how many time it should sample
#   sample_size <- how many obs to sample from x
#
# Notes: use sample(), use tibble as output, use for cycle
#     initialize vectors for the cycle 

get_sampling_dists <- function( x , rep_num = 1000 , sample_size = 1000 ){
  # Check inputs
  stopifnot( is.numeric( x ) )
  stopifnot( is.numeric( rep_num ) , length( rep_num ) == 1 , rep_num > 0 )
  stopifnot( is.numeric( sample_size ) , length( sample_size ) == 1 ,
             sample_size > 0 , sample_size <= length( x ) )
  # initialize the for loop
  set.seed(100)
  mean_stat <- double(rep_num)
  t_stat_1 <- double(rep_num)
  t_stat_2 <- double(rep_num)
  # Usual scaler for SE
  sqrt_n <- sqrt( sample_size )
  for ( i in 1:rep_num ) {
    # Need a new sample
    sample_i <- sample( x , sample_size , replace = FALSE )
    # Mean for sample_i
    mean_stat[ i ] <- mean( sample_i )
    # SE for Mean
    se_mean <- sd( sample_i ) / sqrt_n
    # T-statistics for hypotheses
    t_stat_1[ i ] <- ( mean_stat[ i ] - 1 ) / se_mean
    t_stat_2[ i ] <- mean_stat[ i ] / se_mean
  }
  df <- tibble( mean_stat = mean_stat , t_stat_1 = t_stat_1 , 
                t_stat_2 = t_stat_2 )
}

# Get some sampling distribution
df_X <- get_sampling_dists( X , rep_num = 1000 , sample_size = 5000 )

# Plot these distributions
ggplot( df_X , aes( x = mean_stat ) ) +
  geom_density( color = 'red' ) +
  geom_vline( xintercept = 1 , linetype = "dashed" , color = 'blue' )+
  geom_vline( xintercept = mean( X ) , color = 'green' )


# Plot these distributions - H0 is true
ggplot( df_X , aes( x = t_stat_1 ) ) +
  geom_density( color = 'red' )


# Plot these distributions - H0 is not true
ggplot( df_X , aes( x = t_stat_2 ) ) +
  geom_density( color = 'red' )
