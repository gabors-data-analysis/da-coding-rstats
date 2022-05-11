###############################################
#                                             #
#               Lecture 17                    #
#                                             #
#    Date and time manipulations in R         #
#     -        #
#                                             #
# Case Study:                                 # 
#   SP500 stock prices                        #
#                                             #
###############################################

# clear memory
rm( list = ls() )

# Call packages
library(tidyverse)
library(tidyquant)
if (!require(lubridate)){
  install.packages("lubridate")
  library(lubridate)
}
if (!require(aTSA)){
  install.packages("aTSA")
  library(aTSA)
}

##############
##          ##
##  PART I  ##
##          ##
##############


# You can get the actual date:
today()
# or 
now()
# Note the difference: 
#   today() only gives the day, 
#   now() gives the exact time with the used time zone!


###
# Reading time-format/converting to date_time
#
# String to date: 
#   usually you import string vector -> need to convert to datetime format
str <- "2020-12-10"
dtt <- ymd( str )
class( dtt )

# with lubridate you should use different functions to read different formats of date
#   alternatively you can use base function: `as.Date( str_vec , "%Y/%m/%d", tz="cet")'
#
# Automatically recognise format (in most cases)
# Month-Day-Year
mdy('January 31st, 2017')
mdy('01-31-2017')
# Day-Month-Year
dmy("31-01-2020")
dmy(31012020)
# ect...

# If hours-minutes-seconds are also important (Coordinated Universal Time - UTC := Greenwich Mean Time)
ymd_hms("2020-02-13 13:15:58")
# or
mdy_hm("02/16/2023 09:01")

# You can set the time zone as well to Central European Time (CET)
ymd_hms("2020-02-13 13:15:58", tz = "CET" )

# Sometimes you have separately the year-month-day variables and want to combine them to one:
make_date(year="1995",month="10",day='15')
# Also works with hours/minutes, and with doubles
make_datetime(1995,10,15,5,32,tz="CET")

##
# Get parts of datetime
#
# In some cases you want to simplify/get parts of your date or want to control for seasonality:
# Get the year component
year("2020-12-20")
# Get quarter component
quarter("2020-12-20")
# Get the month component
month("2020-12-20")
# day of the month. day() would also work
mday("2020-12-20") 
# But maybe you are interested which day of this is in a week (1-Monday, 2-Thuesday,ect.)
#   This is handy if your seasonality has a week base.
wday("2020-12-20") 
# Some occasion you are interested in the number of day within a year
yday("2020-12-20") 
# Check for leap year
leap_year("2020-12-20")

##
# Rounding
#
# In some cases you want to round your datetime variable to a certain level (not really often used...)
dt <- ymd("2020-12-20")
# Get the first day of the month
floor_date(dt,"month")
# Get the first or last day in the month depending which is closer
round_date(dt,"month")
# Get the first day for the next month
ceiling_date(dt,"month")

##
# Task:
# Do the rounding for quarters

##
# Time spans - duration vs periods
#
# Duration: how much time spent between to time: now and the first class in DA1
my_study <- today() - ymd(20200928)
my_study
# This creates a time object, which can be used in many ways!
class(my_study)

# Calculate the duration
as.duration(my_study)

# You can make manipulations with durations!
dminutes(10) + dseconds(1)
tomorrow <- today() + ddays(1)
last_year <- today() - dyears(1)

# As you see, you have to be careful with duration, 
#   because it uses actual duration in a year and neglects the time zone
#
# Fix: periods
#
last_year2 <- today() - years(1)
#
# Can use more days or other frequencies
today() - days(c(1,2,3,4))


###############
##           ##
##  PART II  ##
##           ##
###############

rm( list = ls())

# Date-Time-Manipulations
# We have three data-tables:
#   1) US GDP levels - quarterly from 1979Q1 -
#   2) Inflation (CPI level) - monthly from 1978-12 
#   3) SP500 closing prices - daily from 1997-12-31 - 2018-12-31
#
# You can check the ticker name on FRED
#
# We want to make them into the same tibble with same time frequency
#   Need to aggregate everything to quarterly level with time interval between 1997-2018


# GDP (millions of Dollars): using Fred database through tidyquant's tq_get package
gdp <- tq_get( "GDP" , get = "economic.data", from = "1979-01-01") %>% 
        select( date , price ) %>% 
        rename( gdp = price )

head( gdp )

# Inflation (CPI): using Fred database through tidyquant's tq_get package
inflat <- tq_get( "USACPIALLMINMEI" , get = "economic.data", from = "1978-01-01") %>% 
  select( date , price )

head(inflat)
# We want year-on-year changes
inflat <- mutate( inflat, inflat = price - lag( price , 12 ) )
# And filter from 1979-01-01
inflat <- inflat %>% filter( date >= "1979-01-01")

head(inflat)

# SP500 Stock Prices
sp500 <- read_csv("https://osf.io/fpkm4/download") %>% 
  select( date , p_SP500 ) %>% 
  rename( price =  p_SP500 )

head(sp500)


##
# GDP:
# Plot time-series
ggplot( gdp , aes( x = date , y = gdp ) )+
  geom_line(color = 'red',size=1) +
  labs(x="Year",y="GDP (billions)") +
  theme_bw()
# Highly exponentially trending (and there is seasonality)...

##
# Inflation 
# Plot time-series
ggplot( inflat , aes( x = date , y = inflat ) )+
  geom_line( color = 'red', size = 1 ) +
  labs(x="Year", y="Inflation") +
  theme_bw()
# Seems like stationary, but it is not... (we will see)

##
# SP500 prices

