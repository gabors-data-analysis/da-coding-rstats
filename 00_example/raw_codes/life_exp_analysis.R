#######################
## Analysis of       ##
##  Life expectancy  ##
##    and            ##
##  Total GDP        ##
##      OR           ##
##  GPD/capita       ##
##                   ##
##      NO. 3        ##
##                   ##
## Analysis of       ##
#       the data     ##
##                   ##
#######################



# Clear memory
rm(list=ls())

# Packages to use
library(tidyverse)
# Estimate piecewise linear splines
library(lspline)
# Fixest for estimating
library(fixest)
# For scaling ggplots
require(scales)

# Call the data from github
my_url <- "https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/00_example/data/clean/WDI_lifeexp_clean.csv"
df <- read_csv( my_url )



####
# 
# Quick check on all HISTOGRAMS and descriptives


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
# Tip: you can use `cale_x_continuous( trans = log_trans() )` with scales
#   this is good as you can check without creating a new variable

# 3) Change the scale for Total GDP and life-expectancy for checking log-transformation


## Model B) lifeexp = alpha + beta * gdppc:
# 4) lifeexp - gdppc: level-level model without scaling


# 5) Change the scale for GDP/capita for checking log-transformation


# 6) Change the scale for GDP/capita and life-expectancy for checking log-transformation


####
# You should reach the following conclusions:
#   1) taking log of gdptot is needed, but still non-linear pattern in data/need to use 'approximation' interpretation
  #     - feasible to check and we do it due to learn how to do it, 
  #           but in practice I would skip this -> over-complicates analysis
#   2) using only gdppc is possible, but need to model the non-linearity in data
#       - Substantive: Level changes is harder to interpret and our aim is not to get $ based comparison
#       - Statistical: log transformation is way better approximation make simplification!
#   3) taking log of gdppc is making the association close to linear!
#   4) taking log for life-expectancy does not matter -> use levels!
#       - Substantive: it does not give better interpretation
#       - Statistical: you can compare models with the same y, no better fit
#       - Remember: simplest the better!
  

# Create new variables: 
#   ln_gdppc  = Log of gdp/capita 
#   ln_gdptot = log GDP total


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


# 2) Use 'poly(x,n)' functions in graphs ONLY, which creates polynomials of x up to order n
#     ( may use it for models: 
#                   positive - simpler, less new variables, 
#                   negative - uglier names, harder to compare 
#       Note: poly() creates rotates your variables automatically to get mean independent variables
#         use raw = TRUE if you dont want to rotate your variables. )

# Do the regressions
##
# reg1: lifeexp = alpha + beta * ln_gdptot
# + Plot

##
# reg2: lifeexp = alpha + beta_1 * ln_gdptot + beta_2 * ln_gdptot^2
# + Plot

##
# reg3: lifeexp = alpha + beta_1 * ln_gdptot + beta_2 * ln_gdptot^2 + beta_3 * ln_gdptot^3
# + Plot

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
# 2nd take care of log transformation -> cutoff needs to be transformed as well
# reg6: lifeexp = alpha + beta_1 * ln_gdppc * 1(gdppc < 50) + beta_2 * ln_gdppc * 1(gdppc >= 50)
# + plot

##
# Extra
# Weighted-OLS: use reg4 setup and weight with population
# Can be done with the `weights = df$population` input!


# Created a pretty graph for visualize this method:
ggplot(data = df, aes(x = ln_gdppc, y = lifeexp)) +
  geom_point(data = df, aes(size=population),  color = 'blue', shape = 16, alpha = 0.6,  show.legend=F) +
  geom_smooth(aes(weight = population), method = "lm", color='red')+
  scale_size(range = c(1, 15)) +
  coord_cartesian(ylim = c(50, 85)) +
  labs(x = "ln(GDP per capita, thousand US dollars) ",y = "Life expectancy  (years)")+
  annotate("text", x = 4, y = 80, label = "USA", size=5)+
  annotate("text", x = 2.7, y = 79, label = "China", size=5)+
  annotate("text", x = 2,  y = 68, label = "India", size=5)


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

# feols output is a `list` (to be more precise an `object') with different elements
# Check the `Value` section
?feols

# Get the predicted y values from the model

# Calculate the errors of the model and show it on a scatter plot

# Find countries with largest negative errors


# Find countries with largest positive errors









  
