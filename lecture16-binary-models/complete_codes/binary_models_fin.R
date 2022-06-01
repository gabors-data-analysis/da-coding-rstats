###############################################
#                                             #
#               Lecture 16                    #
#                                             #
#   Binary/Probability models                 #
#     - Saturated Linear Probability Models   #
#       - calculate weights and               #
#           estimating models                 #
#       - plot a simple binary model          #
#       - predicted and true outcome          #
#     - Functional form decision              #
#     - Multiple Regression w binary outcome  #
#       - characteristics of predicted groups #
#     - Logit and Probit models               #
#       - simple estimates                    #
#       - average marginal effects            #
#     - Model comparison of non-linear models #
#       - Goodness-of-fit statistics:         #
#       R2, Pseudo-R2, Brier score, Log-loss  #
#       - Visual inspection:                  #
#       distribution of prediction by outcome #
#       - summary stats for predictions       #
#           by outcome                        #
#       - Bias and calibration curve          #
#                                             #
#                                             #
# Case Study:                                 #
#   Does Smoking Pose a Health Risk           #
#                                             #
# Dataset used:                               #
#     share-health                            #
#                                             #
###############################################


# clear memory
rm(list=ls())


# Import libraries
library(tidyverse)
library(modelsummary)
library(lspline)
library(ggpubr)
library(fixest)
# marginaleffects is for calculating non-linear models' marginal effects
if (!require(marginaleffects)){
  install.packages("marginaleffects")
  library(marginaleffects)
}


# load cleaned data from OSF
share <- read_csv("https://osf.io/3ze58/download")

# Check all the data - quick description 
#   (All except country_str, but it is implied in country_mod)
datasummary_skim( share )


# Remove if any of important variable is missing 
share <- share %>% filter( !is.na(share$bmi) ,
                           !is.na(share$eduyears) ,
                           !is.na(share$exerc) )


# Make descriptive statistics for thery based selected variables
datasummary( stayshealthy + smoking + ever_smoked + female +
             age + income10 + eduyears + bmi + exerc ~
              mean + median + min + max + sd + N, data = share )


####
# 1) Saturated Linear Probability Models
#
# y is stayshealthy
#
# Linear probability models of good health at endline and smoking

# 1st model:current smoker on RHS
lpm1 <- feols( stayshealthy ~ smoking , data = share , vcov = 'hetero' )
lpm1

# Get the predicted values
share <- share %>% mutate( pred1 = predict( lpm1 ) )

# Compare smoking with predicted values and real outcomes
#   1) Predicted vs smoking
table(share$pred1, share$smoking)
#   2) Actual vs smoking
table(share$stayshealthy, share$smoking)

# Create weights for prettier plot
share <- share %>%
  group_by(smoking, stayshealthy) %>%
  mutate(weight = n())  %>%
  mutate(weight_2=(weight/1000))

# Show graph with actual and predicted probabilities: LPM
ggplot(data = share, label=smoking) +
  geom_point(aes(x = smoking, y = pred1), size = 1, color='blue', shape = 16) +
  geom_line(aes(x = smoking, y = pred1), colour='blue',  size=0.7) +
  geom_point(aes(x = smoking, y = stayshealthy, size=weight_2), 
             fill = 'red', color='red', shape = 16, alpha=0.8, 
             show.legend=F, na.rm=TRUE)  +
  labs(x = "Current smoker",y = "Staying healthy / Predicted probability of ")+
  coord_cartesian(xlim = c(0, 1), ylim=c(0,1)) +
  scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1))+
  scale_x_continuous(limits = c(0,1), breaks = seq(0,1,1))+
  theme_bw() 



##
# 2nd model: current smoker and ever smoked on RHS
lpm2 <- feols( stayshealthy ~ smoking + ever_smoked , data = share , vcov = 'hetero' )
lpm2

# Compare models:
#   - good to know: digits = 3 also works, but it does not rounds, but uses floor()
etable( lpm1 , lpm2,
        digits="r3")

####
# 2) Multiple variable regressions:
#     selecting multiple variables, when outcome is binary
#
# As usual: check some functional forms

# For pretty plots create weigths for education
share <- share %>%
  group_by( eduyears, stayshealthy ) %>%
  mutate( weight = n()/100 )

