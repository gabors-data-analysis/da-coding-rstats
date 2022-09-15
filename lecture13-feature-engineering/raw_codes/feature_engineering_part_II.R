#######################################################
#                                                     #
#                Lecture 13                           #
#                                                     #
#       Feature Engineering                           #
#                                                     #
#                                                     #
#           PART II                                   #
#                                                     #
#   - Using bisnode data                              #
#     - imputing:                                     #
#       - A: replacing with mean or median            #
#       - B: outside knowledge to replace values      #
#       - C: introduce new value:                     #
#             - only for categorical values           #
#     - log transformation adjustment:                #
#         log(0) is -Inf -> adjust numerically        #
#     - create dummy variable(s) with                 #
#         multiple statements: using lead() function  #
#     - randomizing large data for visualization      #
#     - growth rate with log difference:              #
#           using lag() function                      #
#     - winsorizing                                   #
#                                                     #
# Data used:                                          #
#     bisnode dataset on firm default                 #
#                                                     #
#######################################################

rm(list = ls())

library(tidyverse)
library(modelsummary)
# Multiple ggplot in one graph (has dependencies)
if (!require(ggpubr)){
  if (!require(car)){
    install.packages('car')
  }
  install.packages('ggpubr')
  library(ggpubr)
}


##################
#   PART II      #
##################
#
# Bisnode data to show real-life situations for:
#   - imputing: 
#       - A: replacing with mean or median
#       - B: using outside knowledge to replace values
#       - C: introduce new value -> only for categorical values
#   - log transformation adjustment: log(0) is -Inf -> adjust numerically
#   - create dummy variable(s) with multiple statements: using lead() function
#   - randomizing large data for visualization
#   - growth rate with log difference: using lag() function
#   - winsorizing

rm(list = ls())

##
# Using bisnode data for firm exit
bisnode <- read_csv('https://osf.io/3qyut/download')

# Sample selection
# drop variables with many NAs
bisnode <- bisnode %>%
  select(-c(COGS, finished_prod, net_dom_sales, net_exp_sales, wages)) %>%
  filter(year !=2016) 

# add all missing year and comp_id combinations -
#     (originally missing combinations will have NAs in all other columns)
bisnode <- bisnode %>%
  complete(year, comp_id)

##
# Imputing:
# A) Replacing with mean or median:
#  number of employed in firm is a noisy measure with many missing value.
#   replace missing values with the mean or median
#   also add a flag variable for the imputed values (need to include in the model!)
bisnode <- bisnode %>%
  mutate(labor_avg_mod       = ifelse(is.na(labor_avg), mean(labor_avg, na.rm = TRUE) , labor_avg),
          labor_med_mod       = ifelse(is.na(labor_avg), median(labor_avg, na.rm = TRUE), labor_avg),
          flag_miss_labor_avg = as.numeric(is.na(labor_avg)))
##
# Task:
#   add `Nmiss` as a custom function to datasummary and check the 
#   mean, median, sd, N and Nmiss for labor_avg, labor_avg_mod, labor_med_mod


# Check how stats altered, discuss!

##
# Imputing:
# B) Using outside knowledge to replace values:
#  negative sales should not happen, thus we can overwrite it to a small value: 1
datasummary(sales ~ Mean + Min + Max, data = bisnode)
bisnode <- bisnode %>% mutate(sales = ifelse(sales < 0, 1, sales))
datasummary(sales ~ Mean + Min + Max, data = bisnode)

##
# Imputing:
# C) Categorical variables

# simplify some industry category codes and set missing values to 99
bisnode <- bisnode %>%
  mutate(ind2_cat = ind2 %>%
           ifelse(. > 56, 60, .)  %>%
           ifelse(. < 26, 20, .) %>%
           ifelse(. < 55 & . > 35, 40, .) %>%
           ifelse(. == 31, 30, .) %>%
           ifelse(is.na(.), 99, .))

datasummary(factor(ind2_cat) ~ N + Percent(), data = bisnode)

##
# Adjusting negative sale and for log transformation:
bisnode <- bisnode %>%
  mutate(ln_sales      = ifelse(sales > 0, log(sales), 0),
         sales_mil     = sales / 1000000,
         sales_mil_log = ifelse(sales > 0, log(sales_mil), 0))

