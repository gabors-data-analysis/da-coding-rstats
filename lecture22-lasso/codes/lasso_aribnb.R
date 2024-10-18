#####################################
#                                   #
#     Seminar 2 for Part III        #
#     Prediction with Lasso         #
#                                   #
# Topics covered:                   #
#   - Data cleaning & refactoring   #
#   - Basic feature engineering II  #
#   - 3 sample approach:            #
#       - train and test sample     #
#         to do cross-validation    #
#         or tuning                 #
#       - hold-out sample to        #
#         evaluate prediction       #
#   - Model selection with:         #
#     - lin.regression with cv      #
#     - lasso (ridge & elastic net) #
#   - Diagnostics and evaluation    #
#     - which model gives           #
#       best prediction on hold-out #
#     - stability of the prediction #
#     - further diagnostics with    #
#         figures                   #
#                                   #
# Case studies:                     #
#  -CH14B Predicting AirBnB         #
#     apartment prices:             #
#     selecting a regression model  #
#                                   #
# dataset:                          #
#   airbnb                          #
#                                   #
#####################################



# ------------------------------------------------------------------------------------------------------
#### SET UP
# It is advised to start a new session for every case study
# CLEAR MEMORY
rm(list=ls())


# Descriptive statistics and regressions
library(tidyverse)
library(caret)
library(skimr)
library(grid)
library(cowplot)
library(modelsummary)
library(fixest)
if (!require(glmnet)){
  install.packages('glmnet')
  library(glmnet)
}



########################################
# PART I.
########################################
#####
# Load data
url_data <- 'https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/refs/heads/main/lecture22-lasso/data/airbnb_hackney_workfile_adj_book1.csv'
data <- read_csv(url_data) %>% 
  mutate_if(is.character, factor)

######################
# 1) Feature engineering
#
glimpse(data)

# where do we have missing variables now?
to_filter <- sapply(data, function(x) sum(is.na(x)))
to_filter[to_filter > 0]

# what to do with missing values?
# A) drop if no target value
data <- data %>%
  drop_na(price)


# B) Impute when few
#   Few different practices:
#    i) use the mean or the median
#   ii) use another variable to proxy it
#  iii) set to a known value - due to theory/practical considerations

data <- data %>%
  mutate(
    n_bathrooms =  ifelse(is.na(n_bathrooms), median(n_bathrooms, na.rm = T), n_bathrooms), #assume at least 1 bath
    n_beds = ifelse(is.na(n_beds), n_accommodates, n_beds), #assume n_beds=n_accomodates
    f_bathroom=ifelse(is.na(f_bathroom),1, f_bathroom),
    f_minimum_nights=ifelse(is.na(f_minimum_nights),1, f_minimum_nights),
    f_number_of_reviews=ifelse(is.na(f_number_of_reviews),1, f_number_of_reviews),
    ln_beds=ifelse(is.na(ln_beds),0, ln_beds),
   )

# C) drop variables if many missing and not that important to have them in the analysis
to_drop <- c('usd_cleaning_fee', 'p_host_response_rate','d_reviews_per_month')
data <- data %>%
  select(-one_of(to_drop))

to_filter <- sapply(data, function(x) sum(is.na(x)))
to_filter[to_filter > 0]


# D) Replace missing variables re-reviews with zero, when no review + add flags
#   again, same considerations as in B), but now use flags
# when to use/not use flag -> always good to use if you are not certain about imput will be representative.
data <- data %>%
  mutate(
    flag_days_since = ifelse(is.na(n_days_since),1, 0),
    n_days_since    =  ifelse(is.na(n_days_since), median(n_days_since, na.rm = T), n_days_since),
    flag_review_scores_rating = ifelse(is.na(n_review_scores_rating),1, 0),
    n_review_scores_rating    = ifelse(is.na(n_review_scores_rating), median(n_review_scores_rating, na.rm = T), n_review_scores_rating),
    flag_reviews_per_month    = ifelse(is.na(n_reviews_per_month),1, 0),
    n_reviews_per_month       = ifelse(is.na(n_reviews_per_month), median(n_reviews_per_month, na.rm = T), n_reviews_per_month)
         )
# check one flagged variable
datasummary(factor(flag_days_since) + factor(flag_review_scores_rating) + factor(flag_reviews_per_month) ~ N, data)