# Education
ggplot(data = share, aes(x=eduyears, y=stayshealthy)) +
  geom_point(aes(x = eduyears, y = stayshealthy, size=weight), color='blue', shape = 16, alpha=0.8, show.legend=F, na.rm=TRUE)  +
  geom_smooth(method="loess", color='red', se = F , formula = y ~ x) +
  scale_x_continuous(expand = c(0.01,0.01), limits = c(0,25), breaks = seq(0,25,4))+
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0,1), breaks = seq(0,1,0.1)) +
  labs(x = "Years of education",y = "Probability of staying healthy ") +
  theme_bw() 

# Income groups
ggplot(data = share, aes(x=income10, y=stayshealthy)) +
  geom_smooth(method="loess", color='red', se = F , formula = y ~ x) +
  scale_x_continuous(expand = c(0.01,0.01), limits = c(1,10), breaks = seq(1,10,1))+
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0,1), breaks = seq(0,1,0.1)) +
  labs(x = "Income group within country (deciles)",y = "Probability of staying healthy ") +
  theme_bw()

# Age
ggplot(data = share, aes(x=age, y=stayshealthy)) +
  geom_smooth(method="loess", color='red', se = F , formula = y ~ x) +
  scale_y_continuous(expand = c(0.01,0.01),limits = c(0,1), breaks = seq(0,1,0.2), labels = scales::percent) +
  labs(x = "Age at interview (years)",y = "Probability of staying healthy") +
  theme_bw() 

# BMI
ggplot(data = share, aes(x=bmi, y=stayshealthy)) +
  geom_smooth(method="loess", se=F, color='red', size=1.5, formula = y ~ x) +
  scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.2)) +
  labs(x = "Body mass index",y = "Stays healthy") +
  scale_x_continuous(limits = c(10,50), breaks = seq(10,50, 10))+
  theme_bw() 

###
# Task:
#
# linear probability model with many covariates, use the following
#   smoking, ever_smoked, female, age, eduyears, income10, bmi, exerc, country_str
#   use the P.L.S transformations:
#     eduyears: with knots at 8 (elementary only) and 18 (Diploma)
#     bmi: with knot at 35
#   and include country_str dummy variables as.factor() -> 
#     -> it automatically drops the first category: 11 (Austria), which is now the reference category

lpm3 <-feols( stayshealthy ~ smoking + ever_smoked + female +
              age + lspline(eduyears,c(8,18)) + income10 + lspline(bmi,c(35)) +
              exerc + as.factor(country_str),
              data = share , vcov = 'hetero')

# compare the existing LPMs
etable(lpm1, lpm2, lpm3, drop="country", digits="r3" )


# Check predicted probabilities: is there any interesting values?
# predicted probabilities
share$pred_lpm <- predict( lpm3 )
# Make a descriptive summary of the predictions with 3 digits
datasummary( pred_lpm ~ min + max + mean + median + sd , 
             data = share, fmt="%.3f"  )

# Show the predicted probabilities' distribution (ggplot)
ggplot( share , aes( x = pred_lpm ) ) +
  geom_histogram( aes( y = ..density.. ), fill = 'navyblue' , color = 'grey90', binwidth=0.02) +
  coord_cartesian( xlim = c(0, 1.2) ) +
  labs(x = "Predicted probability of staying healthy (LPM)",y = "Percent")+
  scale_y_continuous(expand = c(0.00,0.0), limits = c(0,3), breaks = seq(0, 3, 0.5)) +
  scale_x_continuous(expand = c(0.001,0.01), limits = c(0,1.1), breaks = seq(0,1.1, 0.2)) +
  theme_bw() 


# We are interested in the top 1% and bottom 1% characteristics!
#   Is there any significant difference?

# Create bins which categorize the predicted values between 1-100
share <- share %>% 
  mutate( q100_pred_lpm = ntile(pred_lpm, 100) )

# Make a summary statistics, using sum_stat for the bottom (q100_pred_lpm==1) 
#   and top 1% (q100_pred_lpm==100), using stats = c('mean','median','sd')
#   and variables c('smoking','ever_smoked','female','age','eduyears','income10','bmi','exerc')
#   use the num_obs = F input for sum_stat

# Top 1%
datasummary( smoking+ever_smoked+female+age+eduyears+income10+bmi+exerc~
              mean + median + sd , data = filter( share , q100_pred_lpm==100 ) ) 

