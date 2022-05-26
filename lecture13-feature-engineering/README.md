# Lecture 13: Feature Engineering

This lecture introduces feature engineering practices and focuses on simple methods used in [Gabor's book](https://gabors-data-analysis.com/) and its [case studies]((https://github.com/gabors-data-analysis/da_case_studies)). It uses [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey) dataset for manipulation of (multiple) variable(s) into a new one and [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms) dataset to show more elaborate techniques such as imputing, nonlinear transformations and winsorizing.

The lecture (partially) uses the following case studies:
  - [Chapter 01, C: Management quality: data collectionv](https://gabors-data-analysis.com/casestudies/#ch01c-management-quality-data-collection)
  - [Chapter 04, A: Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association)
  - [Chapter 08, C: Measurement error in hotel ratings](https://gabors-data-analysis.com/casestudies/#ch08c-measurement-error-in-hotel-ratings) as homework
  - [Chapter 17, A: Predicting firm exit: probability and classification](https://gabors-data-analysis.com/casestudies/#ch17a-predicting-firm-exit-probability-and-classification)


## Learning outcomes
After successfully completing [`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering.R), students should be able:

- How to create a new variable from multiple already existing variables by calculating the mean or the sum
- Create groups of a categorical variable
  - `countrycode` package to get continents and regions
  - `fct_collapse` to group by hand
- Create an ordered factor variable
  - convert an integer-valued variable to an ordered factor variable     
  - `cut`, `cut_numbers` and others to convert a continuous variable into an ordered factor variable
- Create dummy variables from a factor variable with `fastDummies` package
- Imputing values
  - replacing with mean or median
  - using outside knowledge (or other variables)
  - creating a categorical variable with a specific value for missing
- Adjusting log transformation (to avoid log(0))
- Using `lead` and `lag` functions
- Numeric vs factor representation with visualization
- Random sampling with panel data for (faster) visualization
- Winsorizing 
- Using `ggpubr` package to plot multiple `ggplot2` objects at once

## Datasets used

- [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey)
- [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms)
- [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna) as homework.

## Lecture Time

Ideal overall time: **30-50 mins**.

This lecture is a collection of basic feature engineering techniques used throughout [this R course](https://github.com/gabors-data-analysis/da-coding-rstats), [Gabor's book](https://gabors-data-analysis.com/) and its [case studies](https://github.com/gabors-data-analysis/da_case_studies). It can be skipped and one can spend more time in each lecture on the transformations/engineering. However, it is highly useful to see almost all the transformations in one place.

## Homework

*Type*: quick practice, approx 15 mins

This homework should make students think about other issues with variables, namely measurement error in the explanatory variable.

Use [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna) data from [OSF](https://osf.io/y6jvb/). 

  - Filter observations to Hotels with 3-4 stars in Vienna (`city_actual`) and with price less than 600$
  - Create a new variable: log-price
  - Create three sub-samples, where `rating_count` is:
    - less than 100
    - between 100 and 200
    - more than 200
  - Run simple linear regressions: `log-price ~ rating` on all of the abovementioned samples
  - Plot the three predicted log prices on one plot, with proper formatting and legends
  - Argue briefly why the slopes are different.


## Further material
  - More materials on the **World-Management Survey case study** can be found in Gabor's *da_case_studies* repository: [ch04-management-firm-size](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch04-management-firm-size)
  - More materials on the **Predicting firm exit case study** can be found in Gabor's *da_case_studies* repository: [ch17-predicting-firm-exit](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit), especially in the [data preparation file](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit/ch17-firm-exit-data-prep.R)
  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 15](https://r4ds.had.co.nz/factors.html) provide further material on factors and dealing with them.


## File structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/complete_codes/) includes code with solutions for 
    - [`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering.R) as [`feature_engineering_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/complete_codes/feature_engineering_fin.R)