# E) Add features -> different functional forms
# Create variables, measuring the time since: squared, cubic, logs
data <- data %>%
  mutate(
    ln_days_since = log(n_days_since+1),
    ln_days_since2 = log(n_days_since+1)^2,
    ln_days_since3 = log(n_days_since+1)^3 ,
    n_days_since2=n_days_since^2,
    n_days_since3=n_days_since^3,
    ln_review_scores_rating = log(n_review_scores_rating),
    ln_days_since=ifelse(is.na(ln_days_since),0, ln_days_since),
    ln_days_since2=ifelse(is.na(ln_days_since2),0, ln_days_since2),
    ln_days_since3=ifelse(is.na(ln_days_since3),0, ln_days_since3),
 )


# Look at data
summary(data$price)

# where do we have missing variables now?
to_filter <- sapply(data, function(x) sum(is.na(x)))
to_filter[to_filter > 0]


#################################################
# Business logic- define our prediction problem:
# Filter out all observations which are not that relevant


# Decision
# Size, we need a normal apartment, 1-7 persons
data <- data %>%
  filter(n_accommodates < 8
        )

# that's gonna be our sample
skimr::skim(data)


#########################
# Descriptive statistics
#

# Average price by `property_type`, `room_type`
datasummary(f_property_type*f_room_type*price + f_bed_type*price ~ Mean + SD + P25 + P75 + N, data = data)
datasummary(f_property_type*f_room_type*f_bed_type*price ~ Mean + SD + P25 + P75 + N, data = data)
# NB all graphs, we exclude  extreme values of price for plotting
datau <- subset(data, price<400)

###
# Graphs
# price
ggplot(data=datau, aes(x=price)) +
  geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 10, boundary=0,
                  fill = 'navyblue', color = 'white', size = 0.25, alpha = 0.8,  show.legend=F,  na.rm=TRUE) +
  coord_cartesian(xlim = c(0, 400)) +
  labs(x = 'Price (US dollars)',y = 'Percent')+
  scale_y_continuous(expand = c(0.00,0.00),limits=c(0, 0.15), breaks = seq(0, 0.15, by = 0.03), labels = scales::percent_format(1)) +
    scale_x_continuous(expand = c(0.00,0.00),limits=c(0,400), breaks = seq(0,400, 50)) +
  theme_bw() 


# lnprice
ggplot(data=datau, aes(x=ln_price)) +
  geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 0.18,
                 color = 'white', fill = 'navyblue', size = 0.25, alpha = 0.8,  show.legend=F,  na.rm=TRUE) +
  coord_cartesian(xlim = c(2.5, 6.5)) +
  scale_y_continuous(expand = c(0.00,0.00),limits=c(0, 0.15), breaks = seq(0, 0.15, by = 0.05), labels = scales::percent_format(5L)) +
  scale_x_continuous(expand = c(0.00,0.01),breaks = seq(2.4,6.6, 0.6)) +
  labs(x = 'ln(price, US dollars)',y = 'Percent')+
  theme_bw() 


## Boxplot of price by room type
ggplot(data = datau, aes(x = f_room_type, y = price)) +
  stat_boxplot(aes(group = f_room_type), geom = 'errorbar', width = 0.3,
               color = c('red','blue', 'black'), size = 0.5, na.rm=T)+
  geom_boxplot(aes(group = f_room_type),
               color = c('red','blue', 'black'), fill = c('red','blue', 'black'),
               size = 0.5, width = 0.6, alpha = 0.3, na.rm=T, outlier.shape = NA) +
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0,300), breaks = seq(0,300,100)) +
  labs(x = 'Room type',y = 'Price (US dollars)')+
  theme_bw()

# Boxplot of price by number of persons
ggplot(datau, aes(x = factor(n_accommodates), y = price,
                        fill = factor(f_property_type), color=factor(f_property_type))) +
  geom_boxplot(alpha=0.8, na.rm=T, outlier.shape = NA, width = 0.8) +
    stat_boxplot(geom = 'errorbar', width = 0.8, size = 0.3, na.rm=T)+
    scale_color_manual(name='',
                     values=c('red','blue')) +
  scale_fill_manual(name='',
                     values=c('red','blue')) +
  labs(x = 'Accomodates (Persons)',y = 'Price (US dollars)')+
  scale_y_continuous(expand = c(0.01,0.01), limits=c(0, 400), breaks = seq(0,400, 50))+
  theme_bw() +
  theme(legend.position = c(0.3,0.8)       )


