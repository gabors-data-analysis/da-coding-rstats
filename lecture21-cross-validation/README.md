# Lecture 21: Cross-validating linear models 

## Motivation

You have a car that you want to sell in the near future. You want to know what price you can expect if you were to sell it. You may also want to know what you could expect if you were to wait one more year and sell your car then. You have data on used cars with their age and other features, and you can predict price with several kinds of regression models with different righthand-side variables in different functional forms. How should you select the regression model that would give the best prediction?

We introduce point prediction versus interval prediction; we discuss the components of prediction error and how to find the best prediction model that will likely produce the best fit (smallest prediction error) in the live data, using observations in the original data. We introduce loss functions in general and mean squared error (MSE) and its square root (RMSE) in particular, to evaluate predictions. We discuss three ways of finding the best predictor model, using all data and the Bayesian Information Criterion (BIC) as the measure of fit, using training–test splitting of the data, and using k-fold cross-validation, which is an improvement on the training–test split.

## This lecture

This lecture refreshes methods for data cleaning and refactoring data as well as some basic feature engineering practices. After data is set, multiple competing regressions are run and compared via BIC and k-fold cross validation. Cross validation is carried out by the `caret` package as well. After the best-performing model is chosen (by RMSE), prediction performance and risks associated are discussed. In the case, when log-transformed outcome is used as the model, transformation back to level and evaluation of the prediction performance is also covered.

Case studies used:
  - [Chapter 13, A: Predicting used car value with linear regressions](https://gabors-data-analysis.com/casestudies/#ch13a-predicting-used-car-value-with-linear-regressions)
  - [Chapter 14, A: Predicting used car value: log prices](https://gabors-data-analysis.com/casestudies/#ch14a-predicting-used-car-value-log-prices)

## Learning outcomes
After successfully completing [`seminar1_crossvalidation.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/part-III-case-studies/seminar01-cv-used-cars/seminar1_crossvalidation.R), students should be able:

  - Clean and prepare data for modeling
  - Decide for functional forms and do meaningful variable transformations
  - Run multiple regressions and compare performance based on BIC
  - Carry out k-fold cross validation with `caret` package for different regression models
  - Compare the prediction performance of the models
  - Understand what happens if a log-transformed outcome is used
    - convert prediction back to level
    - compare prediction performance of other (non-log) models 

## Dataset used

- [used-cars](https://gabors-data-analysis.com/datasets/#used-cars)

## Lecture Time

Ideal overall time: **100 mins**.


## Further material

  - This seminar is a modified and combined version of [`ch13-used-cars.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch13-used-cars-reg/ch13-used-cars.R) and [`ch14-used-cars-log.R`](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch14-used-cars-log/ch14-used-cars-log.R) codes from [Gabor's case study repository](https://github.com/gabors-data-analysis/da_case_studies).

