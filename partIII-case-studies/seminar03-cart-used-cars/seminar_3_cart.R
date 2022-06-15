#####################################
#                                   #
#     Seminar 3 for Part III        #
#     Prediction with CART          #
#                                   #
# Topics covered:                   #
#   - Regression trees              #
#       - sample splitting          #
#       - visualize simple tree     #
#       - depth, no leaves, etc     #
#       - pruning                   #
#       - diagnostics via           #
#         variable importance plots #
#   - Prediction evaluation         #
#     - which model gives           #
#       best prediction on hold-out #
#     - comparing to lin. reg       #
#                                   #
# Case studies:                     #
#  - CH15A Predicting used car      #
#       value with regression trees #
#                                   #
# dataset:                          #
#   used-cars                       #
#                                   #
#####################################

# CLEAR MEMORY
rm(list=ls())

# Descriptive statistics and regressions
library(caret)
library(tidyverse)
library(ggthemes)
library(gridExtra)
library(glmnet)
library(modelsummary)
library(fixest)
if (!require(rpart)){
  install.packages("rpart")
  library(rpart)
}
if (!require(rattle)){
  install.packages("rattle")
  library(rattle)
}
if (!require(rpart.plot)){
  install.packages("rpart.plot")
  library(rpart.plot)
}


#####
# DATA IMPORT
cars <- read_csv( "https://osf.io/7gvz9/download" )
# convert to factor
cars <- cars %>% mutate_if(is.character, factor)

glimpse( cars )

# SAMPLE DESIGN

# manage missing
cars$fuel         <- fct_explicit_na(cars$fuel, na_level = "Missing")
cars$drive        <- fct_explicit_na(cars$drive, na_level = "Missing")
cars$cylinders    <- fct_explicit_na(cars$cylinders, na_level = "Missing")
cars$transmission <- fct_explicit_na(cars$transmission, na_level = "Missing")
cars$type         <- fct_explicit_na(cars$type, na_level = "Missing")


# missing changed to good not missing
cars$condition[is.na(cars$condition)] <- "good"
datasummary( condition ~ N + Percent() , data = cars )

# same steps as in ch13, see code in ch13 for details
cars <- cars %>% filter(Hybrid ==0) %>% dplyr::select(-Hybrid)
cars <- cars %>% filter(fuel=="gas")
cars <- cars %>% filter(!condition %in% c("new", "fair"))
cars <- cars %>% filter(price %in% c(500:25000), odometer <=100)
cars <- cars %>% filter(!(price < 1000 & (condition == "like new"|age < 8)))
cars <- cars %>% filter(!(transmission == "manual"))
cars <- cars %>% filter(!type %in% c("truck", "pickup"))
cars <- cars %>% dplyr::select(-pricestr)

# to be on the safe side
cars <- cars %>% drop_na(price)


################################################################################

# DATA GENERATION & DESCRIPTIVES
# price  age   odometer + condition cylinder dealer city LE

# condition
cars <- cars %>%
  mutate(cond_excellent = ifelse(condition == "excellent", 1,0),
         cond_good = ifelse(condition == "good", 1,0),
         cond_likenew = ifelse(condition == "like new", 1,0))

# cylinders
cars <- cars %>%
  mutate(cylind6 = ifelse(cylinders=="6 cylinders",1,0))


#chicago
cars$chicago <- ifelse(cars$area=="chicago",1,0)

# age: quadratic, cubic
cars <- cars %>%
  mutate(agesq = age^2,
         agecu = age^3)

# odometer: quadratic
cars <- cars %>%
  mutate(odometersq = odometer^2)



datasummary_skim(cars, 'numeric')
datasummary_skim(cars, 'categorical')


datasummary( price ~ Mean + Median + SD + P25 + P75 + Min + Max + N , data = cars )



#################################
# Create test and train samples #
#################################
# now all stuff runs on training vs test (holdout), alternative: 4-fold CV


# create test and train samples (70% of observations in train sample)
smp_size <- floor(0.7 * nrow(cars))
set.seed(20180122)

train_ids <- sample(seq_len(nrow(cars)), size = smp_size)
cars$train <- 0
cars$train[train_ids] <- 1
# Create train and test sample variables
data_train <- cars %>% filter(train == 1)
data_test <- cars %>% filter(train == 0)



#####################
# Regression tree (rpart)

