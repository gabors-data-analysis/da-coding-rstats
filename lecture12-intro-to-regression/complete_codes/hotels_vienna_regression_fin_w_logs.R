#############################################
#                                           #
#               Lecture 12                  #
# Introduction to Regressions               #
#     - Binary means (close vs far)         #
#     - Pre-specified categories with means #
#     - Non-parametric regression (lowess)  #
#     - Simple linear regression (OLS)      #
#                                           #
# Case Study:                               #
#  Using Hotels Vienna                      #
#                                           #
#############################################


rm(list=ls())

# packages
library(tidyverse)
library(modelsummary)
if ( !require( fixest ) ){
  install.packages("fixest")
  library(fixest)
}
if ( !require( grid ) ){
  install.packages("grid")
  library(grid)
}


##
# 0) Import and clean the data

# from OSF import hotel-vienna data
hotels <- read_csv("https://osf.io/y6jvb/download")

# Apply filters:  3-4 stars, Vienna actual, without  extreme prices
hotels <- hotels %>% 
          filter(accommodation_type=="Hotel",
                 city_actual=="Vienna",
                 stars>=3 & stars<=4,
                 !is.na(stars),
                 price<=600)


# Summary statistics on price
P95 <- function(x){ quantile(x,.95,na.rm=T)}
datasummary( price + distance ~ Mean + SD + Min + 
               Max + Median + P95 + N , data = hotels )

##
# Graphical investigation:
#  create a base scatter-plot between price and distance
p1 <- ggplot( data = hotels ) +
  geom_point( aes( x = distance, y = price ), color = 'red', size = 2,  
              shape = 16, alpha = 0.5 ) + 
  expand_limits(x = 0.01, y = 0.01 ) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7),     breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")
p1


#########
# REGRESSION 1: 
#   Close vs Far away hotels with a binary variable: 
#     if further away from 2 miles, consider as 'far', otherwise 'close'
hotels <- hotels %>% mutate( dist2 = as.numeric( distance >= 2 ) )

# Add the mean of the prices for both categories
dist2 <- hotels %>% group_by( dist2 ) %>% 
            summarize( Eprice_cat2 = mean( price ) )
hotels<-left_join( hotels , dist2 )

# Recode it to a factor with 'close' and 'far' values
hotels <- hotels %>%  mutate(dist2 = recode( dist2 ,`0` = "Close",`1` = "Far" ) )

# Check the descriptives for the two categories:
datasummary( dist2* distance + dist2*price ~ 
               Mean + SD + Min + Max + N , data = hotels )

# Plot the two categories
ggplot(data = hotels) +
  geom_point(aes(x = dist2, y = Eprice_cat2), 
             size = 5, shape = 21, alpha = 0.4, fill = 'red', na.rm=T) +
  geom_text(aes(x = dist2, y = Eprice_cat2, label = round(Eprice_cat2)), 
            hjust = -0.8, vjust = 0, color = "black", size = 3) +
  scale_y_continuous(expand=c(0.01,0.01),limits = c(0, 400), breaks = seq(0,400, by=50)) +
  expand_limits( y = 0.01) +
  scale_x_discrete() +
  labs(x = "Distance to city center (categories)", y = "Average price (US dollars)")

####
# Task:
# Instead of a simple dot, use a box-plot, which shows the underlying (conditional) distribution better!
ggplot( data = hotels, aes(x = dist2, y = price ) ) +
  geom_boxplot( color = "navyblue" ) +
  stat_boxplot( geom = "errorbar", width = 0.05,  size = 0.5, color = 'navyblue') +
  scale_y_continuous(expand=c(0.01,0.01),limits = c(0, 400), breaks = seq(0,400, by=50)) +
  expand_limits( y = 0.01) +
  scale_x_discrete() +
  labs(x = "Distance to city center (categories)", y = "Average price (US dollars)")



###
# REGRESSION 2: 4 DISTANCE CATEGORIES:
# below 1, between 1 and 2, between 2 and 3 and above 3 -> x value will be the midpoint
hotels <- hotels %>% mutate( dist4 = 0.5 
                             + 1*as.numeric( hotels$distance >= 1 ) 
                             + 1*as.numeric(hotels$distance>=2) 
                             + 2.5*as.numeric(hotels$distance>=3) )

# Add mean values for price given each group
dist4 <- hotels %>% group_by( dist4 ) %>% summarize( Eprice_cat4 = mean( price ) )
hotels<-left_join(hotels,dist4)