# Bottom 1%
datasummary(smoking+ever_smoked+female+age+eduyears+income10+bmi+exerc~
              mean + median + sd , data = filter( share , q100_pred_lpm==1 ) ) 


# You may change the variable names to remove...
rm(lpm3)

####
# 3) LOGIT AND PROBIT MODELS
#
# Lets compare
# lpm versus logit and probit
# with all right-hand-side variables

# If comparing different estimation methods for the same model setup:
#   good practice to make a 'formula' variable!

# To have pretty outcomes, we need to create spline variables
aux_1 <- lspline(share$eduyears, c(8,18))
aux_2 <- lspline(share$bmi, c(35))
share <- share %>% add_column( eduyears_l8   = aux_1[ , 1 ],
                               eduyears_8n18 = aux_1[ , 2 ],
                               eduyears_m18  = aux_1[ , 3 ],
                               bmi_l35       = aux_2[ , 1 ],
                               bmi_m35       = aux_2[ , 2 ] )
rm(aux_1,aux_2)

model_formula <- formula( stayshealthy ~ smoking + ever_smoked + female + age + 
                            eduyears_l8 + eduyears_8n18 + eduyears_m18 + income10 +
                            bmi_l35 + bmi_m35 + exerc + as.factor(country_str) )

# Alternatively
# model_formula <- formula( stayshealthy ~ smoking + ever_smoked + female + age + 
#                            lspline(eduyears, c(8,18)) + 
#                            income10 + lspline(bmi, c(35)) + exerc + as.factor(country_str) )

# lpm (repeating the previous regression)
lpm <-feols( model_formula , data=share, vcov = 'hetero')
etable(lpm, drop="country", digits="r3")
# Save predictions
share$pred_lpm <- predict( lpm )

# logit coefficients:
#   alternatively: familiy='binomial' automatically gives you logit, but not probit...
logit_model <- feglm( model_formula , data = share, family = binomial( link = "logit" ) )
etable(logit_model, drop="country", digits="r3")


# predicted probabilities 
share$pred_logit <- predict( logit_model, type="response" )

# Calculate the Average Marginal Effects via `marginaleffects`
logit_marg <- marginaleffects( logit_model )
summary( logit_marg )

##
# Probit coefficients: replicate logit, but now use 'probit'
probit_model <- feglm( model_formula , data=share, family = binomial( link = "probit" ) )
etable(probit_model,drop=c('country'))

# predicted probabilities 
share$pred_probit<- predict( probit_model , type = "response" )

# probit marginal differences
probit_marg <- marginaleffects(  probit_model )
summary( probit_marg )

# Comparing predictions from the three models
datasummary(pred_lpm + pred_logit + pred_probit ~ min + P25 + Median + Mean + P75 + Max , data = share )

##
# a) Creating a model summary output for base models
etable( lpm, logit_model, probit_model,
        drop="country", digits="r3" , fitstat = c('r2','pr2'))

##
# b) To include marginal effects (on average...), we need modelsummary:
modelsummary( list( "LPM" = lpm, "logit coeffs" = logit_model, 
                    "logit marginals" = logit_marg, "probit coeffs" = probit_model,
                    "probit marginals" = probit_marg ),
              coef_omit = 'country|Intercept', gof_omit = 'Within|AIC|BIC|Log.Lik|Std.Errors|R2',
              stars=c('*' = .05, '**' = .01) )


##
# 4) Goodness of Fit (GoF) statistics 
#       with binary models
#
# goodness of fit is the same for marginal effects 
#   as the base models, as it only calculates some averaged effects.

# To have proper GoF stats, we need to define them to etable
#
# R2 for all models:
fitstat_register("modr2", function(x){
  y <- x$fitted.values + x$residuals
  ss_res <- sum(x$residual^2,na.rm=T)
  ss_tot <- sum( (y - mean( y , na.rm = T ) )^2 , na.rm = T )
  1 - ss_res/ss_tot }, "R2")
# Log-loss 
fitstat_register("logloss", function(x){
  log_id <- !is.na( x$fitted.values ) & x$fitted.values < 1 & x$fitted.values > 0
  y   <- x$fitted.values[ log_id ] + x$residuals[ log_id ]
  lp  <- log( x$fitted.values[ log_id ] )
  lnp <- log( 1 - x$fitted.values[ log_id ] )
  nobs <- sum( log_id )
  return( 1 / nobs * sum( y * lp + ( 1 - y ) * lnp ) )
}, "log-loss")

