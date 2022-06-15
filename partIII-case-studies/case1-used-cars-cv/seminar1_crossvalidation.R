#####################################
#                                   #
#   Seminar 1 for Part III          #
#     Model selection with          #
#       cross-validation            #
#                                   #
# Topics covered:                   #
#   - Data cleaning & refactoring   #
#   - Basic feature engineering     #
#   - Multiple var regression       #
#   - Model selection with:         #
#     - cross validation by hand    #
#     - built-in function by caret  #
#   - Prediction with best model    #
#   - Log-transformed outcome model #
#     - transformation of           #
#       log prediction to level     #
#                                   #
# Case studies:                     #
#  -CH13A Predicting used car       #
#   value with linear regressions   #
#  -CH14A Predicting used           #
#     car value: log prices         #
#                                   #
# dataset:                          #
#   used-cars                       #
#                                   #
#####################################

# CLEAR MEMORY
rm(list=ls())

# Import libraries
library(tidyverse)
library(fixest)
library(modelsummary)
library(grid)
if (!require( caret ) ){
  install.packages("caret")
  library(caret)
}



##############
# 1) DATA IMPORT
#
cars <- read.csv( 'https://osf.io/7gvz9/download', stringsAsFactors = TRUE)

# check the datatable
glimpse( cars )

##############
# 2) Data Cleaning
# 

# manage missing: set as factors
cars$fuel         <- fct_explicit_na(cars$fuel, na_level = "Missing")
cars$condition    <- fct_explicit_na(cars$condition, na_level = "Missing")
cars$drive        <- fct_explicit_na(cars$drive, na_level = "Missing")
cars$cylinders    <- fct_explicit_na(cars$cylinders, na_level = "Missing")
cars$transmission <- fct_explicit_na(cars$transmission, na_level = "Missing")
cars$type         <- fct_explicit_na(cars$type, na_level = "Missing")

# check frequency by fuel type
datasummary( fuel ~ N + Percent() , data = cars)

# keep the gas-fuelled vehicles only
cars <- cars %>% filter( fuel=="gas" )

# check frequency by vehicle condition
datasummary( condition ~ N + Percent() , data = cars )

# drop vehicles in fair and new condition
cars <- cars %>% filter(!condition %in% c("new", "fair"))

# drop unrealistic values for price and odometer reading
cars <- cars %>% filter(price %in% c(500:25000), odometer <=100)

# drop if price is smaller than 1000 and condition is like new or age is less than 8
cars <- cars %>% filter(!(price < 1000 & (condition == "like new"|age < 8)))

# check frequency by transmission
datasummary( transmission ~ N + Percent(), data = cars )

# remove obs w manual transmission,
cars <- cars %>% filter(!(transmission == "manual"))

# Check the types
datasummary( type ~ N + Percent(), data = cars )

# drop if truck
cars <- cars %>% filter(!(type == "truck"))
 
# drop pricestr
cars <- cars %>% dplyr::select(-pricestr)


###
# 3) Data refactoring

# condition
cars <- cars %>%
  mutate(cond_excellent = ifelse(condition == "excellent", 1,0),
         cond_good = ifelse(condition == "good", 1,0),
         cond_likenew = ifelse(condition == "like new", 1,0))

# cylinders
cars <- cars %>%
  mutate(cylind6 = ifelse(cylinders=="6 cylinders",1,0))

datasummary( cylinders + as.factor( cylind6 ) ~ N + Percent() , data = cars )


# age: quadratic, cubic
cars <- cars %>%
  mutate(agesq = age^2,
         agecu = age^3)

# odometer: quadratic
cars <- cars %>%
  mutate(odometersq = odometer^2)


# Frequency tables: area 
datasummary( area * price ~ N + Mean , data = cars )

# focus only on Chicago
cars <- cars %>%
  filter(area=="chicago")

# condition
datasummary( condition * price ~ N + Mean , data = cars )

# dealer
datasummary( as.factor( dealer ) * price ~ N + Mean , data = cars )

# data summary
datasummary( age + odometer + LE + XLE + SE + cond_likenew + cond_excellent + cond_good + cylind6 ~
               Mean + Median + Min + Max + P25 + P75 + N , data = cars )
