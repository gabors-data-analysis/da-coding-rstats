###############################################
#                                             #
#               Lecture 15                    #
#                                             #
# Advanced topics with linear regression      #
#     - Multiple regression                   #
#     - Model choice with multiple regressors #
#     - Prediction with multiple regressors:  #
#         - useful graphs for predictions     #
#         - Confidence Interval               #
#         - Prediction Interval               #
#     - Robustness tests/External validity    #
#         - Time/Location/Type                #
#     - Extra: training and test sample       #
#                                             #
# Case Study:                                 #
#  Using Hotels Europe                        #
#                                             #
# Dataset used:                               #
#     hotel-europe                            #
#                                             #
###############################################


rm(list=ls())

# packages
library(tidyverse)
library(modelsummary)
library(fixest)
if (!require(ggpubr)){
  if (!require(car)){
    install.packages('car')
  }
  install.packages('ggpubr')
  library(ggpubr)
}
library(lspline)

#####
# Import Data:
# now we use all the observations from Europe:
hotels_europe_price    <- read_csv('https://osf.io/p6tyr/download')
hotels_europe_features <- read_csv('https://osf.io/utwjs/download')

# Join them by hotel_id
europe <- left_join(hotels_europe_price, hotels_europe_features, by = 'hotel_id')
rm(hotels_europe_price,hotels_europe_features)

###
# I) Predict Hotel prices in Vienna with multiple regressors!
#
# A) Data management:
#   a) get the needed sample:
vienna <- europe %>% filter(accommodation_type=='Hotel') %>%
  filter( year == 2017, month == 11 , weekend == 0) %>% 
  filter(city_actual=='Vienna') %>%
  filter(stars>=3 & stars<=4) %>% filter(!is.na(stars)) %>%
  filter(price<=600)

#   b) calculate log price
vienna <- vienna %>% mutate( lnprice = log( price ) )



# 2) Quick reminder: check the descriptives + association
# Summary statistics on price and log of price
P95 <- function(x){ quantile(x,.95,na.rm=T)}
datasummary( price + lnprice + distance + stars + rating ~ 
               Mean + SD + Min + Max + Median + P95 + N , data = vienna )

# Look at the scatter plots - with the visual inspection we can decide which transformation to use!
# p1: distance vs price
p1 <- ggplot( data = vienna , aes( x = distance, y = lnprice )) +
  geom_point( color = 'red', size = 2, shape = 16, ) + 
  geom_smooth( method = 'loess', formula = y ~ x) +
  labs(x = 'Distance to city center (miles)',y = 'Log of price (US dollars)')
p1
# Log for price, Distance: check linear spline with knots at 1 and 4

# p2: stars vs price
p2 <- ggplot( data = vienna , aes( x = stars, y = lnprice )) +
  geom_point( color = 'red', size = 2, shape = 16, ) + 
  geom_smooth( method = 'loess', formula = y ~ x) +
  labs(x = 'Star of the Hotel',y = 'Log of price (US dollars)')
p2
# Star of a hotel is discrete value: may use as it is, 
#   but using it as dummies would make our model more flexible!

##
# Task: plot p3: rating vs price
# What can you infer?
p3 <- ggplot( data = vienna , aes( x = rating, y = lnprice )) +
  geom_point( color = 'red', size = 2, shape = 16, ) + 
  geom_smooth( method = 'loess', formula = y ~ x) +
  labs(x = 'Ratings of the hotel',y = 'Log of price (US dollars)')
p3
# Rating: check with simple linear and with linear spline around value of 3.5

# Joining these three graphs into one if want to report them!
association_figs <- ggarrange(p1, p2, p3,
                              hjust = -0.6,
                              ncol = 1, nrow = 3)
association_figs

##
# Notes:
#   - when the outcome variable is (much) better for log transformation (for most of the variables):
#       then you will need to use it in your model, there is nothing to do
#   - however if the regressor is needed then it is enough to decide for that particular variable only!

##
# II) Running regressions:

# Baseline A: use only rating with heteroscedastic SE
reg0 <- feols( lnprice ~ rating, data = vienna , vcov = 'hetero')
reg0

# Baseline B: use only distance with heteroscedastic SE
reg1 <- feols( lnprice ~ distance , data = vienna , vcov = 'hetero' )
reg1

# Multiple regression with both rating and distance
reg2 <- feols( lnprice ~ distance + rating , data = vienna , vcov = 'hetero' )
reg2