datasummary( price + age ~ Mean + Median + P75 + P25 + Min + Max , data = cars )

####
# SIMPLEST CASE: 
#   age is the only predictor and we allow only one split
model1 <- formula(price ~ age)

# Single split
# (make sure it's a single split by setting "maxdepth" to 1)
cart1 <- train(
  model1, 
  data = data_train, 
  method = "rpart2",
  trControl = trainControl(method="none"),
  tuneGrid= data.frame(maxdepth=1) )

# Summary
summary(cart1$finalModel)
# Tree graph
rpart.plot(cart1$finalModel, tweak=1.2, digits=-1, extra=1)
# Calculate RMSE
pred_cart1 <- predict(cart1, data_test)
rmse_cart1 <- sqrt(mean((pred_cart1 - data_test$price)^2))

# Visualize:
# Scatterplot with step function
plot_helper    <- seq(min(data_train$age), max(data_train$age))
plot_helper_df <- data.frame(age=plot_helper)
plot_helper_df$xend <- c(plot_helper+1)
plot_helper_df$yend <- predict(cart1, plot_helper_df)
pred_cart1t <- predict(cart1, data_train)

ggplot(data = data_train, aes(x = age, y=price)) +
  geom_point() +
  geom_segment(data = plot_helper_df,  aes(x = age, y=yend, xend=xend, yend=yend), 
               color='blue', size=1, na.rm=TRUE) +
  scale_y_continuous(expand=c(0.01,0.01), limits=c(0, 20000), breaks=seq(0, 20000, by=2500)) +
  scale_x_continuous(expand=c(0.01,0.01),limits=c(0, 25), breaks=seq(0, 25, by=5)) +
  labs(x = "Age (years)", y = "Price (US dollars)") +
  theme_bw() 

###########
# Splits at two levels
# (make sure it stops by setting "maxdepth" to 2)

cart2 <- train(
  model1, data = data_train, method = "rpart2",
  trControl = trainControl(method="none"),
  tuneGrid= data.frame(maxdepth=2))

# Tree
rpart.plot(cart2$finalModel, tweak=1.2, digits=-1, extra=1)

# Put it into a tibble
tab_cart2 <- tibble(
  "Category" = c("Age 1-4", "Age 5-7","Age 8-12","Age 13 or more"),
  "Count" = c( summary(cart2)$frame$n[7], summary(cart2)$frame$n[6], summary(cart2)$frame$n[4], summary(cart2)$frame$n[3]),
  "Average_price" = c(summary(cart2)$frame$yval[7], summary(cart2)$frame$yval[6], summary(cart2)$frame$yval[4], summary(cart2)$frame$yval[3])
  )
tab_cart2
# Calculate RMSE
pred_cart2 <- predict(cart2, data_test)
rmse_cart2 <- sqrt(mean((pred_cart2 - data_test$price)^2))

# Visualize
# Scatterplot with step function
plot_helper_df$yend <- predict(cart2, plot_helper_df)
pred_cart1t <- predict(cart1, data_train)

ggplot(data = data_train, aes(x=age , y=price)) +
  geom_point() +
  geom_segment(data = plot_helper_df, aes(x = age, y=yend, xend=xend, yend=yend), 
               color='blue', size=1, na.rm=TRUE) +
  scale_y_continuous(expand=c(0.01,0.01), limits=c(0, 20000), breaks=seq(0, 20000, by=2500)) +
  scale_x_continuous(expand=c(0.01,0.01),limits=c(0, 25), breaks=seq(0, 25, by=5)) +
  labs(x = "Age (years)", y = "Price (US dollars)") +
  theme_bw() 


############
# Splits go on according to rpart defaults
# 
cart3 <- train(
  model1, data = data_train, method = "rpart",
  trControl = trainControl(method="none"),
  tuneGrid= expand.grid(cp = 0.01))

# Tree graph
rpart.plot(cart3$finalModel, tweak=1.2, digits=-1, extra=1)
# RMSE
pred_cart3 <- predict(cart3, data_test)
rmse_cart3 <- sqrt(mean((pred_cart3 - data_test$price)^2))


# Scatterplot with step function - train data
plot_helper_df$yend <- predict(cart3, plot_helper_df)
pred_cart3t <- predict(cart3, data_train)