# Plot time-series
ggplot( sp500 , aes( x = date , y = price) )+
  geom_line( color = 'red',size=0.5) +
  labs(x="Date",y="Price ($)") +
  theme_bw()
# Classical random walk


######
# Aggregation: put everything into the same frequency
#

# Base data-table is GDP
df <- gdp %>%  transmute( time = date , gdp = gdp )
rm( gdp )
##
# 1st: Aggregate inflat to quarterly frequency:
# Add years and quarters
inflat <- inflat %>% mutate( year = year( date ),
                             quarter = quarter( date ) )

# Average for inflation (median or other measure is also good if reasonable)
agg_inflat <- inflat %>% select( year, quarter , inflat ) %>% 
  group_by( year , quarter ) %>% 
  summarise( inflat = mean( inflat ) )

# Add time and select variables
agg_inflat$time <- yq( paste0( agg_inflat$year , "-" , agg_inflat$quarter ) )
agg_inflat      <- agg_inflat %>% select( time , inflat )

# Join to df
df <- left_join( df , agg_inflat , by = "time" )
rm( agg_inflat, inflat )

##
# 2nd: Aggregate SP500 prices to quarterly frequency:
# Add years and quarters
sp500 <- sp500 %>% mutate( year = year( date ),
                          quarter = quarter( date ) )

# Last day for each quarters ('closing price')
agg_sp500 <- sp500 %>% select( date, year, quarter, price ) %>% 
            group_by( year, quarter ) %>% 
            filter( date == max( date ) ) %>% ungroup()

# Adjust the time for left_join
agg_sp500$time <- yq( paste0( agg_sp500$year , "-" , agg_sp500$quarter ))
# Join to df
df <- left_join( df , select( agg_sp500 , time , price ) , by = "time" )
rm( agg_sp500, sp500)

# Keep only complete cases - !!!USE WITH CARE!!!
df <- df[ complete.cases( df ) , ]


###
# Visualization of the data:

# NO 1: check the time-series in different graphs:

# need a trick to create a new stacked data
df_aux <- gather(df, key = measure, value = Rate, 
                 c("gdp", "inflat", "price"))

ggplot( df_aux, aes(x=time, y = Rate , color = measure ) ) + 
  geom_line() +
  facet_wrap( ~ measure , scales = "free" ,
              labeller = labeller( measure = c("price"="SP500 price","gdp"="GDP (millions)",
                                               "inflat"="Inflation (%)") ),
              ncol = 1) +
  labs( x = 'Years' , y = '' ) +
  guides(color = "none" ) +
  theme_bw()

rm(df_aux)

###
# Analyzing time-series properties:
#

##
# UNIT-ROOT TESTS

# Philips-Perron test for unit-root:
# Type 1: y_t = rho * y_t-1 + eps
# Type 2: y_t = alpha + rho * y_t-1
# Type 3: y_t = alpha + delta * t + rho * y_t-1 (Neglect this output!)
#   Reason to neglect: the power of this test is low (agianst e.g. seasonality)
pp.test( df$gdp , lag.short = F)
pp.test( df$inflat , lag.short = F)
pp.test( df$price , lag.short = F)

# Inflation is non-stationary, but unless we accept Type 2. The other two are clearly non-stationary.
# Lets check percent change for gdp and price and differenced value for inflation:
df <- df %>% mutate( dgdp = ( gdp - lag(gdp,1) ) / gdp * 100 ,
                     dinflat = inflat - lag(inflat,1),
                     return = ( price - lag(price,1) ) / price * 100 )

##
# Task
# Check again the Philip-Perron tests!
pp.test( df$dgdp    , lag.short = F)
pp.test( df$dinflat , lag.short = F)
pp.test( df$return  , lag.short = F)


# Visualization2:
# NO 2: standardization - good to compare the (co)-movement
#   !!TAKE CONCLUSION ONLY IF STATIONARY!!
stdd <- function( x ){ ( x - mean( x , rm.na = T ) ) / sd( x , na.rm = T ) }

ggplot( filter(df,complete.cases(df)) , aes( x = time ) ) +
  geom_line( aes( y = stdd( dgdp )    , color = "dgdp" ) ) +
  geom_line( aes( y = stdd( dinflat )  , color = "dinflat" ) ) +
  geom_line( aes( y = stdd( return )  , color = "return") ) +
  scale_color_manual(name = "Variable",
                     values = c( "dgdp" = "red", 
                                 "dinflat" = "blue",
                                 "return" = "green"),
                     labels = c("dgdp" = "GDP change", 
                                "dinflat"="Inflation change",
                                "return"="SP500 return")) +
  labs(x="Years",y="Standardized values")+
  theme_bw()
# More or less moving together!


# For association, can check scatter plots: 

# GDP and inflation
ggplot( df , aes( x = dgdp , y = dinflat ) ) +
  geom_point( size = 1 , color = 'red' ) +
  geom_smooth(method='lm',formula=y~x,se=F) +
  labs( x = 'GDP quarterly change (%)', y = 'Inflation YoY change (%)' ) +
  theme_bw()

# GDP and SP500 returns
ggplot( df , aes( x = dgdp , y = return ) ) +
  geom_point( size = 1 , color = 'red' ) +
  geom_smooth(method='lm',formula=y~x,se=F) +
  labs( x = 'GDP quarterly change (%)', y = 'SP500 quarterly returns (%)' ) +
  theme_bw()

# SP500 returns and inflation
ggplot( df , aes( x = return , y = dinflat ) ) +
  geom_point( size = 1 , color = 'red' ) +
  geom_smooth(method='lm',formula=y~x,se=F) +
  labs( x = 'SP500 quarterly returns (%)', y = 'Inflation YoY change (%)' ) +
  theme_bw()