##
# Task:
# define the `brier` score, which is the mean of squared residuals
fitstat_register("brier", function(x){mean(x$residual^2)}, "Brier score")

##
# Model performance comparison
etable( lpm, logit_model, probit_model ,
        drop = "factor|Intercept",
        digits.stats = "r3",
        fitstat = ~ modr2 + brier + pr2 + logloss )



##
# 5) Visual inspection for model comparisons
#
# a) Comparing predicted probabilities of logit and probit to LPM
ggplot(data = share) +
  geom_point(aes(x=pred_lpm, y=pred_probit, color="Probit"), size=0.2) +
  geom_point(aes(x=pred_lpm, y=pred_logit,  color="Logit"), size=0.2) +
  geom_line(aes(x=pred_lpm, y=pred_lpm,    color="45 degree line"), size=0.4) +
  labs(x = "Predicted probability of staying healthy (LPM)", y="Predicted probability")+
  scale_y_continuous(expand = c(0.00,0.0), limits = c(0,1), breaks = seq(0,1,0.1)) +
  scale_x_continuous(expand = c(0.00,0.0), limits = c(0,1), breaks = seq(0,1,0.1)) +
  scale_color_manual(name = "", values=c('green', 'blue','red')) +
  theme_bw()+
  theme(legend.position=c(0.55,0.08),
        legend.direction = "horizontal",
        legend.text = element_text(size = 6))


##
# b) Comparing simple LPM and rich LPM's categorization
# re-estimate the simplest lpm
lpmbase <- feols( stayshealthy ~ smoking, data=share ,vcov = 'hetero')
share$pred_lpmbase <- predict( lpmbase ) 
# Distribution of predicted probabilities by outcome

# b1) LPM simple model
glpm1 <- ggplot(data = share,aes(x=pred_lpmbase)) + 
  geom_histogram(data=subset(share[share$stayshealthy == 1, ]), 
                 aes(fill=as.factor(stayshealthy), color=as.factor(stayshealthy), y = (..count..)/sum(..count..)*100),
                 binwidth = 0.05, boundary=0, alpha=0.8) +
  geom_histogram(data=subset(share[share$stayshealthy == 0, ]), 
                 aes(fill=as.factor(stayshealthy), color=as.factor(stayshealthy), y = (..count..)/sum(..count..)*100), 
                 binwidth = 0.05, boundary=0, alpha=0) +
  scale_fill_manual(name="", values=c("0" = "white", "1" = 'blue'),labels=c("Did not stay healthy","Stayed healthy")) +
  scale_color_manual(name="", values=c("0" = 'red', "1" = 'blue'),labels=c("Did not stay healthy","Stayed healthy")) +
  ylab("Percent") +
  xlab("Fitted values") +
  scale_x_continuous(expand=c(0.01,0.01) ,limits = c(0,1), breaks = seq(0,1,0.2)) +
  scale_y_continuous(expand=c(0.00,0.00) ,limits = c(0,80), breaks = seq(0,80,20)) +
  theme_bw() +
  theme(legend.position = c(0.3,0.8),
        legend.key.size = unit(x = 0.5, units = "cm"))

# b2) LPM rich model
glpm2 <- ggplot(data = share,aes(x=pred_lpm)) + 
  geom_histogram(data=subset(share[share$stayshealthy == 1, ]), 
                 aes(fill=as.factor(stayshealthy), color=as.factor(stayshealthy), y = (..count..)/sum(..count..)*100),
                 binwidth = 0.05, boundary=0, alpha=0.8) +
  geom_histogram(data=subset(share[share$stayshealthy == 0, ]), 
                 aes(fill=as.factor(stayshealthy), color=as.factor(stayshealthy), y = (..count..)/sum(..count..)*100), 
                 binwidth = 0.05, boundary=0, alpha=0) +
  scale_fill_manual(name="", values=c("0" = "white", "1" = 'blue'),labels=c("Did not stay healthy","Stayed healthy")) +
  scale_color_manual(name="", values=c("0" = 'red', "1" = 'blue'),labels=c("Did not stay healthy","Stayed healthy")) +
  ylab("Percent") +
  xlab("Fitted values") +
  scale_x_continuous(expand=c(0.01,0.01) ,limits = c(0,1), breaks = seq(0,1,0.2)) +
  scale_y_continuous(expand=c(0.00,0.00) ,limits = c(0,20), breaks = seq(0,20,4)) +
  theme_bw() +
  theme(legend.position = c(0.3,0.8),
        legend.key.size = unit(x = 0.5, units = "cm"))

