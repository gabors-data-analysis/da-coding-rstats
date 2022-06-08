# Lecture 08: Conditional Programming

## Motivation

Deciding what to do on a case by case is widely used in decision making and also in programming. Conditional programming enables writing codes with this in mind. If a certain condition holds execute a command otherwise do something different. Conditional programming is an element of the basic programming technique, which emerges in multiple situations. Adding this technique to the programming toolbox is a must for data scientists.

## This lecture

This lecture introduces students to conditional programming with `if-else` statements. It covers the essentials as well as logical operations with vectors, creating new variables with conditionals and some extra material.


## Learning outcomes
After successfully live-coding the material (see: [`conditionals.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture08-conditionals/conditionals.md)), students will have knowledge on

- How a conditional statement works
- What are the crucial elements of an `if-else` statement
- Good practices writing a conditional
- How multiple conditions work
  - single-valued variables with multiple conditions
  - vector variables with conditions
- with vectors:
  - understanding the differences between `|`, `||`, `&`, `&&`, `any()` and `all()`
  - understanding pairwise comparison of vectors
  - understanding different levels of evaluation of logical operators.
- creating new variable with conditional
  - base R method with logicals
  - `ifelse()` function with `tidyverse`  
- extra material
  - conditional installation of packages
  - spacing and formatting the `if-else` statements
  - `xor` function
  - `switch` statement 

## Datasets used

- [wms-management](https://gabors-data-analysis.com/datasets/#wms-management-survey)

## Lecture Time

Ideal overall time: **10-20 mins**.

This is a relatively short lecture, and it can be even shorter if logical operators with vectors is neglected. Although good understanding of the anatomy of an `if-else` statement is important

## Homework

*Type*: quick practice, approx 15 mins, together with [lecture09-loops](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture09-loops), [lecture10-random-numbers](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture10-random-numbers), and [lecture11-functions](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture11-functions).

Check the common homework [here](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture11-functions/README.md).

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 19.4](https://r4ds.had.co.nz/functions.html) provides further material on conditionals.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 10](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/10_functional_programming.Rmd) provides useful guidelines on conditionals along with other programming skills.


## File structure
  
  - [`conditionals.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture08-conditionals/conditionals.md) provides material for the live coding session with explanations.
  - [`conditionals.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture08-conditionals/conditionals.Rmd) is the generating Rmarkdown file for `conditionals.md`
  - [`conditionals.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture08-conditionals/conditionals.R) is a possible realization of the live coding session