# Add the number of stars to out model:
# As stars are discrete values: better to use `dummy` variables instead of one 'qusi-continuous' variable
vienna <- vienna %>% mutate( star3 = as.numeric( stars == 3 ),
                             star35 = as.numeric( stars == 3.5 ),
                             star4 = as.numeric( stars == 4 ) )

###
# Task: add stars as dummies to the model with heteroscedastic SE
# 
reg3 <- feols( lnprice ~ distance + rating + star3 + star35 , data = vienna , vcov = 'hetero' )
reg3

# Discuss what the coefficients mean for star3 and star35! What about star4?

# Compare the results
etable( reg0 , reg1 , reg2 , reg3 )

# More complex models: this is the art of our profession: find the good knot points 
#     (again this is why we do scatter plots)
reg4 <- feols( lnprice ~ lspline(distance, c(1,4)) + lspline(rating, 3.5) + star3 + star35 ,
               data = vienna , vcov = 'hetero' )


etable( reg2 , reg3 , reg4 )


####
# III) Analyzing the results: our choice is regression 4

# Save the predicted and residual values
vienna$lnprice_hat   <- reg4$fitted.values
vienna$lnprice_resid <- reg4$residuals
# Note we are interested in real price values not in logs:
# the first term is straight forward, however the second exp( reg4$ssr /2 ) is a correction term 
#   which is needed when dealing with log to exp transformation. Later in DA3 it will be discussed.
corr_term <- exp( mean( vienna$lnprice_resid ) / 2 )
vienna$price_hat <- exp( vienna$lnprice_hat ) * corr_term

# List of 5 best deals
vienna %>%  top_n( -5 , lnprice_resid) %>% select( hotel_id , price , price_hat, lnprice , lnprice_hat ,
                                                   lnprice_resid , distance , stars , rating )
# Why the 5 best lnprice_resid is the same as if we have used price_hat? Discuss!

##
# Two useful graphs:
#
# 1) y - yhat graph (regression line must be the same as the 45 degree line!)
ggplot(data = vienna, aes(x = lnprice_hat, y = lnprice)) +
  geom_point( ) + 
  geom_smooth(method='lm',formula=y~x,se=F) +
  labs(x = 'ln(predicted price, US dollars) ',y = 'ln(price, US dollars)')+
  geom_segment(aes(x = 4.8, y = 4.1, xend = 4.68, yend = 4.1), 
               arrow = arrow(length = unit(0.1, 'cm') ),
               color = 'red' )+
  annotate('text', x = 4.95, y = 4.1, label = 'Best deal', size=5,color = 'red')+
  geom_abline(intercept = 0, slope = 1, size = 0.5, color = 'red', linetype = 'dashed' ) +
  coord_cartesian(xlim = c(4, 5.5), ylim = c(4, 5.5)) +
  theme_bw()


# 2) residual - yhat graph: it needs to be flat
ggplot(data = vienna, aes(x = lnprice_hat, y = lnprice_resid)) +
  geom_point(color = 'red', size = 2 ) + 
  geom_smooth( method='lm', colour='blue', se=F , formula = y~x) +
  labs(x = 'ln(Predicted hotel price, US dollars)',y = 'Residuals')+
  theme_bw() 

# Helps to evaluate where we tend to make larger errors. It can be used for different regressors!

###
# Task: check the graphs across distance! (note it is not always flat, discuss, why!)
# residual - distance graph 



###
# Confidence interval for the E(Y|X):
# 1) predict the outcomes with predict command and use the se.fit = T, 
#     this will give you the standard errors for the conditional expectation!
pred_CI <- predict( reg4 , newdata = vienna , se.fit=T , interval = 'confidence' )

# Add the CI values to vienna dataset
vienna <- vienna %>% mutate( CI_up  = pred_CI$ci_high,
                             CI_low = pred_CI$ci_low )

# Why we usually do not use such graphs, when evaluating multiple regression results:
ggplot( data = vienna ) +
  geom_point( aes( x = distance, y = lnprice ) , color = 'blue', size = 2 ) + 
  geom_line( aes( x = distance , y = lnprice_hat ) , color = 'red' , size = 1 ) +
  geom_line( aes( x = distance , y = CI_up ) , color = 'red' , size = .5 , linetype = 'dashed' ) +
  geom_line( aes( x = distance , y = CI_low ) , color = 'red' , size = .5 , linetype = 'dashed' ) +
  labs(x = 'Distance to city center (miles)',y = 'Log of price (US dollars)')

