# Lecture 05: Data Exploration
*Coding course to complete Data Analysis in R*

This lecture introduces students to data exploration with `modelsummary`, `ggplot` and `t.stat`. 
Descriptive statistics and descriptive graphs for one variable are concerned to decide for further data munging.
Moreover simple hypothesis testing is covered as well as association graphs and statistics between two variables.

This lecture uses the [*Billion Price Project* case study from Chapter 6](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) and extends it to specific tools to use in data exploration.


## Learning outcomes
After successfully completing the code in *raw_codes* students should be able to:

[`data_exploration.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture05-data-exploration/raw_codes/data_exploration.R)
  - quick summary for all variables in the tibble
  - specific variables with their descriptive statistics with `datasummary` such as
    - mean, median, standard deviation, minimum, maximum, percentiles, number of observations, number of missing observations
    - user-created functions added to `datasummary` such as range or mode
    - descriptives for specific groups, using a factor variable
  - use of `ggplot`, specifically
    - histogram to plot empirical density via count or relative frequency, with understanding the role of number of bins and bins' width
    - kernel density to plot a smooth function for the empirical density with understanding the role of binwidth.
    - stack multiple geometry object in one graph adn control for opaqueness 
    - manipulate labels
    - set x-axis or y-axis limits
    - use a factor variable to graph multiple groups in one ggplot and understanding the differences between `fill`, `color` and `group` inputs.
    - create multiple plots in one graph with `facet_wrap`
  - carry out hypothesis test via t-test
    - two-sided, one-sided tests
    - multiple hypothesis test with tidyverse -> `summarise` and `group_by` functions
  - Association between two variables  

## Lecture Time

Ideal overall time: **40-60 mins**.

Showing [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)takes around *30 minutes* while doing the tasks would take the rest.
 

## Homework

*Type*: quick practice, approx 15 mins

WIP

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science: [Chapter 5](https://r4ds.had.co.nz/transform.html) provides an overview of the type of variables, selecting, filtering, and arranging along with others. [Chapter 15](https://r4ds.had.co.nz/factors.html) provides further material on factors. [Chapter 18](https://r4ds.had.co.nz/pipes.html) discusses pipes in various applications.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 3](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/03_1d_data.Rmd) is relevant for factors, but includes many more. [Lecture 6](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/06_slicing_dicing.Rmd) introduces similar manipulations with tibble.
  - Grant McDermott: Data Science for Economists, Course material, [Lecture 5](https://github.com/uo-ec607/lectures/blob/master/05-tidyverse/05-tidyverse.pdf) is a nice overview on tidyverse with easy data manipulations.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/complete_codes) includes one code with solutions for
    - [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/complete_codes/data_munging_fin.R) solution for: [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)
