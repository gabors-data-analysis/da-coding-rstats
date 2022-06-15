#######################################
#                                     #
#     Seminar 5 for Part III          #
#  Prediction with Binary outcome     #
#                                     #
# Topics covered:                     #
#   - Data cleaning & refactoring     #
#       & feature engineering         #
#       should be checked at          #
#       official case studies repo    #
#   - Winsorizing                     #
#   - Basic models:                   #
#     - Simple logit model            #
#     - Cross validation with logit   #
#     - Lasso with logit              #
#   - Evaluation of model:            #
#     - Calibration Curve,            #
#     - Confusion Matrix              #
#     - ROC, AUC                      #     
#   - Model comparison based on       #
#     - RMSE or AUC                   #
#   - Using a loss function           #
#     - user-given loss function      #
#       to pick 'best' threshold      #
#   - Random Forest and CART          #
#     - modeling probabilities        #
#       rather than categorization    #
#                                     #
# Case studies:                       #
#  -CH17A Predicting firm exit:       #
#     probability and classification  #
#                                     #
# dataset:                            #
#   bisnode-firms                     #
#                                     #
#######################################


# CLEAR MEMORY
rm(list=ls())

# Import libraries
library(tidyverse)
library(modelsummary)
library(skimr)
library(cowplot)
library(rattle)
library(caret)
library(fixest)
library(glmnet)
library(rpart)
library(rpart.plot)
library(ranger)
# Marginal effects for logit 
# (as an alternative to marginaleffects package)
if (!require(margins)){
  install.packages("margins")
  library(margins)
}
#
if (!require(gmodels)){
  install.packages("gmodels")
  library(gmodels)
}
# Color palett for prettier plot
if (!require(viridis)){
  install.packages("viridis")
  library(viridis)
}
# plotting ROC curve
if (!require(pROC)){
  install.packages("pROC")
  library(pROC)
}

# Call aux function
source('seminar_5_auxfuncs.R')



###################
# Bisnode dataset:
#   Strongly advised to check the data cleaning/feature engineering codes:
#     https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit/ch17-firm-exit-data-prep.R
#
# loading cleaned data
load(url('https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/partIII-case-studies/case5-predicting-firm-exit/data/bisnode_firms_clean.RData?raw=true'))

glimpse( bisnode )

# Summary
skimr::skim(bisnode)
datasummary_skim(bisnode, type="categorical")

############
# Check the default rate
#   and show a graph for winsorizing
#

ggplot( data = bisnode , aes( x = default ) ) +
  geom_histogram( aes( y = ..count.. / sum( count ) ) , size = 0.1 , fill = 'navyblue',
                  bins = 3)+
  labs(y='Probabilities',x='0: Exists, 1: Defaults')+
  ylim(0,1) +
  theme_bw()


# Plot the sales against default
ggplot(data = bisnode, aes(x=sales_mil_log, y=as.numeric(default))) +
  geom_point(size=2,  shape=20, stroke=2, fill="blue", color="blue") +
  geom_smooth(method = "lm", formula = y ~ poly(x,2), color='blue', se = F, size=1)+
  geom_smooth(method="loess", se=F, colour='red', size=1.5, span=0.9) +
  labs(x = "sales_mil_log",y = "default") +
  theme_bw()

#######
# Winsorizing: variations for sales change
#   you have to know your data (and theory) pretty well...

# First measure for change in sales: take the sale change in logs
ggplot(data = bisnode, aes(x=d1_sales_mil_log, y=as.numeric(default))) +
  geom_point(size=0.1,  shape=20, stroke=2, fill='blue', color='blue') +
  geom_smooth(method="loess", se=F, colour='red', size=1.5, span=0.9) +
  labs(x = "Growth rate (Diff of ln sales)",y = "default") +
  theme_bw() +
  scale_x_continuous(limits = c(-6,10), breaks = seq(-5,10, 5))

# First measure for change in sales: take the sale change in logs but now winsorized!
ggplot(data = bisnode, aes(x=d1_sales_mil_log_mod, y=as.numeric(default))) +
  geom_point(size=0.1,  shape=20, stroke=2, fill='blue', color='blue') +
  geom_smooth(method="loess", se=F, colour='red', size=1.5, span=0.9) +
  labs(x = "Growth rate (Diff of ln sales)",y = "default") +
  theme_bw() +
  scale_x_continuous(limits = c(-1.5,1.5), breaks = seq(-1.5,1.5, 0.5))

