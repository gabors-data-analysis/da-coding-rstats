# Lecture 09: Writing Functions
*Coding course to complete Data Analysis in R*

This lecture introduces students to imperative programming with `for` and `while` loops. 


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

## Lecture Time

Ideal overall time: **20-30 mins**.

This is a relatively short lecture, and it can be even shorter if less emphasis is put on output and input controlling and error-handling.

## Homework

*Type*: quick practice, approx 15 mins, together with [lecture08-conditionals](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture08-conditionals), [lecture09-loops](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture09-loops), and [lecture10-random_numbers](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture10-random_numbers)

Bootstrapping - using the [`sp500`](https://gabors-data-analysis.com/datasets/#sp500) data

  - download the cleaned data for `sp500` from [OSF](https://osf.io/h64z2/)
  - write a function, which calculates the bootstrap standard errors and confidence intervals based on these standard errors.
    - function should have an input for a) vector of prices, b) number of bootstraps, c) level for the confidence interval
  - create a new variable for `sp500`: `daily_return`, which is the difference in the prices from one day to the next day.
  - use this `daily_return` variable and calculate the 80% confidence interval based on bootstrap standard errors along with the mean.


## Further material

  - Hadley Wickham and Garrett Grolemund: R for Data Science [Chapter 19](https://r4ds.had.co.nz/functions.html) provide further material on functions with exercises.
  - Grant McDermott: Data Science for Economists - [Lecture 10](https://github.com/uo-ec607/lectures/blob/master/10-funcs-intro/10-funcs-intro.md) is a great alternative to introduce functions.
  - Roger D. Peng, Sean Kross, and Brooke Anderson: Mastering Software Development in R, [Chapter 2](https://bookdown.org/rdpeng/RProgDA/advanced-r-programming.html) is a great place to start deepening programming skills.
  - Hadley Wickham: [Advanced R](http://adv-r.had.co.nz/Introduction.html) is also a great place to start hard-core programming in R.


## File structure
  
  - [`functions.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.md) provides material for the live coding session with explanations.
  - [`functions.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.Rmd) is the generating Rmarkdown file for `functions.md`
  - **[`functions.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/functions.R)** is a possible realization of the live coding session
