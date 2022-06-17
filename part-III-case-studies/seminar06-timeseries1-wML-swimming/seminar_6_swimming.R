###########################################
#                                         #
#     Seminar 6 for Part III              #
#  Forecasting a time-series object: 1    #
#                                         #
# Topics covered:                         #
#   - Data munging with time-series (ts)  #
#   - Descriptive graphs for ts           #
#     - analyzing different periods       #
#       to understand seasonality         #
#   - Sample splitting with ts            #
#   - Simple time-series models with:     #
#     - deterministic trend/seasonality   #
#   - Cross-validation with time-series   #
#   - prophet package                     #
#   - Forecasting                         #
#     - comparing model based on          #
#       forecasting performance (RMSE)    #
#     - graphical representation          #
#                                         #
# Case studies:                           #
#  -CH18A Forecasting daily ticket sales  #
#     for a swimming pool                 #
#                                         #
# dataset:                                #
#   swim-transactions                     #
#                                         #
###########################################



# Clear memory
rm(list=ls())

# Import libraries ---------------------------------------------------
library(tidyverse)
library(modelsummary)
# Add time related properties with timeDate
#   - weekdays/holidays, etc.
if (!require(timeDate)){
  install.packages("timeDate")
  library(timeDate)  
}
library(lubridate)
library(caret)
# ML for time-series package (by FB)
if (!require(prophet)){
  install.packages("prophet")
  library(prophet)  
}
# for plots
library(scales)
library(viridis)

#####################################
# Creating time features  ----------
#####################################


# import data
daily_agg<-read_csv('https://osf.io/jcxmk/download') %>% 
  mutate(date = as.Date(date))

glimpse(daily_agg)

# Add multiple time variables:
#   - year, quarter, month and day
#   - add weekdays and weekend from lubridate package
daily_agg <- daily_agg %>%
  mutate(year = year(date),
         quarter = quarter(date),
         month = factor(month(date)),
         day = day(date)) %>%
  mutate(dow = factor(lubridate::wday(date, week_start = getOption("lubridate.week.start", 1)))) %>%
  mutate(weekend = factor(as.integer(dow %in% c(6,7))))

# School off days -> specific dates (domain knowledge)
#   need to know the US state specific schools
daily_agg <- daily_agg %>% 
  mutate(school_off = ((day>15 & month==5 & day <=30) | (month==6 |  month==7) |
                         (day<15 & month==8) | (day>20 & month==12) ))

# Add a trend variable (1 to number of observations)
daily_agg <- daily_agg %>% 
  mutate(trend = c(1:dim(daily_agg)[1]))

# Get holiday calendar (from timeDate package)
holidays <-  as.Date(holidayNYSE(2010:2017))

# Add to data
daily_agg <- daily_agg %>% 
  mutate(isHoliday = ifelse(date %in% holidays,1,0))

# Summary stat
datasummary_skim( daily_agg )




# Define vars for analysis ----------------------------------

# Add a monthly average quantity sold
daily_agg <- 
  daily_agg %>% 
  group_by(month) %>% 
  mutate(q_month = mean(QUANTITY)) %>% 
  ungroup()

# Create a log quantity with adjusting below 1
daily_agg <- daily_agg %>% 
  mutate(QUANTITY2 = ifelse(QUANTITY<1, 1, QUANTITY)) %>% 
  mutate(q_ln = log(QUANTITY2))

# Create tickets variable as quantity sold for each day for given months
daily_agg <- 
  daily_agg %>% 
  group_by(month, dow) %>% 
  mutate(tickets = mean(QUANTITY),
         tickets_ln = mean(q_ln)) %>% 
  ungroup()

# named date vars for graphs
mydays <- c("Mon","Tue","Wed",
            "Thu","Fri","Sat",
            "Sun")
daily_agg$dow_abb   <-factor(   mydays[daily_agg$dow],  levels=mydays)
daily_agg$month_abb <-factor(month.abb[daily_agg$month],levels=month.abb)

