#############################################
#                                           #
#               Lecture 14                  #
#                                           #
#   Simple (Linear) Regressions             #
#     - multiple graphs and descriptive     #
#     - Scatterplots                        #
#         - to decide functional form       #
#         - to decide outcome variable      #
#     - Simple, nonlinear models:           #
#         - models with log                 #
#         - polynomials                     #
#         - piecewise linear spline         #
#         - extra: weighted OLS             #
#     - Residual analysis                   #
#         - with multiple annotations       #
#                                           #
# Case Study:                               #
#  Life-expectancy and income               #
#                                           #
#############################################


# Clear memory
rm(list=ls())

# Packages to use
library(tidyverse)
library(modelsummary)
# Estimate piecewise linear splines
library(lspline)
library(fixest)
# For scaling ggplots
require(scales)

# Call the data from github
my_url <- 'https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/lecture14-simple-regression/data/clean/WDI_lifeexp_clean.csv'
df     <- read_csv(my_url)



####
# 
# Good-to-know: Quick check on all HISTOGRAMS
df %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~key, scales = 'free') +
  geom_histogram(bins=20)+
  theme_bw()

datasummary_skim(df)

######
# Create new variable: Total GDP = GDP per Capita * Populatio
#     note we could have download an other GDP total variable for this,
#     but for comparison purposes, let use the exact same data and 
#     concentrate on difference which are only due to transforming the variables.




######
# Check basic scatter-plots!
#   Two competing models:
#     A) lifeexp = alpha + beta * gdptot
#     B) lifeexp = alpha + beta * gdppc
#
# Where to use log-transformation? - level-level vs level-log vs log-level vs log-log
# Create the following graphs with loess:

## Model A) lifeexp = alpha + beta * gdptot
# 1) lifeexp - gdptot: level-level model without scaling


# 2) Change the scale for Total GDP for checking log-transformation
# Tip: you can use `scale_x_continuous(trans = log_trans())` with scales package
#     to make your graph pretty, use: breaks = c(1,2,5,10,20,50,100,200,500,1000,10000)
#   this is good as you can check without creating a new variable


# 3) Change the scale for Total GDP and life-expectancy for checking log-transformation


###
## Model B) lifeexp = alpha + beta * gdppc:
# 4) lifeexp - gdppc: level-level model without scaling


# 5) Change the scale for GDP/capita for checking log-transformation


# 6) Change the scale for GDP/capita and life-expectancy for checking log-transformation,
#     with breaks = seq(0, 120, by = 20))


####
# You should reach the following conclusions:
#   1) taking log of gdptot is needed, but still non-linear pattern in data/need to use 'approximation' interpretation
#       - feasible to check and we do it due to learn how to do it, 
#           but in practice I would skip this -> over-complicates analysis
#   2) using only gdppc is possible, but need to model the non-linearity in data
#       - Substantive: Level changes is harder to interpret and our aim is not to get $ based comparison
#       - Statistical: log transformation is way better approximation make simplification!
#   3) taking log of gdppc is making the association close to linear!
#   4) taking log for life-expectancy does not matter -> use levels!
#       - Substantive: it does not give better interpretation
#       - Statistical: you can compare models with the same y, no better fit
#       - Remember: the simpler the better!

####
# Create new variables: 
#   ln_gdppc  = Log of gdp/capita 
#   ln_gdptot = log GDP total  
# Take Log of gdp/capita and log GDP total



######
# Run the following competing models:
#   w ln_gdptot:
#     reg1: lifeexp = alpha + beta * ln_gdptot
#     reg2: lifeexp = alpha + beta_1 * ln_gdptot + beta_2 * ln_gdptot^2
#     reg3: lifeexp = alpha + beta_1 * ln_gdptot + beta_2 * ln_gdptot^2 + beta_3 * ln_gdptot^3
#   w ln_gdppc:
#     reg4: lifeexp = alpha + beta * ln_gdppc
#     reg5: lifeexp = alpha + beta_1 * ln_gdppc + beta_2 * ln_gdppc^2
#     reg6: lifeexp = alpha + beta_1 * ln_gdppc * 1(gdppc < 50) + beta_2 * ln_gdppc * 1(gdppc >= 50)
#   Extra: weighted-ols:
#     reg7: lifeexp = alpha + beta * ln_gdppc, weights: population