########################################
# PART II.
########################################


#########################
# 1) Setting up models 

##
# A) Define grouping variables which contains variable names

# Define basic levels
basic_lev  <- c('n_accommodates', 'n_beds', 'f_property_type', 'f_room_type', 'n_days_since', 'flag_days_since')
# Factorized variables
basic_add <- c('f_bathroom','f_cancellation_policy','f_bed_type')
# Reviews
reviews <- c('f_number_of_reviews','n_review_scores_rating', 'flag_review_scores_rating')
# Higher orders
poly_lev <- c('n_accommodates2', 'n_days_since2', 'n_days_since3')

# Create dummy variable names: 
#   Extras -> collect all options and create dummies
amenities <-  grep('^d_.*', names(data), value = TRUE)

##########################
# B) Creating interactions:

# let us call the ch14_aux_fncs funtion -> to plot interaction terms
source('ch14_aux_fncs.R')

##
# a) Check the interactions for various variables and create a ggplot
# Look up room type interactions
p1 <- price_diff_by_variables2(data, 'f_room_type', 'd_familykidfriendly', 'Room type', 'Family kid friendly')
p2 <- price_diff_by_variables2(data, 'f_room_type', 'f_property_type', 'Room type', 'Property type')
#Look up canelation policy
p3 <- price_diff_by_variables2(data, 'f_cancellation_policy', 'd_familykidfriendly', 'Cancellation policy', 'Family kid friendly')
p4 <- price_diff_by_variables2(data, 'f_cancellation_policy', 'd_tv', 'Cancellation policy', 'TV')
#Look up property type
p5 <- price_diff_by_variables2(data, 'f_property_type', 'd_cats', 'Property type', 'Cats')
p6 <- price_diff_by_variables2(data, 'f_property_type', 'd_dogs', 'Property type', 'Dogs')
# combine plots
g_interactions <- plot_grid(p1, p2, p3, p4, p5, p6, nrow=3, ncol=2)
g_interactions


##
# b) create the interaction terms

# dummies suggested by graphs
X1  <- c('f_room_type*f_property_type',  'f_room_type*d_familykidfriendly')

# Additional interactions of factors and dummies
X2  <- c('d_airconditioning*f_property_type', 'd_cats*f_property_type', 'd_dogs*f_property_type')
X3  <- c(paste0('(f_property_type + f_room_type + f_cancellation_policy + f_bed_type) * (',
                paste(amenities, collapse=' + '),')'))

#######################
# C) Create model setups
#
# Create models in levels models: 1-8
modellev1 <- ' ~ n_accommodates'
modellev2 <- paste0(' ~ ',paste(basic_lev,collapse = ' + '))
modellev3 <- paste0(' ~ ',paste(c(basic_lev, basic_add,reviews),collapse = ' + '))
modellev4 <- paste0(' ~ ',paste(c(basic_lev,basic_add,reviews,poly_lev),collapse = ' + '))
modellev5 <- paste0(' ~ ',paste(c(basic_lev,basic_add,reviews,poly_lev,X1),collapse = ' + '))
modellev6 <- paste0(' ~ ',paste(c(basic_lev,basic_add,reviews,poly_lev,X1,X2),collapse = ' + '))
modellev7 <- paste0(' ~ ',paste(c(basic_lev,basic_add,reviews,poly_lev,X1,X2,amenities),collapse = ' + '))
modellev8 <- paste0(' ~ ',paste(c(basic_lev,basic_add,reviews,poly_lev,X1,X2,amenities,X3),collapse = ' + '))

#################################
# 2) Manage different samples:


#######
# A) Create a separate hold-out set
#   - for evaluating prediction performance
#   - diagnostics
#   - always use as a completely random and locked away sample!

# create a holdout set (20% of observations)
smp_size <- floor(0.2 * nrow(data))

# Set the random number generator: It will make results reproducable
set.seed(20180123)

# create ids:
# 1) seq_len: generate regular sequences
# 2) sample: select random rows from a table
holdout_ids <- sample(seq_len(nrow(data)), size = smp_size)
data$holdout <- 0
data$holdout[holdout_ids] <- 1

