#######################################
#                                     #
#     Seminar 4 for Part III          #
#  Prediction with Random Forest      #
#                                     #
# Topics covered:                     #
#   - Data cleaning & refactoring     #
#       & feature engineering         #
#       in a separate file            #
#   - Run random forest via 'ranger'  #
#     - set mytr                      #
#     - autotune                      # 
#   - Understanding RF output:        #
#     - variable importance plots:    #
#       - all, top 10 andgrouped      #
#     - partial dependence plot       #
#     - sub-sample analysis           #
#   - 'Horse-race': model comparison  #
#     - OLS, Lasso, CART, RF          #
#         and GBM model               #
#                                     #
# Case studies:                       #
#  -CH16A Predicting apartment        #
#     prices with random forest       #
#                                     #
# dataset:                            #
#   airbnb                            #
#                                     #
#######################################


rm(list=ls())

library(tidyverse)
library(modelsummary)
library(caret)
# Pretty plots
if (!require(rattle)){
  install.packages('rattle')
  library(rattle)
}
# Random forest package
if (!require(ranger)){
  install.packages('ranger')
  library(ranger)
}
# Partial dependence plot package
if (!require(pdp)){
  install.packages('pdp')
  library(pdp)
}
# Gradient boosting machine
if (!require(gbm)){
  install.packages('gbm')
  library(gbm)
}



#########################################################################################
#
# PART I
# Loading and preparing data ----------------------------------------------
#
#########################################################################################



# Used area
path_url <- 'https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/refs/heads/main/lecture24-random-forest/data/'
airbnb <- read_csv(paste0(path_url,'airbnb_london_workfile_adj_book.csv')) %>%
  mutate_if(is.character, factor) %>%
  filter(!is.na(price))

# Sample definition and preparation ---------------------------------------

# We focus on normal apartments, n<8
airbnb <- airbnb %>% filter(n_accommodates < 8)


# copy a variable - purpose later, see at variable importance
airbnb <- airbnb %>% mutate(n_accommodates_copy = n_accommodates)

# basic descr stat -------------------------------------------
skimr::skim(airbnb)
datasummary(price~Mean+Median+P25+P75+N,data=airbnb)
datasummary(f_room_type + f_property_type ~ N + Percent(), data = airbnb)

# create train and holdout samples -------------------------------------------
# train is where we do it all, incl CV

set.seed(2801)
train_indices <- as.integer(createDataPartition(airbnb$price, p = 0.7, list = FALSE))
data_train    <- airbnb[train_indices, ]
data_holdout  <- airbnb[-train_indices, ]

# Check the number of observations
dim(data_train)
dim(data_holdout)

# Define models: simpler -> extended

# Basic Variables inc neighnourhood
basic_vars <- c(
  'n_accommodates', 'n_beds', 'n_days_since',
  'f_property_type','f_room_type', 'n_bathrooms', 'f_cancellation_policy', 'f_bed_type',
  'f_neighbourhood_cleansed')

# reviews
reviews <- c('n_number_of_reviews', 'flag_n_number_of_reviews' ,
             'n_review_scores_rating', 'flag_review_scores_rating')

# Dummy variables
amenities <-  grep('^d_.*', names(airbnb), value = TRUE)

#interactions for the LASSO
# from ch14
X1  <- c('n_accommodates*f_property_type',  'f_room_type*f_property_type',  'f_room_type*d_familykidfriendly',
         'd_airconditioning*f_property_type', 'd_cats*f_property_type', 'd_dogs*f_property_type')
# with boroughs
X2  <- c('f_property_type*f_neighbourhood_cleansed', 'f_room_type*f_neighbourhood_cleansed',
         'n_accommodates*f_neighbourhood_cleansed')


predictors_1 <- c(basic_vars)
predictors_2 <- c(basic_vars, reviews, amenities)
predictors_E <- c(basic_vars, reviews, amenities, X1,X2)


#########################################################################################
#
# PART II
# RANDOM FORESTS -------------------------------------------------------
#
# We are going to make some simplification for faster running time
#   see the original codes on the book's github page!
#

# do 5-fold CV
train_control <- trainControl(method = 'cv',
                              number = 5,
                              verboseIter = FALSE)

# set tuning
tune_grid <- expand.grid(
  .mtry = c(8),
  .splitrule = 'variance',
  .min.node.size = c(50)
)


