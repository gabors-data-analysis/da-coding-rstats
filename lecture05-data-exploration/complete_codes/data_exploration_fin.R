#########################################
#                                       #
#              Lecture 06               #
#                                       #
#           Data Exploration            #
#                                       #
#   - modelsummary package:             #
#     - datasummary for descriptives    #
#     - descriptive by categories       #
#     - custom function                 #
#   - ggplot                            #
#     - histogram                       #
#     - customize a ggplot              #
#     - kernel density                  #
#     - multiple geometries             #
#   - Hypothesis testing with t.test    #
#   - Association                       #
#     - scatter plot                    #
#     - bin-scatter:                    #
#         - equal distance              #
#         - equal number of obs         #
#     - correlation and covariance      #
#     - factors with ggplot             #
#                                       #
# Case-study:                           #
#  Billion Price Project:               #
#   Online and Offline prices           #
#                                       #
# Dataset:                              #
#   billion-prices                      #
#                                       #
#########################################


# Remove variables from the memory
rm(list=ls())

# Call packages
library(tidyverse)
# new package we use for descriptive purposes
# install.packages('modelsummary')
library(modelsummary)



###
## Import data
bpp_orig <- read_csv( 'https://osf.io/yhbr5/download' )

# Check the variables
glimpse(bpp_orig)

## Create our key variable: price differences
bpp_orig <- mutate( bpp_orig, p_diff = price_online - price )

####
## DESCRIPTIVE STATISTICS
#
# Check all the variables in tibble by a quick built-in summary statistics
datasummary_skim( bpp_orig )
# alternatively - base R command: 
summary( bpp_orig )

# Get a better idea about the key variables:
# use `datasummary()` function:
# datasummary( in_rows ~ in_columns, data = df ), 
#   where in_rows OR in_columns are variables and the other is a descriptive function
datasummary( price + price_online + p_diff ~ 
               Mean + Median + SD + Min + Max + P25 + P75 + N + PercentMissing, 
             data = bpp_orig )

# Or put the descriptives into rows and variables into columns:
datasummary( Mean + Median + SD + Min + Max + P25 + P75 + N + PercentMissing ~
               price + price_online + p_diff, 
             data = bpp_orig )
##
# next let us check the price differences for each countries.
# here comes 'factor' variables into picture:

# lets create a new variable country_f which is a factor variable:
bpp_orig <- mutate( bpp_orig, country_f = factor(COUNTRY) )

# With datasummary it is super easy to check, we only need to use '*'
# always make sure one of the variable is factor!
datasummary( country_f * p_diff ~ Mean + Median, data = bpp_orig )


# Lets say we are interested in the prices as well for each countries.
# In this case we need to use parenthesis in a clever way:
#   for each country show the differences and levels
datasummary( country_f * ( p_diff + price + price_online ) ~ Mean + Median, data = bpp_orig )

# for each variable, show the different countries:
datasummary( ( country_f * p_diff ) + ( country_f * price  ) ~ Mean + Median, data = bpp_orig )

##
# Task
# 1) filter the data to 2016 and check price difference the mean and median for each country
#
datasummary( country_f * p_diff ~ Mean + Median, 
             data = filter( bpp_orig, year == 2016 ) )

##
# Add self created descriptive function to datasummary:
#
# To do this we need to understand `function` in R
  # Lets check the 'range' as an external function to the descriptive
# Our first function - explain each part, especially the output
range_ds <- function( x ){ 
                max( x, na.rm = T ) - min( x, na.rm = T ) }

# Later we will discuss functions more in details!

datasummary( price + price_online + p_diff ~ 
               Mean + Median + SD + Min + Max + P25 +
               P75 + N + PercentMissing + range_ds, 
             data = bpp_orig )

# Extra example: the 'mode'
mode_ds <- function(v){
  uniqv <- unique( v )
  uniqv[ which.max( tabulate( match( v, uniqv ) ) ) ]
}
datasummary( price + price_online + p_diff ~ 
               Mean + Median + mode_ds, data = bpp_orig )

