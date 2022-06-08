# Lecture 00: Introduction to R and RStudio

## Motivation

In this course, we focus on R and its IDE: RStudio. This means, you won’t learn anything about Python, Julia, or any other programming language useful for data science. They’re also excellent choices, and in practice, most data science teams use a mix of languages, often at least R and Python.

We also believe that R is a great place to start your data science carrier as it is an environment designed from the ground up to support data science. R is not just a programming language, but it is also an interactive environment for doing data science. To support interaction, R is a much more flexible language than many of its peers. This flexibility comes with its downsides, but the big upside is how easy it is to evolve tailored grammars for specific parts of the data science process. These mini languages help you think about problems as a data scientist, while supporting fluent interaction between your brain and the computer. ([Hadley Wickham and Garrett Grolemund R for Data Science](https://r4ds.had.co.nz/introduction.html))

## This lecture

This is the starting lecture, that introduces students to R and RStudio (download and install), runs a pre-written script, asks them to knit a pdf/Html document, and highlights the importance of version control.

The aim of this class is not to teach coding, but to make sure that everybody has R and RStudio on their laptop, installs `tidyverse` package, and (tries to) knit an RMarkdown document. The main aim of these steps is to reveal possible OS mismatches or other problems with R and RStudio. 
The material and steps are detailed in [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md).


## Learning outcomes
After successfully teaching the material (see: [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md)), students will have

- R and RStudio on their laptop/computers

and understand,

- How RStudio looks like, which window is which.
- How to run a command via console.
- What are libraries (packages), and how to install and load them.
- Why version control is important and what are the main possibilities with Git and GitHub.

Furthermore, students will,

- knit a Rmarkdown in both *pdf* and *Html*, without any deeper knowledge on the issue.

These steps are found to be extremely important, as fixing installation and knitting problems may take days to weeks.

## Datasets used
* No dataset is used in this lecture

## Lecture Time

Ideal overall time: **20-30 mins**.

It can substantially differ from this if the teacher decides to do a live coding session with students and fixes the emerging problems during the class (up to ~90 mins).

## Homework

No homework, apart from fixing possible issues with R, RStudio, and compiling a '.Rmd' in Html and pdf.

## Further material

  - Hadley Wickham and Garrett Grolemund R for Data Science [Chapter 1](https://r4ds.had.co.nz/introduction.html) on introduction, [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) on libraries, [Chapter 6](https://r4ds.had.co.nz/workflow-scripts.html) on windows and workflow. 
  - Kieran H. (2019): Data Visualization [Chapter 2.2](https://socviz.co/gettingstarted.html#use-r-with-rstudio) introduces window structure in RStudio pretty well.
  - Andrew Heiss: Data Visualization with R, [Lesson 1](https://datavizs21.classes.andrewheiss.com/lesson/01-lesson/) provides some great videos and an introduction to R and Rmarkdown.
  - Git references: 
    - [Technical foundations of informatics book](https://info201.github.io/git-basics.html)
    - [Software carpentry course](https://swcarpentry.github.io/git-novice/)  (Strongly recommended)
    - [Github Learning Lab](https://lab.github.com/)
    - [If you are really committed](https://git-scm.com/book/en/v2) (pun intended)


## File structure
  
  - [`getting_started.md`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.md) provides material on the installation of R and RStudio, tidyverse and show some cool stuff with R.
  - [`getting_started.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/getting_started.Rmd) is the generating Rmarkdown file for `getting_started.md`
  - [`intro_to_R.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/intro_to_R.R) includes codes to introduce scripts, install `tidyverse`, and show how cool R is.
  - [`test_Rmarkdown.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture00-intro/test_Rmarkdown.Rmd) is a test file to reveal possible issues with knitting a Rmarkdown document. During the course, students need to be able to compile their work into pdf and/or Html. This is a test, which is super important to do as quickly as possible, while some fixes take a while...

## Help with RMarkdown and RStudio with git

In case you have trouble with the knitting of a Rmarkdown document or connecting your GitHub to RStudio, I have collected the major solutions, which may help in [**common_issues**](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/common_issues) folder.

  - For RMarkdown: [help_rmarkdown.md](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/common_issues/help_rmarkdown.md) file.
  - For GitHub: [help_github_n_Rstudio.md](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/common_issues/help_github_n_Rstudio.md) file.
