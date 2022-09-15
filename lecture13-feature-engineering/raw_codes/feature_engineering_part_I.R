#######################################################
#                                                     #
#                Lecture 13                           #
#                                                     #
#       Feature Engineering                           #
#                                                     #
#                 PART I:                             #
#                                                     #
# - Using World-Management Survey Data                #
#  - Creating new variable(s) from multiple           #
#       already existing (mean of multiple variable)  #
#  - Grouping a categorical variable:                 #
#       countries to continents                       #
#  - Ordered variables:                               #
#     - creating an ordered factor                    #
#         from character or integer                   #
#     - creating an ordered                           #
#         from numeric                                #
#  - Factors or dummy variables:                      #
#       creating multiple dummies                     #
#  - Extra: intro to principal component analysis     #
#                                                     #
# Data used:                                          #
#     World-Management Survey Data                    #
#                                                     #
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
# Country details
if (!require(countrycode)){
  install.packages('countrycode')
  library(countrycode)
}
# Creating dummies
if (!require(fastDummies)){
  install.packages('fastDummies')
  library(fastDummies)
}

#################
#   PART I      #
#################
#
# World-Management Survey Data
#  - Creating new variable(s) from multiple already existing (mean of multiple variable)
#  - Grouping a categorical variable: countries to continents
#  - Ordered variables:
#     - creating an ordered factor variable from character or integer variables
#     - creating an ordered variable from numeric
#  - Factors or dummy variables: creating multiple dummies


###
# Import World-Management Survey Data
wms <- read_csv('https://osf.io/uzpce/download')


# Creating a continuous variable out of ordered variables:
# Trick: lean, perf and talent measures, but multiple variables.
#     matches will select these variables.
wms <- wms %>% 
  select(matches(c('lean','perf','talent'))) %>% 
  select(where(is.numeric)) %>%
  rowMeans(na.rm = TRUE) %>% 
  mutate(wms, avg_score = .)

datasummary(avg_score ~ Mean + Median + SD + Min + Max + N, data = wms)

# For other type of manipulations, simply change `rowMeans` with your needed function


###
# Task:
#   create the sum of `aa_` variables
#   check that the resulting variable has value of 1 for each observation as `aa_` variables 
#     are dummies for industry code
# hint: for simple row-sum, you can use `reduce(`+`)` instead of rowMeans



####
# Grouping categorical
#
# Creating groups by continents -> reducing dimensionality of a categorical variable
datasummary(country ~ N + Percent(), data = wms)

# Create continent variable with `countrycode` function
wms <- wms %>%  mutate(continent =
                          countrycode(sourcevar = wms$country,
                              origin = 'country.name',
                              destination = 'continent'))

# It says 'Northern Ireland' is not detected...
wms <- wms %>% mutate(continent = replace(continent, country == 'Northern Ireland', 'Europe'))

# Check
datasummary(continent ~ N + Percent(), data = wms)

# With `countrycode`, you can create region dummies and many more, see ?countrycode

###
# Task:
# Create a region variable 


##
# It is also possible to create these groups by hand, with fct_collapse command.
#
# check the type ownership:
unique(wms$ownership)

wms <- wms %>% 
  mutate(owner = fct_collapse(ownership,
                                other   = c('Other'),
                                family  = grep('Family', unique(ownership), value = TRUE),
                                gov     = c('Government'),
                                private = c('Dispersed Shareholders','Private Individuals',
                                            'Founder owned, CEO unknown','Private Equity/Venture Capital',
                                            'Founder owned, external CEO','Founder owned, founder CEO')))
unique(wms$owner)

####
# Good-to-know: labeled ordered factor variable: 
#  labels are ordered, however difference is only in few application
wms <- wms %>% mutate(lean1_ord = factor(lean1, levels = 1:5, 
                                            labels = c('extermly poor','bad','mediocre','good','excellent'),
                                            ordered = TRUE))

# Can easily plot
wms %>% select(lean1_ord, avg_score) %>% 
        group_by(lean1_ord) %>% 
        summarise(mavg_score = mean(avg_score, na.rm = T)) %>% 
        ggplot(aes(x = lean1_ord, y = mavg_score)) +
          geom_point(color = 'red', size = 10) +
          labs(x = 'Lean 1 score', y = 'Mean average management score')+
          theme_bw()

