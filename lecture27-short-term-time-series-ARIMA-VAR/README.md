# Seminar 07: Forecasting from Time Series Data II - ARIMA and VAR models

## Motivation

Your task is to predict how house prices will move in a particular city in the next months. You have monthly data on the house price index of the city, and you can collect monthly data on other variables that may be correlated with how house prices move. How should you use that data to forecast changes in house prices for the next few months? In particular, how should you use those other variables to help that forecast even though you don’t know their future values?

## This seminar

This seminar discusses forecasting: prediction from time series data for one or more time periods in the future. The focus of this chapter is forecasting future values of one variable, by making use of past values of the same variable, and possibly other variables, too. We build on what we learned about time series regressions in [lecture18-timeseries-regression](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture18-timeseries-regression). Now, we then turn to short horizon forecasts that forecast y for a few time periods ahead. These forecasts make use of serial correlation of the time series of y besides those long-term features. We introduce autoregression (AR) and ARIMA models via `fpp3` package, which captures the patterns of serial correlation and can use for short horizon forecasting. We then turn to use other variables in forecasting and introduce vector autoregression (VAR) models that help in forecasting future values of those x variables that we can use to forecast y. We discuss how to carry out cross-validation in forecasting and the specific challenges and opportunities the time series nature of our data provides for assessing external validity.

Case study:
  - [Chapter 18, B: Forecasting a house price index](https://gabors-data-analysis.com/casestudies/#ch18b-forecasting-a-house-price-index)

## Learning outcomes
After successfully completing [`seminar_7_priceindex.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/part-III-case-studies/seminar07-timeseries1-wML-case-shiller-la/seminar_7_priceindex.R), students should be able:

  - Decide if a conversion of data to stationarity is needed
  - ARIMA models with `fpp3` package
    - self specified lags for AR, I, and MA components
    - auto select the lags
    - handling trend and seasonality within ARIMA
    - understand 'S' from SARIMA and why we do not use it in this course
  - Cross-validation with ARIMA models
  - Vector AutoRegressive models (VAR)
    - estimation and cross-validation
  - Forecasting
    - comparing models based on forecast performance
    - external validity check on a longer horizon
    - Fan charts for assessing risks   

## Seminar Time

Ideal overall time: **50-80 mins**.


## Further material

  - This seminar is a modified version of [`ch18-ts-pred-homeprices.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch18-case-shiller-la/ch18-ts-pred-homeprices.R) from [Gabor's case study repository](https://github.com/gabors-data-analysis/da_case_studies).

