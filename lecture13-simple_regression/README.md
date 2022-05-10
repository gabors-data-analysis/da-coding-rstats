# Lecture 13: life expectancy analysis
*Coding course to complete Data Analysis in R*

This lecture provides materials to analyze the association between life expectancy and GDP measures for various countries in 2019, inspired by the dataset [worldbank-lifeexpectancy](https://gabors-data-analysis.com/datasets/#worldbank-lifeexpectancy). During this exercise, students get familiar with creating simple linear regression-based models with different transformations, such as level-level, log-level, level-log, log-log models, or using polynomials or piecewise linear splines transformation of the explanatory variable.

This lecture is based on [Chapter 08, B: *How is life expectancy related to the average income of a country?*](https://gabors-data-analysis.com/casestudies/#ch08b-how-is-life-expectancy-related-to-the-average-income-of-a-country)

## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

`life_exp_getdata.R`
  - Solid ground for importing and exporting data from World Bank's website via API.


`life_exp_analysis.R`
  - Create scatter plots for competing models.
  - Transform variables from level to log in a ggplot and scale the axis for proper interpretation.
  - Run and plot multiple single-variable regressions with:
    - log transformation,
    - higher-order polynomial, or
    - piecewise linear spline
  - Be able to estimate heteroscedastic robust SEs and compare specific model results with `etable` in one output.

## Lecture Time

Ideal overall time: **60 mins**.

Solving `life_exp_getdata.R` takes around *5-10 minutes* as it builds on [lecture01-data-imp_n_exp](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture01-data-imp_n_exp). In principle it should be a quick reminder and practice.

Solving `life_exp_analysis.R` introduces the main material, and takes *40-60 minutes* depending on the student's background. This lecture is mainly a theory-based lecture (practice via case study) and includes easy, but many new commands in a repetitive way. 

## Homework

*Type*: quick practice, approx 20 mins

Use the [hotels-vienna dataset](https://gabors-data-analysis.com/datasets/#hotels-vienna), similarly as we used in [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12_intro_to_regression/raw_codes/hotels_intro_to_regression.R). Create and compare different transformations of y = price, x = distance variables:
  
  - level-level
  - log-level
  - level-log
  - log-log
  - polinomials of distance with square and cube terms
  - piecewise-linear-spline model, with a cutoff of 2 miles 

 Compare these models with an `etable` and decide which model would you use and why! Argue!

## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income)
  - Coding and simple linear regression: partially related in Chapter 3 from [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)
  - On ggplot and transforming variables:
    - Chapter 3.5-6 and Chapter 5.6 [Kieran H. (2019): Data Visualization](https://socviz.co/makeplot.html#mapping-aesthetics-vs-setting-them). For the homework, Chapter 5.4 can be handy.
    - [Winston C. (2022): R Graphics Cookbook, Chapter 5](https://r-graphics.org/chapter-scatter) also provides further material.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/raw_codes) includes codes, which are ready to use during the course but require some live coding in class.
    - `life_exp_getdata.R`, shows how to get life-expectancy data (and GDP measure) directly from the World Bank's website via an API. It saves a raw data file.
    - **`life_exp_analysis.R`** is the main material for this lecture. 
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/complete_codes) includes codes with solutions for
    - `life_exp_getdata.R` as `life_exp_getdata_fin.R` and
    - `life_exp_analysis.R` as `life_exp_analysis_fin.R`.
    - furthermore, it includes `life_exp_clean.R`, which is an auxiliary file. It shows how to create clean data from the raw data, produced by *life_exp_getdata.R*. Usually, this code is skipped during the lecture as it is already known, but tedious material. If needed it can be given as extra homework.
  - [data](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data) includes [raw](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data/raw) and [clean](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data/clean) data which are produced by codes in [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/complete_codes).
    - helps lagging students to catch up, without complete codes as files in [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/raw_codes) load data from this source.