#Hold-out set Set
data_holdout <- data %>% filter(holdout == 1)

#Working data set
data_work <- data %>% filter(holdout == 0)


####################################
# B) Utilize the Working data set:
#   a) estimate measures on the whole working sample (R2,BIC,RMSE)
#   b) DO K-fold cross validation to get proper Test RMSE
#
# Do everything within a for-loop

## K = 5
k_folds <- 5
# Define seed value
seed_val <- 20210117

# Do the iteration
for (i in 1:8){
  print(paste0('Estimating model: ' ,i))
  # Get the model name
  model_name <-  paste0('modellev',i)
  model_pretty_name <- paste0('M',i,'')
  # Specify the formula
  yvar <- 'price'
  xvars <- eval(parse(text = model_name))
  formula <- formula(paste0(yvar,xvars))
  
  # Estimate model on the whole sample
  model_work_data <- feols(formula, data = data_work, vcov='hetero')
  #  and get the summary statistics
  fs  <- fitstat(model_work_data,c('rmse','r2','bic'))
  BIC <- fs$bic
  r2  <- fs$r2
  rmse_train <- fs$rmse
  ncoeff <- length(model_work_data$coefficients)
  
  # Do the k-fold estimation
  set.seed(seed_val)
  cv_i <- train(formula, data_work, method = 'lm', 
                 trControl = trainControl(method = 'cv', number = k_folds))
  rmse_test <- mean(cv_i$resample$RMSE)
  
  # Save the results
  model_add <- tibble(Model=model_pretty_name, Coefficients=ncoeff,
                      R_squared=r2, BIC = BIC, 
                      Training_RMSE = rmse_train, Test_RMSE = rmse_test)
  if (i == 1){
    model_results <- model_add
  } else{
    model_results <- rbind(model_results, model_add)
  }
}

# Check summary table
model_results


# RMSE training vs test graph
colors = c('Training RMSE'='green','Test RMSE' = 'blue')
ggplot(data = model_results, aes(x = factor(Coefficients), group = 1))+
  geom_line(aes(y = Training_RMSE, color = 'Training RMSE'), size = 1) +
  geom_line(aes(y = Test_RMSE, color = 'Test RMSE'), size = 1)+
  labs(y='RMSE',x='Number of coefficients',color = '')+
  scale_color_manual(values = colors)+
  theme_bw()+
  theme(legend.position='top')


#################################
# 3) Use of LASSO

# take model 8 (and find observations where there is no missing data)
vars_model_8 <- c('price', basic_lev,basic_add,reviews,poly_lev,X1,X2,amenities,X3)

# Set lasso tuning parameters:
# a) basic setup
train_control <- trainControl(method = 'cv', number = k_folds)
# b) tell the actual lambda (penalty parameter) to use for lasso
tune_grid     <- expand.grid('alpha' = c(1), 'lambda' = seq(0.05, 1, by = 0.05))
# c) create a formula
formula <- formula(paste0('price ~ ', paste(setdiff(vars_model_8, 'price'), collapse = ' + ')))

# Run LASSO
set.seed(seed_val)
lasso_model <- caret::train(formula,
                      data = data_work,
                      method = 'glmnet',
                      preProcess = c('center', 'scale'),
                      trControl = train_control,
                      tuneGrid = tune_grid,
                      na.action=na.exclude)
# Check the output
lasso_model
# Penalty parameters
lasso_model$bestTune
# Check th optimal lambda parameter
lasso_model$bestTune$lambda
# Check the RMSE curve
plot(lasso_model)

# One can get the coefficients as well
lasso_coeffs <- coef(lasso_model$finalModel, lasso_model$bestTune$lambda) %>%
  as.matrix() %>%
  as.data.frame() %>%
  rownames_to_column(var = 'variable') %>%
  rename(coefficient = `s1`)  # the column has a name '1', to be renamed

print(lasso_coeffs)

# Check the number of variables which actually has coefficients other than 0
lasso_coeffs_nz<-lasso_coeffs %>%
  filter(coefficient!=0)
print(nrow(lasso_coeffs_nz))

# Get the RMSE of the Lasso model 
#   Note you should compare this to the test RMSE
lasso_fitstats <- lasso_model$results %>%
  filter(lambda == lasso_model$bestTune$lambda) 
