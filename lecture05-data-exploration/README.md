# Lecture 05: Data Exploration

This lecture introduces students to data exploration. `modelsummary` is used for data descriptive tables, `ggplot2` for creating graphs, and `t.stat` for hypothesis testing. 
Descriptive statistics and descriptive graphs for one variable are concerned to decide on further data munging.
Moreover, simple hypothesis testing is covered as well as association graphs and statistics between two variables.

Case studies connected to this lecture:
  - [Chapter 03, A: Finding a good deal among hotels: data exploration](https://gabors-data-analysis.com/casestudies/#ch03a-finding-a-good-deal-among-hotels-data-exploration) - emphasis on one variable descriptive analysis, different data
  - [Chapter 03, D: Distributions of body height and income](https://gabors-data-analysis.com/casestudies/#ch03d-distributions-of-body-height-and-income)  and [Chapter 03, U1: Size distribution of Japanese cities](https://gabors-data-analysis.com/casestudies/#ch03u1-size-distribution-of-japanese-cities) connects theoretical and empirical distributions
  - [Chapter 04, A: Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association) - focuses on the association between two variables, one variable descriptive is not emphasized, different data.
  - [Chapter 06, A: Comparing online and offline prices: testing the difference](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference) - focuses on hypothesis testing, association and one variable descriptive is not emphasized.

This lecture uses [Chapter 06, A](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference) as the starting point, but stresses the one variable descriptives such as in [Chapter 03, A](https://gabors-data-analysis.com/casestudies/#ch03a-finding-a-good-deal-among-hotels-data-exploration) and adds the two variable pattern analysis such as in [Chapter 04, A](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association).


## Learning outcomes
After completing the codes in [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture05-data-exploration/raw_codes/data_exploration.R), students should be able to:

  - `datarsummary_skim` for a quick summary of all variables in the tibble
  - specific variables with their descriptive statistics with `datasummary` such as
    - mean, median, standard deviation, minimum, maximum, percentiles, number of observations, number of missing observations
    - user-created functions added to `datasummary` such as range or mode
    - descriptives for specific groups, using a factor variable
  - use of `ggplot`:
    - histogram to plot empirical density with count or relative frequency. Understanding the role of the number of bins and bins' width.
    - kernel density to plot a smooth function for the empirical density with an understanding of the role of bandwidth.
    - stack multiple geometry objects in one graph and control for opaqueness 
    - manipulate labels with `labs`
    - set axis limits with `xlim` and `ylim`
    - use a factor variable to graph multiple groups in one ggplot and understand the differences between `fill`, `color`, and `group` arguments.
    - create multiple plots in one graph with `facet_wrap`
  - carry out hypothesis test via t-test
    - two-sided, one-sided tests
    - multiple hypothesis test with tidyverse -> `summarise` and `group_by` functions
  - Association between two variables:
    - covariance with `cov` and correlation with `cor`
    - scatter plot
    - bin-scatter: equidistance bin-scatter with `stat_summary_bin` and an equal number of observations in each bin by hand
    - correlation for specific subgroups and how to plot them. Use of `fct_reorder`.  

## Datasets used

* [billion-prices](https://gabors-data-analysis.com/datasets/#billion-prices)
* [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey) as homework


## Lecture Time

Ideal overall time: **70-100mins**.

Showing [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture05-data-exploration/raw_codes/data_exploration.R) takes around *50 minutes* while doing the tasks would take the rest.

I highly recommend doing all the tasks as this lecture involves many new functions.
If you do not have the needed time for one lecture, you may take this into two parts. Good breakpoints are:
  
  - hypothesis-testing
  - association
 

## Homework

*Type*: quick practice, approx 15 mins

Use the [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey) data, 'wms_da_textbook.csv' file.
Use the following units:
  - United States firms, observed in wave 2004 and employment of the firms should be between 100 and 5000.
  - Create a descriptive statistic table for variables of `management`, `emp_firm`, and `firm_age` with mean, median, sd, min, max, range, and 5% and 95% percentiles. Hint: use `quantile()` function for percentiles.
  - Create descriptive statistics for `management` grouped by `ownership` types. Use mean, median, min, and max.
  - Create a plot with histogram and kernel density, with proper labeling for `management` variable.
  - Create a new factor variable `firm_size`, which takes the value of 'small and medium' if `emp_firm` is smaller than 1000 and otherwise it is 'large' Hint: use a simple logical operator in a factor function, specifying the label.
  - Test if the average `management` score is different in large vs small and medium firms
  - Create a bin-scatter with 10 bins, where on x-axis is the `emp_firm` and y-axis the `management` score. Use the same number of observations within each bin.

## Further material

  - Hadley Wickham and Garrett Grolemund: R for Data Science, [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) introduces `ggplot` and show some features of how to visualize data. [Chapter 5.6 - 7](https://r4ds.had.co.nz/transform.html) discusses `summarise` and `group_by` more in detail. [Chapter 7](https://r4ds.had.co.nz/exploratory-data-analysis.html) provides an overview of histograms, scatter plots, and associations along with other exploratory tools. [Chapter 15](https://r4ds.had.co.nz/factors.html) provides further material on factors.
  - Billion-Price-Project case study can be found in Gabor's da_case_studies repository: [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) This case study primarily focuses on hypothesis testing only.
  - Data exploration case study in Gabor's da_case_studies repository is [ch03-hotels-vienna-explore](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch03-hotels-vienna-explore) and [ch03-hotels-europe-compare](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch03-hotels-europe-compare). It focuses on bars, histograms and basic descriptive statistics.
  - Association, scatter, and bin-scatter is used in the case study [ch04-management-firm-size](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch04-management-firm-size) in Gabor's book.
  - Kieran Healy: Data Visualization, [Chapter 3](https://socviz.co/makeplot.html#makeplot) is a great (but somewhat outdated) overview of ggplot and the theory behind it.
  - [Winston Chang: R Graphics Cookbook](https://r-graphics.org/) is a great book all about graphics in general with R.
  - Andrew Heiss: Data Visualization with R - [Lesson 3](https://datavizs21.classes.andrewheiss.com/lesson/03-lesson/) points to many other useful links to use ggplot. [Lesson 4](https://datavizs21.classes.andrewheiss.com/lesson/04-lesson/) overviews `summarise` and `group_by`.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes/data_exploration.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/complete_codes) includes one code with solutions for
    - [`data_exploration_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/complete_codes/data_exploration_fin.R) solution for: [`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration/raw_codes/data_exploration.R)
