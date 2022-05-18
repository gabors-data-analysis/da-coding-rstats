# Lecture 13: Feature Engineering
*Coding course to complete Data Analysis in R*

This lecture overviews main feature engineering practices. It uses [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey) dataset for manipulation of (mulitple) variable(s) into a new one and [bisnode-firms](https://gabors-data-analysis.com/datasets/#bisnode-firms) dataset to show more elaborate techniques such as imputing, nonlinear transformations and winsorizing.

The lecture (partially) uses case studies of [Chapter 1C: Management quality: data collectionv](https://gabors-data-analysis.com/casestudies/#ch01c-management-quality-data-collection), [Chapter 4A: Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association) and [Chapter 17A Predicting firm exit: probability and classification](https://gabors-data-analysis.com/casestudies/#ch17a-predicting-firm-exit-probability-and-classification)


## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

[`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/raw_codes/feature_engineering.R)
- How to create new variable from multiple already existing variables with calculating the mean or the sum
- Create groups of a categorical variable
  - `countrycode` package to get continents and regions
  - `fct_collapse` to group by hand
- Create ordered factor variable
  - convert an integer valued variable to ordered factor variable     
  - `cut`, `cut_numbers` and others to convert a contiunous variable into an ordered factor variable
- Create dummy variables from a factor variable with `fastDummies` package
- Imputing values
  - replacing with mean or median
  - using outside knowledge (or other variable)
  - creating categorical variable with specific value for missing
- Adjusting log transformation (to avoid log(0))
- Using `lead` and `lag` functions
- Numeric vs factor representation with visualization
- Random sampling with panel data for (faster) visualization
- Winsorizing 
- Using `ggpubr` package to plot multiple `ggplot2` object at once

## Lecture Time

Ideal overall time: **30-50 mins**.

This lecture is a collection of feature engineering techniques used throught [this R course](https://github.com/gabors-data-analysis/da-coding-rstats) and [case studies](https://github.com/gabors-data-analysis/da_case_studies). Therefore it can be skipped and spend more time in each individual lecture with the transformations. However it is highly useful to see almost all the transformations in one place.

## Homework

*Type*: TBC


## Further material
  - More materials on the **World-Management Survey case study** can be found in Gabor's *da_case_studies* repository: [ch04-management-firm-size](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch04-management-firm-size)
  - More materials on the **Predicting firm exit case study** can be found in Gabor's *da_case_studies* repository: [ch17-predicting-firm-exit](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit), especially in the [data preparation file](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch17-predicting-firm-exit/ch17-firm-exit-data-prep.R)
  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 15](https://r4ds.had.co.nz/factors.html) provide further material on factors and dealing with them.


## File structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/raw_codes/) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/raw_codes/feature_engineering.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/complete_codes/) includes code with solution for [`feature_engineering.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/raw_codes/feature_engineering.R) as [`feature_engineering_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture13-feature_engineering/complete_codes/feature_engineering_fin.R)