##################
## VISUALIZATION
# the ggplot
#   ggplot always has a `ggplot()` function and a geom_*type*() function added.
#     ggplot is awesome, as you can add multiple objects, easily.
#     for some historical reasons, ggplot uses '+' sign instead of '%>%' 
#     to add new commands/objects to the graph 


# Check the empirical distribution:  histogram.
#   simple - built in histogram with `geom_histogram()`
ggplot( data = bpp_orig ) +
  geom_histogram( aes( x = price ), fill = 'navyblue' ) +
  labs(x = 'Price',
       y = 'Count' )
# Lets just ignore the warning, we will discuss it later!

##
# It is clear: need to filter out some data
# FILTER DATA -> filter for 'PRICETYPE' is a too large restriction!
#     may check without that filter!
# for reasons of this check the discussion in the book, Chapter 6.
bpp <- bpp_orig %>%  
  filter( is.na(sale_online) ) %>%
  filter(!is.na(price)) %>%
  filter(!is.na(price_online)) %>% 
  filter( PRICETYPE == 'Regular Price' )

# Check our newly created data:
datasummary( price + price_online + p_diff ~ 
               Mean + Median + SD + Min + Max + P25 + P75 + N, 
             data = bpp )

# Drop obvious errors: price is larger than $1000
bpp <- bpp %>% 
  filter( price < 1000 )

# Check again our datatable:
datasummary( price + price_online + p_diff ~ 
               Mean + Median + SD + Min + Max + P25 + P75 + N, 
             data = bpp )

# Histogram for filtered data
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue' ) +
  labs(x = 'Price',
       y = 'Count' )

##
# Role of number of bins (or binwidth)

# Play with the number of Bins:
# 1) approx ok
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  bins = 50 ) +
  labs(x = 'Price',
       y = 'Count' )

# 2) too many
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  bins = 150 ) +
  labs(x = 'Price',
       y = 'Count' )

# 3) too few
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  bins = 5 ) +
  labs(x = 'Price',
       y = 'Count' )
##
# Task:
# Play with the binwidth - instead of `bins=`, use `binwidth=`
# create 3 graphs: 1) approx ok, 2) too large binwidth, 3) too narrow binwidth
# discuss, what is the relation between bins and binwidth!

# 1) approx ok
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  binwidth = 20 ) +
  labs(x = 'Price',
       y = 'Count' )

# 2) too large
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  binwidth = 200 ) +
  labs(x = 'Price',
       y = 'Count' )

# 3) too narrow
ggplot( data = bpp ) +
  geom_histogram( aes( x = price ), fill = 'navyblue',
                  binwidth = 2 ) +
  labs(x = 'Price',
       y = 'Count' )

##
# Relation: they are inversely proportional

##
# Count vs. Relative Frequency
#   until now we have used count (counted the number of observations in each bin)
#   the other possibility is to use relative frequency instead:
# you need to add `y = ..density..` to the aesthetics:
ggplot( data = bpp ) +
  geom_histogram( aes(  y = ..density.., x = price ), fill = 'navyblue',
                  bins = 50 ) +
  labs(x = 'Price',
       y = 'Relative Frequency' )


##
# Kernel density
#
# Histogram or kernel density? Kernel is the smooth line instead of using bars.
# Now, let us name our ggplot:
my_graph <- ggplot( data = bpp ) +
            geom_density( aes( x = price ), color = 'red', bw = 20 ) +
            labs(x = 'Price',
                 y = 'Relative Frequency' )

# to make it visible we need to call it
my_graph

# Cool stuff about ggplot, is that we can add (later as well) new geometric object to it.
# e.g. we can add a histogram:
my_graph + geom_histogram( aes(  y = ..density.., x = price ), fill = 'navyblue', 
                           alpha = 0.4, binwidth = 20 )
