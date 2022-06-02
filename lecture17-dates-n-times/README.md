# Lecture 17: Date and time manipulations

This lecture introduces basic date and time variable manipulations. The first part starts with the basics using `lubridate` package by overviewing basic time-related functions and manipulations with time-related values and variables. The second part discusses time-series data aggregation from different frequencies along with visualization for time-series data and unit root tests.

This lecture utilizes the case study of [Chapter 12, A: Returns on a company stock and market returns](https://gabors-data-analysis.com/casestudies/#ch12a-returns-on-a-company-stock-and-market-returns) as homework, and uses [`stocks-sp500`](https://gabors-data-analysis.com/datasets/#stocks-sp500) dataset.

## Learning outcomes
After successfully completing [`date_time_manipulations.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture17-dates-n-times/raw_codes/date_time_manipulations.R), students should be:

  - Familiar with the `lubridate` package, especially with
    - creating specific time variables, converting other types of variables into a date or datetime object
    - understand the importance of time zones
    - Get specific parts of a date object such as `year, quarter, month, wday, yday, day, leap_year`
    - Rounding to the closest month, year, quarter, etc.
    - Understand the difference between duration and periods
  - Carry out time aggregation
    - Aggregate different time series objects to lower frequencies, using mean/median/max/end date, etc.
    - Adding `lag`-ged and differenced variables to data
  - Visualize time series with
    - handle time variable on x-axis with `scale_x_date()`  
    - `facet_wrap` to stack multiple graphs as an alternative to `ggpurb`
    - standardize variables and put multiple lines into one graph   
  - Unit root tests using `aTSA` package's `pp.test` function
    - understanding the result of the Philip-Perron test and deciding if the variable needs to be differenced or not. 

## Datasets used

- [`stocks-sp500`](https://gabors-data-analysis.com/datasets/#stocks-sp500)

## Lecture Time

Ideal overall time: **35-40 mins**.

Going through [`date_time_manipulations.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture17-dates-n-times/raw_codes/date_time_manipulations.R) takes around *30 minutes*. There are some discussions and interpretations of the time series (e.g. stationarity). Solving the tasks takes the remaining *5-10 minutes*. The lecture can be shortened by only showing the methods. It will be partially repeated in [lecture18-timeseries-regression](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture18-timeseries-regression).


## Homework

*Type*: quick practice, approx 10 mins

Estimate the *beta* coefficient between quarterly SP500 log returns on Microsoft stocks log return. Use the [`stocks-sp500`](https://gabors-data-analysis.com/datasets/#stocks-sp500) dataset. Take care when aggregating the data to a) use the last day in the quarter and then take the logs and then difference the variable to get log returns. When estimating the regression use heteroskedastic robust standard error (next lecture we learn how to use Newey-West SE).


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch12-stock-returns-risk](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch12-stock-returns-risk/ch12-stock-returns-risk.R)
  - Hadley Wickham and Garrett Grolemund R for Data Science: [Chapter 16](https://r4ds.had.co.nz/dates-and-times.html) discuss time and date formates more in detail.
  - [`timetk` package](https://business-science.github.io/timetk/index.html) is a well-documented advanced time-series related package. There are many possibilities with great solutions. A good starting point for further material in time series with R.
  - [`lubridate` package](https://lubridate.tidyverse.org/index.html) has good documentation, worth checking.

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture17-dates-n-times/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`date_time_manipulations.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture17-dates-n-times/raw_codes/date_time_manipulations.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture17-dates-n-times/complete_codes) includes code with solution for [`date_time_manipulations.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture17-dates-n-times/raw_codes/date_time_manipulations.R) as [`date_time_manipulations_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture17-dates-n-times/complete_codes/date_time_manipulations_fin.R)