ggplot(data = data_train, aes(x=age , y=price)) +
  geom_point() +
  geom_segment(data = plot_helper_df, aes(x = age, y=yend, xend=xend, yend=yend), color='blue', size=1, na.rm=TRUE) +
  scale_y_continuous(expand=c(0.01,0.01), limits=c(0, 20000), breaks=seq(0, 20000, by=2500)) +
  scale_x_continuous(expand=c(0.01,0.01),limits=c(0, 25), breaks=seq(0, 25, by=5)) +
  labs(x = "Age (years)", y = "Price (US dollars)") +
  theme_bw() 


#####################
# Competing model:
#   OLS: Age only (Linear regression)

linreg1 <- feols(model1 , data=data_train, vcov = 'hetero' )
linreg1
pred_linreg1 <- predict(linreg1, data_test)
rmse_linreg1 <- sqrt(mean((pred_linreg1 - data_test$price)^2))

# Scatterplot with predicted values
pred_linreg1t<- predict(linreg1, data_train)

ggplot(data = data_train) +
  geom_point(aes(x = age, y = price), color = 'red', size = 1,  shape = 16, alpha = 0.7, show.legend=FALSE, na.rm = TRUE) +
  geom_line(aes(x=age,y=pred_linreg1t), colour='blue', size=0.7) +
  scale_y_continuous(expand=c(0.01,0.01), limits=c(0, 20000), breaks=seq(0, 20000, by=2500)) +
  scale_x_continuous(expand=c(0.01,0.01), limits=c(0, 25), breaks=seq(0, 25, by=5)) +
  labs(x = "Age (years)", y = "Price (US dollars)") +
  theme_bw() 


#####################
# Age only, Lowess  regression

lowess1 <- loess(model1, data=data_train)
# no prediction with loess on test
pred_lowess1 <- predict(lowess1, data_test)
rmse_lowess1 <- sqrt(mean((pred_lowess1 - data_test$price)^2))

# Scatterplot with predicted values
lowess1 <- loess(model1, data=data_train)
pred_lowess1t <- predict(lowess1, data_train)

ggplot(data = data_train, aes(x=age , y=price)) +
  geom_point(size=1, colour="black" ) +
  labs(x = "Age", y = "Price") +
  coord_cartesian(xlim=c(0, 25), ylim=c(0, 20000)) +
  geom_smooth(method="loess", colour="darkblue", se=F, size=1.5) +
  theme_bw()


########################################
# OLS - MULTIPLE PREDICTOR VARIABLES


#####################
# Linear regression with multiple variables
model2 <- formula(price ~ age + odometer + LE + XLE + SE + cond_excellent + cond_good + cylind6 + dealer+chicago)
linreg2 <- feols(model2 , data=data_train ,vcov= 'hetero')
linreg2
pred_linreg2 <- predict(linreg2, data_test)
rmse_linreg2 <- sqrt(mean((pred_linreg2 - data_test$price)^2))

# add squared for age, odometer
model3 <- formula(price ~ age + agesq+ odometer+odometersq +LE + XLE + SE + cond_excellent + cond_good + cylind6 + dealer+chicago)
linreg3 <- feols(model3 , data=data_train,vcov='hetero')
linreg3
pred_linreg3 <- predict(linreg3, data_test)
rmse_linreg3 <- sqrt(mean((pred_linreg3 - data_test$price)^2))

#############
# Tree - maybe cut cart4...

# Splits at four levels, for illustrative purposes
# (make sure it stops by setting "maxdepth" to 4)
cart4 <- train(
  model2, data=data_train, method = "rpart2",
  trControl = trainControl(method="none"),
  tuneGrid= data.frame(maxdepth=4),
  na.action = na.pass)

# Tree graph
rpart.plot(cart4$finalModel, tweak=1.2, digits=-1, extra=1)
# RMSE Prediction
pred_cart4 <- predict(cart4, data_test, na.action = na.pass)
rmse_cart4 <- sqrt(mean((pred_cart4 - data_test$price)^2))




cart5 <- train(
  model2, data=data_train, method = "rpart",
  trControl = trainControl(method="none"),
  tuneGrid= expand.grid(cp = 0.002),
  control = rpart.control(minsplit = 20),
  na.action = na.pass)

print(cart5)

# Tree graph
rpart.plot(cart5$finalModel, tweak=1.2, digits=-1, extra=1)
# RMSE Prediction
pred_cart5 <- predict(cart5, data_test, na.action = na.pass)
rmse_cart5 <- sqrt(mean((pred_cart5 - data_test$price)^2))