################################
# Descriptive graphs 
#################################

# Check: 
#   1) within year pattern
#   2) Across years pattern
#   3) Across months
#   4) Across days
#   +1) Heatmap to have an idea across month and daily pattern

# Daily ticket sales 2015
ggplot(data=daily_agg[daily_agg$year==2015,], aes(x=date, y=QUANTITY)) +
  geom_line(size=0.4, color='red') +
  theme_bw() +
  scale_x_date(breaks = as.Date(c("2015-01-01","2015-04-01","2015-07-01","2015-10-01","2016-01-01")),
               labels = date_format("%d%b%Y"),
               date_minor_breaks = "1 month" ) +
  labs( x = "Date (day)", y="Daily ticket sales" ) +
  scale_color_discrete(name = "")

# Daily ticket sales 2010 - 2014
ggplot(data=daily_agg[(daily_agg$year>=2010) & (daily_agg$year<=2014),], aes(x=date, y=QUANTITY)) +
  geom_line(size=0.2, color='red') +
  theme_bw() +
  scale_x_date(breaks = as.Date(c("2010-01-01","2011-01-01","2012-01-01","2013-01-01","2014-01-01","2015-01-01")),
               labels = date_format("%d%b%Y"),
               minor_breaks = "3 months") +
  labs( x = "Date (day)", y="Daily ticket sales" ) +
  scale_color_discrete(name = "")

# Monthly box-plots for ticket sales
ggplot(data=daily_agg, aes(x=month_abb, y=QUANTITY)) +
  theme_bw() +
  labs( x = "Date (month)", y="Daily ticket sales" ) +
  geom_boxplot(color='red',outlier.color = 'green', outlier.alpha = 0.9, outlier.size = 1)

# Daily box-plots for ticket sales
ggplot(data=daily_agg, aes(x=dow_abb, y=QUANTITY)) +
  theme_bw() +
  labs( x = "Day of the week", y="Daily ticket sales" ) +
  geom_boxplot(color='red',outlier.color = 'green', outlier.alpha = 0.9, outlier.size = 1)
  #geom_boxplot(color='red', outlier.shape = NA)


# to check for interactions between months and days look at the heatmap
ggplot(daily_agg, aes(x = dow_abb, y = month_abb, fill = tickets)) +
  geom_tile(colour = "white") +
  labs(x = 'Day of the week', y = 'Month ') +
  scale_fill_viridis(alpha = 0.7, begin = 1, end = 0.2, direction = 1, option = "D") +
  theme_bw() +
  theme(legend.position = "right",
    legend.text = element_text(size=6),
    legend.title =element_text(size=6))


# Same but with log sales
ggplot(daily_agg, aes(x = dow_abb, y = month_abb, fill = tickets_ln)) +
  geom_tile(colour = "white") +
  labs(x = 'Day of week', y = 'Month ') +
  scale_fill_viridis(alpha = 0.7, begin = 1, end = 0.2, direction = 1, option = "D") +
  theme_bw()  


#####################################
# PREDICTION  ----------
#####################################


#############################
# Create train/houldout data
#############################

# Last year of data
data_holdout<- daily_agg %>%
  filter(year==2016)

# Rest of data for training
data_train <- daily_agg %>%
  filter(year<2016)

# Prepare for cross-validation (add an extra column)
data_train <- data_train %>% 
  rownames_to_column() %>% 
  mutate(rowname = as.integer(rowname))

# Create indexes for the test samples: 
# create a list for each year's rowname
test_index_list <- data_train %>% 
  split(f = factor(data_train$year)) %>% 
  lapply(FUN = function(x){x$rowname})

# Create indexes for the train samples - similarly but take the other parts 
train_index_list <- test_index_list %>% 
  lapply(FUN = function(x){setdiff(data_train$rowname, x)})
  
