#########################
##                     ##
##    Functions        ##
##                     ##
#########################
rm(list=ls())

# 1) simplest case - calculate the mean
my_avg <- function( x ){
  sum_x <- sum( x )
  sum_x / length( x )
}

# Import wms-management data
library(tidyverse)
wms <- read_csv( 'https://osf.io/uzpce/download' )
# save management score x1
x1 <- wms$management
# Remove wms to keep environment tidy
rm( wms )
# Print out
my_avg( x1 )

# or save it as a variable
avg_x <- my_avg( x1 )
avg_x

# 2) Calculate mean and standard deviation with checking inputs
my_fun1 <- function( x ){
  sum_x <- sum( x )
  # number of observations
  N <- length( x )
  # Mean of x
  mean_x <- sum_x / N
  # Variance of x
  var_x  <- sum( ( x - mean_x )^2 / N )
  # Standard deviation of x
  sqrt( var_x )
}

# Get the standard deviation for x1
my_fun1( x1 )

# 3) Control for output
my_fun2 <- function( x ){
  sum_x <- sum( x )
  # number of observations
  N <- length( x )
  # Mean of x
  mean_x <- sum_x / N
  # Variance of x
  var_x  <- sum( ( x - mean_x )^2 ) / ( N - 1 )
  # Standard deviation of x
  sqrt( var_x )
  return( mean_x )
}

# Get the mean for x1
my_fun2( x1 )

# 4) Multiple output
my_fun3 <- function( x ){
  sum_x <- sum( x )
  # number of observations
  N <- length( x )
  # Mean of x
  mean_x <- sum_x / N
  # Variance of x
  var_x  <- sum( ( x - mean_x )^2 ) / ( N - 1 )
  # Standard deviation of x
  sd_x <- sqrt( var_x )
  out <- list( 'sum' = sum_x, 'mean' = mean_x, 'var' = var_x ,'sd' = sd_x )
  return( out )
}

# Check the output
out3 <- my_fun3( x1 )
# get all the output as list
out3
# get e.g. the mean
out3$mean

# 5) Controlling for input
my_avg_chck <- function( x ){
  stopifnot( is.numeric( x ) )
  sum_x <- sum( x )
  sum_x / length( x )
}

# Good input
my_avg_chck( x1 )
# Bad input
my_avg_chck( 'Hello world' )

# 6) Multiple input
conf_interval <- function( x, level = 0.95 ){
  # mean of x
  mean_x <- mean( x, na.rm = TRUE ) 
  # standard deviation
  sd_x <- sd( x, na.rm = TRUE )
  # number of observations in x
  n_x <- sum( !is.na( x ) )
  # Calculate the theoretical SE for mean of x
  se_mean_x <- sd_x / sqrt( n_x )
  # Calculate the CI
  if ( level == 0.95 ){
    CI_mean <- c( mean_x - 1.96*se_mean_x, mean_x + 1.96*se_mean_x )
  } else if ( level == 0.99 ){
    CI_mean <- c( mean_x - 2.58*se_mean_x, mean_x + 2.58*se_mean_x )
  } else {
    stop('No such level implemented for confidence interval, use 0.95 or 0.99')
  }
  out <- list('mean'=mean_x,'CI_mean' = CI_mean )
  return( out )
}
# Get some CI values
conf_interval( x1, level = 0.95 )
conf_interval( x1 )
conf_interval( x1, level = 0.99 )
conf_interval( x1, level = 0.98 )

