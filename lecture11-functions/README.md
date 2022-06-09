# Lecture 11: Writing Functions

## Motivation

One of the best ways to improve your reach as a data scientist is to write functions. Functions allow automating common tasks in a more powerful and general way than copy-and-pasting. Writing a function has three big advantages over using copy-and-paste:

1. You can give a function an evocative name that makes your code easier to understand.
2. As requirements change, you only need to update code in one place, instead of many.
3. You eliminate the chance of making incidental mistakes when you copy and paste (i.e. updating a variable name in one place, but not in another).

Writing good functions is a lifetime journey. Even after using R for many years, one can still learn new techniques and better ways of approaching old problems. The goal is not to teach you every esoteric detail of functions but to get you started with some pragmatic advice that you can apply immediately. ([Hadley Wickham and Garrett Grolemund: R for Data Science, Ch. 19](https://r4ds.had.co.nz/functions.html))

## This lecture

This lecture introduces functions, how they are structured and how to write them. Students will know how to write basic functions, control for input(s) and output(s), and error-handling.

Case studies related to lecture:
  - [Chapter 05, A: What likelihood of loss to expect on a stock portfolio?](https://gabors-data-analysis.com/casestudies/#ch05a-what-likelihood-of-loss-to-expect-on-a-stock-portfolio) as homework to calculate bootstrap standard errors and calculate confidence intervals.
  - [Chapter 06, A: Comparing online and offline prices: testing the difference](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference) and [Chapter 06, B: Testing the likelihood of loss on a stock portfolio](https://gabors-data-analysis.com/casestudies/#ch06b-testing-the-likelihood-of-loss-on-a-stock-portfolio) as at the end of the lecture we build a function to show the distribution of t-statistics.

In addition to writing functions, it uses data from the case study [Chapter 04, A: Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association).


## Learning outcomes
After successfully live-coding the material (see: [`functions.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.md)), students will know on

- What is the structure of a function
- Out of the function
  - simple output
  - controlling for the output with `return`
  - multiple outputs with lists
- Controlling for the input
  - `stopifnot` function
  - other methods and error-handling in general
  - pre-set inputs
- Exercise for the sampling distribution of the t-statistics, to use:
  - conditionals
  - loops
  - random numbers and random sampling
  - writing a function

## Datasets used

  - [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey)
  - [sp500](https://gabors-data-analysis.com/datasets/#sp500) as homework.

## Lecture Time

Ideal overall time: **20-30 mins**.

This is a relatively short lecture, and it can be even shorter if less emphasis is put on output and input controlling and error-handling.

## Homework

*Type*: quick practice, approx 15 mins, together with [lecture08-conditionals](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture08-conditionals), [lecture09-loops](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture09-loops), and [lecture10-random-numbers](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture10-random-numbers)

Bootstrapping - using the [`sp500`](https://gabors-data-analysis.com/datasets/#sp500) data

  - download the cleaned data for `sp500` from [OSF](https://osf.io/h64z2/)
  - write a function, which calculates the bootstrap standard errors and confidence intervals based on these standard errors.
    - function should have an input for a) vector of prices, b) number of bootstraps, c) level for the confidence interval
  - create a new variable for `sp500`: `daily_return`, which is the difference in the prices from one day to the next day.
  - use this `daily_return` variable and calculate the 80% confidence interval based on bootstrap standard errors along with the mean.


## Further material

  - Case study materials from Gabor's da_case_studies repository on generalization (with bootstrapping) is: [ch05-stock-market-loss-generalize](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch05-stock-market-loss-generalize) on testing are: [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) and [ch06-stock-market-loss-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-stock-market-loss-test)
  - Hadley Wickham and Garrett Grolemund: R for Data Science [Chapter 19](https://r4ds.had.co.nz/functions.html) provide further material on functions with exercises.
  - Grant McDermott: Data Science for Economists - [Lecture 10](https://github.com/uo-ec607/lectures/blob/master/10-funcs-intro/10-funcs-intro.md) is a great alternative to introduce functions.
  - Roger D. Peng, Sean Kross, and Brooke Anderson: Mastering Software Development in R, [Chapter 2](https://bookdown.org/rdpeng/RProgDA/advanced-r-programming.html) is a great place to start deepening programming skills.
  - Hadley Wickham: [Advanced R](http://adv-r.had.co.nz/Introduction.html) is also a great place to start hard-core programming in R.


## File structure
  
  - [`functions.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.md) provides material for the live coding session with explanations.
  - [`functions.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.Rmd) is the generating Rmarkdown file for [`functions.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.md)
  - [`functions.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.R) is a possible realization of the live coding session
