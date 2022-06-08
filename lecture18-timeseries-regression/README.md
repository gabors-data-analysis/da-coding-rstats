# Lecture 18: Introduction to time-series regression

## Motivation

Heating and cooling are potentially important uses of electricity. To investigate how weather conditions affect electricity consumption, you have collected data on temperature and residential electricity consumption in a hot region. How should you estimate the association between temperature and electricity consumption? How should you define the variables of interest, and how should you prepare the data, which has daily observations on temperature and monthly observations on electricity consumption? Should you worry about the fact that both electricity consumption and temperature vary a lot across months within years, and if yes, what should you do about it?

Time series data is often used to analyze business, economic, and policy questions. Time series data presents additional opportunities as well as additional challenges for regression analysis. Unlike cross-sectional data, it enables examining how y changes when x changes, and it also allows us to examine what happens to y right away or with a delay. However, variables in time series data come with some special features that affect how we should estimate regressions, and how we can interpret their coefficients.

## This lecture

This lecture introduces time-series regression via the [arizona-electricity](https://gabors-data-analysis.com/datasets/#arizona-electricity) dataset. During this lecture, students manipulate time-series data along time dimensions, create multiple time-series related graphs and get familiar with (partial) autocorrelation. Differenced variables, lags of the outcome, and lags of the explanatory variables, (deterministic) seasonality are used during regression models. Estimating these models are via `feols` with Newey-West standard errors. Model comparisons and estimating cumulative effects with valid SEs are shown.

This lecture is based on [Chapter 12, B: Electricity consumption and temperature](https://gabors-data-analysis.com/casestudies/#ch12b-electricity-consumption-and-temperature)

## Learning outcomes
After successfully completing [`intro_time_series.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/intro_time_series.R), students should be able:

  - Merge different time-series data
  - Create time-series related descriptives and graphs
    - handle date as the axis with different formatting
    - import source code from URL via `source_url` from `devtools`
    - create autocorrelation and partial autocorrelation graphs and interpret
  - Run time-series regression with `feols` from `fixest`
    - Understand why defining period and id is important with `fixest` package
    - Estimate Newey-West standard errors and understand the role of lags
    - Control for seasonality via dummies
    - Add lagged variables to the model (and possibly leads as well)
    - How and why to use the same time interval when comparing competing time-series models
    - Estimate the standard error(s) for the cumulative effect

## Datasets used

- [arizona-electricity](https://gabors-data-analysis.com/datasets/#arizona-electricity)

## Lecture Time

Ideal overall time: **60-80 mins**.

Going through [`intro_time_series.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/intro_time_series.R) takes around *50-70 minutes* as there are some discussions and interpretations of the time series (e.g. stationarity, a transformation of variables, etc). Solving the tasks takes the remaining *5-10 minutes*.


## Homework

*Type*: quick practice, approx 20 mins

You will use the [case-shiller-la](https://gabors-data-analysis.com/datasets/#case-shiller-la) dataset to build a model for unemployment based on the Shiller price index. Load the data and consider only `pn` (Shiller price index) and `un` (unemployment) as the variables of interest. Both are seasonally adjusted. Decide which transformation to use to make the variables stationary. Create models, where you predict unemployment based on the Shiller price index. At least you should have one model where you use only the contemporaneous effects and one when you use lagged variables for both variables as explanatory variables.


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch12-electricity-temperature](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch12-electricity-temperature)
  - Handy, but a somewhat different approach for time-series analysis can be found [James Long and Paul Teetor: R Cookbook (2019), Chapter 14](https://rc2e.com/timeseriesanalysis)
  - A good starting point for advanced methods in the time-series analysis is: [`modeltime`](https://business-science.github.io/modeltime/) introduces automated, machine learning, and deep learning-based analysis, its supplementary package [`timetk`](https://business-science.github.io/timetk/index.html) has many great time-series related manipulations.

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`intro_time_series.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/intro_time_series.R), is the main material for this lecture.
    - [`ggplot.acorr.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/ggplot.acorr.R) is an auxillary function to plot (partial) autocorrelation graphs, by [Kevin Liu](https://rh8liuqy.github.io/ACF_PACF_by_ggplot2.html). This file is `source_url`-ed to [`intro_time_series.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/intro_time_series.R).
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/complete_codes) includes code with solution for [`intro_time_series.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/raw_codes/intro_time_series.R) as [`intro_time_series_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression/complete_codes/intro_time_series_fin.R)

