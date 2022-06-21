###############################################
#                                             #
#               Lecture 18                    #
#                                             #
#   Introduction to Time-Series Analysis      #
#     - time-series data manipulations        #
#     - data explorations:                    #
#         - descriptive + graphs              #
#         - auto-correlation                  #
#     - model with feols                      #
#         - setup feols w panel.id            #
#         - Newey-West standard errors        #
#         - lagged variables                  #
#         - cumulative effects w SEs          #
#                                             #
# Case Study:                                 # 
#   Arizona Electricity Consumption           #
#                                             #
###############################################

# Clear memory
rm(list=ls())

# Import libraries
library(tidyverse)
library(modelsummary)
library(fixest)
library(ggpubr)
library(scales)
library(lubridate)
if (!require(devtools)){
  install.packages('devtools')
  library(devtools)
}


####
# Importing Data
#
# 1st source: climate data  (cooling degree days etc, by month)
climate <- read_csv('https://osf.io/g3tj7/download')
# and convert them into date format as well: here we have an easier implemented format
climate <- climate %>% mutate( tempdate = ym( DATE ) )

# Add the same variables
climate <- climate %>% mutate(year     = year( tempdate ),
                              month    = month( tempdate ) ,
                              ym       = format( tempdate, '%Ym%m'))

# Data manipulation with time-series data:
# 1) Generate averages from sums:
#     when dividing by N, must take into account N of days
climate <-  climate %>% mutate( ndays = ifelse( month %in% c(1, 3, 5, 7, 8, 10, 12) , 31 ,
                                                ifelse(month == 2,28,30 ) )
)
# Focus on cooling degree, heating degree 
climate <- climate %>% mutate_at( c( 'CLDD', 'HTDD' ) , list( avg = ~./ndays) )

# Drop the others
climate <- climate %>% select(-c('DATE', 'tempdate', 'STATION', 'NAME','DX32','DX70','DX90'))

# Check the descriptive
datasummary( CLDD_avg + HTDD_avg ~ Mean + Median + SD + Min + Max , data = climate )


##
# 2nd source: the electricity consumption data (monthly data)
electricity <- read_csv('https://osf.io/wbef4/download')

# Convert 'MY' variable into numeric format
electricity <- electricity %>% mutate( date = parse_date_time( as.character( MY ), orders = 'my' ) )

# Convert it into date-time
electricity <- electricity %>% mutate( date = ymd( date ) )

# We can create different time variables:
# year -> the actual year
# month -> the actual month
# format -> create your own format
electricity <- electricity %>% mutate(year  = year( date ),
                                      month = month( date ),
                                      ym    = format( electricity$date,'%Ym%m') )

# Remove MY, year and month variables
electricity <- electricity %>% select(-c('MY','year','month'))

# Take logs of q (used electricity)
electricity <- electricity %>% mutate(lnQ = log(Q))


###
# Merging the two data
df <- inner_join( climate , electricity , by = 'ym' )
rm(electricity, climate)

# Restrict the sample between years 2001 and 2017
df <- df %>% filter( year >= 2001 & year <= 2017)

# Ensure date is a date format
df <- df %>% mutate( date = ymd( date ) )


##
# DATA EXPLORATION

# Overall descriptive
datasummary( Q + lnQ + CLDD_avg + HTDD_avg ~ Mean + Median + SD + Min + Max + N , data = df )


# PLOT THE TIME SERIES

# Consumption
p1 <- ggplot(data = df, aes(x = date, y = Q))+
  geom_line(color = 'red', size = 0.7) +
  ylab('Residential electricity consumption (GWh)') +
  xlab('Date (month)') +
  scale_y_continuous(limits = c(1000,5000), breaks = seq(1000,5000,1000)) +  
  scale_x_date(breaks = as.Date(c('2001-01-01','2004-01-01',  '2007-01-01', '2010-01-01','2013-01-01','2016-01-01')),
             limits = as.Date(c('2001-01-01','2017-12-31')), labels = date_format('%b %Y')) +
    theme_bw()
p1