#####
# 4) Histograms - check the outcome variable
# a) price
ggplot(data=cars, aes(x=price)) +
  geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 1000, boundary=0,
                 fill = 'navyblue', color = 'white', size = 0.25, alpha = 0.8,  show.legend=F, na.rm=TRUE) +
  coord_cartesian(xlim = c(0, 20000)) +
  labs(x = "Price (US dollars)",y = "Percent")+
  theme_bw() +
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand = c(0.01,0.01),labels = scales::percent_format(accuracy = 1)) +
  scale_x_continuous(expand = c(0.01,0.01),breaks = seq(0,20000, 2500))


# b) log of price (for later usage)
ggplot(data=cars, aes(x=lnprice)) +
  geom_histogram(aes(y = (..count..)/sum(..count..)), binwidth = 0.2, boundary=0,
                 fill = 'navyblue', color = 'white', size = 0.25, alpha = 0.8,  show.legend=F, na.rm=TRUE) +
  coord_cartesian(xlim = c(6, 10)) +
  labs(x = "ln(Price, US dollars)",y = "Percent")+
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand = c(0.01,0.01),labels = scales::percent_format(accuracy = 0.1)) +
  scale_x_continuous(expand = c(0.01,0.01),breaks = seq(6,10, 1)) +
  theme_bw() 


################################################
# 5) REGRESSION ANALYSIS I. - Predicting Price
#

# lowess with observations
ggplot(data = cars, aes(x=age, y=price)) +
  geom_point( color = 'blue', size = 2,  shape = 16, alpha = 0.8, show.legend=F, na.rm = TRUE) + 
  geom_smooth(method="loess", se=F, colour='red', size=1, span=0.9) +
  labs(x = "Age (years)",y = "Price (US dollars)") +
  theme_bw() +
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0,20000), breaks = seq(0,20000, 5000)) +
  scale_x_continuous(expand = c(0.01,0.01),limits = c(0,30), breaks = seq(0,30, 5))

# Lowess vs. quadratic specification with age
ggplot(data = cars, aes(x=age,y=price)) +
  geom_smooth( aes(colour='red'), method="loess", formula = y ~ x,se=F, size=1) +
  geom_smooth( aes(colour='black'), method="lm", formula = y ~ poly(x,2) , se=F, size=1) +
  geom_point( aes( y = price ) , color = 'blue', size = 1,  shape = 16, alpha = 0.8, show.legend=F, na.rm = TRUE) + 
  labs(x = "Age (years)",y = "Price (US dollars)") +
  scale_color_manual(name="", values=c('red','black'),labels=c("Lowess in age","Quadratic in age")) +
  theme_bw() +
  scale_x_continuous(limits = c(0,30), breaks = seq(0,30, 5)) +
  scale_y_continuous(limits = c(0,20000), breaks = seq(0,20000, 5000)) +
  theme(legend.position = c(0.7,0.7),
        legend.direction = "horizontal",
        legend.background = element_blank(),
        legend.box.background = element_rect(color = "white"))



#######################################################
# 5A) Running linear regressions using all observations

# Model 1: Linear regression on age
model1 <- as.formula(price ~ age + agesq)
# Models 2-5: Multiple linear regressions
# note: condition - missing will be baseline for regs
model2 <- as.formula(price ~ age + agesq + odometer)
model3 <- as.formula(price ~ age + agesq + odometer + odometersq + LE + cond_excellent + cond_good + dealer)
model4 <- as.formula(price ~ age + agesq + odometer + odometersq + LE + XLE + SE + cond_likenew +
                       cond_excellent + cond_good + cylind6 + dealer)

model5 <- as.formula(price ~ age + agesq + agecu + odometer + odometersq + LE*age + XLE*age + SE*age +
                       cond_likenew*age + cond_excellent*age + cond_good*age + cylind6*age + odometer*age + dealer*age)