# note alpha governs the opaqueness of the object

###
# Task
#   1) Do the same kernel density and histogram, but now with the price differences
#   2) Add xlim(-5,5) command to ggplot! What changed?
ggplot( data = bpp ) +
  geom_density( aes( x = p_diff ), color = 'red', fill = 'red', alpha = 0.2, bw = 0.2 ) +
  geom_histogram( aes(  y = ..density.., x = p_diff ), fill = 'navyblue', 
                  alpha = 0.4, binwidth = 0.2 ) +
  labs( x = 'Price Differences' ,
        y = 'Relative Frequency' ) +
  xlim( -5, 5 )


# Check for price differences
chck <- bpp %>% filter( p_diff > 500 | p_diff < -500 )
# Drop them
bpp <- bpp %>% filter( p_diff < 500 & p_diff > -500 )
rm( chck )

###
# Comparing different countries via graphs

# Create ggplot for each countries - histogram:
# Note: 
#   1) if you only use one type of x or y, you can put it into the `aes()` of the ggplot. Otherwise not.
#   2) use 'fill=' in `aes()`, to define different groups. 

ggplot( data = bpp, aes( x = p_diff, fill = country_f ) ) +
  geom_histogram( aes( y = ..density.. ), alpha =0.4, bins = 15 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        fill = 'Country' ) +
  xlim(-4,4)


# 2) Use the extra command `facet_wrap(~country_f)` to create multiple plots for each country at once!

ggplot( data = bpp, aes( x = p_diff, fill = country_f ) ) +
  geom_histogram( aes( y = ..density.. ), alpha =0.4, bins = 15 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        fill = 'Country' ) +
  facet_wrap(~country_f)+
  xlim(-4,4)

###
# Task 1) You can also use  'color=' or 'group=' instead of 'fill='. Compare! What is the difference?
#   Be careful with `labs()` you need to change there as well!

# Use color instead
ggplot( data = bpp, aes( x = p_diff, color = country_f ) ) +
  geom_histogram( aes( y = ..density.. ), alpha =0.4, bins = 15 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        color = 'Country' ) +
  facet_wrap(~country_f)+
  xlim(-4,4)

# Use group instead
ggplot( data = bpp, aes( x = p_diff, group = country_f ) ) +
  geom_histogram( aes( y = ..density.. ), alpha =0.4, bins = 15 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        group = 'Country' ) +
  facet_wrap(~country_f)+
  xlim(-4,4)



###
# Task 2)
# 1) Do the same, but use geom_density instead of geom_histogram!
#     You may play around with the xlim!
# 2) Drop the `facet_wrap` command! What happens? Which graph would you use to tell your story in this case?
# What if instead of `fill` you use `color` or `group`

# 1) Density with multiple graphs
ggplot( data = bpp, aes( x = p_diff, fill = country_f ) ) +
  geom_density( aes( y = ..density.. ), alpha =0.4 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        fill = 'Country' ) +
  facet_wrap(~country_f)+
  xlim(-1,1)

# 2) Density with single graphs:
# fill
ggplot( data = bpp, aes( x = p_diff, fill = country_f ) ) +
  geom_density( alpha = 0.2 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        fill = 'Country' ) +
  xlim(-1,1)

# color
ggplot( data = bpp, aes( x = p_diff, color = country_f ) ) +
  geom_density( alpha =0.4 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        color = 'Country' ) +
  xlim(-1,1)

# group
ggplot( data = bpp, aes( x = p_diff, group = country_f ) ) +
  geom_density( alpha =0.4 ) +
  labs( x = 'Price', y = 'Relative Frequency' ,
        group = 'Country' ) +
  xlim(-1,1)

# Which graph to use: I would definitely use single density graph with color. 
#   It tells the story best: there are differences between countries!

######
# HYPOTHESIS TESTING