datasummary( factor( dist4 ) * distance + factor( dist4 ) * price ~ 
               Mean + SD + Min + Max + N , data = hotels )


# Make a graph for each segment
ggplot(data = hotels) +
  geom_point(aes(x = dist4, y = Eprice_cat4), 
             size = 2.5, fill='red', shape = 21, alpha = 0.4, na.rm=T ) +
  geom_text(aes(x = dist4, y = Eprice_cat4, label = round( Eprice_cat4 ) ) ,
              hjust = -0.6, vjust = 0, color = "black", size = 3) +
  expand_limits(x = 0.01, y = 0.01) +
  coord_cartesian(xlim = c(0,7), ylim = c(0, 400)) +
  scale_y_continuous(expand=c(0.01,0.01),limits = c(0, 400), breaks = seq(0, 400, by=50)) +
  scale_x_continuous(expand=c(0.01,0.01), limits= c(0,7), breaks = c(0, 1, 2, 3,4,5, 6,7)) +
  labs(x = "Distance to city center (miles)", y = "Price (US dollars)")


# What actually is happening is a:
# scatterplot with step function (we use 1km bits for simplicity using 4 bits for 3-7km)
hotels <-hotels %>% mutate( dist4_s = 1*as.numeric(hotels$distance>=1) + 
                                      1*as.numeric(hotels$distance>=2) +   
                                      1*as.numeric(hotels$distance>=3) + 
                                      1*as.numeric(hotels$distance>=4) +
                                      1*as.numeric(hotels$distance>=5) + 
                                      1*as.numeric(hotels$distance>=6) )
# Specifying the end parameters in y and x axis
hotels$xend <- c(hotels$dist4_s+1)
hotels$yend <- c(hotels$Eprice_cat4)
# Creating a plot:
p1 + geom_segment( data=hotels, aes(x = dist4_s, y=yend, xend=xend, yend=yend), 
                   color='blue', size=0.7, na.rm=TRUE) 


#####
# Task: 
#   REGRESSION 3: use 7 different categories/bins based on distance:
# below 1, between:
#           1 and 2
#           2 and 3
#           ...
#           6 and 7

# Creating the new intervals
hotels <- hotels %>% mutate( dist7_new = 0.5 + 
                               1*as.numeric(hotels$distance>=1) + 
                               1*as.numeric(hotels$distance>=2) +   
                               1*as.numeric(hotels$distance>=3) + 
                               1*as.numeric(hotels$distance>=4) + 
                               1*as.numeric(hotels$distance>=5) + 
                               1*as.numeric(hotels$distance>=6) )  
dist7_new <- hotels %>% group_by(dist7_new) %>% summarize( Eprice_cat7_new = mean(price))
hotels<-left_join(hotels,dist7_new)

datasummary( factor( dist7_new ) * distance + factor( dist7_new ) * price ~ 
               Mean + SD + Min + Max + N , data = hotels )

# Scatterplot with step function, starting point is simply at cut-off
hotels <-hotels %>% mutate( dist7_s = 1*as.numeric(hotels$distance>=1) + 
                                      1*as.numeric(hotels$distance>=2) +   
                                      1*as.numeric(hotels$distance>=3) + 
                                      1*as.numeric(hotels$distance>=4) +
                                      1*as.numeric(hotels$distance>=5) + 
                                      1*as.numeric(hotels$distance>=6))  

hotels$xend <- c(hotels$dist7_s+1)
hotels$yend <- c(hotels$Eprice_cat7_new)

p1 + geom_segment( data=hotels, aes(x = dist7_s, y=yend, xend=xend, yend=yend), 
                   color='blue', size=0.7, na.rm=TRUE) 


#####
#
# LOWESS NONPARAMETRIC REGRESSION

p1 + geom_smooth( aes( x = distance , y = price ) , 
                  method = 'loess' , formula = 'y ~ x', se = F )

# Advantage: 
#    smooth curve which represent the pattern of association pretty flexibly!
# Disadvantage:
#    no measurable properties: it smooth over the observations with an 'optimal' bandwidth.

# Extra: you can check the output of the model estimate for loess:
model_loess <- loess( price ~ distance , data = hotels )
model_loess
summary( model_loess )


###
#
# Solution: linear regression
p1 + geom_smooth( aes( x = distance , y = price ) , 
                  method = 'lm' , formula = 'y ~ x', se = F )