# Log-consumption
p2 <- ggplot(data = df, aes(x = date, y = lnQ))+
  geom_line(color = 'red', size = 0.7) +
  ylab('ln(residential electricity consumption, GWh)') +
  xlab('Date (month)') +
  scale_y_continuous(limits = c(7,8.5), breaks = seq(7,8.5,0.25)) +  
  scale_x_date(breaks = as.Date(c('2001-01-01','2004-01-01',  '2007-01-01', '2010-01-01','2013-01-01','2016-01-01')),
               limits = as.Date(c('2001-01-01','2017-12-31')), labels = date_format('%b %Y')) +
  theme_bw()
p2 

# Cooling degrees
p3 <- ggplot(data = df, aes(x = date, y = CLDD_avg))+
  geom_line(color = 'red', size = 0.7) +
  ylab('Cooling degrees (Farenheit)') +
  xlab('Date (month)') +
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0,35), breaks = seq(0,35,5)) +  
  scale_x_date(breaks = as.Date(c('2001-01-01','2004-01-01',  '2007-01-01', '2010-01-01','2013-01-01','2016-01-01')),
               limits = as.Date(c('2001-01-01','2017-12-31')), labels = date_format('%b %Y')) +
  theme_bw()
p3

# Heating degrees
p4 <- ggplot(data = df, aes(x = date, y = HTDD_avg))+
  geom_line(color = 'red', size = 0.7) +
  ylab('Heating degrees (Farenheit)') +
  xlab('Date (month)') +
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0,14), breaks = seq(0,14,2)) +  
  scale_x_date(breaks = as.Date(c('2001-01-01','2004-01-01',  '2007-01-01', '2010-01-01','2013-01-01','2016-01-01')),
               limits = as.Date(c('2001-01-01','2017-12-31')), labels = date_format('%b %Y')) +
  theme_bw()
p4

# Plot all of them together - reset the labels
ggarrange(p1 + scale_x_date(date_breaks = '3 years', date_labels = '%Y') + 
               theme( axis.title = element_text( size = 8 ),
                      axis.text = element_text( size = 8 ) ) ,
          p2 + scale_x_date(date_breaks = '3 years', date_labels = '%Y') + 
            theme( axis.title = element_text( size = 8 ),
                   axis.text = element_text( size = 8 ) ) ,
          p3 + scale_x_date(date_breaks = '3 years', date_labels = '%Y') + 
            theme( axis.title = element_text( size = 8 ),
                   axis.text = element_text( size = 8 ) ) ,
          p4 + scale_x_date(date_breaks = '3 years', date_labels = '%Y') + 
            theme( axis.title = element_text( size = 8 ),
                   axis.text = element_text( size = 8 ) ) ,
          hjust = -0.6, ncol = 2, nrow = 2 ) 


####
# Time-series specific analysis

# 1) Serial correlation: a.k.a. Auto-correlation
source_url( 'https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/lecture18-timeseries-regression/raw_codes/ggplot.acorr.R' )

# ACF - gives the correlation between y_t and lags: Corr(y_t,y_t-lag)
# PACF - (Partial Autocorrelation Fnc)
#     shows the correlation between Corr(y_t,y_t-lag) | Corr( y_t , y_t-lag-1 )
#     thus what is the correlation between y_t and y_t-lag if 
#       we have controlled for the previous lags already!
#
# In both graph the dashed lines gives 95% CI for statistical value = 0
#   In ACF it means if bars within the line we have a White-Noise: Corr = 0

# Log of electricity consumption
ggplot.acorr( df$lnQ , lag.max = 24, ci= 0.95, 
              large.sample.size = F, horizontal = TRUE)
# Cooling degree
ggplot.acorr( df$CLDD_avg , lag.max = 24, ci= 0.95, 
              large.sample.size = F, horizontal = TRUE)
# Heating degree
ggplot.acorr( df$HTDD_avg , lag.max = 24, ci= 0.95, 
              large.sample.size = F, horizontal = TRUE)


# Solution --> Create differences
df <- df %>% mutate(DlnQ=lnQ-lag(lnQ),
                        DCLDD_avg=CLDD_avg-lag(CLDD_avg),
                        DHTDD_avg=HTDD_avg-lag(HTDD_avg)
                        )

