# Lecture 14: Advanced topics in linear regression
*Coding course to complete Data Analysis in R*

This lecture extends the toolkit for linear regressions via [hotels-europe dataset](https://gabors-data-analysis.com/datasets/#hotels-europe). It introduces to multiple regression, where there are multiple explanatory variables. Overviews how to add and with which functional form these multiple explanatory variables. `fixest` is used to estimate these models and `etable` to compare them. With a selected model, the lecture shows how to estimate confidence and prediction intervals along with evaluating predictions via graphs in multiple dimensions. In the second section robustness checks are carried out to investigate external validity of the model: checking different time/place/types of observations. As an extra exercise the observations are split into training and test samples to evaluate goodness of fit.

This lecture is based on [Chapter 10, B: *Finding a good deal among hotels with multiple regression*](https://gabors-data-analysis.com/casestudies/#ch10b-finding-a-good-deal-among-hotels-with-multiple-regression)

## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

[`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/raw_codes/hotels_advanced_regression.R)
  - Decide which transformation to use for explanatory variables and outcome
    - Join multiple `ggplot` with `ggarrange` from the package `ggpubr`. This helps reporting and arguing your model choice.
  - Multiple linear regression
    - Run multiple linear regression with `feols`
    - Compare the results of multiple models with `etable` and add header for the models
  - Prediction
    - Get predicted values and errors for a model and if log transformation is used to convert back to level.
    - Plot errors and outcome or explanatory variable to assess uncertainty in the model along different dimensions
    - Estimate confidence intervals with `predict` and set the `level`
    - Estimate the prediction interval with `predict` and set the `level`
    - Understand and interpret the difference between the two concepts
  - Robustness tests as checking for External Validity
    - Understand the why to do robustness tests
    - Check results robustness along time/place/type of observation
  - Extra: split the original sample into a training and test sample and use the training sample to fit the model, while the test sample to evaluate the prediction precision of a model.

## Lecture Time

Ideal overall time: **60 mins**.

Solving tasks in [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/raw_codes/hotels_advanced_regression.R) takes around *10-25 minutes*, but the majority can be skipped.


## Homework

*Type*: 


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch10-hotels-multiple-reg](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch10-hotels-multiple-reg)


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/raw_codes/hotels_advanced_regression.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression//complete_codes) includes code with solution for [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/raw_codes/hotels_advanced_regression.R) as [`hotels_advanced_regression_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture14-advanced_linear_regression/complete_codes/hotels_advanced_regression_fin.R)