##
# Creating 'status_alive' variable to decide if firm exists or not:
#
# generate status_alive; if sales larger than zero and not-NA, then firm is alive
bisnode  <- bisnode %>%
  mutate(status_alive = sales > 0 & !is.na(sales) %>%
           as.numeric(.))

# defaults in two years if there are sales in this year but no sales two years later
#   lead() function will take values for the same company two years ahead
bisnode <- bisnode %>%
  group_by(comp_id) %>%
  mutate(default = ((status_alive == 1) & (lead(status_alive, 2) == 0)) %>%
           as.numeric(.)) %>%
  ungroup()

# Select years before 2013
bisnode <- bisnode %>%
  filter(year <=2013)

# To speed up let take a randomly selected 5k companies
set.seed(123)
comp_id_f <- bisnode %>% select(comp_id) %>% sample_n(5000)
bisnode_s <- bisnode %>% filter(comp_id %in% comp_id_f$comp_id)


####
# Numeric vs factor representation:

# Numeric representation (good)
ggplot(bisnode_s, aes(x=sales_mil_log, y=default)) +
  geom_point(size=2,  shape=20, stroke=2, color='blue') +
  geom_smooth(method = 'lm', formula = y ~ poly(x,2), color='black', se = F, size=1)+
  geom_smooth(method='loess', se=F, colour='red', size=1.5, span=0.9) +
  labs(x = 'sales_mil_log',y = 'default') +
  theme_bw()

##
# Task: convert default to a factor variable and plot!
#   what is the problem? It is a bad idea to convert to a factor?


###
# Growth (%) in sales
# Take the lags but make sure only for the same company!
bisnode <- bisnode %>%
  group_by(comp_id) %>%
  mutate(d1_sales_mil_log = sales_mil_log - lag(sales_mil_log, 1)) %>%
  ungroup()

# Repeat random sample to include the new variables
bisnode_s <- bisnode %>% filter(comp_id %in% comp_id_f$comp_id)

# First measure for change in sales: take the sale change in logs
nw <- ggplot(bisnode_s, aes(x=d1_sales_mil_log, y=default)) +
          geom_point(size=0.1,  shape=20, stroke=2, fill='blue', color='blue') +
          geom_smooth(method='loess', se=F, colour='red', size=1.5, span=0.9) +
          labs(x = 'Growth rate (Diff of ln sales)',y = 'default') +
          theme_bw() +
          scale_x_continuous(limits = c(-6,10), breaks = seq(-5,10, 5))
nw

###
# Winsorized data:
#   - set (extreme) values to a certain (lower) value
#
# Note: winsorizing is the action to set manually a value
#       'censoring' is called if the values are already 'winsorized' 
#       thus it is unknown what was the original value, but can only see the set value
#         e.g. mother's wage who are at home is 0, however if she would work this value would be different
#       'truncation' is when we dropping certain values below or above a threshold from the data


#   create new variable and add flag variables for modelling
bisnode <- bisnode %>%
  mutate(flag_low_d1_sales_mil_log  = ifelse(d1_sales_mil_log < -1.5, 1, 0),
         flag_high_d1_sales_mil_log = ifelse(d1_sales_mil_log >  1.5, 1, 0),
         d1_sales_mil_log_mod       = ifelse(d1_sales_mil_log < -1.5, -1.5,
                                             ifelse(d1_sales_mil_log > 1.5, 1.5, d1_sales_mil_log))
 )

# Repeat random sample to include the new variables
bisnode_s <- bisnode %>% filter(comp_id %in% comp_id_f$comp_id)

# First measure for change in sales: take the sale change in logs but now winsorized!
w<- ggplot(bisnode_s, aes(x=d1_sales_mil_log_mod, y=default)) +
      geom_point(size=0.1,  shape=20, stroke=2, fill='blue', color='blue') +
      geom_smooth(method='loess', se=F, colour='red', size=1.5, span=0.9) +
      labs(x = 'Growth rate (Diff of ln sales)',y = 'default') +
      theme_bw() +
      scale_x_continuous(limits = c(-1.5,1.5), breaks = seq(-1.5,1.5, 0.5))
w

# Comparing pattern with and without winsorizing
ggarrange(nw, w + scale_x_continuous(limits = c(-6,10), breaks = seq(-5,10, 5)), nrow = 2) 


##
# Task:
# Show the effect of winsorizing: transformation of the original data
# put d1_sales_mil_log on x-axis and d1_sales_mil_log_mod to the y-axis