###
# Price a new hotel with the model
#
# However you can predict any (new) potential variable
new_hotel_vienna <- tibble( distance = 2.5 , star3 = 0 , star35 = 0, rating = 3.2 )
pred_CI_new <- predict( reg4 , newdata = new_hotel_vienna , se.fit=T , interval = 'confidence' )
pred_CI_new

# Note: you are not really looking for log-price, hence the correction
pred_CI_new <- pred_CI_new %>% mutate( pred_price = exp( fit ) * corr_term,
                                       CI_up = exp( ci_high ) * corr_term,
                                       CI_low = exp( ci_low) * corr_term )
pred_CI_new

# Is the Confidence Interval symmetric? In which case? Why? Discuss! 


####
# Prediction interval: considers the inherent error as well!
pred_PI <- predict( reg4 , newdata = vienna , se.fit=T , interval = 'prediction' )

# Check for our new hotel
pred_PI_new <- predict( reg4 , newdata = new_hotel_vienna , se.fit=T , interval = 'prediction' )

# Unfortunately, by default it is called 'ci' here as well...
pred_PI_new

# Note: you are not really looking for log-price:
pred_PI_new <- pred_PI_new %>% mutate( pred_price = exp( fit ) * corr_term,
                                       PI_up = exp( ci_high )* corr_term,
                                       PI_low = exp( ci_low ) * corr_term)
pred_PI_new

# Let us compare the two results for our newly predicted hote:
our_hotel_price <- tibble( price = pred_CI_new$pred_price , 
                           CI_low = pred_CI_new$CI_low ,
                           CI_up = pred_CI_new$CI_up,
                           PI_low = pred_PI_new$PI_low ,
                           PI_up = pred_PI_new$PI_up)

# Results for the hotel to price:
our_hotel_price

# Discuss what the results mean! How would you price this hotel?


###
# Task:
#   There is a new hotel with the following feature values that you would like to price
#       distance = 0.25 , star3 = 0 , star35 = 0, rating = 4.1
#   Now, you use polynomials rather than piecewise linear spline up to 3rd order for distance and rating. 
#     Use dummies for stars and use heteroskedastic robust SE!
#   Estimate the model, and check the distance and ratings against the residuals for the LEVELS.
#   Calculate the CI and PI with 80% levels, using the `level` input argument
#     for this hotel based on the model.
#   What price would you use? Argue!



#####
# IV) External validity of the model
#
# We want to test how our favorite model would perform if we change:
#   time OR place OR type of observations (e.g. Apartment instead of Hotels)
#
#

# 0) Add the variable transformations to the general dataset: hotels-europe
europe <- europe %>% mutate( lnprice = log( price ),
                             star3 = as.numeric( stars == 3 ) ,
                             star35 = as.numeric( stars == 3.5 ) )




# 1) First let check for different time: Vienna multiple time
vienna_m_time <- europe %>% filter(accommodation_type=='Hotel') %>%
  filter(city_actual=='Vienna') %>%
  filter( nnights == 1 ) %>% 
  filter(stars>=3 & stars<=4) %>% filter(!is.na(stars)) %>%
  filter(price<=600)

# IMPORTANT: for a fair comparison, we need to use the SAME HOTELS!
# we have three alternative candidates:
#   main: 2017/11 weekday
#   1): 2017/11 on a weekend
#   2): 2017 December, holiday
#   3): 2018 June, weekend

# first we get our preferred dates
vienna_m_time <- vienna_m_time %>% 
  filter( ( year == 2017 & month == 11 & weekend == 1 ) |
            ( year == 2017 & month == 11 & weekend == 0 ) |
            ( year == 2017 & month == 12 & holiday == 1 ) |
            ( year == 2018 & month ==  6 & weekend == 1 ) )

# Secondly we extract the frequencies for each hotels
freq_hotel_id <- vienna_m_time %>% select( hotel_id ) %>% 
  group_by( hotel_id ) %>% 
  summarise( num_hotel = n() )
# Hotels with frequency of four are in all of our dates
four_freq_id <- freq_hotel_id$hotel_id[ freq_hotel_id$num_hotel == 4 ]

vienna_m_time <- vienna_m_time %>% filter( hotel_id %in% four_freq_id )

# Trick: save the formula for the main model:
m_form <- formula( lnprice ~ lspline(distance, c(1,4)) + lspline(rating, 3.5) + star3 + star35 )

# Our main model: 2017/11 in a weekday
regt_0 <- feols( m_form , vcov = 'hetero', data = filter( vienna_m_time ,  year == 2017, month == 11 , weekend == 0 ) )