# Compare the original and winsored data
ggplot(data = bisnode, aes(x=d1_sales_mil_log, y=d1_sales_mil_log_mod)) +
  geom_point(size=0.1,  shape=20, stroke=2, fill='blue', color='blue') +
  labs(x = "Growth rate (Diff of ln sales) (original)",y = "Growth rate (Diff of ln sales) (winsorized)") +
  theme_bw() +
  scale_x_continuous(limits = c(-5,5), breaks = seq(-5,5, 1)) +
  scale_y_continuous(limits = c(-3,3), breaks = seq(-3,3, 1))

##################
# Model Building
#
#
# a) Define variable sets for modelling
#   

# Main firm variables
rawvars <-  c("curr_assets", "curr_liab", "extra_exp", "extra_inc", "extra_profit_loss", "fixed_assets",
              "inc_bef_tax", "intang_assets", "inventories", "liq_assets", "material_exp", "personnel_exp",
              "profit_loss_year", "sales", "share_eq", "subscribed_cap")
# Further financial variables
qualityvars <- c("balsheet_flag", "balsheet_length", "balsheet_notfullyear")
engvar <- c("total_assets_bs", "fixed_assets_bs", "liq_assets_bs", "curr_assets_bs",
            "share_eq_bs", "subscribed_cap_bs", "intang_assets_bs", "extra_exp_pl",
            "extra_inc_pl", "extra_profit_loss_pl", "inc_bef_tax_pl", "inventories_pl",
            "material_exp_pl", "profit_loss_year_pl", "personnel_exp_pl")
engvar2 <- c("extra_profit_loss_pl_quad", "inc_bef_tax_pl_quad",
             "profit_loss_year_pl_quad", "share_eq_bs_quad")
# Flag variables
engvar3 <- c(grep("*flag_low$", names(bisnode), value = TRUE),
             grep("*flag_high$", names(bisnode), value = TRUE),
             grep("*flag_error$", names(bisnode), value = TRUE),
             grep("*flag_zero$", names(bisnode), value = TRUE))
# Growth variables
d1 <-  c("d1_sales_mil_log_mod", "d1_sales_mil_log_mod_sq",
         "flag_low_d1_sales_mil_log", "flag_high_d1_sales_mil_log")
# Human capital related variables
hr <- c("female", "ceo_age", "flag_high_ceo_age", "flag_low_ceo_age",
        "flag_miss_ceo_age", "ceo_count", "labor_avg_mod",
        "flag_miss_labor_avg", "foreign_management")
# Firms history related variables
firm <- c("age", "age2", "new", "ind2_cat", "m_region_loc", "urban_m")

# interactions for logit, LASSO
interactions1 <- c("ind2_cat*age", "ind2_cat*age2",
                   "ind2_cat*d1_sales_mil_log_mod", "ind2_cat*sales_mil_log",
                   "ind2_cat*ceo_age", "ind2_cat*foreign_management",
                   "ind2_cat*female",   "ind2_cat*urban_m", "ind2_cat*labor_avg_mod")
interactions2 <- c("sales_mil_log*age", "sales_mil_log*female",
                   "sales_mil_log*profit_loss_year_pl", "sales_mil_log*foreign_management")

########
# Model setups

###
# 1) Simple logit models 
X1 <- c("sales_mil_log", "sales_mil_log_sq", "d1_sales_mil_log_mod", "profit_loss_year_pl", "ind2_cat")
X2 <- c("sales_mil_log", "sales_mil_log_sq", "d1_sales_mil_log_mod", "profit_loss_year_pl",
        "fixed_assets_bs","share_eq_bs","curr_liab_bs ",   "curr_liab_bs_flag_high ", 
        "curr_liab_bs_flag_error",  "age","foreign_management" , "ind2_cat")