###
# Two ways to handle polynomials: 
#
# 1) Add powers of the variable(s) to the dataframe:

#
# 2) Use 'poly(x,n)' functions in graphs ONLY, which creates polynomials of x up to order n
#     use this approach for graphs! may use it for models: 
#                   positive - simpler, less new variables, 
#                   negative - uglier names, harder to compare
#     Note: poly() creates rotates your variables automatically to get mean independent variables
#       use raw = TRUE if you dont want to rotate your variables.

# Do the regressions
#
# Using `feols' with classical standard errors
# Reminder: formula: y ~ x1 + x2 + ..., note: intercept is automatically added


# First model:


# Visual inspection:


# Second and third model with gdptot

# Plot


# Compare these models with etable()

# From these you should consider reg1 and reg3 only!


##
# Models with gdp per capita:
# reg4: lifeexp = alpha + beta * ln_gdppc
# + plot


# reg5: lifeexp = alpha + beta_1 * ln_gdppc + beta_2 * ln_gdppc^2
# + plot


##
# Compare results with gdp per capita:

# Conclusion: reg5 is not adding new information

# Compare reg1, reg3 and reg4 to get an idea log transformation is a good idea:

# R2 measure is much better for reg4...


##
# Regression with piecewise linear spline:
# 1st define the cutoff for gdp per capita
cutoff <- 50
# 2nd take care of log transformation -> cutoff needs to be transformed as well
# reg6: lifeexp = alpha + beta_1 * ln_gdppc * 1(gdppc < 50) + beta_2 * ln_gdppc * 1(gdppc >= 50)
# + plot

# Use simple regression with the lspline function
?lspline



##
# Extra
# Weighted-OLS: use reg4 setup and weight with population
# Can be done with the `weights = df$population` input!


# Created a pretty graph for visualize this method:
ggplot(data = df, aes(x = ln_gdppc, y = lifeexp)) +
  geom_point(data = df, aes(size=population),  color = 'blue', shape = 16, alpha = 0.6,  show.legend=F) +
  geom_smooth(aes(weight = population), method = 'lm', color='red')+
  scale_size(range = c(1, 15)) +
  coord_cartesian(ylim = c(50, 85)) +
  labs(x = 'ln(GDP per capita, thousand US dollars) ',y = 'Life expectancy  (years)')+
  annotate('text', x = c(4.5, 2.7, 2), y = c(78, 80, 67), label = c('USA', 'China', 'India'), size=5)+
  theme_bw()


#####
# Compare reg4, reg6 and reg7 models with etable:



#####
# Based on model comparison your chosen model should be reg4 - lifeexp ~ ln_gdppc
#   Substantive: - level-log interpretation works properly for countries
#                - magnitude of coefficients are meaningful
#   Statistical: - simple model, easy to interpret
#                - Comparatively high R2 and captures variation well


######
# Residual analysis.


# Get the predicted y values from the model

# Calculate the errors of the model


# Find countries with largest negative errors
worst5 <- 

# Find countries with largest positive errors
best5 <- 

# Show again the scatter plot with bests and worst
ggplot(data = df, aes(x = ln_gdppc, y = lifeexp)) + 
  geom_point(color='blue') +
  geom_smooth(method = lm, color = 'red') +
  annotate('text', x = worst5$ln_gdppc, y = worst5$lifeexp - 1, label = worst5$country ,
           color = 'purple') +
  annotate('text', x = best5$ln_gdppc, y = best5$lifeexp + 1, label = best5$country ,
           color = 'green') +
  theme_bw()