##
# functional form investigations 
ggplot(data = df, aes(x=DCLDD_avg, y=DlnQ)) +
  geom_point(size=1,  shape=20, stroke=2, fill='blue', color='blue') +
  geom_smooth(method='loess', se=F, colour='black', size=1.5, span=0.9 , formula = y ~ x) +
  labs(x = 'Cooling degrees (Farenheit), first difference',
       y = 'ln(monthly electricity consumption), first difference') +
  scale_x_continuous(limits = c(-20,20), breaks = seq(-20,20, 10)) +
  theme_bw()

ggplot(data = df, aes(x=DHTDD_avg, y=DlnQ)) +
  geom_point(size=1,  shape=20, stroke=2, fill='blue', color='blue') +
  geom_smooth(method='loess', se=F, colour='black', size=1.5, span=0.9 , formula = y ~ x) +
  labs(x = 'Heating degrees (Farenheit), first difference',
       y = 'ln(monthly electricity consumption), first difference') +
  scale_x_continuous(limits = c(-10,10), breaks = seq(-10,10, 10)) +
  theme_bw()

######################
# Linear regressions
#
# reg1: DlnQ = alpha + beta_1 * DCLDD_avg + beta_2 * DHTDD_avg
# reg2: DlnQ = alpha + beta_1 * DCLDD_avg + beta_2 * DHTDD_avg + months
# reg3: DlnQ = alpha + gamma * lag( DlnQ ) + beta_1 * DCLDD_avg + beta_2 * DHTDD_avg + months
# reg4: DlnQ = alpha + beta_1 * DCLDD_avg + beta_2 * DHTDD_avg + months + 2 LAGS of DCLDD_avg and DHTDD_avg
# reg_cumSE: use reg4 but estimate standard errors for the cumulative effect

# Need to add a new variable which is telling fixest that it is a time-series data and not panel:
#   period is changing as date, but id is the same
df <- df %>% mutate( period = 1 : nrow( df ) , id = 1 )


# Run reg1 with, Newey-West SE
reg1 <- feols( DlnQ ~ DCLDD_avg + DHTDD_avg, data = df , 
               panel.id = ~ id + period , vcov = NW(24) )
reg1

# Run reg2 with, Newey-West SE
reg2 <- feols(DlnQ ~ DCLDD_avg + DHTDD_avg + as.factor(month), data=df, 
              panel.id = ~ id + period , vcov = NW(24) )
reg2 

# Compare the two models
etable( reg1 , reg2 )

# reg3: include the lag of DlnQ:
reg3 <- feols( DlnQ ~ l( DlnQ , 1 ) + DCLDD_avg + DHTDD_avg + as.factor(month), 
               data=df, panel.id = ~ id + period , vcov = NW(24) )
reg3

# reg4: include the lag of heating/cooling degrees up to two lags
reg4 <- feols( DlnQ ~ l( DCLDD_avg , 0 : 2 ) + l( DHTDD_avg , 0 : 2 ) + as.factor(month), 
               data = df, panel.id = ~ id + period , vcov = NW(24) )
reg4

# Compare the results:
etable( reg1 , reg2 , reg3 , reg4 )
# Note: to be fair, one needs to use a restricted sample with 201 observations in this case!

etable( reg1 , reg2 , reg3 , reg4 , drop = 'factor' , se.below = T )

# Task:
# Replicate these results, but now using the same sample for each model to ensure fair comparison!
# You should have the same number of observations in the end





####
# Trick to estimate SE on the cumulative effect
# 1) create double differenced variable
df <- df %>% mutate( DDCLDD_avg = DCLDD_avg - lag( DCLDD_avg ) ,
                     DDHTDD_avg = DHTDD_avg - lag( DHTDD_avg ) )

reg_cumSE <- feols( DlnQ ~ l( DCLDD_avg , 2 ) + l( DHTDD_avg , 2 ) +
                           l( DDCLDD_avg , 0:1 ) + l( DDHTDD_avg , 0:1 ) + as.factor(month), 
                    data=df, panel.id = ~ id + period , vcov = NW(24) )
reg_cumSE

# Compare the results
etable( reg4 , reg_cumSE )
# Remark - from reg4: DCLDD_avg+l(DCLDD_avg,1)+l(DCLDD_avg,2) == reg_cumSE: l(DCLDD_avg,2)
#   extra: for reg_cumSE: l(DCLDD_avg,2) we have SE as well!
#   same for l(DHTDD_avg,2)





