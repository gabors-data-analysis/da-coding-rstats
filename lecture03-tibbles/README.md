# Lecture 03: Tibbles

This lecture introduces `tibble`-s as the 'Data' variable in `tidyverse`. It shows multiple column and row manipulations with one `tibble` as well as how to merge two `tibble`s. It uses pre-written codes with tasks during the class.

Data merging is based on [Chapter 02, C: Identifying successful football managers](https://gabors-data-analysis.com/casestudies/#ch02c-identifying-successful-football-managers).


## Learning outcomes
After successfully completing codes in [`intro_to_tibbles.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/raw_codes/intro_to_tibbles.R) students should be able:

  - understand what is a 'Data' variable, why to use tibble and how it relates to `data_frame` and `data.frame`
  - How to do indexing with a tibble
    - indexing with integer numbers
    - indexing with logicals
    - when to use which and what are the connections
  - How to use simple functions with tibbles
    - `sum`, `mean`, `sd`, `add_column`, `select`, `add_row` 
  - How to:
    - reset a cell's value in a tibble
    - add or remove a column (or variable)
    - add or remove a row (or an observation)
  - Wide vs long format and how to convert one to another
    - `pivot_wider` and `pivot_longer` functions
  - Merging - different ways to merge two tibbles:
    - new/other rows/observations are in the new tibble
    - new/other columns/variables are in the new tibble  
    - difference between: `left_join`, `right_join`, `full_join` and `inner_join`
    - importance of the identifier variables and cases for non-unique identifications
    - `all_equal` to compare tibbles
    - extra: `semi_join` and `anti_join`

## Datasets used

  - [Football](https://gabors-data-analysis.com/datasets/#football)

## Lecture Time

Ideal overall time: **30-40 mins**.

Showing [`intro_to_tibbles.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/raw_codes/intro_to_tibbles.R) takes around *20-25 minutes*, while doing the tasks would take the rest.
 

## Homework

*Type*: quick practice, approx 15 mins

Use the created tibble from class (called `df`) and create two new tibble -- call it `df_2` and `df_3` -- with the following values:

`df_2`:

| id | age | grade | gender |
| -- | --- | ----- | ------ |
| 10 |  16 |  C    |    F   |
| 11 |  40 |  A    |    F   |
| 12 |  52 |  B-   |    M   | 
| 13 |  24 |  C+   |    M   |
| 14 |  28 |  B+   |    M   |
| 15 |  26 |  A-   |    F   |

`df_3`:

| id | height |
| -- | ------ |
|  1 | 165 |
| 3  | 200 |
| 5  | 187 |
| 10 | 175 |
| 12 | 170 |

Do the following manipulations:

 - add `df_2` to `df`  and call the new merged tibble as `df_m`
 - merge `df_3` to `df_m` such that you have *all kind of id* values (adding missing values), call it `df_m2`
 - merge `df_3` to `df_m` such that you have only such id-s that there are no missing values, call it `df_m3`
 - create a wide format from `df_m2` with names from grades and values from age (not really meaningful, but good practice)


## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science: [Chapter 12](https://r4ds.had.co.nz/tidy-data.html) introduces to tidy approach and works with tibble. [Chapter 13](https://r4ds.had.co.nz/relational-data.html) provides a detailed discussion on merging.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 05](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/05_tidy_data.Rmd) provides useful further guidelines on tidy approach and merging.
  - Another interesting material on this topic is by [Hansjörg Neth: Data Science for Psychologists](https://bookdown.org/hneth/ds4psy/), especially [Chapter 7.2](https://bookdown.org/hneth/ds4psy/7-2-tidy-essentials.html) on wide vs long format and [Chapter 8](https://bookdown.org/hneth/ds4psy/8-join.html) on merging.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`intro_to_tibbles.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/raw_codes/intro_to_tibbles.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/complete_codes) includes one code with solutions for
    - [`intro_to_tibbles_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/complete_codes/intro_to_tibbles_fin.R) solution for: [`intro_to_tibbles.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture03-tibbles/raw_codes/intro_to_tibbles.R)
    