# Test: H0: the average price difference 
#             between price_online - price = 0
#       HA: the avg price diff is non 0.

t.test( bpp$p_diff, mu = 0 )

# Test 2: The online prices are smaller or equal to offline prices
#   H0: price_online - price = 0
#   HA: price_online - price >  0
t.test( bpp$p_diff, mu = 0, alternative = 'greater' )

# Test 3: The online prices are larger or equal to offline prices
#   H0: price_online - price = 0
#   HA: price_online - price <  0
t.test( bpp$p_diff, mu = 0, alternative = 'less' )

###
# summarise and group_by functions in tidyverse:
#
# Let us create multiple hypothesis tests:
#   check the hypothesis that online prices are the same as offline for each country!
testing <- bpp %>% 
  select( country_f, p_diff ) %>% 
  group_by( country_f ) %>% 
  summarise( mean_pdiff = mean( p_diff ) ,
             se_pdiff = 1/sqrt(n())*sd(p_diff),
             num_obs = n() )

testing

# Testing in R is easy if one understands the theory!
# t_stat: with this H0 and t-test: 
testing <- mutate( testing, t_stat = mean_pdiff / se_pdiff )
testing
# Built-in p-value calculation with `pt()` function:
testing <- mutate( testing, p_val = pt( -abs( t_stat ), df = num_obs - 1 ) )
testing
# round it to 4 digits:
testing <- mutate( testing,  p_val = round( p_val, digit = 4 ) )
testing

##
# Interpret the results for each country!
#   What are the possible dangers of multiple hypothesis testing?

####
# ASSOCIATON
#   relation between two variables

# Association between online and retail prices: geom_point() will add dots to the graph
ggplot( bpp, aes( x = price_online, y = price ) )+
  geom_point( color = 'red' )+
  labs( x = 'Price online', y = 'Price retail' )

# You can add a line (regression line to be specific), 
#   by `geom_smooth()` function. It is a great function, 
#     we now focus on `method=lm` which says it is a linear relation (linear model) 
#     and formula, which identifies y and x. We will discuss these more in details later.
ggplot( bpp, aes( x = price_online, y = price ) )+
  geom_point( color = 'red' )+
  labs( x = 'Price online', y = 'Price retail' )+
  geom_smooth(method = 'lm',formula = y ~ x, color = 'blue' )

##
# Bin-scatter:
#
# in many case there are too many observations for a simple graph 
#   and it does not tells the story we would like to.
# One solution is to do a `bin-scatter`, which put observations into bins.
#   The simplest way to do is use 'equal distances': cut x-variable's range into k equally sized bins
#     and then calculate the same observations' y-variable e.g. mean (or median).
#     - this is great: simple and intuitive (similar to histogram),
#       BUT it hides, how many observations are in each bin. 
#         E.g. it can happen in the lowest valued bin there are many observations 
#             and in the highest there is only one.
#
#   The second option is use the same number of observations in each bin. 
#     This will ensure that no such problem will rise. On the other hand it is harder to compute, 
#     and the width of the bins will vary along x.

# Bin-scatter
# 1) 'easy way': using equal distances and calculate mean for y
#   use `stat_summary_bin()`
ggplot( bpp, aes( x = price_online, y = price ) )+
  stat_summary_bin( fun = 'mean', bins = 10, 
                    geom = 'point', color = 'red',
                    size = 2 )

# 2) 'easy way': using equal distances
#   group by countries, explain facet_wrap additional inputs!
ggplot( bpp, aes( x = price_online, y = price ,
                   color = country_f ) )+
  stat_summary_bin( fun = 'mean', bins = 10, 
                    geom = 'point',  size = 2 ) +
  labs( x = 'Price online', y = 'Price offline', 
        color = 'Country' ) +
  facet_wrap(~country_f,scales = 'free',ncol = 2 )+
  theme(legend.position = 'none')+
  geom_smooth(method='lm',formula = y~x, se=F)