# How to quantify linear regression:
# Remember: y = alpha + beta * x + eps

# Most commonly used command in R is `lm` stands for `linear model`
base_reg <- lm( price ~ distance, data = hotels )
summary( base_reg )

# Instead we are going to use `feols` 
#   -> more flexible: using robust SE
#      can be used for panel data, which will be covered in DA4
#      has a nice model comparison command

# Simple model, with homoskedastic SE:
reg <- feols( price ~ distance , data = hotels )
reg

# Simple model, with heteroskedastic robust SE:
reg_h <- feols( price ~ distance , data = hotels , vcov = 'hetero' )
reg_h

# and it is easy to compare
etable( reg , reg_h )

###
# Good to know:
# `estimatr` library with `lm_robust` command is also a frequently used package/command.
#  It is built to estimate heteroscedastic SE, similar to feols.
#   as it would use multiple packages (robust SE, reporting, etc.), we use rather feols.


#####
# Analysis of the results:
#   - price prediction of a model
#   - errors of predictions


# It is easy to save the predicted values and residuals
hotels$predprice <- reg$fitted.values
hotels$e <- reg$residuals

# Get the hotel, which is the most underpriced
hotels %>% top_n( -1 , e )
# probably we are only interested in hotel_id, distance, price, prediction and error values:
hotels %>% top_n( -1 , e ) %>% 
  select( hotel_id, price, distance , predprice , e )
# Interpret the result!


# We can get the 5 most overpriced five hotels
hotels %>% top_n( 5 , e ) %>% 
  select( hotel_id, price, distance , predprice , e )


# Checking the histogram of residuals: 
#  we can better understand about how well we can predict the prices
#   notes: 
#     - we picked previously the smallest and 5 largest values from here
#     - on average we will have 0 error, as this is a property of the OLS estimator
ggplot(data = hotels, aes (x = e)) +
  geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 20, fill = 'navyblue', color='white',
                 size = 0.2, alpha = 0.8,  show.legend=F, na.rm=TRUE, boundary=1)+
  labs(x = "Residuals", y = "Percent") +
  scale_x_continuous(limits = c(-100, 300), breaks = seq(-100, 300, by = 100)) +
  scale_y_continuous(expand = c(0.0,0.0), limits = c(0, 0.3), breaks = seq(0, 0.3, by = 0.05), 
                     labels = scales::percent_format(accuracy = 1)) +
  theme_bw() 


# We can make a pretty graph with the bottom and top 5 deals:

# create a factor variable with 4 possible values
hotels$reg1_res <- ifelse(hotels$e >=0, "overpriced", "underpriced")
hotels$reg1_res <- ifelse(hotels$e %in% tail( sort(reg$residuals, decreasing=TRUE) , 5 ) , "bottom5",
                          ifelse(hotels$e %in% head(sort(reg$residuals, decreasing=TRUE), 5), "top5", hotels$reg1_res))

# Create a pretty graph with the 4 factor types:
ggplot(data= hotels, aes(x = distance, y = price)) +
  geom_point(data = filter(hotels,reg1_res=="overpriced"), aes(color=factor(reg1_res)), 
             size = 2, shape = 16, alpha = 0.6, show.legend=F) +
  geom_point(data = filter(hotels,reg1_res=="underpriced"), aes(color=factor(reg1_res)), 
             size = 2, shape = 16, alpha = 0.6, show.legend=F) +
  geom_point(data = filter(hotels,reg1_res=="bottom5"), 
             size = 5, color = 'red',shape = 21, alpha = 1, show.legend=F) +
  geom_point(data = filter(hotels,reg1_res=="top5"),  
             size = 5, color = 'black', shape = 16, alpha = 1, show.legend=F) +
  geom_smooth(method="lm", size=1, se = F, formula = y ~ x )+
  coord_cartesian( xlim = c(0, 7), ylim = c(0, 400)) +
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7)   , breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")+
  geom_segment(aes(x = 2, y = 25, xend = 1.15, yend = 50), arrow = arrow(length = unit(0.1, "cm")))+
  annotate("text", x = 3, y = 25, label = "Most underpriced hotels", size=3)+
  theme_bw()



##
# EDDIG

#############################
# LOG MODELS

# TAKE LOG PRICE
hotels$lnprice <- log(hotels$price)