####
# Task:
# Create the same graph, but using talent2 instead


#####
# Numeric to ordered
#

# It is hard to get any conclusion if we plot the pattern between 
#   average management score and number of employees
ggplot(wms, aes(x = emp_firm, y = avg_score)) +
  geom_point(color = 'red', size = 2, alpha = 0.6) +
  labs(x = 'Number of employees', y = 'Mean average management score')+
  theme_bw()

# One simple way to solve this issue:
# Simplifying firm size: creating categories from numeric (cut() creates a factor)
wms <- wms %>% mutate(emp_cat = cut(emp_firm, c(0, 200, 1000, Inf), 
                                      labels = c('small','medium','large')))
wms %>% 
  group_by(emp_cat) %>% 
  filter(!is.na(emp_cat)) %>% 
  summarize(mavg_score = mean(avg_score, na.rm = T)) %>% 
    ggplot(aes(x = emp_cat, y = mavg_score)) +
      geom_point(color = 'red', size = 10) +
      labs(x = 'Firm size', y = 'Mean average management score')+
      theme_bw()

###
# Task:
#   use instead of `cut()` `cut_number()` function with 3 categories. 
#   Do not use labels input, but check the levels with `levels()` function!
#   After that add labels and plot a similar graph as before and explain what changed
#   Extra: can check cut_interval() and cut_width() functions 



####
# Factors or dummies?

# Creating multiple factor dummy from a categorical:
dummies <- wms %>% select(emp_cat) %>% dummy_cols()


# Note: may drop the original variable (not an issue if you put into the same df)
#       if NA it will appear as a new column. This is good, as it should be considered (e.g. dropped)
#
# In many cases we use `as.numeric(logical operation)`, which creates a dummy variable
#   this is favorable in many cases: 
#     - easy to create a dummy with elaborate logical operation
#     - if outcome is binary it is needed (factor behaves differently)
#     - can control for what is in your model (what is the reference category)


####
# Extra:
#   principle component analysis or PCA
#
# One can argue, that the mean of the score is not the best measure, as it takes each value with the same weight
# An alternative solution is creating principal components, which transform the original variables.

# The function is called `prcomp()`
?prcomp

# Let us create principle components with all the questionnaires.
# have to make sure there is no NA value
pca <- wms %>% 
  select(matches(c('lean','perf','talent'))) %>%
  select(where(is.numeric)) %>%
  drop_na() %>% 
  prcomp()

# We have the same number of variables, but they are transformed.
# As PCA is an information reductionist approach, we can see, 
#     which transformed variable explains what percent of the overall information (variation)
pca %>%
  tidy(matrix = 'eigenvalues')

# Let us decide to use only the first variable, which explains 45.6%
pca_tibble <- pca %>% tidy(matrix = 'x') %>% 
  pivot_wider(names_from = PC, 
               values_from = value, 
               names_prefix = 'PC')

# aux: add firmid and wave with same filter to match PCs to wms data
aux <- wms %>% select(matches(c('firmid','wave','lean','perf','talent'))) %>%
  select(where(is.numeric)) %>%
  drop_na()

# add firmid wave and only PC1 from pca-s
pca_tibble <- cbind(select(pca_tibble, PC1), select(aux, firmid, wave))

# add to wms data
wms <- left_join(wms, pca_tibble, by = c('firmid','wave'))

# Compare descriptives with average score
datasummary(avg_score + PC1 ~ Mean + Median + SD + Min + Max, data = wms)

# Create a bin-scatter with PC1
wms %>% 
  group_by(emp_cat) %>% 
  filter(!is.na(emp_cat)) %>% 
  summarize(mPC1_score = mean(PC1, na.rm = T)) %>% 
  ggplot(aes(x = emp_cat, y = mPC1_score)) +
  geom_point(color = 'red', size = 10) +
  labs(x = 'Firm size', y = 'Principal component')+
  theme_bw()

# Notes: 
#   1) PCA is especially useful when you have too many explanatory variables and want to reduce num vars, 
#       with minimal information loss. However, should use it with care, especially with time series!
#   2) There are many variations of PCA, if one starts to `rotate` the factors 
#       to make some meaningful variables out of it (especially in psychology)
#   3) There are many packages, which carry out PCA, this is pretty much the simplest intro here...