lasso_fitstats
# Create an auxilary tibble
lasso_add <- tibble(Model='LASSO', Coefficients=nrow(lasso_coeffs_nz),
                    R_squared=lasso_fitstats$Rsquared, BIC = NA, 
                    Training_RMSE = NA, Test_RMSE = lasso_fitstats$RMSE)
# Add it to final results
model_results <- rbind(model_results, lasso_add)
model_results


# Notes on LASSO:
# a) preProcessing: in practice shows great results therefore it is advised to use it
#     if you neglect you may end up with using different variables (but the prediction will not change tremendously)
# b) tune_grid: can neglect specifying the grid (and usually you should), but it will slow down the calculation
#     as LASSO will check much more possible values
# c) in tune_grid 'alpha' decides which 'method' you use:
#     alpha = 1 -> LASSO regression
#     alpha = 0 -> RIDGE regression
#     alpha = any number -> ELASTIC NET

set.seed(seed_val)
elasticnet_model <- caret::train(formula,
                            data = data_work,
                            method = 'glmnet',
                            preProcess = c('center', 'scale'),
                            trControl = train_control,
                            na.action=na.exclude)

# If you are interested in LASSO, check out glmnet package
#   it has different inputs (this is why we use caret), but allows to set tuning parameters more directly.
#   Note 1) that in prediction there will be no big differences however
#   Note 2) You may check which variables are relevant, however in a predictive concept, 
#       LASSO is documented to be unstable across which variables to shrink. 
#       Therefore you should not use the results directly for causal interpretation. (Remember it is like a lego...)
elasticnet_model

# Note 1) - Stability of prediction: check RMSE
elasticnet_model$results %>%
  filter(lambda == elasticnet_model$bestTune$lambda & alpha == elasticnet_model$bestTune$alpha) %>% 
  select(RMSE)

# Note 2) - Instability of coefficients: check number of coefficients
elastic_coeffs <- coef(elasticnet_model$finalModel, elasticnet_model$bestTune$lambda) %>%
  as.matrix() %>%
  as.data.frame() %>%
  rownames_to_column(var = 'variable') %>%
  rename(coefficient = `s1`)
elasticnet_model_nz<-elastic_coeffs %>%
  filter(coefficient!=0)
print(nrow(elasticnet_model_nz))

########################################
# PART III. Diagnostics
#

########
# 1) Evaluate performance on the hold-out sample
#
# Let us check only Models: 3, 7 and LASSO

# we need to re-run Model 3 and 7 on the work data
m3 <- feols(formula(paste0('price',modellev3)), data = data_work, vcov = 'hetero')
m7 <- feols(formula(paste0('price',modellev7)), data = data_work, vcov = 'hetero')

# Make prediction for the hold-out sample with each models
m3_p <- predict(m3, newdata = data_holdout)
m7_p <- predict(m7, newdata = data_holdout)
mL_p <- predict(lasso_model, newdata = data_holdout)

# Calculate the RMSE on hold-out sample
m3_rmse <- RMSE(m3_p,data_holdout$price)
m7_rmse <- RMSE(m7_p,data_holdout$price)
mL_rmse <- RMSE(mL_p,data_holdout$price)
# Create a table
sum <- rbind(m3_rmse,m7_rmse,mL_rmse)
rownames(sum) <- c('Model 3','Model 7','LASSO')
colnames(sum) <- c('RMSE on hold-out sample')
sum



####################################################
# 2) FIGURES FOR FITTED VS ACTUAL OUTCOME VARIABLES
#


#######
# A) Predicted vs Actual prices

# Let us use the fancy LASSO model
#   But note you shell do robustness checks -> do it for other models as well!

# add the predicted values
data_holdout$predLp <- mL_p

ggplot(data_holdout, aes(y = price, x = predLp)) +
  geom_point(size = 1, color = 'blue') +
  geom_abline(intercept = 0, slope = 1, size = 1, color = 'green', linetype = 'dashed') +
  xlim(-1,max(data_holdout$price))+
  ylim(-1,max(data_holdout$price))+
  labs(x='Predicted price (US$)',y='Price (US$)')+
  theme_bw()

#######
# B) Accuracy of prediction along accomadates (or your favorite variable)

