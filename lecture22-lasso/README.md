# Lecture 22: Prediction with LASSO 

## Motivation

You want to predict the rental prices of apartments in a big city using their location, size, amenities, and other features. You have access to data on many apartments with many variables. You know how to select the best regression model for prediction from several candidate models. But how should you specify those candidate models, to begin with? In particular, which of the many variables should they include, in what functional forms, and in what interactions? More generally, how can you make sure that the candidates include truly good predictive models?

How should we specify the regression models? In particular, when we have many candidate predictor variables, how should we select from them, and how should we decide on their functional forms?

## This lecture

This lecture discusses how to build regression models for prediction and how to evaluate the predictions they produce. We discuss how to select
variables out of a large pool of candidate x variables, and how to decide on their functional forms. We introduce LASSO via `glmnet`, an algorithm that can help with variable selection. With respect to evaluating predictions, we discuss why we need a holdout sample for evaluation that is separate from all of the rest of the data we use for model building and selection.

Case study:
  - [Chapter 14, B: Predicting AirBnB apartment prices: selecting a regression model](https://gabors-data-analysis.com/casestudies/#ch14b-predicting-airbnb-apartment-prices-selecting-a-regression-model)

## Learning outcomes
After successfully completing [`lasso_aribnb.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture22-lasso/codes/lasso_aribnb.R), students should be able:

  - Data cleaning and refactoring to prepare for LASSO type modelling
  - Basic feature engineering for LASSO
  - Understand the three sample approach:
    - train and test sample to select model (cross validation for tuning parameters)
    - hold-out sample to evaluate model prediction performance
  - Model selection with
    - (linear) regression models
    - LASSO, RIDGE and Elastic Net via `glmnet` package
  - Model diagnostics
    - Performance measure(s) on hold-out set to evalate competing models
    - stability of the prediction
    - specific diagnostic figures for LASSO

## Dataset used

  - [airbnb](https://gabors-data-analysis.com/datasets/#airbnb)

## Lecture Time

Ideal overall time: **100 mins**.


## Further material

  - This lecture is a modified version of [`Ch16-airbnb-random-forest.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch16-airbnb-random-forest/Ch16-airbnb-random-forest.R) from [Gabor's case study repository](https://github.com/gabors-data-analysis/da_case_studies).