# Task - flexible level
conf_interval2 <- function( x, level = 0.95 ){
  # mean of x
  mean_x <- mean( x, na.rm = TRUE ) 
  # standard deviation
  sd_x <- sd( x, na.rm = TRUE )
  # number of observations in x
  n_x <- sum( !is.na( x ) )
  # Calculate the theoretical SE for mean of x
  se_mean_x <- sd_x / sqrt( n_x )
  # Calculate the CI
  if ( level >= 0 | level <= 1 ){
    crit_val <- qnorm( level + ( 1 - level )/2 )
    CI_mean <- c( mean_x - crit_val*se_mean_x, mean_x + crit_val*se_mean_x )
  } else {
    stop('level must be between 0 and 1')
  }
  out <- list('mean'=mean_x,'CI_mean' = CI_mean )
  return( out )
}
# Get some CI values
conf_interval2( x1, level = 0.95 )
conf_interval2( x1 )
conf_interval2( x1, level = 0.99 )
conf_interval2( x1, level = 0.98 )

##########
# A solution for Execrice: sampling distribution
library(tidyverse)

# Function for sampling distribution
get_sampling_dists <- function( y, rep_num = 1000, sample_size = 1000 ){
  # Check inputs
  stopifnot( is.numeric( y ) )
  stopifnot( is.numeric( rep_num ), length( rep_num ) == 1, rep_num > 0 )
  stopifnot( is.numeric( sample_size ), length( sample_size ) == 1 ,
             sample_size > 0, sample_size <= length( y ) )
  # initialize the for loop
  set.seed(100)
  mean_stat <- double(rep_num)
  t_stat_A <- double(rep_num)
  t_stat_B <- double(rep_num)
  # Usual scaler for SE
  sqrt_n <- sqrt( sample_size )
  for ( i in 1:rep_num ) {
    # Need a new sample
    y_i <- sample( y, sample_size, replace = FALSE )
    # Mean for sample_i
    mean_stat[ i ] <- mean( y_i )
    # SE for Mean
    se_mean <- sd( y_i ) / sqrt_n
    # T-statistics for hypotheses
    t_stat_A[ i ] <- ( mean_stat[ i ] - 1 ) / se_mean
    t_stat_B[ i ] <- mean_stat[ i ] / se_mean
  }
  out <- tibble( mean_stat = mean_stat, t_stat_A = t_stat_A, 
                 t_stat_B = t_stat_B )
}

# Create y
set.seed(123)
y <- runif( 10000, min = 0, max = 2 )
# Get some sampling distribution
sampling_y <- get_sampling_dists( y, rep_num = 1000, sample_size = 100 )

# Plot these distributions
ggplot( sampling_y, aes( x = mean_stat ) ) +
  geom_histogram( aes( y = ..density.. ), bins = 60, color = 'navyblue', fill = 'navyblue' ) +
  geom_vline( xintercept = 1, linetype = 'dashed', color = 'blue', size = 1 )+
  geom_vline( xintercept = mean( y ), color = 'red', size = 1 ) +
  geom_vline( xintercept = mean( sampling_y$mean_stat ), color = 'black', size = 1 )+
  stat_function( fun = dnorm, args = list( mean = mean( y ), sd = sd( y ) / sqrt(100) ) ,
                 color = 'red', size = 1 ) +
  labs( x = 'Sampling distribution of the mean', y = 'Density') +
  theme_bw()


# Plot distribution for t-stats - Hypothesis A
ggplot( sampling_y, aes( x = t_stat_A ) ) +
  geom_histogram( aes( y = ..density.. ), bins = 60, fill = 'navyblue' ) +
  stat_function( fun = dnorm, args = list( mean = 0, sd = 1 ) ,
                 color = 'red', size = 1 ) +
  labs( x = 'Sampling distribution of t-stats: hypothesis A', y = 'Density') +
  theme_bw()


# Plot distribution for t-stats - Hypothesis B
ggplot( sampling_y, aes( x = t_stat_B ) ) +
  geom_histogram( aes( y = ..density.. ), bins = 60, fill = 'navyblue' ) +
  stat_function( fun = dnorm, args = list( mean = 0, sd = 1 ) ,
                 color = 'red', size = 1 ) +
  scale_x_continuous(limits = c(-4,30))+
  labs( x = 'Sampling distribution of t-stats: hypothesis B', y = 'Density') +
  theme_bw()