# Running simple OLS
reg1 <- feols(model1, data=cars, vcov = 'hetero')
reg2 <- feols(model2, data=cars, vcov = 'hetero')
reg3 <- feols(model3, data=cars, vcov = 'hetero')
reg4 <- feols(model4, data=cars, vcov = 'hetero')
reg5 <- feols(model5, data=cars, vcov = 'hetero')

# evaluation of the models: using all the sample
fitstat_register("k", function(x){length( x$coefficients ) - 1}, "No. Variables")
etable( reg1 , reg2 , reg3 , reg4 , reg5 , fitstat = c('aic','bic','rmse','r2','n','k') )



#####################
# 5B) Cross-validation for better evaluation of predictive performance
#

# We are going to use the 'caret' package mainly.
#  It is also a container package (similarly to `tidyverse`)
# Good to read if want to understand better: https://topepo.github.io/caret/

# Simple k-fold cross validation setup:
# 1) Used method for estimating the model: "lm" - linear model (y_hat = b0+b1*x1+b2*x2 + ...)
# 2) set number of folds to use (must be less than the no. observations)
k <- 4

# We use the 'train' function which allows many type of model training -> use cross-validation
set.seed(13505)
cv1 <- train(model1, cars, method = "lm", trControl = trainControl(method = "cv", number = k))

# Check the output:
cv1
summary(cv1)
cv1$results
cv1$resample