# Set the samples for cv
train_control <- trainControl(
  method = "cv",
  index = train_index_list, #index of train data for each fold
  # indexOut = index of test data for each fold, complement of index by default
  # indexFinal = index of data to use to train final model, whole train data by default
  savePredictions = TRUE
)

# Fit models: here simple OLS which is applicable to TS data

# Model 1 linear trend + monthly seasonality
model1 <- as.formula(QUANTITY ~ 1 + trend + month)
reg1 <- train(
  model1,
  method = "lm",
  data = data_train,
  trControl = train_control
)
# output
reg1
reg1$finalModel

#Model 2 linear trend + monthly seasonality + days of week seasonality 
model2 <- as.formula(QUANTITY ~ 1 + trend + month + dow)
reg2 <- train(
  model2,
  method = "lm",
  data = data_train,
  trControl = train_control
)

#Model 3 linear trend + monthly seasonality + days of week  seasonality + holidays 
model3 <- as.formula(QUANTITY ~ 1 + trend + month + dow + isHoliday)
reg3 <- train(
  model3,
  method = "lm",
  data = data_train,
  trControl = train_control
)

#Model 4 linear trend + monthly seasonality + days of week  seasonality + holidays + sch*dow
model4 <- as.formula(QUANTITY ~ 1 + trend + month + dow + isHoliday + school_off*dow)
reg4 <- train(
  model4,
  method = "lm",
  data = data_train,
  trControl = train_control
)

#Model 5 linear trend + monthly seasonality + days of week  seasonality + holidays + interactions
model5 <- as.formula(QUANTITY ~ 1 + trend + month + dow + isHoliday + school_off*dow + weekend*month)
reg5 <- train(
  model5,
  method = "lm",
  data = data_train,
  trControl = train_control
)

#Model 6 =  multiplicative trend and seasonality (ie take logs, predict log values and transform back with correction term)
model6 <- as.formula(q_ln ~ 1 + trend + month + dow + isHoliday + school_off*dow)
reg6 <- train(
  model6,
  method = "lm",
  data = data_train,
  trControl = train_control
)

# Get CV RMSE ----------------------------------------------

model_names <- c("reg1","reg2","reg3","reg4","reg5")
rmse_CV <- c()

for (i in model_names) {
  rmse_CV[i]  <- get(i)$results$RMSE
}
rmse_CV

# For the log model we need to compute the RMSE with the adjustment term!
#   had to cheat and use train error on full train set 
#     because could not obtain CV fold train errors
corrb <- mean((reg6$finalModel$residuals)^2)
rmse_CV["reg6"] <- reg6$pred %>% 
  mutate(pred = exp(pred  + corrb/2)) %>% 
  group_by(Resample) %>% 
  summarise(rmse = RMSE(pred, exp(obs))) %>% 
  as.data.frame() %>% 
  summarise(mean(rmse)) %>% 
  as.numeric()
rmse_CV["reg6"] 

rmse_CV

# Use prophet prediction -------------------------------------------
# add CV into prophet
# can be done with prophet: https://facebook.github.io/prophet/docs/diagnostics.html
# done but this is a different cross-validation as for the other models as it must be time-series like

# prophet -  multiplicative option -- tried but produced much worse results (~34. RMSE)


model_prophet <- prophet( fit=F, 
                          seasonality.mode = "additive", 
                          yearly.seasonality = "auto",
                          weekly.seasonality = "auto",
                          growth = "linear",
                          daily.seasonality=TRUE)

model_prophet <-  add_country_holidays(model_prophet, "US")
model_prophet <- fit.prophet(model_prophet, df= data.frame(ds = data_train$date,
                                                           y = data_train$QUANTITY ))

cv_pred <- cross_validation(model_prophet, initial = 365, period = 365, horizon = 365, units = 'days')
rmse_prophet_cv <- performance_metrics(cv_pred, rolling_window = 1)$rmse
rmse_prophet_cv

