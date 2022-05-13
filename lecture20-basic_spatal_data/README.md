# Lecture 20: Spatial data visualization
*Coding course to complete Data Analysis in R*

This lecture introduces spatial data visualization using maps. During the lecture students will visualize 2016 US election results on US map along with covid death rates on world map.

## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

[`arizona_electricity.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries_regression/raw_codes/arizona_electricity.R)
  - Merge different data
  - Create time-series related descriptives and graphs
    - handle date as the axis
    - import source code from URL via `source_url` from `devtools`
    - create autocorrelation and partial autocorrelation graphs and interpret
  - Run time-series regression with `feols` from `fixest`
    - Understand why defining period and id is important with `fixest` package
    - Estimate Newey-West standard errors and understand the role of lags
    - Control for seasonality via dummies
    - Add lagged variables to the model (and possibly leads as well)
    - How and why to use the same time interval when comparing competing time-series models
    - Estimate the standard error for the cumulative effect

## Lecture Time

Ideal overall time: **60-80 mins**.

Going through [`arizona_electricity.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries_regression/raw_codes/arizona_electricity.R) takes around *50-70 minutes* as there are some discussions and interpretations of the time series (e.g. stationarity, transformation of variables, etc). Solving the tasks takes the remaining *10 minutes*.


## Homework

*Type*: quick practice, approx 20 mins

You will use the [case-shiller-la](https://gabors-data-analysis.com/datasets/#case-shiller-la) dataset to build a model for unemployment based on the Shiller price index. Load the data and consider only `pn` (Shiller price index) and `un` (unemployment) as the variables of interest. Both are seasonally adjusted. Decide which transformation to use to make the variables stationary. Create models, where you predict unemployment based on the Shiller price index. At least you should have one model where you use only the contemporaneous effects and one when you use lagged variables for both variables as explanatory variables.


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch12-electricity-temperature](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch12-electricity-temperature)
  - Handy, but a somewhat different approach for time-series analysis can be found [James Long and Paul Teetor: R Cookbook (2019), Chapter 14](https://rc2e.com/timeseriesanalysis)
  - A good starting point for advanced methods in the time-series analysis is: [`modeltime`](https://business-science.github.io/modeltime/) introduces automated, machine learning, and deep learning-based analysis, its supplementary package [`timetk`](https://business-science.github.io/timetk/index.html) has many great time-series related manipulations.

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture18-timeseries_regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`arizona_electricity.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries_regression/raw_codes/arizona_electricity.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture18-timeseries_regression/complete_codes) includes code with solution for [`arizona_electricity.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries_regression/raw_codes/arizona_electricity.R) as [`arizona_electricity_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries_regression/complete_codes/arizona_electricity_fin.R)

