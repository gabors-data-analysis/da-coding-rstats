# Lecture 05: Data Exploration
*Coding course to complete Data Analysis in R*

This lecture introduces students to data exploration with `modelsummary`, `ggplot` and `t.stat`. 
Descriptive statistics and descriptive graphs for one variable are concerned to decide for further data munging.
Moreover simple hypothesis testing is covered as well as association graphs and statistics between two variables.

This lecture uses the [*Billion Price Project* case study from Chapter 6](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) and extends it to specific tools to use in data exploration.


## Learning outcomes
After successfully completing the code in *raw_codes* students should be able to:

[`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture05-data-exploration/raw_codes/data_exploration.R)
  - `datarsummary_skim` for quick summary for all variables in the tibble
  - specific variables with their descriptive statistics with `datasummary` such as
    - mean, median, standard deviation, minimum, maximum, percentiles, number of observations, number of missing observations
    - user-created functions added to `datasummary` such as range or mode
    - descriptives for specific groups, using a factor variable
  - use of `ggplot`:
    - histogram to plot empirical density with count or relative frequency. Understanding the role of number of bins and bins' width.
    - kernel density to plot a smooth function for the empirical density with understanding the role of binwidth.
    - stack multiple geometry object in one graph and control for opaqueness 
    - manipulate labels with `labs`
    - set axis limits with `xlim` and `ylim`
    - use a factor variable to graph multiple groups in one ggplot and understanding the differences between `fill`, `color` and `group` arguments.
    - create multiple plots in one graph with `facet_wrap`
  - carry out hypothesis test via t-test
    - two-sided, one-sided tests
    - multiple hypothesis test with tidyverse -> `summarise` and `group_by` functions
  - Association between two variables:
    - covariance with `cov` and correlation with `cor`
    - scatter plot
    - bin-scatter: equidistance bin-scatter with `stat_summary_bin` and equal number of observations in each bins by hand
    - correlation for specific subgroups and how to plot them. Use of `fct_reorder`.  

## Lecture Time

Ideal overall time: **70-100mins**.

Showing [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture05-data-exploration/raw_codes/data_exploration.R) takes around *50 minutes* while doing the tasks would take the rest.
I highly recommend to do the tasks as this lecture involves many new functions.
If do not have the needed time, you may take this into two parts. Good break points are:
  
  - hypothesis testing
  - association
 

## Homework

*Type*: quick practice, approx 15 mins

WIP

## Further material

  - Hadley Wickham and Garrett Grolemund: R for Data Science, [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) introduces to `ggplot` and show some features how to visualize data. [Chapter 5.6-7](https://r4ds.had.co.nz/transform.html) discusses `summarise` and `group_by` more in detail. [Chapter 7](https://r4ds.had.co.nz/exploratory-data-analysis.html) provides an overview on histograms, scatter plot and associations along with other exploratory tools. [Chapter 15](https://r4ds.had.co.nz/factors.html) provides further material on factors.
  - Billion-Price-Project case study can be found in Gabor's da_case_studies repository: [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) This case study primarly focuses on hypothesis testing only.
  - Data exploration case study in Gabor's da_case_studies repository is [ch03-hotels-vienna-explore](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch03-hotels-vienna-explore/ch03-hotels-vienna-explore.R). It focuses on bars, histograms and basic descriptive statistics.
  - Kieran Healy: Data Visualization, [Chapter 3](https://socviz.co/makeplot.html#makeplot) is a great (but somewhat outdated) overview of ggplot and the theory behind.
  - [Winston Chang: R Graphics Cookbook](https://r-graphics.org/) is a great book all about graphics in general with R.
  - Andrew Heiss: Data Visualization with R - [Lesson 3](https://datavizs21.classes.andrewheiss.com/lesson/03-lesson/) points to many other useful links to use ggplot. [Lesson 4](https://datavizs21.classes.andrewheiss.com/lesson/04-lesson/) overviews `summarise` and `group_by`.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes/data_exploration.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/complete_codes) includes one code with solutions for
    - [`data_exploration_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/complete_codes/data_exploration_fin.R) solution for: [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes/data_exploration.R)
