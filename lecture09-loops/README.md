# Lecture 09: Programming loops

## Motivation

There are many cases when one needs to do repetitive coding: carry out the same commands but on a different object/data. Writing loops is one of the best tools to carry out such repetition with only a few modifications to the codes. It also reduces the code duplication, which has three main benefits:

  1. It’s easier to see the intent of your code because your eyes are drawn to what’s different, not what stays the same.
  2. It’s easier to respond to changes in requirements. As your needs change, you only need to make changes in one place, rather than remembering to change every place that you copied and pasted the code.
  3. You’re likely to have fewer bugs because each line of code is used in more places.

*([Hadley Wickham and Garrett Grolemund R for Data Science Ch. 21.1](https://r4ds.had.co.nz/iteration.html))*


## This lecture

This lecture introduces students to imperative programming with `for` and `while` loops. Furthermore, it provides an exercise with [sp500](https://gabors-data-analysis.com/datasets/#sp500) dataset to calculate yearly and monthly returns.

[Chapter 05, A: What likelihood of loss to expect on a stock portfolio?](https://gabors-data-analysis.com/casestudies/#ch05a-what-likelihood-of-loss-to-expect-on-a-stock-portfolio) case study was a starting point to develop the exercise.


## Learning outcomes
After successfully live-coding the material (see: [`loops.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops/loops.md)), students will know

- What is imperative programming and what is functional programming for iterations
- What is a for loop
  - what are the possible inputs for an iteration vector
  - how to measure CPU time
  - what are the possible issues with the for-loop
- What is a while loop
  - what are the possible drawbacks of a while loop
  - how to use a for loop instead
  - `break` command
- Calculate returns with different time periods.   

## Datasets used

- [sp500](https://gabors-data-analysis.com/datasets/#sp500)

## Lecture Time

Ideal overall time: **10-20 mins**.

This is a relatively short lecture, and it can be even shorter if measuring CPU time and/or exercise is/are neglected.

## Homework

*Type*: quick practice, approx 15 mins, together with [lecture08-conditionals](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture08-conditionals), [lecture10-random-numbers](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture10-random-numbers), and [lecture11-functions](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture11-functions).

Check the common homework [here](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/README.md).

## Further material
  
  - More materials on the case study can be found in Gabor's da_case_studies repository: [ch05-stock-market-loss-generalize](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch05-stock-market-loss-generalize)
  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 21](https://r4ds.had.co.nz/iteration.html) provide further material on iterations, both imperative and functional programming.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 10](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/10_functional_programming.Rmd) provides useful guidelines on iterations along with other programming skills.


## File structure
  
  - [`loops.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops/loops.md) provides material for the live coding session with explanations.
  - [`loops.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops/loops.Rmd) is the generating Rmarkdown file for `loops.md`
  - [`loops.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops/loops.R) is a possible realization of the live coding session