X3 <- c("sales_mil_log", "sales_mil_log_sq", firm, engvar,                   d1)
X4 <- c("sales_mil_log", "sales_mil_log_sq", firm, engvar, engvar2, engvar3, d1, hr, qualityvars)
X5 <- c("sales_mil_log", "sales_mil_log_sq", firm, engvar, engvar2, engvar3, d1, hr, qualityvars, interactions1, interactions2)

# 2) logit+LASSO
logitvars <- c("sales_mil_log", "sales_mil_log_sq", engvar, engvar2, engvar3, d1, hr, firm, qualityvars, interactions1, interactions2)

# 3) CART and RF (no interactions, no modified features)
rfvars  <-  c("sales_mil", "d1_sales_mil_log", rawvars, hr, firm, qualityvars)



######
# Quick reminder about probability models:


# Linear probability model
ols_modelx2 <- feols(formula(paste0("default ~", paste0(X2, collapse = " + "))),
                     data = bisnode , vcov = 'hetero')
summary(ols_modelx2)

# Logit model
glm_modelx2 <- glm(formula(paste0("default ~", paste0(X2, collapse = " + "))),
                   data = bisnode, family = "binomial")
summary(glm_modelx2)

# With Logit we need to calculate average marginal effects (dy/dx)
#   to be able to interpret the coefficients (under some assumptions...)
# Note: vce="none" makes it run much faster, here we do not need variances
#   but if you do need it (e.g. prediction intervals -> take the time!)
mx2 <- margins(glm_modelx2, vce = "none")

sum_table <- summary(glm_modelx2) %>%
  coef() %>%
  as.data.frame() %>%
  select(Estimate) %>%
  mutate(factor = row.names(.)) %>%
  merge(summary(mx2)[,c("factor","AME")])

sum_table

####
# In the following:
#
#  To get you more familiar with the steps of categorization and the notions we are going to:
#     1) Run simple logit and logit + lasso models and check the CV results
#     2) Introduce to the classification problem and show the tools of:
#         - what is the threshold value and how it relates to:
#         - confusion tables, ROC, AUC.
#         - refresh the calibration curve
#     3) Show how classification problem alters if you have a loss function:
#         - how to cross-validate your loss function (Youden index)
#         - and how this criterion will give you 
#            an 'optimal threshold' for your loss function
#     4) Finally we will cover CART and Random Forest with two different setups:
#         - averaging the predicted probabilities of each tree
#         - use 'majority vote' method, which classifies each observations in each tree and 
#             then use the majority
#     5) Compare the results.
#


######################
# STEP 0)
#   separate datasets

set.seed(13505)
# Create train and holdout samples
train_indices <- as.integer(createDataPartition(bisnode$default, p = 0.8, list = FALSE))
data_train    <- bisnode[train_indices, ]
data_holdout  <- bisnode[-train_indices, ]

dim(data_train)
dim(data_holdout)



#######################################################
# Step 1) Predict probabilities 
#   with logit + logit and LASSO models
#     using CV


# 5 fold cross-validation:
#   check the summary function
train_control <- trainControl(
  method = "cv",
  number = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummaryExtended,
  savePredictions = TRUE
)

####
# a) Cross-Validate Logit Models 
logit_model_vars <- list("X1" = X1, "X2" = X2, "X3" = X3, "X4" = X4, "X5" = X5)

CV_RMSE_folds <- list()
logit_models <- list()

for (model_name in names(logit_model_vars)) {

  # setting the variables for each model
  features <- logit_model_vars[[model_name]]

  # Estimate logit model with 5-fold CV
  set.seed(13505)
  glm_model <- train(
    formula(paste0("default_f ~", paste0(features, collapse = " + "))),
    method    = "glm",
    data      = data_train,
    family    = binomial,
    trControl = train_control
  )

  # Save the results to list
  logit_models[[model_name]] <- glm_model
  # Save RMSE on test for each fold
  CV_RMSE_folds[[model_name]] <- glm_model$resample[,c("Resample", "RMSE")]

}

#####
# b) Logit + LASSO

# Set lambda parameters to check
lambda <- 10^seq(-1, -4, length = 10)
grid <- expand.grid("alpha" = 1, lambda = lambda)

