# Lecture 12: Introduction to regression

## Motivation

You want to identify hotels in a city that are good deals: underpriced for their location and quality. You have scraped the web for data on all hotels in the city, and you have cleaned the data. You have carried out exploratory data analysis that revealed that hotels closer to the city center tend to be more expensive, but there is a lot of variation in prices between hotels at the same distance. How should you identify hotels that are underpriced relative to their distance to the city center? In particular, how should you capture the average price–distance relationship that would provide you a benchmark, to which you can compare actual prices to find good deals?

The analysis of hotel prices and distance to the city center reveals that hotels further away from the center are less expensive by a certain amount, on average. Can you use this result to estimate how much more revenue a hotel developer could expect if it were to build a hotel closer to the center rather than farther away? Regression is a model for the conditional mean: the mean of y for different values of one or more x variables. Regression is used to uncover patterns of association. That, in turn, is used in the causal analysis, to uncover the effect of x on y, and in predictions, to arrive at a good guess of what the value of y is if we don’t know it, but we know the value of x.

In this lecture, we introduce simple non-parametric regression and simple linear regression, and we show how to visualize their results. We then discuss simple linear regression in detail. We introduce the regression equation, how its coefficients are uncovered (estimated) in actual data, and we emphasize how to interpret the coefficients. We introduce the concepts of predicted value and residual and goodness of fit, and we discuss the relationship between regression and correlation.

## This lecture

This lecture introduces regressions via [hotels-vienna dataset](https://gabors-data-analysis.com/datasets/#hotels-vienna). It overviews models based on simple binary means, binscatters, lowess nonparametric regression, and introduces simple linear regression techniques. The lecture illustrates the use of predicted values and regression residuals with linear regression, but as homework, the same exercise is repeated with a binscatter-based model.

This lecture is based on [Chapter 07, A: *Finding a good deal among hotels with simple regression*](https://gabors-data-analysis.com/casestudies/#ch07a-finding-a-good-deal-among-hotels-with-simple-regression)

## Learning outcomes
After successfully completing [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/raw_codes/hotels_intro_to_regression.R) students should be able:

  - Binary means:
    - Calculate prediction based on means of two categories and create an annotated graph
  - Binscatter:
    - Create means based on differently defined bins for the X variable
    - Show two different graphs: simple mean predictions for each bins as a dot and scatter with step functions
  - Lowess nonparametric regression:
    - How to create a lowess (loess) graph
    - What is an output of a loess model? What are the main advantages and disadvantages?
  - Simple linear regression
    - How to create a simple linear regression line in a scatterplot
    - The classical `lm` command and its limitation
    - `feols` package: estimate two models w and w/o heteroscedastic robust SE and compare the two model
    - Have an idea about `estimatr` package and `lm_robust` command
    - How to get predicted values and errors of predictions
    - Get the best and worst deals: identify hotels with the smallest/largest errors
    - Visualize the errors via histogram and scatter plot with annotating the best and worst 5 deals.

## Dataset used

- [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna)

## Lecture Time

Ideal overall time: **60 mins**.

Going through [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/raw_codes/hotels_intro_to_regression.R) takes around *45-50 minutes*, the rests are the tasks. It builds on [lecture07-ggplot-indepth](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth) as it requires building a boxplot. Can be skipped.


## Homework

*Type*: quick practice, approx 15 mins

Use the binscatter model with 7 bins and save the predicted values and errors (true price minus the predicted value). Find the best and worst 10 deals and visualize with a scatterplot, highlighting the under/overpriced hotels with these best/worst deals according to this model. Compare to the simple linear regression. Which model would you use? Argue!


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch07-hotels-simple-reg](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch07-hotels-simple-reg)
  - On ggplot, see Chapter 3.5-6 and Chapter 5.6 [Kieran H. (2019): Data Visualization](https://socviz.co/makeplot.html#mapping-aesthetics-vs-setting-them) or [Winston C. (2022): R Graphics Cookbook, Chapter 5](https://r-graphics.org/chapter-scatter)
  - On regression [Grant McDermott: Data Science for Economists, Course material Lecture 08](https://github.com/uo-ec607/lectures/tree/master/08-regression) provides a somewhat different approach, but can be a nice supplement


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture12-intro-to-regression/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/raw_codes/hotels_intro_to_regression.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture12-intro-to-regression/complete_codes) includes code with solution for [`hotels_intro_to_regression.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/raw_codes/hotels_intro_to_regression.R) as [`hotels_intro_to_regression_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture12-intro-to-regression/complete_codes/hotels_intro_to_regression_fin.R)

