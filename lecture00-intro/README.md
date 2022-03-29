# Lecture 00: Introduction to R and RStudio
*Coding course to complete Data Analysis in R*

This is the starting lecture, that introduces students to R and RStudio (download and install), runs a pre-written script, and asks them to knit a pdf/html document.
It is an introductory lecture with pre-written codes. The aim of this class is not to teach coding, but to make sure that everybody has R and RStudio on her/his laptop, install `tidyverse` package, and knit an RMarkdown document. The main aim of these steps is to reveal possible OS mismatches or other problems with working in R. 
The material and steps are detailed in [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md).


## Learning outcomes
After successfully teaching the material (see: [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md)), students will have

- R and RStudio on their laptop/computers

and understand,

- How RStudio looks like, which window is which.
- How to run a command via console.
- What are libraries and how to install and load them.

Furthermore, students will,

- knit an Rmarkdown in both *pdf* and *html*, without any deeper knowledge on the issue.

These steps are found to be extremely important, as fixing installation and knitting problems may take days to weeks.

## Lecture Time

Ideal overall time: **30 mins**.

It can substantially differ from this if the teacher decides to run all codes together with students (up to ~90 mins) or even do a live coding session.

## Homework

No homework, apart from fixing possible issues with R, RStudio, and compiling an '.Rmd' in html and pdf.

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) on libraries, [Chapter 6](https://r4ds.had.co.nz/workflow-scripts.html) on windows and workflow.
  - Kieran H. (2019): Data Visualization [Chapter 2.2](https://socviz.co/gettingstarted.html#use-r-with-rstudio) introduces window structure in RStudio pretty well


## File structure
  
  - [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md) provides material on the installation of R and RStudio, tidyverse and show some cool stuff with R.
  - [`getting_started.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.Rmd) is the generating Rmarkdown file for `getting_started.md`
  - [`intro_to_R.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture01-intro/intro_to_R.R) includes codes to introduce scripts, install `tidyverse`, and show how cool R is.
  - [`test_Rmarkdown.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture01-intro/test_Rmarkdown.Rmd) is a test file to reveal possible issues with knitting a Rmarkdown document. During the course, students need to be able to compile their work into pdf and/or html. This is a test, which is super important to do as quickly as possible, while some fixes take a while...

In case you have trouble with the knitting of a Rmarkdown document, I have collected the major solutions, which may help in **common_issues** folder's [help_rmarkdown.md](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/common_issues/help_rmarkdown.md) file.
