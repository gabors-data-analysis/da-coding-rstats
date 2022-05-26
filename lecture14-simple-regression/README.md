# Lecture 14: Analysis of life expectancy and GDP


This lecture provides materials to analyze the association between life expectancy and GDP measures for various countries in 2019 (or later), inspired by the dataset [worldbank-lifeexpectancy](https://gabors-data-analysis.com/datasets/#worldbank-lifeexpectancy). During this exercise, students get familiar with creating simple linear regression-based models with different transformations, such as level-level, log-level, level-log, and log-log models, or using polynomials and piecewise linear splines transformation of the explanatory variable.

This lecture is a practice (or similar to live coding) lecture, as it does not teaches much new material, but provides students to deepen their understanding with simple regressions and the reasoning behind them.

**Check out 
[`life_exp_analysis.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture14-simple-regression/raw_codes/life_exp_analysis.R), which is basically a skeleton for live coding!** Although, this lecture has similar folder structure as a pre-written class.

This lecture is based on [Chapter 08, B: How is life expectancy related to the average income of a country?](https://gabors-data-analysis.com/casestudies/#ch08b-how-is-life-expectancy-related-to-the-average-income-of-a-country)

## Learning outcomes
After successfully completing codes in *raw_codes* student should have:

[`life_exp_getdata.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture14-simple-regression/raw_codes/life_exp_getdata.R)
  - Solid ground for importing and exporting data from World Bank's website via API.

[`life_exp_analysis.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture14-simple-regression/raw_codes/life_exp_analysis.R)
  - Create scatter plots for competing models.
  - Transform variables from level to log in a ggplot and scale the axis for proper interpretation.
  - Run and plot multiple single-variable regressions with:
    - log transformation,
    - higher-order polynomial,
    - piecewise linear spline
    - or using weighted OLS.
  - Be able to estimate heteroscedastic robust SEs and compare specific model results with `etable` in one output.
  - Create a graph, which automatically annotates observations with the *n* largest and smallest errors.


## Datasets used

- [worldbank-lifeexpectancy](https://gabors-data-analysis.com/datasets/#worldbank-lifeexpectancy), but for more recent year.

## Lecture Time

Ideal overall time: approx 60 minutes.

Solving [`life_exp_getdata.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture14-simple-regression/raw_codes/life_exp_getdata.R) takes around *5-10 minutes* as it builds on [lecture02-data-imp-n-exp](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp). In principle it should be a quick reminder and practice.

Solving [`life_exp_analysis.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture14-simple-regression/raw_codes/life_exp_analysis.R) covers the main material, and takes *40-60 minutes* depending on the student's background. This lecture is mainly theory-based (practice via case study) and includes easy, but many new commands in a repetitive way. 

## Homework

*Type*: quick practice, approx 20 mins

Use the [hotels-vienna dataset](https://gabors-data-analysis.com/datasets/#hotels-vienna), similarly as we used in [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/raw_codes/hotels_intro_to_regression.R). Create and compare different models, based on transformations of `y=price` or `x=distance` variables:
  
  - level-level
  - log-level
  - level-log
  - log-log
  - polinomials of distance with square and cube terms
  - piecewise-linear-spline model, with a cutoff at 2 miles 

 Estimate these models with `feols`, using robust SEs, and compare with `etable`. Decide which model would you use and why! Argue!

## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income)
  - Coding and simple linear regression principles: [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)
  - On ggplot and transforming variables:
    - Chapter 3.5-6 and Chapter 5.6 [Kieran H. (2019): Data Visualization](https://socviz.co/makeplot.html#mapping-aesthetics-vs-setting-them). For the homework, Chapter 5.4 can be handy.
    - [Winston C. (2022): R Graphics Cookbook, Chapter 5](https://r-graphics.org/chapter-scatter) also provides further material.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes) includes codes, which are ready to use during the course but require some live coding in class.
    - [`life_exp_getdata.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes/life_exp_getdata.R), shows how to get life-expectancy data (and GDP measure) directly from the World Bank's website via an API. It saves a raw data file.
    - [**`life_exp_analysis.R`**](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes/life_exp_analysis.R) is the main skeleton material for this lecture. 
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/complete_codes) includes codes with solutions for
    - [`life_exp_getdata.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes/life_exp_getdata.R) as [`life_exp_getdata_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/complete_codes/life_exp_getdata_fin.R) and
    - [`life_exp_analysis.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes/life_exp_analysis.R) as [`life_exp_analysis_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/complete_codes/life_exp_analysis_fin.R).
    - furthermore, it includes [`life_exp_clean.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/complete_codes/life_exp_clean.R), which is an auxiliary file. It shows how to create clean data from the raw data, produced by [*`life_exp_getdata.R`*](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes/life_exp_getdata.R). Usually, this code is skipped during the lecture as it is already known, but tedious material. If needed it can be given as extra homework or practice.
  - [data](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/data) includes [raw](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/data/raw) and [clean](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/data/clean) data which are produced by codes in [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/complete_codes).
    - helps lagging students to catch up, without complete codes as files in [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple-regression/raw_codes) load data from this source.