# As it turns out science is not that developed yet to have 80% prediction intervals with LASSO...
#
#   If you are interested you may read this super technical paper on the confidence intervals
#     https://arxiv.org/abs/1801.09037v2
#   Or check a package which gives you confidence intervals on your parameters:
#     https://cran.r-project.org/web/packages/selectiveInference/index.html


# Use Model 7 which is similarly good to get 80% PI:
m7_pPI <- predict(m7, newdata = data_holdout, interval = 'predict', level = 0.8)

# Save into datatable
data_holdout$predm7p    <- m7_pPI$fit
data_holdout$pi80_l_m7p <- m7_pPI$ci_low
data_holdout$pi80_h_m7p <- m7_pPI$ci_high

# Create a summary:
# Note: we use mean as it reflects the what can you expect, but can use e.g. median or any other measure.
#   BUT keep it simple and always use such measure which makes sense!

datasummary(as.factor(n_accommodates)*(predm7p + pi80_l_m7p + pi80_h_m7p)  ~ Mean, data = data_holdout)

# Or a tibble
pred_persons <- data_holdout %>% select(n_accommodates, predm7p, pi80_l_m7p, pi80_h_m7p) %>% 
                group_by(n_accommodates) %>% 
  summarise(fit = mean(predm7p, na.rm=TRUE), pred_lwr = mean(pi80_l_m7p, na.rm=TRUE), pred_upr = mean(pi80_h_m7p, na.rm=TRUE))
pred_persons

# Create a bar graph with PIs
ggplot(pred_persons, aes(x=factor(n_accommodates))) +
  geom_bar(aes(y = fit), stat='identity',  fill = 'blue', alpha=0.7) +
  geom_errorbar(aes(ymin=pred_lwr, ymax=pred_upr, color = 'Pred. interval'),width=.3,size=1) +
  scale_y_continuous(name = 'Predicted price (US dollars)') +
  scale_x_discrete(name = 'Accomodates (Persons)') +
  scale_color_manual(values=c('red', 'red')) +
  theme_bw() +
  theme(legend.title= element_blank(),legend.position='none')

#####
# If we have time:
#   A) More on LASSO
#   B) Ethics/consequences of machine learning algorithms 1.


# A) LASSO:
#
#
# May check how the coefficients are changing as lambda changes (resulting the L1 norm to change)
# Plot against L1 norm
plot(lasso_model$finalModel)
# Plot against log of lambda
plot(lasso_model$finalModel, xvar = 'lambda', label = TRUE)

# Using 1SE rule for selecting a more parsimonious model:
# Get the 1SE value:
one_SE <- sd(lasso_model$resample$RMSE) / sqrt(length(lasso_model$resample$RMSE))
# Get a decision rule: minimum RMSE + 1SE
min_rmse_p1se <- min(lasso_model$results$RMSE) + one_SE
min_rmse_p1se

# One can see that we may have lambda = 1 as well based on 1SE rule... (but note lambda in (0,Inf[)
lasso_model$results
# Always compare:
# Run parsimonious LASSO
set.seed(seed_val)
lasso_simple <- caret::train(formula,
                            data = data_work,
                            method = 'glmnet',
                            preProcess = c('center', 'scale'),
                            trControl = train_control,
                            tuneGrid = expand.grid('alpha' = c(1), 'lambda' = 1)  ,
                            na.action=na.exclude)

# One can get the coefficients as well
lasso_s_coeffs <- coef(lasso_simple$finalModel, lasso_simple$bestTune$lambda) %>%
  as.matrix() %>%
  as.data.frame() %>%
  rownames_to_column(var = 'variable') %>%
  rename(coefficient = `s1`)  # the column has a name '1', to be renamed

print(lasso_s_coeffs)

# Check the number of variables which actually has coefficients other than 0
lasso_s_coeffs_nz<-lasso_s_coeffs %>%
  filter(coefficient!=0)
print(nrow(lasso_s_coeffs_nz))

# Check on prediction
mLs_p <- predict(lasso_simple, newdata = data_holdout)
mLs_rmse <- RMSE(mLs_p,data_holdout$price)
# Create a table
sum <- rbind(m3_rmse,m7_rmse,mL_rmse,mLs_rmse)
rownames(sum) <- c('Model 3','Model 7','LASSO','LASSO-simple')
colnames(sum) <- c('RMSE on hold-out sample')
sum

# Actually we get a better out-of-sample prediction :)

