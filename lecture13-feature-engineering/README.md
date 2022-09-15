# Lecture 13: Feature Engineering

## Motivation

Feature engineering is the part when we take the variables as recorded in the raw data and create (transform) the y and x variables that we’ll include in the model. In general x variables are called features (in predictive analytics) whereas y is often called labels (coming from categorization tasks).

Specifying the functional form of the variables is a difficult aspect of feature engineering. That includes capturing nonlinear relationships with quantitative variables (quadratic, higher order polynomial, piecewise linear spline, etc), deciding on the number of categories for qualitative variables (joining
rare categories into fewer ones), and deciding on interactions. The emphasis is on getting the best fit without overfitting the data. Domain knowledge is important: knowledge from previous analyses, and/or theory, about what tends to make the outcome different. Domain knowledge can help answer what variables are likely to be more important versus less important, what interactions are likely important, and where should we be most worried about nonlinearity. For instance, professional weather forecasts use computational models that use the laws of physics to relate many variables and feed in measured values of those variables from data. Or, many central banks complement purely data-driven inflation forecasts with predictions from general equilibrium models that are simplified representations of how the economy works. The other source of information is the data itself. Exploratory data analysis (EDA) is a key part of all predictive analytics. We do EDA to make sure we understand the content of each variable, to make sure they are as clean as possible, and to understand their distribution. Besides exploring the variables in themselves, we need to investigate the patterns of associations with the y variable. In addition, we may look at how the x variables are correlated with each other, to make sure that we don’t include variables together that are extremely closely related to each other (e.g., that have a correlation coefficient of 0.95) unless we have a very good reason (usually theoretical) to do so.

This work is tedious and time-consuming. Some of it is unavoidable. We need to know our data: we should never build models with x variables whose content we don’t understand. That’s because we cannot assess, or even think about, the stability of the patterns of association between y and x if we don’t know what those variables are, what their content is, and how they are measured. And assessing stability is necessary for assessing external validity, which is a key aspect of a good model. Thus, we can play around with data and estimate models without knowing what’s in them, but that won’t necessarily help with the true goal of our analysis.

## This lecture

This lecture introduces feature engineering practices and focuses on simple methods used in [Gabor's book](https://gabors-data-analysis.com/) and its [case studies]((https://github.com/gabors-data-analysis/da_case_studies)). It utilizes [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey) dataset for manipulation of (multiple) variable(s) into a new one and [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms) dataset to show more elaborate techniques such as imputing, nonlinear transformations and winsorizing.

The lecture (partially) uses the following case studies:
  - [Chapter 01, C: Management quality: data collection](https://gabors-data-analysis.com/casestudies/#ch01c-management-quality-data-collection)
  - [Chapter 04, A: Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association)
  - [Chapter 08, C: Measurement error in hotel ratings](https://gabors-data-analysis.com/casestudies/#ch08c-measurement-error-in-hotel-ratings) as homework
  - [Chapter 17, A: Predicting firm exit: probability and classification](https://gabors-data-analysis.com/casestudies/#ch17a-predicting-firm-exit-probability-and-classification)

*Note: this is rather an introduction to feature engineering, emphasizing the importance of what kind of (basic) transformations are necessary with the variables. However, the literature rather thinks of feature engineering as a complex, usually machine learning-based method, to create new variables. Main applications are converting texts, pictures, videos, web-page content, etc into data-analysis-ready variables.* 


## Learning outcomes
PART I: after successfully completing [`feature_engineering_part_I.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_I.R), students should be able:

- How to create a new variable from multiple already existing variables by calculating the mean or the sum
- Create groups of a categorical variable
  - `countrycode` package to get continents and regions
  - `fct_collapse` to group by hand
- Create an ordered factor variable
  - convert an integer-valued variable to an ordered factor variable     
  - `cut`, `cut_numbers`, and others to convert a continuous variable into an ordered factor variable
- Create dummy variables from a factor variable with `fastDummies` package
- Extra: introduction to principal component analysis with `prcomp()`

PART II: after successfully completing [`feature_engineering_part_II.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_II.R), students should be able:

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

- Part I: [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey)
- Part II: [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms)
- Homework: [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna)

## Lecture Time

Ideal overall time: **30-50 mins**.

This lecture is a collection of basic feature engineering techniques used throughout [this R course](https://github.com/gabors-data-analysis/da-coding-rstats), [Gabor's book](https://gabors-data-analysis.com/) and its [case studies](https://github.com/gabors-data-analysis/da_case_studies). It can be skipped and one can spend more time in each lecture on the transformations/engineering. However, it is highly useful to see almost all the transformations in one place.

## Homework

*Type*: quick practice, approx 15 mins

This homework should make students think about other issues with variables, namely measurement error in the explanatory variable.

Use [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna) data from [OSF](https://osf.io/y6jvb/). 

  - Filter observations to Hotels with 3-4 stars in Vienna (`city_actual`) and with prices less than 600$
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
    - [`feature_engineering_part_I.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_I.R), is covering the first part for this lecture.
    - [`feature_engineering_part_II.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_II.R), is covering the second part for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/complete_codes/) includes code with solutions for 
    - [`feature_engineering_part_I.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_I.R) as [`feature_engineering__part_I_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/complete_codes/feature_engineering_part_II_fin.R)
    - [`feature_engineering_part_II.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/raw_codes/feature_engineering_part_II.R) as [`feature_engineering__part_II_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature-engineering/complete_codes/feature_engineering_part_II_fin.R)