# Estimate logit + LASSO with 5-fold CV to find lambda
set.seed(13505)
system.time({
  logit_lasso_model <- train(
    formula(paste0("default_f ~", paste0(logitvars, collapse = " + "))),
    data = data_train,
    method = "glmnet",
    preProcess = c("center", "scale"),
    family = "binomial",
    trControl = train_control,
    tuneGrid = grid,
    na.action=na.exclude
  )
})

# Save the results
tuned_logit_lasso_model <- logit_lasso_model$finalModel
best_lambda <- logit_lasso_model$bestTune$lambda
logit_models[["LASSO"]] <- logit_lasso_model
lasso_coeffs <- as.matrix(coef(tuned_logit_lasso_model, best_lambda))
CV_RMSE_folds[["LASSO"]] <- logit_lasso_model$resample[,c("Resample", "RMSE")]

# Soon we will check the performance...

#############################################
# Step 2)
#  Calibration Curve, Confusion Matrix,
#     ROC, AUC, 

### 
# a) For demonstration, let us use Logit Model 4 (which will turn out to be the 'best')
#     Estimate RMSE on holdout sample

best_logit_no_loss <- logit_models[["X4"]]

logit_predicted_probabilities_holdout    <- predict(best_logit_no_loss, newdata = data_holdout, type = "prob")
data_holdout[,"best_logit_no_loss_pred"] <- logit_predicted_probabilities_holdout[,"default"]
RMSE(data_holdout[, "best_logit_no_loss_pred", drop=TRUE], data_holdout$default)

####
# a) Old friend: calibration curve:
# how well do estimated vs actual event probabilities relate to each other?

create_calibration_plot(data_holdout, 
                        prob_var = "best_logit_no_loss_pred", 
                        actual_var = "default",
                        n_bins = 10)

####
# b) Confusion Matrix, with (arbitrarily) chosen threshold(s)

# default: the threshold 0.5 is used to convert probabilities to binary classes
logit_class_prediction <- predict(best_logit_no_loss, newdata = data_holdout)
summary(logit_class_prediction)

# Confusion matrix: summarize different type of errors and successfully predicted cases
# positive = "yes": explicitly specify the positive case
cm_object1 <- confusionMatrix(logit_class_prediction, data_holdout$default_f, positive = "default")
cm_object1
cm1 <- cm_object1$table
cm1

# we can apply different thresholds:
# 0.5 same as before
holdout_prediction <-
  ifelse(data_holdout$best_logit_no_loss_pred < 0.5, "no_default", "default") %>%
  factor(levels = c("no_default", "default"))
cm_object1b <- confusionMatrix(holdout_prediction,data_holdout$default_f)
cm1b <- cm_object1b$table
cm1b

# calculating the probabilities
cm1b_p <- cm1b / sum(cm1b)
cm1b_p <- cbind( cm1b_p , c( sum(cm1b_p[1,]), sum(cm1b_p[2,]) ) )
cm1b_p <- rbind( cm1b_p , c( sum(cm1b_p[,1]), sum(cm1b_p[,2]), sum(cm1b_p[,3]) ) )
cm1b_p <- round( cm1b_p*100 , 1 )
cm1b_p


# a sensible choice: mean of predicted probabilities
mean_predicted_default_prob <- mean(data_holdout$best_logit_no_loss_pred)
mean_predicted_default_prob
holdout_prediction <-
  ifelse(data_holdout$best_logit_no_loss_pred < mean_predicted_default_prob, "no_default", "default") %>%
  factor(levels = c("no_default", "default"))
cm_object2 <- confusionMatrix(holdout_prediction,data_holdout$default_f)
cm2 <- cm_object2$table
cm2


####
# c) Visualize ROC (with thresholds in steps) on holdout
#     what if we want to compare multiple thresholds?
#   Get AUC - how good our model is in terms of classification error?

thresholds <- seq(0.05, 0.75, by = 0.05)

# pre allocate lists
cm <- list()
true_positive_rates <- c()
false_positive_rates <- c()
for (thr in thresholds) {
  # get holdout prediction
  holdout_prediction <- ifelse(data_holdout[,"best_logit_no_loss_pred"] < thr, "no_default", "default") %>%
    factor(levels = c("no_default", "default"))
  # create confusion Martrix
  cm_thr <- confusionMatrix(holdout_prediction,data_holdout$default_f)$table
  cm[[as.character(thr)]] <- cm_thr
  # Categorize to true positive/false positive
  true_positive_rates <- c(true_positive_rates, cm_thr["default", "default"] /
                             (cm_thr["default", "default"] + cm_thr["no_default", "default"]))
  false_positive_rates <- c(false_positive_rates, cm_thr["default", "no_default"] /
                              (cm_thr["default", "no_default"] + cm_thr["no_default", "no_default"]))
}

