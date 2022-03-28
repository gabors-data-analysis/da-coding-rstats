# Lecture 00: Getting started with R
*Coding course to complete Data Analysis in R*

This is the starting lecture, that introduces students to R and RStudio (download and install), runs a pre-written script and tries to knit a pdf/html document.
It is an introductory course with pre-written codes. The teaching material is detailed in [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md).


## Learning outcomes
After successfully teaching the material (see: [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md)), students will have

- R and RStudio on their laptop/computers

and understand,

- How RStudio works and which window is which.
- How to run a command via console.
- What are libraries, how to install them and load.

and make sure that they can:

- knit an Rmarkdown in both *pdf* and *html*, without any deeper knowledge on the issue.

This is extremly important, as fixing knitting problem may take weeks and the first large assignment is expected to be written in Rmarkdown.

## Lecture Time

Ideal overall time: **30 mins**.

It can substantially differ from this, if teacher decides to run all codes together with students (up to ~90 mins).

## Homework

No homework, apart from fixing possible issues with R, RStudio and compiling an .Rmd in html and in pdf.

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) on libraries, [Chapter 6](https://r4ds.had.co.nz/workflow-scripts.html) on windows and workflow.
  - Kieran H. (2019): Data Visualization [Chapter 2.2](https://socviz.co/gettingstarted.html#use-r-with-rstudio) introduces window structure in RStudio pretty well


## File structure
  
  - [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md) provides material for the live coding session with explanations.
  - [`getting_started.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.Rmd) is the generating Rmarkdown file for `getting_started.md`
  - [`intro_to_R.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture01-intro/intro_to_R.R) includes codes to introduce scripts, install `tidyverse`, and show how cool R is.
  - [`test_Rmarkdown.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture01-intro/test_Rmarkdown.Rmd) is a test file to reveal possible issues with knitting a Rmarkdown document. During the course students needs to be able to compile their work into pdf and/or html. This is a test, which is super important to do as quickly as possible, while some fixes takes a while...
