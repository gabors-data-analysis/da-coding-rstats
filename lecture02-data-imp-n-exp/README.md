# Lecture 02: Import and Export data to R

This lecture introduces students to importing and exporting data to R with `dplyr` from `tidyverse`. Various importation technique and format is discussed and several options on how to export data to the local computer.


## Learning outcomes
After successfully completing the code in *raw_codes* students should be able to:

[`dataset_handling.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/raw_codes/dataset_handling.R)
  - Import data *csv* or other formats via 
    - clicking through the built-in options 
    - using a local path
    - download directly via internet url
    - use API, namingly: `tidyquant` and `WDI` packages.
  - Export data on *csv*, *xlsx* or *RData* format to local computer 

## Datasets used

* [Hotels Vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna)
* [Football](https://gabors-data-analysis.com/datasets/#football) as homework.


## Lecture Time

Ideal overall time: **10-20 mins**.

Showing [`dataset_handling.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/raw_codes/dataset_handling.R) takes around *10 minutes* while doing the tasks would take the rest.
 

## Homework

*Type*: quick practice, approx 10 mins

Import from OSF the [football](https://osf.io/zqm6c/) data tables. To be more precise you should import table containing manager's characteristics data (`football_managers.csv`) and football performance with teams (`football_managers_workfile.csv`). Make sure of using a tidy folder structure: create a data folder with raw and clean folders. For this time only, export the same data tables into an export folder as `xlsx` and `.RData` files.

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science: [Chapter 11](https://r4ds.had.co.nz/data-import.html) provides an overview of data import and export along with a detailed discussion of how these methods are done and how tidyverse approaches.
  - Jae Yeon Kim: R Fundamentals for Public Policy, Course material, [Lecture 02](https://github.com/KDIS-DSPPM/r-fundamentals/blob/main/lecture_notes/02_computational_reproducibility.Rmd) provides useful further guidelines on how to organize the folder structure and how to export and import data/figures/etc.


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`dataset_handling.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/raw_codes/dataset_handling.R)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/complete_codes) includes one code with solutions for
    - [`dataset_handling_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/complete_codes/dataset_handling_fin.R) solution for: [`dataset_handling.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture02-data-imp-n-exp/raw_codes/dataset_handling.R)
  - [data/hotels_vienna](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp/data/hotels_vienna) provides a folder structure for the class. It contains data that will be used during the lecture as well as folders for the outputs.
    - [clean](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp/data/hotels_vienna/clean) - this is a great example of how to organize a project's cleaned data folder.
    - [raw](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp/data/hotels_vienna/raw) - includes (a) raw files. Should save during the lecture the data on bookings of hotels as `hotelbookingdata.csv` into this folder.
    - [export](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp/data/hotels_vienna/export) - is a folder where you should export all the files during the course.
    