###########################x
# Evaluate best model on holdout set --------------------------------------------
###########################x

data_holdout <- data_holdout %>% 
  mutate(y_hat_5 = predict(reg5, newdata = .))

rmse_holdout_best <- RMSE(data_holdout$QUANTITY, data_holdout$y_hat_5)
rmse_holdout_best

###########################x
# Plot best predictions --------------------------------------------
###########################x

#graph relative RMSE (on holdout) per month 
rmse_monthly <- data_holdout %>% 
  mutate(month = factor(format(date,"%b"), 
                        levels= unique(format(sort(.$date),"%b")), 
                        ordered=TRUE)) %>% 
  group_by(month) %>% 
  summarise(
    RMSE = RMSE(QUANTITY, y_hat_5),
    RMSE_norm= RMSE(QUANTITY, y_hat_5)/mean(QUANTITY)
            ) 
# Values
rmse_monthly
# Graph
ggplot(rmse_monthly, aes(x = month, y = RMSE_norm)) +
  geom_col(bg='red', color='red') +
  labs( x = "Date (month)", y="RMSE (normalized by monthly sales)" ) +
    theme_bw() 

# Prediction on training sample
ggplot(data=data_holdout, aes(x=date, y=QUANTITY)) +
  geom_line(aes(size="Actual", colour="Actual", linetype = "Actual") ) +
  geom_line(aes(y=y_hat_5, size="Predicted" ,colour="Predicted",  linetype= "Predicted")) +
  scale_y_continuous(expand = c(0,0))+
  scale_x_date(expand=c(0,0), breaks = as.Date(c("2016-01-01","2016-03-01","2016-05-01","2016-07-01","2016-09-01","2016-11-01", "2017-01-01")),
               labels = date_format("%d%b%Y"),
               date_minor_breaks = "1 month" )+
  scale_color_manual(values=c('red','blue'), name="")+
  scale_size_manual(name="", values=c(0.4,0.7))+
  scale_linetype_manual(name = "", values=c("solid", "twodash")) +
  labs( x = "Date (day)", y="Daily ticket sales" ) +
  theme_bw() +
  theme(legend.position=c(0.7,0.8),
      legend.direction = "horizontal",
      legend.text = element_text(size = 6),
      legend.key.width = unit(.8, "cm"),
      legend.key.height = unit(.3, "cm")) + 
  guides(linetype = guide_legend(override.aes = list(size = 0.8))
         )


# Prediction on hold-out sample
ggplot(data=data_holdout %>% filter(month==8), aes(x=date, y=QUANTITY)) +
  geom_line(aes(size="Actual", colour="Actual", linetype = "Actual") ) +
  geom_line(aes(y=y_hat_5, size="Predicted" ,colour="Predicted",  linetype= "Predicted")) +
  geom_ribbon(aes(ymin=QUANTITY,ymax=y_hat_5), fill='green', alpha=0.3) +
  scale_y_continuous(expand = c(0.01,0.01), limits = c(0,150))+
  scale_x_date(expand=c(0.01,0.01), breaks = as.Date(c("2016-08-01","2016-08-08","2016-08-15","2016-08-22","2016-08-29")),
               limits = as.Date(c("2016-08-01","2016-08-31")),
               labels = date_format("%d%b")) +
  scale_color_manual(values=c('red','blue'), name="")+
  scale_size_manual(name="", values=c(0.4,0.7))+
  scale_linetype_manual(name = "", values=c("solid", "twodash")) +
  labs( x = "Date (day)", y="Daily ticket sales" ) +
  theme_bw() +
  theme(legend.position=c(0.7,0.8),
        legend.direction = "horizontal",
        legend.text = element_text(size = 4),
        legend.key.width = unit(.8, "cm"),
        legend.key.height = unit(.2, "cm")) + 
  guides(linetype = guide_legend(override.aes = list(size = 0.6))
  )