# Alternatively 1) 2017/11 on a weekend
regt_1 <- feols( m_form , vcov = 'hetero', data = filter( vienna_m_time ,  year == 2017, month == 11 , weekend == 1 ) )
# Alternatively 2) 2017 December, holiday
regt_2 <- feols( m_form , vcov = 'hetero', data = filter( vienna_m_time ,  year == 2017, month == 12 , holiday == 1 ) )
# Alternatively 2) 2018 June, weekend
regt_3 <- feols( m_form , vcov = 'hetero', data = filter( vienna_m_time ,  year == 2018, month == 6 , weekend == 1 ) )

# Compare the results:
etable( regt_0 , regt_1 , regt_2 , regt_3 ,
        headers = c('2017/11 weekday','2017/11 on a weekend',
                    '2017 December, holiday','2018 June, weekend') )

# With prediction look at: R2, and stability of the parameters!
# Note: we have slightly different results than in the slides as we use rating and stars as well.
#   You may check without these regressors!




# 2) Second let's check for different accommodation types in Vienna:
#  Compare hotels with Apartments:
# Note: we only change one thing at a time!

vienna_h_vs_a <- europe %>% filter( accommodation_type=='Hotel' | accommodation_type == 'Apartment') %>%
  filter(city_actual=='Vienna') %>%
  filter( year == 2017 & month == 11 & weekend == 1  ) %>% 
  filter( nnights == 1 ) %>% 
  filter(stars>=3 & stars<=4) %>% filter(!is.na(stars)) %>%
  filter(price<=600) %>% 
  filter(!is.na(rating))

# Note: here we can not compare the same observations as they are inherently different!

# Run regression for the hotels
regh <- feols(  m_form , vcov = 'hetero', data = filter( vienna_h_vs_a ,  accommodation_type=='Hotel' ) )

# Run regression for the apartments
rega <- feols(  m_form , vcov = 'hetero', data = filter( vienna_h_vs_a ,  accommodation_type == 'Apartment' ) )

# Compare the results:
etable( regh , rega , headers = c('Hotels','Apartments') )

##
# Task: 3) Compare different cities:
#   Check Vienna, Amsterdam, and Barcelona!
#   Note: Get rid of the price filter!




####
# Extra:
# In prediction competitions usually there is a training/available sample
#   and a test/locked sample for the competitors. 
#   The task is to build a model which gives the best prediction (according to a pre-defined measure)

# E.g. uses our original sample:

set.seed( 123 )
ID_train <- sample( 1 : dim( vienna )[ 1 ] , 150 )
ID_test  <- setdiff(  1 : dim( vienna )[ 1 ] , ID_train )
vienna_train <- vienna[ ID_train , ]
# Note that you do not know the test sample in the competition!
vienna_test <- vienna[ ID_test , ]

# Let us use two competing models:
# model 1: simple multivariate model
pred_m1 <- feols( lnprice ~ distance + rating + star3 + star35 , vcov = 'hetero' , data = vienna_train )

# model 2: multivariate model with linear splines
pred_m2 <- feols( m_form , vcov = 'hetero' , data = vienna_train )

# Now let us use these models on our test sample to predict the values
pred_m1_test <- predict( pred_m1 , newdata = vienna_test )
pred_m2_test <- predict( pred_m2 , newdata = vienna_test )

# Create a tibble to compare the results
pred_compare <- tibble( actual_lnprice = vienna_test$lnprice ,
                        m1_lnprice = pred_m1_test ,
                        m2_lnprice = pred_m2_test )

# If you want to visualize
ggplot( pred_compare ) +
  geom_point( aes( x = actual_lnprice , y = m1_lnprice) , color = 'red' , size = 2 ) +
  geom_point( aes( x = actual_lnprice , y = m2_lnprice) , color = 'blue' , size = 2 ) +
  geom_line( aes( x = actual_lnprice , y = actual_lnprice ), color = 'black' , size = 1 ) +
  labs( x = 'Actual log price' , y = 'Predicted log prices' ) +
  coord_cartesian( xlim = c(4, 5.5), ylim = c(4, 5.5)) +
  theme_bw()

# Evaluate according to RMSE measure:
rmse <- function( y , y_hat){
  sqrt( sum( ( y - y_hat )^2 ) )
}
# The two rmse values:
rmse( pred_compare$actual_lnprice , pred_compare$m1_lnprice )
rmse( pred_compare$actual_lnprice , pred_compare$m2_lnprice )

# Therefore model 2 wins this competition according to RMSE measure.