set.seed(13505)
cv2 <- train(model2, cars, method = "lm", trControl = trainControl(method = "cv", number = k))
set.seed(13505)
cv3 <- train(model3, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")
set.seed(13505)
cv4 <- train(model4, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")
set.seed(13505)
cv5 <- train(model5, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")

# Calculate RMSE for each fold and the average RMSE as well
cv <- c("cv1", "cv2", "cv3", "cv4", "cv5")
rmse_cv <- c()

for(i in 1:length(cv)){
  rmse_cv[i] <- sqrt((get(cv[i])$resample[[1]][1]^2 +
                       get(cv[i])$resample[[1]][2]^2 +
                       get(cv[i])$resample[[1]][3]^2 +
                       get(cv[i])$resample[[1]][4]^2)/4)
}


# summarize results
cv_mat <- data.frame(rbind(cv1$resample[4], "Average"),
           rbind(cv1$resample[1], rmse_cv[1]),
           rbind(cv2$resample[1], rmse_cv[2]),
           rbind(cv3$resample[1], rmse_cv[3]),
           rbind(cv4$resample[1], rmse_cv[4]),
           rbind(cv5$resample[1], rmse_cv[5])
           )

colnames(cv_mat)<-c("Resample","Model1", "Model2", "Model3", "Model4", "Model5")
cv_mat 

# Show model complexity and out-of-sample RMSE performance
m_comp <- c()
models <- c("reg1", "reg2", "reg3", "reg4", "reg5")
for( i in 1 : length(cv) ){
  m_comp[ i ] <- length( get( models[i] )$coefficient  - 1 ) 
}

m_comp <- tibble( model = models , 
                  complexity = m_comp,
                  RMSE = rmse_cv )

ggplot( m_comp , aes( x = complexity , y = RMSE ) ) +
  geom_point(color='red',size=2) +
  geom_line(color='blue',size=0.5)+
  labs(x='Number of explanatory variables',y='Averaged RMSE on test samples',
       title='Prediction performance and model compexity') +
  theme_bw()


###############
# 5C) Prediction
#   Compare model1 and model3 to predict our car

# Use only the predictor variables and outcome
cars <- cars %>% select(age, agesq, odometer, odometersq, SE, LE, XLE, cond_likenew,
                        cond_excellent, cond_good, dealer,price, lnprice, cylind6)

# Add new observation that we would like to predict
new <- tibble(age=10, agesq=10^2,odometer=12,odometersq=12^2,SE=0,XLE=0, LE=1, 
            cond_likenew=0,cond_excellent=1,cond_good=0, 
            dealer=0, cylind6=0, price=NA)


# Predict price with only 2 predictors (Model1)
pred1 <- feols(model1, data=cars, vcov = 'hetero')
# Standard errors of residuals
p1 <- predict(pred1, cars)
resid_p1 <- p1-cars$price
summary(resid_p1)
# calculate the RMSE by hand:
sqrt( mean( resid_p1^2 ) )

# predict value for newly added obs
pred1_new <- predict(pred1, newdata = new ,se.fit = TRUE, interval = "prediction")
p1 <- pred1_new$fit
pred1_new

# Predict price with all predictors (Model3)
pred3 <- feols(model3, data=cars,vcov = 'hetero')
# Standard errors of residuals
p3 <- predict(pred3, cars)
resid_p3 <- p3-cars$price
summary(resid_p3)
# predict value for newly added obs
pred3_new <- predict(pred3, newdata = new,se.fit = TRUE, interval = "prediction")
p3<- pred3_new$fit
pred3_new 

#get model RMSE for model3
cars$p3a <- predict( pred3, cars)
rmse3 <- RMSE(cars$p3a,cars$price)
rmse3

# Result summary
sum1 <- cbind(t(pred1_new[,c(1,3,4)]), t(pred3_new[,c(1,3,4)]))
colnames(sum1) <- c('Model1', 'Model3')
rownames(sum1) <- c('Predicted', 'PI_low (95%)', 'PI_high (95%)')

sum1



# Prediction with 80% PI:
# predict value for newly added obs
pred1_new80 <- predict(pred1, newdata = new, se.fit=TRUE, interval = "prediction", level=0.8)
p180<- pred1_new80$fit
pred3_new80 <- predict(pred3, newdata = new,se.fit = TRUE, interval = "prediction", level=0.8)
p380<- pred3_new80$fit

# Result summary
sum2 <- cbind(t(pred1_new80[,c(1,3,4)]), t(pred3_new80[,c(1,3,4)]))
colnames(sum2) <- c('Model1', 'Model3')
rownames(sum2) <- c('Predicted', 'PI_low (80%)', 'PI_high (80%)')
sum2

# Summarize
rbind(sum1,sum2[2:3,])



#####################
# 6) LOG TRANSFORMATION


# Reminder: lnprice
ggplot(data = cars, aes(x = age, y = lnprice)) +
  geom_point(color = 'blue', size = 2,  shape = 16, alpha = 0.8, show.legend=FALSE, na.rm=TRUE) +
  geom_smooth(method="loess", color='red', se=F, size=1, na.rm=T)+
  scale_x_continuous(expand = c(0.01,0.01), limits = c(0,30), breaks = seq(0,30, 5)) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(6, 10), breaks = seq(6,10, 1)) +
  labs(x = "Age (years)", y = "ln(price, US dollars)") +
  theme_bw() 


###################################
# 6A) Linear regressions with logs

# Model 1: Linear regression on age
model1log <- as.formula(lnprice ~ age +agesq )
# Models 2-5: no quads
model2log <- as.formula(lnprice ~ age  + agesq + odometer + odometersq)
model3log <- as.formula(lnprice ~ age  + agesq + odometer + odometersq + LE + cond_excellent + cond_good + dealer)
model4log <- as.formula(lnprice ~ age  + agesq + odometer + odometersq + LE + XLE + SE + cond_likenew +
                          cond_excellent + cond_good + cylind6 + dealer)
model5log <- as.formula(lnprice ~ age +  agesq + odometer + odometersq + LE*age + XLE*age + SE*age +
                          cond_likenew*age + cond_excellent*age + cond_good*age + cylind6*age + odometer*age + dealer*age)


# Running simple OLS
reg1log <- feols(model1log, data=cars, vcov = 'hetero')
reg2log <- feols(model2log, data=cars, vcov = 'hetero')
reg3log <- feols(model3log, data=cars, vcov = 'hetero')
reg4log <- feols(model4log, data=cars, vcov = 'hetero')
reg5log <- feols(model5log, data=cars, vcov = 'hetero')

# evaluation of the models
etable( reg1log , reg2log , reg3log , reg4log , reg5log , fitstat = c('aic','bic','rmse','r2','n','k') )

#####################
# Cross-validation for LOG

# reminder: number of folds
k <- 4

# need to set the same seed again and again
set.seed(13505)
cv1log <- train(model1log, cars, method = "lm", trControl = trainControl(method = "cv", number = k))
set.seed(13505)
cv2log <- train(model2log, cars, method = "lm", trControl = trainControl(method = "cv", number = k))
set.seed(13505)
cv3log <- train(model3log, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")
set.seed(13505)
cv4log <- train(model4log, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")
set.seed(13505)
cv5log <- train(model5log, cars, method = "lm", trControl = trainControl(method = "cv", number = k), na.action = "na.omit")

# calculate average rmse
cv <- c("cv1log", "cv2log", "cv3log", "cv4log", "cv5log")
rmse_cv <- c()

for(i in 1:length(cv)){
  rmse_cv[i] <- sqrt((get(cv[i])$resample[[1]][1]^2 +
                        get(cv[i])$resample[[1]][2]^2 +
                        get(cv[i])$resample[[1]][3]^2 +
                        get(cv[i])$resample[[1]][4]^2)/4)
}


# summarize results
cv_matlog <- data.frame(rbind(cv1log$resample[4], "Average"),
                        rbind(cv1log$resample[1], rmse_cv[1]),
                        rbind(cv2log$resample[1], rmse_cv[2]),
                        rbind(cv3log$resample[1], rmse_cv[3]),
                        rbind(cv4log$resample[1], rmse_cv[4]),
                        rbind(cv5log$resample[1], rmse_cv[5])
)

colnames(cv_matlog)<-c("Resample","Model1log", "Model2log", "Model3log", "Model4log", "Model5log")
cv_matlog


######
# Prediction with LOG 

# Predict price with all predictors (Model3)
pred3l <- feols(model3log, data=cars,vcov = 'hetero')
# predict value for newly added obs
pred3_new_log <- predict(pred3l, newdata = new,se.fit = TRUE, interval = "prediction")
pred3_new_log 

# get log model rmse
cars$lnp2 <- predict( pred3l , cars )
rmse3_log <- RMSE(cars$lnp2,cars$lnprice)
rmse3_log

# Convert to level: the data and the new observation as well
cars$lnplev <- exp(cars$lnp2)*exp((rmse3_log^2)/2)
lnp2_new_lev <- exp(pred3_new_log[1])*exp((rmse3_log^2)/2)

# Check the RMSE to compare with the level model:
rmse3_log2lvl <- RMSE(cars$lnplev,cars$price)

tibble( level = rmse3 , log = rmse3_log2lvl )

## Create the 80% PI and the 95% PI as well
# prediction for new observation
predln_new80 <- predict(pred3l, newdata = new,se.fit = TRUE, interval = "prediction", level=0.80)

# 95% prediction intervals (log to level)
lnp2_PIlow <- pred3_new_log[3]
lnp2_PIhigh <- pred3_new_log[4]
lnplev_PIlow <- exp(lnp2_PIlow)*exp(rmse3_log^2/2)
lnplev_PIhigh <- exp(lnp2_PIhigh)*exp(rmse3_log^2/2)

# 80% prediction intervals (log to level)
lnp2_PIlow80 <- predln_new80[3]
lnp2_PIhigh80 <- predln_new80[4]
lnplev_PIlow80 <- exp(lnp2_PIlow80)*exp(rmse3_log^2/2)
lnplev_PIhigh80 <- exp(lnp2_PIhigh80)*exp(rmse3_log^2/2)

# summary of predictions and PI
sum <- matrix( c( pred3_new_log[1], lnp2_PIlow ,lnp2_PIhigh, lnp2_PIlow80, lnp2_PIhigh80,
                  lnp2_new_lev, lnplev_PIlow, lnplev_PIhigh, lnplev_PIlow80, lnplev_PIhigh80,
                  pred3_new[1], pred3_new[3], pred3_new[4], pred3_new80[3], pred3_new80[4]) , nrow = 5 ,ncol = 3)

colnames(sum) <- c('Model in logs', 'Recalculated to level','Original in level')
rownames(sum) <- c('Predicted', 'PI_low(95%)', 'PI_high(95%)','PI_low(80%)', 'PI_high(80%)')
sum