# simpler model for model - using random forest
# may take a while -> commented lines to load from github the model results
set.seed(1234)
system.time({
rf_model_1 <- train(
  formula(paste0('price ~', paste0(predictors_1, collapse = ' + '))),
  data = data_train,
  method = 'ranger',
  trControl = train_control,
  tuneGrid = tune_grid,
  importance = 'impurity'
)
})
rf_model_1
# save(rf_model_1, file = 'rf_model_1.RData')
# load(url(paste0(path_url,'rf_model_1.RData?raw=true')))

# more complicated model - using random forest
set.seed(1234)
system.time({
rf_model_2 <- train(
  formula(paste0('price ~', paste0(predictors_2, collapse = ' + '))),
  data = data_train,
  method = 'ranger',
  trControl = train_control,
  tuneGrid = tune_grid,
  importance = 'impurity'
)
})
rf_model_2
# save(rf_model_2, file = 'rf_model_2.RData')
# load(url(paste0(path_url,'rf_model_2.RData?raw=true')))


# auto tuning - just takes too much time to run now, 
#   and too much space to store it on github...
#set.seed(1234)
#system.time({
#   rf_model_2auto <- train(
#     formula(paste0('price ~', paste0(predictors_2, collapse = ' + '))),
#     data = data_train,
#     method = 'ranger',
#     trControl = train_control,
#     importance = 'impurity'
#  )
#})
#rf_model_2auto 


# evaluate random forests -------------------------------------------------

results <- resamples(
  list(
    model_1  = rf_model_1,
    model_2  = rf_model_2
 )
)
summary(results)


#########################################################################################
#
# PART III
# MODEL DIAGNOSTICS -------------------------------------------------------
#


#########################################################################################
# Variable Importance Plots -------------------------------------------------------
#########################################################################################

# variable importance plot
# 1) full varimp plot, full
# 2) varimp plot grouped
# 3) varimp plot, top 10
# 4) varimp plot  w copy, top 10


rf_model_2_var_imp <- ranger::importance(rf_model_2$finalModel)/1000
rf_model_2_var_imp_df <-
  data.frame(varname = names(rf_model_2_var_imp),imp = rf_model_2_var_imp) %>%
  mutate(varname = gsub('f_neighbourhood_cleansed', 'Borough:', varname)) %>%
  mutate(varname = gsub('f_room_type', 'Room type:', varname)) %>%
  arrange(desc(imp)) %>%
  mutate(imp_percentage = imp/sum(imp))

rf_model_2_var_imp_df
##############################
# 1) full varimp plot, above a cutoff
##############################

# to have a quick look
plot(varImp(rf_model_2))

cutoff = 600
ggplot(rf_model_2_var_imp_df[rf_model_2_var_imp_df$imp>cutoff,],
                                  aes(x=reorder(varname, imp), y=imp_percentage)) +
  geom_point(color='red', size=1.5) +
  geom_segment(aes(x=varname,xend=varname,y=0,yend=imp_percentage), color='red', size=1) +
  ylab('Importance (Percent)') +
  xlab('Variable Name') +
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_bw() +
  theme(axis.text.x = element_text(size=6), axis.text.y = element_text(size=6),
        axis.title.x = element_text(size=6), axis.title.y = element_text(size=6))

##############################
# 2) full varimp plot, top 10 only
##############################


# have a version with top 10 vars only
ggplot(rf_model_2_var_imp_df[1:10,], aes(x=reorder(varname, imp), y=imp_percentage)) +
  geom_point(color='red', size=1) +
  geom_segment(aes(x=varname,xend=varname,y=0,yend=imp_percentage), color='red', size=0.75) +
  ylab('Importance (Percent)') +
  xlab('Variable Name') +
  coord_flip() +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_bw()


##############################
# 2) varimp plot grouped
##############################
# grouped variable importance - keep binaries created off factors together

varnames <- rf_model_2$finalModel$xNames
f_neighbourhood_cleansed_varnames <- grep('f_neighbourhood_cleansed',varnames, value = TRUE)
f_cancellation_policy_varnames <- grep('f_cancellation_policy',varnames, value = TRUE)
f_bed_type_varnames <- grep('f_bed_type',varnames, value = TRUE)
f_property_type_varnames <- grep('f_property_type',varnames, value = TRUE)
f_room_type_varnames <- grep('f_room_type',varnames, value = TRUE)