# create a tibble for results
tpr_fpr_for_thresholds <- tibble(
  "threshold" = thresholds,
  "true_positive_rate"  = true_positive_rates,
  "false_positive_rate" = false_positive_rates
)

# Plot discrete ROC
ggplot(
  data = tpr_fpr_for_thresholds,
  aes(x = false_positive_rate, y = true_positive_rate, color = threshold)) +
  labs(x = "False positive rate (1 - Specificity)", y = "True positive rate (Sensitivity)") +
  geom_point(size=2, alpha=0.8) +
  scale_color_viridis(option = "D", direction = -1) +
  scale_x_continuous(expand = c(0.01,0.01), limit=c(0,1), breaks = seq(0,1,0.1)) +
  scale_y_continuous(expand = c(0.01,0.01), limit=c(0,1), breaks = seq(0,1,0.1)) +
  theme_bw() +
  theme(legend.position ="right") +
  theme(legend.title = element_text(size = 4), 
        legend.text = element_text(size = 4),
        legend.key.size = unit(.4, "cm")) 


# Or with a fairly easy commands, we can plot, the
#   continuous ROC on holdout with Logit 4
roc_obj_holdout <- roc(data_holdout$default, data_holdout$best_logit_no_loss_pred, quiet = T)
# use aux function
createRocPlot(roc_obj_holdout, "best_logit_no_loss_roc_plot_holdout")
# and quantify the AUC (Area Under the (ROC) Curve)
roc_obj_holdout$auc


######
# d) Calculate the ROC Curve and calculate AUC for each folds
#   We can compare different competing models based on AUC measure

# d1) calculate AUC for each fold
CV_AUC_folds <- list()
for (model_name in names(logit_models)) {

  auc <- list()
  model <- logit_models[[model_name]]
  for (fold in c("Fold1", "Fold2", "Fold3", "Fold4", "Fold5")) {
    # get the prediction from each fold
    cv_fold <-
      model$pred %>%
      filter(Resample == fold)
    # calculate the roc curve
    roc_obj <- roc(cv_fold$obs, cv_fold$default, quiet = TRUE)
    # save the AUC value
    auc[[fold]] <- as.numeric(roc_obj$auc)
  }

  CV_AUC_folds[[model_name]] <- data.frame("Resample" = names(auc),
                                              "AUC" = unlist(auc))
}

####
# d2) for each model: 
#     average RMSE and average AUC for each models

CV_RMSE <- list()
CV_AUC <- list()

for (model_name in names(logit_models)) {
  CV_RMSE[[model_name]] <- mean(CV_RMSE_folds[[model_name]]$RMSE)
  CV_AUC[[model_name]] <- mean(CV_AUC_folds[[model_name]]$AUC)
}

# We have 6 models, (5 logit and the logit lasso). For each we have a 5-CV RMSE and AUC.
# We pick our preferred model based on that.

nvars <- lapply(logit_models, FUN = function(x) length(x$coefnames))
# quick adjustment for LASSO
nvars[["LASSO"]] <- sum(lasso_coeffs != 0)

logit_summary1 <- data.frame("Number of predictors" = unlist(nvars),
                             "CV RMSE" = unlist(CV_RMSE),
                             "CV AUC" = unlist(CV_AUC))

# Summary for average RMSE and AUC for each model on the test sample
logit_summary1






#############################################x
# Step 3)
# We have a loss function
#

# Introduce loss function
# relative cost of of a false negative classification (as compared with a false positive classification)
FP=1
FN=10
cost = FN/FP
# the prevalence, or the proportion of cases in the population (n.cases/(n.controls+n.cases))
prevelance = sum(data_train$default)/length(data_train$default)

# Draw ROC Curve and find optimal threshold WITH loss function