############################
# prune the tree
############################


# build very large tree

cart6 <- train(
  model2, data=data_train, method = "rpart",
  trControl = trainControl(method="none"),
  tuneGrid= expand.grid(cp = 0.0001),
  control = rpart.control(minsplit = 4),
  na.action = na.pass)


# Tree graph
rpart.plot(cart6$finalModel, tweak=1.2, digits=-1, extra=1)
# Get prediction from an overfitted tree
pred_cart6 <- predict(cart6, data_test, na.action = na.pass)
rmse_cart6 <- sqrt(mean((pred_cart6 - data_test$price)^2))

###
# take the last model (large tree) and prune (cut back)
pfit <-prune(cart6$finalModel, cp=0.005 )
summary(pfit)

# Tree graph
rpart.plot(pfit, digits=-1, extra=1, tweak=1)

# getting rmse
pred_cart7 <- predict(pfit, data_test, na.action = na.pass)
rmse_cart7 <- sqrt(mean((pred_cart7 - data_test$price)^2))
rmse_cart7

# Show the improvement with different pruning parameter
printcp(pfit)




######## summary performance table

tab_rmse <- tibble(
  "Model" = c("CART1", "CART2","CART3","CART4", "CART5","CART6","CART7", "OLS multivar", "OLS extended"),
  "Describe" = c("2 term. nodes", "4 term. nodes","5 term. nodes","cp = 0.01","cp = 0.002","cp = 0.0001","pruned", "multi-var", "w/ squared vars"),
  "RMSE" = c(rmse_cart1, rmse_cart2, rmse_cart3, rmse_cart4,rmse_cart5,rmse_cart6,rmse_cart7, rmse_linreg2, rmse_linreg3)
)
tab_rmse

arrange( tab_rmse , RMSE )


#############
# Variable importance

cart4_var_imp <- varImp(cart4)$importance
cart4_var_imp
# Make it pretty for the plot
cart4_var_imp_df <-
  data.frame(varname = rownames(cart4_var_imp),imp = cart4_var_imp$Overall) %>%
  mutate(varname = gsub("cond_", "Condition:", varname) ) %>%
  arrange(desc(imp)) %>%
  mutate(imp_percentage = imp/sum(imp))

ggplot(cart4_var_imp_df, aes(x=reorder(varname, imp), y=imp_percentage)) +
  geom_point(color='red', size=2) +
  geom_segment(aes(x=varname,xend=varname,y=0,yend=imp_percentage), color='red', size=1.5) +
  ylab("Importance") +
  xlab("Variable Name") +
  coord_flip() +
  scale_y_continuous(expand = c(0.01,0.01),labels = scales::percent_format(accuracy = 1)) +
  theme_bw()



############################################################x

## a note for varimp 

# https://topepo.github.io/caret/variable-importance.html
# Recursive Partitioning: The reduction in the loss function (e.g. mean squared error) 
#   attributed to each variable at each split is tabulated and the sum is returned. 
#   Also, since there may be candidate variables that are important but are not used in a split,
#   the top competing variables are also tabulated at each split. 
#   This can be turned off using the maxcompete argument in rpart.control.
# To avoid this, we can rerun cart4 with a new control fn to ensure matching 
  
cart4 <- train(
  model2, data=data_train, method = "rpart",
  trControl = trainControl(method="none"),
  tuneGrid= expand.grid(cp = 0.01),
  control = rpart.control(minsplit = 20, maxcompete = FALSE),
  na.action = na.pass)

cart4_var_imp <- varImp(cart4)$importance
cart4_var_imp_df <-
    data.frame(varname = rownames(cart4_var_imp),imp = cart4_var_imp$Overall) %>%
    mutate(varname = gsub("cond_", "Condition:", varname) ) %>%
    arrange(desc(imp)) %>%
    mutate(imp_percentage = imp/sum(imp))
  
ggplot(cart4_var_imp_df, aes(x=reorder(varname, imp), y=imp_percentage)) +
    geom_point(color='red', size=2) +
    geom_segment(aes(x=varname,xend=varname,y=0,yend=imp_percentage), color='red', size=1.5) +
    ylab("Importance") +
    xlab("Variable Name") +
    coord_flip() +
    scale_y_continuous(expand = c(0.01,0.01),labels = scales::percent_format(accuracy = 1)) +
    theme_bw()

