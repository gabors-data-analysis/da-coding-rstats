# Lecture 04: Data Munging with dplyr

This lecture introduces students to how to manipulate raw data in various ways with `dplyr` from `tidyverse`.

This lecture is based on [Chapter 02, A: Finding a good deal among hotels: data preparation](https://gabors-data-analysis.com/casestudies/#ch02a-finding-a-good-deal-among-hotels-data-preparation).


## Learning outcomes
After successfully completing [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R), students should be able to:

  - Add variables
  - Separate a character variable into two (or more) variables with `separate`
  - Convert different type of variables to specific types:
    - character to numeric
    - character to factor -> understanding `factor` variable type
  - Further string manipulations (`gsub` and string expressions)
  - Rename variables with `rename`
  - Filter out different observations with `filter`
    - select observations with specific values
    - tabulate different values of a variable with `table`
    - filter out missing values
    - replace specific values with others
    - handle duplicates with `duplicated`
  - use pipes `%>%` to do multiple manipulations at once
  - sort data ascending or descending according to a specific variable with `arrange`

## Datasets used
* [Hotels Europe](https://gabors-data-analysis.com/datasets/#hotels-europe)


## Lecture Time

Ideal overall time: **40-60 mins**.

Showing [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)takes around *30 minutes* while doing the tasks would take the rest.
 

## Homework

*Type*: quick practice, approx 10 mins

Use the same [hotel-europe data from OSF](https://osf.io/r6uqb/), but now 
  - Download both `hotels-europe_price.csv` and `hotels-europe_features.csv`
  - `left_join` them in this order by `hotel_id`
  - filter for :
    - time: 2018/01 and weekend == 1
    - city: Vienna or London. Hint: for multiple matches, use something like: 
    ```r 
    city %in% c('City_A','City_B')
    ``` 
    - accommodation should be Apartment, 3-4 stars (only) with more than 10 reviews
    - price is less than 600$
 - arrange the data in ascending order by price

## Further material

  - More materials on the case study can be found in Gabor's [da_case_studies repository](https://github.com/gabors-data-analysis/da_case_studies): [ch02-hotels-data-prep](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch02-hotels-data-prep/ch02-hotels-data-prep.R)
  - Hadley Wickham and Garrett Grolemund R for Data Science: [Chapter 5](https://r4ds.had.co.nz/transform.html) provides an overview of the type of variables, selecting, filtering, and arranging along with others. [Chapter 15](https://r4ds.had.co.nz/factors.html) provides further material on factors. [Chapter 18](https://r4ds.had.co.nz/pipes.html) discusses pipes in various applications.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 3](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/03_1d_data.Rmd) is relevant for factors, but includes many more. [Lecture 6](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/06_slicing_dicing.Rmd) introduces similar manipulations with tibble.
  - Grant McDermott: Data Science for Economists, Course material, [Lecture 5](https://github.com/uo-ec607/lectures/blob/master/05-tidyverse/05-tidyverse.pdf) is a nice overview on tidyverse with easy data manipulations.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/complete_codes) includes one code with solutions for
    - [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture04-data-munging/complete_codes/data_munging_fin.R) solution for: [`data_munging.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture04-data-munging/raw_codes/data_munging.R)