best_tresholds <- list()
expected_loss <- list()
logit_cv_rocs <- list()
logit_cv_threshold <- list()
logit_cv_expected_loss <- list()

# Iterate through:
#  a) models
#  b) Folds
for (model_name in names(logit_models)) {

  model <- logit_models[[model_name]]
  colname <- paste0(model_name,"_prediction")

  best_tresholds_cv <- list()
  expected_loss_cv <- list()

  for (fold in c("Fold1", "Fold2", "Fold3", "Fold4", "Fold5")) {
    cv_fold <-
      model$pred %>%
      filter(Resample == fold)

    roc_obj <- roc(cv_fold$obs, cv_fold$default, quiet = TRUE)
    # Add the weights (costs) here!
    best_treshold <- coords(roc_obj, "best", ret="all", transpose = FALSE,
                            best.method="youden", best.weights=c(cost, prevelance))
    # save best treshold for each fold and save the expected loss value
    best_tresholds_cv[[fold]] <- best_treshold$threshold
    expected_loss_cv[[fold]] <- (best_treshold$fp*FP + best_treshold$fn*FN)/length(cv_fold$default)
  }

  # average
  best_tresholds[[model_name]] <- mean(unlist(best_tresholds_cv))
  expected_loss[[model_name]]  <- mean(unlist(expected_loss_cv))

  # for fold #5
  logit_cv_rocs[[model_name]] <- roc_obj
  logit_cv_threshold[[model_name]] <- best_treshold
  logit_cv_expected_loss[[model_name]] <- expected_loss_cv[[fold]]

  }

logit_summary2 <- data.frame("Avg of optimal thresholds" = unlist(best_tresholds),
                             "Threshold for Fold5" = sapply(logit_cv_threshold, function(x) {x$threshold}),
                             "Avg expected loss" = unlist(expected_loss),
                             "Expected loss for Fold5" = unlist(logit_cv_expected_loss))

logit_summary2

#####
# Example:
#   Create plots for Logit M4 - training sample

# get the ROC properties
r <- logit_cv_rocs[["X4"]]
# get coordinates and properties of the choosen threshold
best_coords <- logit_cv_threshold[["X4"]]
# plot for Loss function
createLossPlot(r, best_coords,
                 paste0("X4", "_loss_plot"))
# Plot for optimal ROC
createRocPlotWithOptimal(r, best_coords,
                           paste0("X4", "_roc_plot"))


####
# Pick best model based on average expected loss
#   Calculate the expected loss on holdout sample

# Get model with optimal threshold
best_logit_with_loss <- logit_models[["X4"]]
best_logit_optimal_treshold <- best_tresholds[["X4"]]

# Predict the probabilities on holdout
logit_predicted_probabilities_holdout      <- predict(best_logit_with_loss, newdata = data_holdout, type = "prob")
data_holdout[,"best_logit_with_loss_pred"] <- logit_predicted_probabilities_holdout[,"default"]

# ROC curve on holdout
roc_obj_holdout <- roc(data_holdout$default, data_holdout[, "best_logit_with_loss_pred", drop=TRUE],quiet = TRUE)

# Get expected loss on holdout:
holdout_treshold <- coords(roc_obj_holdout, x = best_logit_optimal_treshold, input= "threshold",
                           ret="all", transpose = FALSE)
# Calculate the expected loss on holdout sample
expected_loss_holdout <- (holdout_treshold$fp*FP + holdout_treshold$fn*FN)/length(data_holdout$default)
expected_loss_holdout

# Confusion table on holdout with optimal threshold
holdout_prediction <-
  ifelse(data_holdout$best_logit_with_loss_pred < best_logit_optimal_treshold, "no_default", "default") %>%
  factor(levels = c("no_default", "default"))
cm_object3 <- confusionMatrix(holdout_prediction,data_holdout$default_f)
cm3 <- cm_object3$table
cm3
# in pctg
round( cm3 / sum(cm3) * 100 , 1 )




#################################################
# Step 4)
#   PREDICTION WITH RANDOM FOREST (and CART)


### 
# warm up with CART

data_for_graph <- data_train
levels(data_for_graph$default_f) <- list("stay" = "no_default", "exit" = "default")

