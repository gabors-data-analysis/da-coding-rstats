#############################################
#                                           #
#               Lecture 14                  #
#                                           #
#   Getting the data for analysis           #
#     - practice with WDI package           #
#                                           #
# Case Study:                               #
#  Life-expectancy and income               #
#                                           #
#############################################


# Clear memory
rm(list=ls())

# Call packages
if ( !require(WDI) ){
  install.packages('WDI')
  library(WDI)
}
library(tidyverse)


# Reminder on how WDI works - it is an API
# Search for variables which contains GDP
a <- WDIsearch('gdp')
# Narrow down the serach for: GDP + something + capita + something + constant
a <- WDIsearch('gdp.*capita.*constant')

# Get GDP data
gdp_data = WDI(indicator='NY.GDP.PCAP.PP.KD', country='all', start=2019, end=2019)

##
# Task: get the GDP data, along with `population, total' and `life expectancy at birth'
# for year 2019 and save to your raw folder!
# Note: I have pushed it to Github, we will use that later, just to be on the same page!
# Note this is only the raw files! I am cleaning them in a separate file and save the results to the clean folder!