groups <- list(f_neighbourhood_cleansed=f_neighbourhood_cleansed_varnames,
               f_cancellation_policy = f_cancellation_policy_varnames,
               f_bed_type = f_bed_type_varnames,
               f_property_type = f_property_type_varnames,
               f_room_type = f_room_type_varnames,
               f_bathroom = 'f_bathroom',
               n_days_since = 'n_days_since',
               n_accommodates = 'n_accommodates',
               n_beds = 'n_beds')

# Need a function to calculate grouped varimp
group.importance <- function(rf.obj, groups) {
  var.imp <- as.matrix(sapply(groups, function(g) {
    sum(ranger::importance(rf.obj)[g], na.rm = TRUE)
  }))
  colnames(var.imp) <- 'MeanDecreaseGini'
  return(var.imp)
}

rf_model_2_var_imp_grouped <- group.importance(rf_model_2$finalModel, groups)
rf_model_2_var_imp_grouped_df <- data.frame(varname = rownames(rf_model_2_var_imp_grouped),
                                            imp = rf_model_2_var_imp_grouped[,1])  %>%
                                      mutate(imp_percentage = imp/sum(imp))

ggplot(rf_model_2_var_imp_grouped_df, aes(x=reorder(varname, imp), y=imp_percentage)) +
  geom_point(color='red', size=1) +
  geom_segment(aes(x=varname,xend=varname,y=0,yend=imp_percentage), color='red', size=0.7) +
  ylab('Importance (Percent)') +   xlab('Variable Name') +
  coord_flip() +
  # expand=c(0,0),
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_bw()


#########################################################################################
# Partial Dependence Plots -------------------------------------------------------
#########################################################################################

# 1) Number of accommodates
pdp_n_acc <- pdp::partial(rf_model_2, pred.var = 'n_accommodates', 
                          pred.grid = distinct_(data_holdout, 'n_accommodates'), 
                          train = data_train)

pdp_n_acc %>%
  autoplot() +
  geom_point(color='red', size=2) +
  geom_line(color='red', size=1) +
  ylab('Predicted price') +
  xlab('Accommodates (persons)') +
  scale_x_continuous(limit=c(1,7), breaks=seq(1,7,1))+
theme_bw()


# 2) Room type
pdp_n_roomtype <- pdp::partial(rf_model_2, pred.var = 'f_room_type', 
                               pred.grid = distinct_(data_holdout, 'f_room_type'), 
                               train = data_train)
pdp_n_roomtype %>%
  autoplot() +
  geom_point(color='red', size=4) +
  ylab('Predicted price') +
  xlab('Room type') +
  scale_y_continuous(limits=c(60,120), breaks=seq(60,120, by=10)) +
  theme_bw()

####
# Subsample performance: RMSE / mean(y) ---------------------------------------
# NOTE  we do this on the holdout set.

# ---- cheaper or more expensive flats - not used in book
data_holdout_w_prediction <- data_holdout %>%
  mutate(predicted_price = predict(rf_model_2, newdata = data_holdout))



######### create nice summary table of heterogeneity
a <- data_holdout_w_prediction %>%
  mutate(is_low_size = ifelse(n_accommodates <= 3, 'small apt', 'large apt')) %>%
  group_by(is_low_size) %>%
  dplyr::summarise(
    rmse = RMSE(predicted_price, price),
    mean_price = mean(price),
    rmse_norm = RMSE(predicted_price, price) / mean(price)
 )


b <- data_holdout_w_prediction %>%
  filter(f_neighbourhood_cleansed %in% c('Westminster', 'Camden',
                                         'Kensington and Chelsea', 'Tower Hamlets',
                                         'Hackney', 'Newham')) %>%
  group_by(f_neighbourhood_cleansed) %>%
  dplyr::summarise(
    rmse = RMSE(predicted_price, price),
    mean_price = mean(price),
    rmse_norm = rmse / mean_price
 )

c <- data_holdout_w_prediction %>%
  filter(f_property_type %in% c('Apartment', 'House')) %>%
  group_by(f_property_type) %>%
  dplyr::summarise(
    rmse = RMSE(predicted_price, price),
    mean_price = mean(price),
    rmse_norm = rmse / mean_price
 )


d <- data_holdout_w_prediction %>%
  dplyr::summarise(
    rmse = RMSE(predicted_price, price),
    mean_price = mean(price),
    rmse_norm = RMSE(predicted_price, price) / mean(price)
 )

# Save output
colnames(a) <- c('', 'RMSE', 'Mean price', 'RMSE/price')
colnames(b) <- c('', 'RMSE', 'Mean price', 'RMSE/price')
colnames(c) <- c('', 'RMSE', 'Mean price', 'RMSE/price')
d<- cbind('All', d)
colnames(d) <- c('', 'RMSE', 'Mean price', 'RMSE/price')