# First a simple CART (with pre-set cp and minbucket)
set.seed(13505)
rf_for_graph <-
  rpart(
    formula = default_f ~ sales_mil + profit_loss_year+ foreign_management,
    data = data_for_graph,
    control = rpart.control(cp = 0.0028, minbucket = 100)
  )

rpart.plot(rf_for_graph, tweak=1, digits=2, extra=107, under = TRUE)



#################################################
# A) Probability forest
#     Split by gini, ratio of 1's in each tree, 
#      and average over trees


# 5 fold cross-validation
train_control <- trainControl(
  method = "cv",
  n = 5,
  classProbs = TRUE, # same as probability = TRUE in ranger
  summaryFunction = twoClassSummaryExtended,
  savePredictions = TRUE
)
train_control$verboseIter <- TRUE

# Tuning parameters -> now only check for one setup, 
#     but you can play around with the rest, which is uncommented
tune_grid <- expand.grid(
  .mtry = 5, # c(5, 6, 7),
  .splitrule = "gini",
  .min.node.size = 15 # c(10, 15)
)

# By default ranger understoods that the outcome is binary, 
#   thus needs to use 'gini index' to decide split rule
# getModelInfo("ranger")
set.seed(13505)
rf_model_p <- train(
  formula(paste0("default_f ~ ", paste0(rfvars , collapse = " + "))),
  method = "ranger",
  data = data_train,
  tuneGrid = tune_grid,
  trControl = train_control
)

rf_model_p$results

best_mtry <- rf_model_p$bestTune$mtry
best_min_node_size <- rf_model_p$bestTune$min.node.size

# Get average (ie over the folds) RMSE and AUC
CV_RMSE_folds[["rf_p"]] <- rf_model_p$resample[,c("Resample", "RMSE")]

auc <- list()
for (fold in c("Fold1", "Fold2", "Fold3", "Fold4", "Fold5")) {
  cv_fold <-
    rf_model_p$pred %>%
    filter(Resample == fold)

  roc_obj <- roc(cv_fold$obs, cv_fold$default, quiet = TRUE)
  auc[[fold]] <- as.numeric(roc_obj$auc)
}
CV_AUC_folds[["rf_p"]] <- data.frame("Resample" = names(auc),
                                         "AUC" = unlist(auc))

CV_RMSE[["rf_p"]] <- mean(CV_RMSE_folds[["rf_p"]]$RMSE)
CV_AUC[["rf_p"]] <- mean(CV_AUC_folds[["rf_p"]]$AUC)


###
# Now use loss function and search for best thresholds and expected loss over folds
best_tresholds_cv <- list()
expected_loss_cv <- list()

for (fold in c("Fold1", "Fold2", "Fold3", "Fold4", "Fold5")) {
  cv_fold <-
    rf_model_p$pred %>%
    filter(mtry == best_mtry,
           min.node.size == best_min_node_size,
           Resample == fold)

  roc_obj <- roc(cv_fold$obs, cv_fold$default, quiet = TRUE)
  best_treshold <- coords(roc_obj, "best", ret="all", transpose = FALSE,
                          best.method="youden", best.weights=c(cost, prevelance))
  best_tresholds_cv[[fold]] <- best_treshold$threshold
  expected_loss_cv[[fold]] <- (best_treshold$fp*FP + best_treshold$fn*FN)/length(cv_fold$default)
}

# average
best_tresholds[["rf_p"]] <- mean(unlist(best_tresholds_cv))
expected_loss[["rf_p"]] <- mean(unlist(expected_loss_cv))


rf_summary <- data.frame("CV RMSE" = CV_RMSE[["rf_p"]],
                         "CV AUC" = CV_AUC[["rf_p"]],
                         "Avg of optimal thresholds" = best_tresholds[["rf_p"]],
                         "Threshold for Fold5" = best_treshold$threshold,
                         "Avg expected loss" = expected_loss[["rf_p"]],
                         "Expected loss for Fold5" = expected_loss_cv[[fold]])

rf_summary

###
# Create plots - this is for Fold5

createLossPlot(roc_obj, best_treshold, "rf_p_loss_plot")
createRocPlotWithOptimal(roc_obj, best_treshold, "rf_p_roc_plot")

