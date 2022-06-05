# Lecture 16: Binary outcome - modeling probabilities

## Motivation

Does smoking make you sick? And can smoking make you sick in late middle age even if you stopped years earlier? You have data on many healthy people in their fifties from various countries, and you know whether they stayed healthy four years later. You have variables on their smoking habits, their age, income, and many other characteristics. How can you use this data to estimate how much more likely non-smokers are to stay healthy? How can you uncover ifthat depends on whether they never smoked or are former smokers? And how can you tell if that association is the result of smoking itself or, instead, underlying differences in smoking by education, income, and other factors?

The lecture is related to thechapter that discusses probability models: regressions with binary y variables. In a sense, we can treat a binary y variable just like any other variable and use regression analysis as we would otherwise. with a binary y variable, we can estimate nonlinear probability models instead of the linear one. Data analystsneed to have a good understanding of when to use these different probability models, and how to interpret and evaluate their results.

## This lecture

This lecture introduces binary outcome models with an analysis of health outcomes with multiple variables based on the [share-health](https://gabors-data-analysis.com/datasets/#share-health) dataset. First, we introduce saturated models (smoking on health) and linear probability models with multiple explanatory variables. We check the predicted outcome probabilities for certain groups. Then we focus on non-linear binary models: the logit and probit model. We estimate marginal effects, to interpret the average (marginal) effects of variables on the outcome probabilities. We overview goodness of fit statistics (R2, Pseudo-R2, Brier score, and Log-loss) along with visual and descriptive inspection of the predicted probabilities. Finally, we calculate the estimated bias and the calibration curve to understand model perform better.

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

Ideal overall time: **100 mins**.

Going through [`binary_models.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/raw_codes/binary_models.R) takes around *80-90 minutes* as there are many discussion and interpretation of the models. Solving the tasks takes the remaining *10-20 minutes*. 


## Homework

*Type*: quick practice, approx 20 mins

Use the same [share-health](https://gabors-data-analysis.com/datasets/#share-health) dataset, but now use `smoking` as your outcome variable as this task is going to ask you to predict if a person is a smoker or not. Use similar variables except `stayshealthy` to explain `smoking`. Run a LPM, logit and probit model. Compare the coefficients of these models along with the average marginal effects. Compute the goodness of fit statistics (R2, Pseudo-R2, Brier score, log-loss) of all of the models. Choose one, calculate the bias, and plot the calibration curve.



## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch11-smoking-health-risk](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch11-smoking-health-risk)
  - Coding and multiple linear regression: partially related in Chapter 4, especially Ch 4.2 from [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)
  - Some other useful resources which are R-related, using base-R methods: [Christoph Hanck, Martin Arnold, Alexander Gerber, and Martin Schmelzer: Introduction to Econometrics with R, Chapter 11](https://www.econometrics-with-r.org/11-rwabdv.html) or [Ramzi W. Nahhas: Introduction to Regression Methods for Public Health Using R
](https://bookdown.org/rwnahhas/RMPH/blr.html).


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture16-binary-models/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`binary_models.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/raw_codes/binary_models.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture16-binary-models/complete_codes) includes code with solution for [`binary_models.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/raw_codes/binary_models.R) as [`binary_models_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture16-binary-models/complete_codes/binary_models_fin.R)