##
# Bin-scatter 2
# Using percentiles instead of equally sized bins to ensure same number of observations!
# 

# As there is no built-in function for this, we need to do some work:
# a) cut_number(K) will provide the lower and upper boundary for K number of bins, 
#   which has approx the same number of observations in them. 
# Note: it is not an easy problem to put the same number of observations to each bin!

# check in the tibble variable!
bpp$price_online_10b <- bpp$price_online %>% 
  cut_number( 10 )

# b) Select these new intervals and the y-variable
#   then group by the intervals and calculate some descriptive statistics!
#     from these descriptive statistics we can choose which to show on the y-axis!
bs_summary <- bpp %>% 
  select( price, price_online_10b ) %>% 
  group_by( price_online_10b ) %>% 
  summarise_all( lst(p_min=min,p_max=max,
                     p_mean = mean, 
                     p_median = median,
                     p_sd = sd,
                     p_num_obs = length ))
bs_summary

# c) Recode the interval variable (factor type) to new numeric variables for creating a graph
# separate into three parts: (, lower_bound, upper_bound (and the remaining)
bs_summary <- bs_summary %>% 
  separate( price_online_10b, 
            into = c('trash','lower_bound',
                     'upper_bound' ), 
            sep = '[^0-9\\.]' )

# transform to numeric and drop trash
bs_summary <- bs_summary %>% 
  mutate( lower_bound = as.numeric(lower_bound) ) %>% 
  mutate( upper_bound = as.numeric(upper_bound)) %>% 
  select( -trash )

# Use the mid-point as x-axis values
bs_summary <- bs_summary %>% 
  mutate( mid_point = ( lower_bound + upper_bound ) / 2 )

bs_summary

# Bin-scatter plot with same number of observations within each bin:
# mid-value for x-axis and mean for y-axis:
ggplot( bs_summary, aes( x = mid_point, y = p_mean ) ) +
  geom_point( size = 2, color = 'red' ) +
  labs( x = 'Online prices', y = 'Retail prices' )

# Add x and y limits to check smaller values
ggplot( bs_summary, aes( x = mid_point, y = p_mean ) ) +
  geom_point( size = 2, color = 'red' ) +
  labs( x = 'Online prices', y = 'Retail prices' )+
  xlim(0,100)+
  ylim(0,100)

#####
# Correlation and plots with factors
#
# Often we would like to measure an association:
# covariance and correlation for mean-dependence

# Covariance
cov( bpp$price, bpp$price_online )

##
# Task:
# Check if it is symmetric!
cov( bpp$price_online, bpp$price )


# Correlation
cor( bpp$price, bpp$price_online )

##
# Make a correlation table, including correlation for each country
corr_table <- bpp %>% 
  select( country_f, price, price_online ) %>% 
  group_by( country_f ) %>% 
  summarise( correlation = cor( price,price_online) )

corr_table

# Graph to show the correlation pattern by each country:
# fct_reorder will reorder the countries by their correlation
ggplot( corr_table, aes( x = correlation ,
                          y = fct_reorder( country_f, correlation ) ) ) +
  geom_point( color = 'red', size = 2 )+
  labs(y='Countries',x='Correlation')


## 
# Task check the same for years and countries to check how the pattern altered!
# Note: 1) use color for prettier output with factor
#       2) You can alter the legend labels with `color=`

corr_table2 <- bpp %>% 
  select( country_f, year, price, price_online ) %>% 
  group_by( year, country_f ) %>% 
  summarise( correlation = cor( price, price_online ) )
  
corr_table2

ggplot( corr_table2, aes( x = correlation ,
                           y = fct_reorder( country_f, correlation),
                           color = as.factor( year ) ) )+
  geom_point( size = 2 ) +
  labs( x = 'Correlation', y = 'Country', color = 'Year' )

## What does this graph tell you? Interpret and argue!
  
  
  
