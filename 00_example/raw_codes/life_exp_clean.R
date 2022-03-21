#######################
## Analysis of       ##
##  Life expectancy  ##
##    and            ##
##  GPD/capita       ##
##                   ##
##      NO. 2        ##
##                   ##
## Cleaning the data ##
##                   ##
#######################



# Clear memory
rm(list=ls())

library(tidyverse)
library(modelsummary)

# Call the data from github
my_url <- "https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/00_example/data/raw/WDI_lifeexp_raw.csv"
df <- read_csv( my_url )

## Check the observations:
#   Lot of grouping observations
#     usually contains a number
d1 <- df %>% filter(grepl("[[:digit:]]", df$iso2c))
d1
# Filter these out
df <- df %>% filter( !grepl("[[:digit:]]", df$iso2c) )

# Some grouping observations are still there, check each of them
#   HK - Hong Kong, China
#   OE - OECD members
#   all with starting X, except XK which is Kosovo
#   all with starting Z, except ZA-South Africa, ZM-Zambia and ZW-Zimbabwe

# 1st drop specific values
drop_id <- c("EU","HK","OE")
# Check for filtering
df %>% filter( grepl( paste( drop_id , collapse="|"), df$iso2c ) ) 
# Save the opposite
df <- df %>% filter( !grepl( paste( drop_id , collapse="|"), df$iso2c ) ) 

# 2nd drop values with certain starting char
# Get the first letter from iso2c
fl_iso2c <- substr(df$iso2c, 1, 1)
retain_id <- c("XK","ZA","ZM","ZW")
# Check
d1 <- df %>% filter( grepl( "X", fl_iso2c ) | grepl( "Z", fl_iso2c ) & 
                       !grepl( paste( retain_id , collapse="|"), df$iso2c ) ) 
# Save observations which are the opposite (use of !)
df <- df %>% filter( !( grepl( "X", fl_iso2c ) | grepl( "Z", fl_iso2c ) & 
                        !grepl( paste( retain_id , collapse="|"), df$iso2c ) ) ) 

# Clear non-needed variables
rm( d1 , drop_id, fl_iso2c , retain_id )
  
### 
# Check for missing observations
m <- df %>% filter( !complete.cases( df ) )
# Drop if life-expectancy, gdp or total population missing -> if not complete case except iso2c
df <- df %>% filter( complete.cases( df ) | is.na( df$iso2c ) )

###
# CLEAN VARIABLES
#
# Recreate table:
#   Rename variables and scale them
#   Drop all the others !! in this case write into readme it is referring to year 2018!!
df <-df %>% transmute( country = country,
                        population=SP.POP.TOTL/1000000,
                        gdppc=NY.GDP.PCAP.PP.KD/1000,
                        lifeexp=SP.DYN.LE00.IN )

###
# Check for extreme values
# all HISTOGRAMS
df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") +
  geom_histogram(bins=30)

# It seems we have a large value(s) for population:
df %>% filter( population > 500 )
# These are India and China... not an extreme value

# Check for summary as well
datasummary_skim( df )

# Save the raw data file for your working directory
my_path <- 'ENTER YOUR OWN PATH'
write_csv( df, paste0(my_path,'data/clean/WDI_lifeexp_clean.csv'))

# I have pushed it into github as well!