line1 <- c('Type', '', '', '')
line2 <- c('Apartment size', '', '', '')
line3 <- c('Borough', '', '', '')

result_3 <- rbind(line2, a, line1, c, line3, b, d) %>%
  transform(RMSE = as.numeric(RMSE), `Mean price` = as.numeric(`Mean price`),
            `RMSE/price` = as.numeric(`RMSE/price`))

result_3


#########################################################################################
#
# PART IV
# HORSERACE: compare with other models -----------------------------------------------
#
#########################################################################################

# OLS with dummies for area
# using model B

set.seed(1234)
system.time({
ols_model <- train(
  formula(paste0('price ~', paste0(predictors_2, collapse = ' + '))),
  data = data_train,
  method = 'lm',
  trControl = train_control
)
})

ols_model_coeffs <-  ols_model$finalModel$coefficients
ols_model_coeffs_df <- data.frame(
  'variable' = names(ols_model_coeffs),
  'ols_coefficient' = ols_model_coeffs
) %>%
  mutate(variable = gsub('`','',variable))

# * LASSO
# using extended model w interactions

set.seed(1234)
system.time({
lasso_model <- train(
  formula(paste0('price ~', paste0(predictors_E, collapse = ' + '))),
  data = data_train,
  method = 'glmnet',
  preProcess = c('center', 'scale'),
  tuneGrid =  expand.grid('alpha' = 1, 'lambda' = seq(0.01, 0.25, by = 0.01)),
  trControl = train_control
)
})

lasso_coeffs <- coef(
    lasso_model$finalModel,
    lasso_model$bestTune$lambda) %>%
  as.matrix() %>%
  as.data.frame() %>%
  rownames_to_column(var = 'variable') %>%
  rename(lasso_coefficient = `s1`)  # the column has a name '1', to be renamed

lasso_coeffs_non_null <- lasso_coeffs[!lasso_coeffs$lasso_coefficient == 0,]

regression_coeffs <- merge(ols_model_coeffs_df, lasso_coeffs_non_null, by = 'variable', all=TRUE)

# CART with built-in pruning
set.seed(1234)
system.time({
cart_model <- train(
  formula(paste0('price ~', paste0(predictors_2, collapse = ' + '))),
  data = data_train,
  method = 'rpart',
  tuneLength = 10,
  trControl = train_control
)
})
cart_model
# Showing an alternative for plotting a tree
fancyRpartPlot(cart_model$finalModel, sub = '')

# GBM  -------------------------------------------------------
# See more e.g.:
#   http://uc-r.github.io/gbm_regression
gbm_grid <-  expand.grid(interaction.depth = 5, # complexity of the tree
                         n.trees = 250, # number of iterations, i.e. trees
                         shrinkage = 0.1, # learning rate: how quickly the algorithm adapts
                         n.minobsinnode = 20 # the minimum number of training set samples in a node to commence splitting
)


set.seed(1234)
system.time({
  gbm_model <- train(formula(paste0('price ~', paste0(predictors_2, collapse = ' + '))),
                     data = data_train,
                     method = 'gbm',
                     trControl = train_control,
                     verbose = FALSE,
                     tuneGrid = gbm_grid)
})
gbm_model
gbm_model$finalModel
# save(gbm_model, file = 'gbm_model.RData')
# load(url(paste0(path_url,'gbm_model.RData?raw=true')))


###
# and get prediction rmse and add to next summary table
# ---- compare these models

final_models <-
  list('OLS' = ols_model,
  'LASSO (model w/ interactions)' = lasso_model,
  'CART' = cart_model,
  'Random forest 1: smaller model' = rf_model_1,
  'Random forest 2: extended model' = rf_model_2,
  'GBM'  = gbm_model)

results <- resamples(final_models) %>% summary()
results

# Model selection is carried out on this CV RMSE
result_4 <- imap(final_models, ~{
  mean(results$values[[paste0(.y,'~RMSE')]])
}) %>% unlist() %>% as.data.frame() %>%
  rename('CV RMSE' = '.')

result_4



# evaluate preferred model on the holdout set -----------------------------

result_5 <- map(final_models, ~{
  RMSE(predict(.x, newdata = data_holdout), data_holdout[['price']])
}) %>% unlist() %>% as.data.frame() %>%
  rename('Holdout RMSE' = '.')

result_5
