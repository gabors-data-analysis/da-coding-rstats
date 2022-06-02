# Lecture 16: Binary outcome - modeling probabilities

This lecture introduces binary outcome models with an analysis of health outcome with multiple variables based on [share-health](https://gabors-data-analysis.com/datasets/#share-health) dataset. First we introduce saturated models (smoking on health) and linear probability models with multiple explanatory variables. We check the predicted outcome probabilities for certain groups. Then we focus on non-linear binary models: the logit and probit model. We estimate marginal effects, to interpret the average (marginal) effects of variables on the outcome probabilities. We overview goodness of fit statistics (R2, Pseudo-R2, Brier score and Log-loss) along with visual and destricitve inspection of the predicted probabilities. Finally we calculate the estimed bias and the calibration curve to understand model performance better.

This lecture is based on [Chapter 11, A: Does smoking pose a health risk?](https://gabors-data-analysis.com/casestudies/#ch11a-does-smoking-pose-a-health-risk)

## Learning outcomes
After successfully completing codes in [`binary_models.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/raw_codes/binary_models.R), students should be able:


  - Calculated by hand or estimate saturated models
  - Visualize and understand binary outcome scatter-plots
  - Estimate Linear Probability Models (LPM)
    - Use `feols` to estimate regressions with multiple explanatory variables
    - Use `etable` to compare multiple candidate models and report model statistics such as R2 to evaluate models.
    - Understand the limitations of LPM
    - Carry out sub-group analysis based on predicted probabilities
  - Estimate Non-Linear Probability Models
    - Use `feglm` with `link = 'logit'` or `'probit'`, to estimate logit or probit models
    - Estimate `marginaleffects` with package `marginaleffects`
    - Use `etable` to compare logit and probit coefficients
    - Use `modelsummary` (from package `modelsummary`) to compare, LPM, logit/probit and logit/probit with marginal effects
    - Handle `modelsummary` function to get relevant goodness-of-fit measures
    - Use `fitstat_register()` function for `etable` to calculate user-supplied goodness-of-fit statistics, such as *Brier score* or *Log-loss* measures
  - Understand the usefulness of comparing the distribution of predicted probabilities for different models
  - Understanding the usefulness of comparing descriptive statistics of the predicted probabilities for different models
  - Calculate the bias of the model along with the calibration curve

## Datasets used

- [share-health](https://gabors-data-analysis.com/datasets/#share-health)

## Lecture Time

Ideal overall time: **80 mins**.

Going through [`binary_models.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/raw_codes/binary_models.R) takes around *60-70 minutes* as there are many discussion and interpretation of the models. Solving the tasks takes the remaining *10-20 minutes*. 


## Homework

*Type*: quick practice, approx 20 mins




## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch11-smoking-health-risk](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch11-smoking-health-risk)
  - Coding and multiple linear regression: partially related in Chapter 4, especially Ch 4.2 from [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)
  - Some other useful resources which are R-related, using base-R methods: [Ramzi W. Nahhas: Introduction to Regression Methods for Public Health Using R
](https://bookdown.org/rwnahhas/RMPH/blr.html) or [Cheng Hua, Dr. Youn-Jeng Choi, Qingzhou Shi: Companion to BER 642: Advanced Regression Methods](https://bookdown.org/chua/ber642_advanced_regression/binary-logistic-regression.html)


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture15_advanced_regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12_intro_to_regression/raw_codes/hotels_advanced_regression.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture15_advanced_regression/complete_codes) includes code with solution for [`hotels_advanced_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15_advanced_regression/raw_codes/hotels_advanced_regression.R) as [`hotels_advanced_regression_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture15_advanced_regression/complete_codes/hotels_advanced_regression.R)