####
# Take model to holdout and estimate RMSE, AUC and expected loss
rf_predicted_probabilities_holdout <- predict(rf_model_p, newdata = data_holdout, type = "prob")
data_holdout$rf_p_prediction <- rf_predicted_probabilities_holdout[,"default"]
RMSE(data_holdout$rf_p_prediction, data_holdout$default)

# ROC curve on holdout
roc_obj_holdout <- roc(data_holdout$default, data_holdout[, "rf_p_prediction", drop=TRUE], quiet=TRUE)

# AUC
as.numeric(roc_obj_holdout$auc)

# Get expected loss on holdout with optimal threshold
holdout_treshold <- coords(roc_obj_holdout, x = best_tresholds[["rf_p"]] , input= "threshold",
                           ret="all", transpose = FALSE)
expected_loss_holdout <- (holdout_treshold$fp*FP + holdout_treshold$fn*FN)/length(data_holdout$default)
expected_loss_holdout


# Summary results

nvars[["rf_p"]] <- length(rfvars)

summary_results <- data.frame("Number of predictors" = unlist(nvars),
                              "CV RMSE" = unlist(CV_RMSE),
                              "CV AUC" = unlist(CV_AUC),
                              "CV threshold" = unlist(best_tresholds),
                              "CV expected Loss" = unlist(expected_loss))

model_names <- c("Logit X1", "Logit X4",
                 "Logit LASSO","RF probability")
summary_results <- summary_results %>%
  filter(rownames(.) %in% c("X1", "X4", "LASSO", "rf_p"))
rownames(summary_results) <- model_names

summary_results


#################################################
# B) Classification forest
# Split by Gini, majority vote in each tree, 
#     majority vote over trees
#   Difference: before we have averaged the probabilities
#       now, we grow a tree, make a prediction, based on that we classify each observation
#       to be 0 or 1. We do it for each tree, then check which classification has more 'vote'
#       if there is more 0 then it is going to be classified as 0 and vica-versa.
#
# USE ONLY IF AGNOSTIC ABOUT THE EXPECTED LOSS!!! 

train_control <- trainControl(
  method = "cv",
  n = 5
)
train_control$verboseIter <- TRUE

set.seed(13505)
rf_model_f <- train(
  formula(paste0("default_f ~ ", paste0(rfvars , collapse = " + "))),
  method = "ranger",
  data = data_train,
  tuneGrid = tune_grid,
  trControl = train_control
)

# Predict on both samples
data_train$rf_f_prediction_class   <- predict(rf_model_f, type = "raw")
data_holdout$rf_f_prediction_class <- predict(rf_model_f, newdata = data_holdout, type = "raw")

# We use predicted classes to calculate expected loss based on our loss fn
fp <- sum(data_holdout$rf_f_prediction_class == "default"    & data_holdout$default_f == "no_default")
fn <- sum(data_holdout$rf_f_prediction_class == "no_default" & data_holdout$default_f == "default")
(fp*FP + fn*FN)/length(data_holdout$default)


######################
# Summary for horse-race with binary variables
#   Goal is to categorize the newcomers in the live data
#   Steps:
#       1) separate datasets - training and holdout set to evaluate model performance
#       2) Variables and models:
#         a) Define outcome (y) variable and the explanatory (x) variables
#            and their functional forms and interactions.
#         b) Decide which model/algorithm to use. 
#               Note your set of x variables should depend on your model/algorithm choice:
#               E.g. Interactions in LASSO but not in CART/RF
#       3) Decide on the criterion to use in model evaluation. We discussed the following:
#           - Mean Squared Error (MSE) -> same results as RMSE, Brier score or 'gini index'.
#                   - the latter two MSE = Brier = gini is only true in case of binary outcome
#           - Area Under the (ROC) Curve (AUC) -> specifically for classification (not covered here)
#           - Implement your expected loss function (not covered here)
#       4) Apply classification threshold to convert probabilities to categories:
#           - selecting classification threshold will influence 
#               the false negative and false positive categorization
#           - use a loss function to decide the value/loss from making a wrong decision
#               Note: minimize expected loss and maximizing the Youden index will give the same result.
#           - Note: AUC will give you 0.5 and 0.5 weights on both and give the 'best' threshold accordingly