# Correct distance2 measure: no closer than 0.05km
hotels$distance2<-hotels$distance
hotels$distance2[hotels$distance2<0.05] <- 0.05

# Take the log of distance2
hotels$lndistance<-log(hotels$distance2)


# describe price and ln price
datasummary( price + lnprice ~ Mean + SD + Min + Max + P25 + P75 + N , data = hotels )

######
# Running multiple regressions:

# LEVEL-LEVEL LINEAR REGRESSION
reg1 <- feols(price ~ distance, data=hotels)
reg1

f1 <- ggplot(data = hotels, aes(x = distance, y = price)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~x)+
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7), breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")+
  theme_bw() 
f1

# LEVEL-LOG LINEAR REGRESSION 
reg2 <- feols(price ~ lndistance, data=hotels)
reg2

f2 <- ggplot(data = hotels, aes(x = lndistance, y = price)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ x)+
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "ln(distance to city center, miles)",y = "Price (US dollars)")+
  theme_bw() 
f2



# LOG-LEVEL LINEAR REGRESSION
reg3 <- feols(lnprice ~ distance, data=hotels)
reg3

f3 <- ggplot(data = hotels, aes(x = distance, y = lnprice)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ x)+
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7), breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(3.5, 6), breaks = seq(3.5, 6, by = 0.50)) +
  labs(x = "Distance to city center (miles)",y = "ln(price, US dollars)")+
  theme_bw() 
f3


# LOG-LOG LINEAR REGRESSION 
reg4 <- feols(lnprice ~ lndistance, data=hotels)
reg4

f4 <- ggplot(data = hotels, aes(x = lndistance, y = lnprice)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ x)+
  #scale_x_continuous(limits=c(-2.5, 2), breaks=seq(-2.5, 2, by=0.5)) + 
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(3.5, 6), breaks = seq(3.5, 6, by = 0.50)) +
  labs(x = "ln(distance to city center, miles)",y = "ln(price, US dollars)")+
  theme_bw() 
f4

#####
# Checking and comparing all models:
etable( reg1 , reg2 , reg3 , reg4 , 
        headers = c('Level-Level','Level-Log','Log-Level','Log-Log'))

# Visually
if (!require(ggpubr)){
  install.packages("ggpubr")
  library(ggpubr)
}

reg_figs1 <- ggarrange(f1, f2, f3, f4,
                    labels = c("Level-Level", "Log-Level", "Level-Log","Log-Log"),
                    hjust = -0.6,
                    ncol = 2, nrow = 2)
reg_figs1


###
# Using polynomials:
hotels <- hotels %>% mutate( dist_sq = distance^2,
                             dist_cb = distance^3 )
# Single squared
reg5 <- feols( price ~ distance + dist_sq , data = hotels )
reg5

f5 <- ggplot(data = hotels, aes(x = distance, y = price)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ poly(x,2) )+
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7), breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")+
  theme_bw() 
f5



# Squared and cubic
reg6 <- feols( price ~ distance + dist_sq + dist_cb , data = hotels )
reg6

f6 <- ggplot(data = hotels, aes(x = distance, y = price)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ poly(x,3) )+
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7), breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")+
  theme_bw() 
f6

###
# Linear Spline

if (!require(lspline)){
  install.packages("lspline")
  library(lspline)
}
cutoff <- 2
# Use simple regression with the lspline function
?lspline
reg7 <- feols( price ~ lspline( distance , cutoff ), data = hotels )
reg7

f7 <- ggplot(data = hotels, aes(x = distance, y = price)) +
  geom_point(color='red',size=1.5) + 
  geom_smooth(method = "lm", formula = y~ lspline( x , cutoff ) )+
  expand_limits(x = 0.01, y = 0.01) +
  scale_x_continuous(expand = c(0.01,0.01), limits=c(0, 7), breaks=seq(0, 7, by=1)) + 
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0, 400), breaks = seq(0, 400, by = 50)) +
  labs(x = "Distance to city center (miles)",y = "Price (US dollars)")+
  theme_bw() 
f7

##
# Compare these non-linear models:
# 
etable( reg1 , reg5 , reg6 , reg7 )

reg_figs2 <- ggarrange( f1 , f5, f6, f7,
                       labels = c("Linear", "Squared", "Cubic","L.Spline"),
                       hjust = -1,
                       ncol = 2, nrow = 2)
reg_figs2


