# Lecture 15: Advanced Linear Regression

This lecture introduces multiple variable regressions via [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe) dataset. It introduces topics on

  - how to choose a model from many possible candidates based on R2, 
  - how to evaluate prediction with multiple regressors: 
      - different graphs prediction uncertainty, and 
      - calculate the confidence and prediction intervals. 
      
Moreover, it covers external validity with robustness test: checking model results in different time/location/type of observations. Finally, as an extra part, it shows a simple example of using a training and test sample to better understand the process of model choice and the limitation of R2.

This lecture is based on 
  - [Chapter 09, B: How stable is the hotel price–distance to center relationship?](https://gabors-data-analysis.com/casestudies/#ch09b-how-stable-is-the-hotel-pricedistance-to-center-relationship)
  - [Chapter 10, B: Finding a good deal among hotels with multiple regression](https://gabors-data-analysis.com/casestudies/#ch10b-finding-a-good-deal-among-hotels-with-multiple-regression)
  

## Learning outcomes
After successfully completing [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/raw_codes/hotels_advanced_regression.R), students should be able to:

  - Visualize multiple explanatory variables with the outcome:
    - With a scatter plot decide the functional form which is needed.
  - Multiple linear regression
    - Use `feols` to estimate regressions with multiple explanatory variables
    - Use `etable` to compare multiple candidate models and report model statistics such as R2 to evaluate models.
  - Analysing model prediction
    - Get model predictions and residuals and in case of a log-transformed outcome, how to convert the predictions and residuals into level.
    - y-yhat scatter plot with 45-degree line to evaluate prediction uncertainty
    - residual-yhat or residual-explanatory variable scatter plot to evaluate model performance along different dimensions
  - Confidence and Prediction interval
    - Using `predict` function to get confidence and prediction interval
    - Set the significance level for the intervals with `level` input argument
    - Convert log-transformed outcome confidence and/or prediction intervals into level. Limitations.
  - External Validity: robustness checks
    - Estimate a selected model with different data to assess model uncertainty
    - Using different time periods, locations, and types of hotels/apartments.
    - Compare these models to the original and evaluate external validity
  - Extra:
    - Split the original sample into a training and test samples
    - Use the training sample to estimate the model and the test sample to predict hotel prices
    - Evaluate which model performs better with RMSE measure.

## Dataset used
  
  - [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe)

## Lecture Time

Ideal overall time: **100 mins**.

Going through [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/raw_codes/hotels_advanced_regression.R) takes around *70-80 minutes*. There are many discussions and interpretations of the models, which are similarly important.  Solving the tasks takes the remaining *20-30 minutes*. 


## Homework

*Type*: quick practice, approx 20 mins

Choose a different city from Vienna and make sure you have **at least 100 observations after filtering**. Create at least 3 models with at least 3 explanatory variables (check for transformation) and choose the best. Imagine you can build a new hotel in your city and can specify the feature values as you wish. Predict the price and estimate confidence and prediction intervals with a 90% significance level. Set the price of your hotel and argue, why is it your choice. 


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch10-hotels-multiple-reg](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch10-hotels-multiple-reg) on multiple regressions and [ch09-hotels-europe-stability](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch09-hotels-europe-stability) discusses external validity.
  - Coding and multiple linear regression: partially related in Chapter 3 from [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)
  - On regression [Grant McDermott: Data Science for Economists, Course material Lecture 08](https://github.com/uo-ec607/lectures/tree/master/08-regression) provides a somewhat different approach, but can be a nice supplement


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/raw_codes/hotels_advanced_regression.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/complete_codes) includes code with solution for [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/raw_codes/hotels_advanced_regression.R) as [`hotels_advanced_regression_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15-advanced-linear-regression/complete_codes/hotels_advanced_regression_fin.R)