# Compare the two model's predicitons
ggarrange(glpm1,glpm2,ncol=1)


##
# 6) Summary statistics on predicted probabilities:
#
# Task:
#   Create a CONDITIONAL descriptive statistics on stayhealth for:
#     "pred_lpmbase","pred_lpm","pred_logit","pred_probit" 
#   use: "mean","median","min","max","sd" as descriptives
#
#   Hint: you may convert stayshealthy as factor and multiply the predicted values
#  

datasummary( ( `stays healthy` = as_factor( stayshealthy ) ) * 
               ( pred_lpmbase + pred_lpm + pred_logit + pred_probit ) ~
               mean + median + min + max + sd,
            data = share )



###
# 7) Bias and Calibration curve
#
# Lets use the logit model!
#

##
# Task:
#
# Biased prediction? Calculate bias!
#   Hint: bias = mean(prediction) - mean(actual)
bias <- mean( share$pred_logit ) - mean(share$stayshealthy)

# calibration curves -> essentially a scatter-bin!

# Intervals
intervals = c(0, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 1.05)

# Create binned data:
binned_data <- share %>%
  mutate( prob_bin = cut( pred_logit , breaks = intervals, include.lowest = TRUE ) ) %>%
  group_by( prob_bin, .drop=FALSE ) %>%
  summarise( mean_prob   = mean( pred_logit ) , 
             mean_actual = mean( stayshealthy ) ,
             n = n() )

ggplot( data = binned_data ) +
  geom_line(aes(mean_prob, mean_actual), color='blue', size=0.6, show.legend = TRUE) +
  geom_point(aes(mean_prob,mean_actual), color = 'blue', size = 1, shape = 16, alpha = 0.7, show.legend=F, na.rm = TRUE) +
  geom_segment(x=min(intervals), xend=max(intervals), y=min(intervals), yend=max(intervals), color='red', size=0.5) +
  theme_bw() +
  labs(x= "Predicted event probability",
       y= 'Stays healthy') +
  coord_cartesian(xlim=c(0,1), ylim=c(0,1))+
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) +
  scale_x_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) 


##
# Task:
#   Do the same calibration curve, but now for LPM rich model
#   Make sure that in the ggplot you also show the Logit-bias as well
binned_data2 <- share %>%
  mutate( prob_bin = cut( pred_lpm , breaks = intervals, include.lowest = TRUE ) ) %>%
  group_by( prob_bin, .drop=FALSE ) %>%
  summarise( mean_prob_lpm   = mean( pred_lpm ) , 
             mean_actual_lpm = mean( stayshealthy ) ,
             n = n() )

# Join the two data for pretty plot
binned_data <- left_join( binned_data , binned_data2 , by = 'prob_bin' )


ggplot( data = binned_data ) +
  geom_line(  aes( mean_prob , mean_actual ) , color = 'blue',  size = 0.6, show.legend = T ) +
  geom_point( aes( mean_prob , mean_actual ) , color = 'blue', size = 1, shape = 16, alpha = 0.7) +
  geom_line(  aes( mean_prob_lpm , mean_actual_lpm ) , color = 'red'  , size = 0.6 , show.legend = T ) +
  geom_point( aes( mean_prob_lpm , mean_actual_lpm ) , color = 'red' , size = 1, shape = 16, alpha = 0.7) +
  geom_segment( x=min(intervals), xend=max(intervals), y=min(intervals), yend=max(intervals), color='black', size=0.5) +
  theme_bw() +
  annotate("text", x = c( 0.2 , 0.15 ), y = c( 0.35 , 0.25 ), label = c('logit','LPM'), color = c('blue','red') )+
  labs(x= "Predicted event probability",
       y= 'Stays healthy') +
  coord_cartesian(xlim=c(0,1), ylim=c(0,1))+
  expand_limits(x = 0.01, y = 0.01) +
  scale_y_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) +
  scale_x_continuous(expand=c(0.01,0.01),breaks=c(seq(0,1,0.1))) 

