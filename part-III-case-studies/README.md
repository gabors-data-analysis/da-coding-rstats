# Coding material in R for Part III: Prediction

This folder contains modified codes from [Gabor's official case study repo](https://github.com/gabors-data-analysis/da_case_studies) to tailor them to the needs of the seminars for Part III: prediction.

It covers different machine learning-based methods such as

  - cross-validation for model selection
  - LASSO, RIDGE, and Elastic Net
  - Regression Trees with the CART algorithm
  - Random Forest and Boosting,

to predict
  
  - cross-sectional data with continuous outcome
  - cross-sectional data with binary outcome: probabilities and classification.

Part III also covers time-series data and offers cross-validation techniques for simple time series, ARIMA, and VAR models with an outlook of using `prophet` package.

Our general approach is to use `caret` as an umbrella package and then supply it with different packages containing different ML tools. This way one can adopt easily a unified framework and there is no need to switch different input formats for different packages such as matrixes of data_frame/tibble.

## Seminars

There are 7 seminars connecting to Part III, however, usually, only 6, 100-min classes, as the last two seminars are covered in one session. The usual way how this material is organized is the following:

| Class    | Seminar | Learning outcome | Case-study | Dataset |
| -------- | ------- | ---------------- | ---------- | ------- |
| Class 01 | [seminar01-cv-used-cars](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar01-cv-used-cars) | Model comparison introduced by BIC and RMSE. Limitations of these comparisons. Cross-validation: using different samples to tackle overfitting. The `caret` package.| [Ch13A Predicting used car value with linear regressions](https://gabors-data-analysis.com/casestudies/#ch13a-predicting-used-car-value-with-linear-regressions) and [Ch14A Predicting used car value: log prices](https://gabors-data-analysis.com/casestudies/#ch14a-predicting-used-car-value-log-prices) | [used-cars](https://gabors-data-analysis.com/datasets/#used-cars) |
| Class 02 | [seminar02-lasso-airbnb](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar02-lasso-airbnb) | Feature engineering for LASSO: interactions and polynomials. Cross-validation in detail. LASSO (and RIDGE, Elastic Net) via `glmnet`. Training-test samples and the holdout sample to evaluate predictions. LASSO diagnostics. | [Ch14B Predicting AirBnB apartment prices: selecting a regression model](https://gabors-data-analysis.com/casestudies/#ch14b-predicting-airbnb-apartment-prices-selecting-a-regression-model) | [airbnb](https://gabors-data-analysis.com/datasets/#airbnb) |
| Class 03 | [seminar03-cart-used-cars](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar03-cart-used-cars) | Estimating regression tree via `rpart`. Understanding regression trees and comparing them to linear regressions. Tuning and setup of CART. Tree and variable importance plots. | [CH15A Predicting used car value with regression trees](https://gabors-data-analysis.com/casestudies/#ch15a-predicting-used-car-value-with-regression-trees) | [used-cars](https://gabors-data-analysis.com/datasets/#used-cars) |
| Class 04 | [seminar04-random-forest-airbnb](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar04-random-forest-airbnb) | Data cleaning and feature engineering specifics for random forest (RF). Estimate RFs via `ranger`. Examine the results of RFs with variable importance plots, and partial dependence plots, and check the quality of predictions in (important) subgroups. Gradient Boosting Method (GBM) via `gbm` package. Prediction comparisons (prediction horse-race) for OLS, LASSO, CART, RF, and GBM. | [Ch16A Predicting apartment prices with random forest](https://gabors-data-analysis.com/casestudies/#ch16a-predicting-apartment-prices-with-random-forest) | [airbnb](https://gabors-data-analysis.com/datasets/#airbnb) |
| Class 05 | [seminar05-binary-wML-predicting-firm-exit](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar05-binary-wML-predicting-firm-exit) | Predicting probabilities and classification with machine learning tools. Cross validated logit models. LASSO with logit, CART, and Random Forest (bonus: why not use Classification Forest). Classification of probabilities, ROC curve, and AUC. Confusion Matrix. Model comparison via RMSE or AUC. User-defined loss function to weight false-positive and false-negative rate. Optimizing threshold value for classification to get best loss function value. | [CH17A Predicting firm exit: probability and classification](https://gabors-data-analysis.com/casestudies/#ch17a-predicting-firm-exit-probability-and-classification) | [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms) |
| Class 06 | [seminar06-timeseries1-wML-swimming](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar06-timeseries1-wML-swimming) and [seminar07-timeseries1-wML-case-shiller-la](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/part-III-case-studies/seminar07-timeseries1-wML-case-shiller-la) | Forecasting time series data. Feature engineering with time series, deciding transformations for stationarity. Cross-validation options with time series. Modeling with deterministic trend, seasonality and other dummy variables for long term horizon. Evaluation of model and forecast precision. ARIMA and VAR models for short term forecasting. `prophet` as machine learning tool for time series data. Evaluation of forecasts on short run: performance on hold out set, fan-chart to assess risks and stability of forecasting performance on an extended time period. | [Ch18A Forecasting daily ticket sales for a swimming pool](https://gabors-data-analysis.com/casestudies/#ch18a-forecasting-daily-ticket-sales-for-a-swimming-pool) and [CH18B Forecasting a house price index](https://gabors-data-analysis.com/casestudies/#ch18b-forecasting-a-house-price-index) | [swim-transactions](https://gabors-data-analysis.com/datasets/#swim-transactions), [case-shiller-la](https://gabors-data-analysis.com/datasets/#case-shiller-la) |

There are no homework and/or in-class tasks as this seminar series is a supplement to theoretical lectures and already assumes robust coding knowledge. In many cases, it is assumed that [coding lecture materials are already known and listed on the main page](https://github.com/gabors-data-analysis/da-coding-rstats/README.md).


