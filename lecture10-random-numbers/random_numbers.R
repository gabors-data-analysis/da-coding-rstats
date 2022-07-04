##################################
##                              ##
##  Random Numbers and          ##
##       Random Sampling in R   ##
##                              ##
##################################

# Clear memory and load packages
rm(list=ls())
library(tidyverse)


# 1) case uniform distribution random sampling
n <- 10
x <- runif( n, min = 0, max = 10 )
x

# 2) Set the seed for the computer for rng
set.seed(123)
x <- runif( n, min = 0, max = 10 )

rm( x, n )


# Play around with n
n <- 10000
y <- rnorm( n, mean = 1, sd = 2 )
df <- tibble( var1 = y )
ggplot( df, aes( x = var1 ) ) +
  geom_histogram( aes( y = ..density.. ), fill = 'navyblue') +
  stat_function( fun = dnorm, args = list( mean = 1, sd = 2 ),
                 color = 'red', size = 1.5 )

# There are some other type of distributions:
#   rbinom, rexp, rlnorm, etc.

###
# Exercise with height-income distributions

# Get data from OSF
df <- read_csv('https://osf.io/rnuh2/download')
# set height as numeric
df <- df %>% mutate( height = as.numeric( height ) )

# Create a empirical histogram of height with theoretical normal
emp_height <- ggplot( df, aes( x = height ) ) +
  geom_histogram( aes( y = ..density.. ), binwidth = 0.03, 
                  fill = 'navyblue', alpha = 0.6 ) +
  stat_function( fun = dnorm, color = 'red',  
                 args = with( df, c( mean = mean( height, na.rm = T ), sd = sd( height, na.rm = T ) ) ) ) + 
  labs(x='Height (meters)', y='Density' ) +
  theme_bw()

emp_height

# Calculate the empirical mean and standard deviation 
mu <- with( filter( df, hhincome < 1000 ), 
            log( mean( hhincome )^2 / sqrt( var( hhincome ) + mean( hhincome )^2 ) ) )
sigma <- with( filter( df, hhincome < 1000 ),
               sqrt( log( var( hhincome ) / mean( hhincome )^2 + 1 ) ) )

emp_inc <- ggplot( filter( df, hhincome < 1000 ), aes( x = hhincome ) ) +
  geom_histogram( aes( y = ..density.. ), binwidth = 10,
                  fill = 'navyblue', alpha = 0.6 ) +
  stat_function( fun = dlnorm, colour= 'red',  
                 args = c( mean = mu, sd =  sigma ) ) + 
  labs(x='Income (thousand $)', y='Density' ) +
  theme_bw()

emp_inc

# Generate artificial data
set.seed(123)
artif <- tibble( height_art = rnorm( nrow( df ), mean( df$height, na.rm = T ), 
                                     sd = sd( df$height, na.rm = T ) ),
                 inc_art = rlnorm( nrow( df ), meanlog = mu, sdlog = sigma ) )

# Compare height
emp_height + geom_histogram( data = artif, aes( x = height_art, y = ..density.. ), 
                             binwidth = 0.03, boundary = 1.3, 
                             fill = 'orange', alpha = 0.3 )

# Compare income
emp_inc + geom_histogram( data = artif, aes( x = inc_art, y = ..density.. ), binwidth = 10,
                          fill = 'orange', alpha = 0.3 ) +
  xlim(0,500)

# Task: log-income

# Create log income and artificial as well
set.seed(123)
df <- df %>% mutate( lninc = ifelse( hhincome > 0, log( hhincome ), 0 ),
                     lninc_art = rnorm( nrow(df), mean = mean( lninc, na.rm = T ),
                                                   sd = sd( lninc, na.rm = T ) ) )

ggplot( df ) +
  geom_histogram( aes( x = lninc, y = ..density.. ), binwidth = 0.3,
                  fill = 'navyblue', alpha = 0.6 ) +
  geom_histogram( aes( x = lninc_art, y = ..density.. ), binwidth = 0.3,
                  fill = 'orange', alpha = 0.3 ) +
  stat_function( fun = dnorm, colour= 'red',  
                 args = with( df, c( mean = mean( lninc, na.rm = T ), 
                                      sd =  sd( lninc, na.rm = T) ) ) ) + 
  labs(x='Log-Income (thousand $)', y='Density' ) +
  theme_bw()



#####
# Random sampling from a data/variable:

sp500 <- read_csv('https://osf.io/h64z2/download')
head(sp500)


# Sample_1 is without replacement
set.seed(123)
sample_1 <- slice_sample( sp500, n = 1000, replace = F )
head(sample_1)
# Sample_2 with replacement -> useful for bootstrapping
sample_2 <- slice_sample( sp500, n = 1000, replace = T )

# alternatively:
set.seed(123)
sample_1a <- sample_n( sp500, 1000, replace = FALSE )
set.seed(123)
sample_1b <- tibble( VALUE = sample( sp500$VALUE, 1000, replace = FALSE ) )
set.seed(123)
sample_1c <- sp500[sample.int( 1000, replace = FALSE ),]
# Note: all the other are the same except sample_1c, this is due to the fact 
#   that set.seed controls for the output of the function, but the function may alter the seed.


