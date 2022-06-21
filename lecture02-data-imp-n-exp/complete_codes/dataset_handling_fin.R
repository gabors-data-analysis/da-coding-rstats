##################################
#                                #
#          Lecture 02            #
#                                #
#    Import and Export Data      #
#       to R with                #
#                                #
#     - Importing with clicking  #
#     - read_csv():              #
#       - local and url          #
#       - working directory      #
#     - Export                   #
#       - write_csv              #
#       - xlsx package           #
#       - save to RData          #
#     - API:                     #
#       - tidyquant and WDI      #
#                                #
#                                #
##################################

rm( list = ls() )
# Tidyverse includes readr package 
#  which we use for importing data!
library( tidyverse )



####################
## Importing data:
# 3 options to import data:


#####
#   1) Import by clicking: File -> Import Dataset -> 
#       -> From Text (readr) / this is for csv. You may use other to import other specific formats
#
# Notes: 
#   - Do this exercise to find your data and realize that importing this way will show up in the console.
#         if second option does not work, check the path on the console!
#   - Check the library, that the import command used: it is called 'readr' which is part of 'tidyverse'!
#         you should avoid calling libraries multiple times, thus if tidyverse is already imported,
#         there is no need to import readr again. 
#           (But in this case will not cause any problem. It may be a problem if you call different versions!)

#######
#   2) Import by defining your path:
#       a) use an absolute path (you have to know from root folder the path of your csv)

data_in <- '~/Documents/Egyetem/Bekes_Kezdi_Textbook/da-coding-rstats/lecture02-data-imp_n_exp/data/hotels_vienna/'
df_0      <- read_csv(paste0(data_in,'clean/hotels-vienna.csv'))

#       b) use relative path:
#           R works in a specific folder called `working directory`, that you can check by:
getwd()

# after that, you can set your working directory by:
setwd( data_in )
# and simply call the data
df_1      <- read_csv('clean/hotels-vienna.csv')


# delete your data
rm( hotels_vienna , df_0, df_1 )


########
#   3) Import by using url - this is going to be our preferred method at this course!
#     Note: importing from the web is almost inferior to use your local disc, 
#       but there are some exceptions:
#         a) The data is considerably large (>1GB)
#         b) It is important that there is no `refresh` or change in the data
#       in these case it is good practice to download to your computer the datas

# Can access (almost) all the dat from 'ISF'
# the hotels vienna dataset has the following url:
df <- read_csv(url('https://osf.io/y6jvb/download')) 


###
# Quick check on the data:

# glimpse on data
glimpse( df )

# Check some of the first observations
head( df )

# Have a built in summary for the variables
summary( df )


###########################
# Exporting your data:
#
# This is a special case: data_out is now the same as data_in (no cleaning...)
data_out <- paste0( data_in , '/export/' )
write_csv( df , paste0( data_out , 'my_csvfile.csv' ) )

# If due to some reason you would like to export as xls(x)
install.packages( 'writexl' )
library( writexl )
write_xlsx( df , paste0( data_out , 'my_csvfile.xlsx' ) )

# Third option is to save as an R object
save( df , file = paste0( data_out , 'my_rfile.RData' ) )

######
# Extra: using API
#   - tq_get - get stock prices from Yahoo/Google/FRED/Quandl, ect.
#   - WDI    - get various data from World Bank's site
#

# tidyquant
install.packages('tidyquant')
library(tidyquant)
# Apple stock prices from Yahoo
aapl <- tq_get('AAPL',
               from = '2020-01-01',
               to = '2021-10-01',
               get = 'stock.prices')

glimpse(aapl)

# World Bank
install.packages('WDI')
library(WDI)
# How WDI works - it is an API
# Search for variables which contains GDP
a <- WDIsearch('gdp')
# Narrow down the serach for: GDP + something + capita + something + constant
a <- WDIsearch('gdp.*capita.*constant')
# Get data
gdp_data <- WDI(indicator='NY.GDP.PCAP.PP.KD', country='all', start=2019, end=2019)

glimpse(gdp_data)

##
# Tasks:
#
# 1) Go to the webpage: https://gabors-data-analysis.com/ and find OSF database under `Data and Code`
# 2) Go the the Gabor's OSF database and download manually 
#       the `hotelbookingdata.csv` from `hotels-europe` dataset into your computer and save it to 'raw' folder.
# 3) load the data from this path
# 4) also load the data directly from the web (note you need to add `/download` to the url)
# 5) write out this file as xlsx and as a .RData next to the original data.

# Load from path
df_t0 <- read_csv(paste0(data_in,'raw/hotelbookingdata.csv'))
# Load from wed
df_t1 <- read_csv('https://osf.io/yzntm/download')
# Write as xlsx
write_xlsx( df_t1 , paste0( data_out , 'hotelbookingdata.xlsx' ) )
# Write as .RData
save( df_t1 , file = paste0( data_out , 'hotelbookingdata.RData' ) )



