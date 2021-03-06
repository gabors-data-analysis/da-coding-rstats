# Lecture 19: Advanced RMarkdown

## Motivation

There is a substantial difference in the average earnings of women and men in all countries. You want to understand, analyze and present more about the potential origins of that difference, focusing on employees with a graduate degree in your country. You have data on a large sample of employees with a graduate degree, with their earnings and some of their characteristics, such as age and the kind of graduate degree they have. Women and men differ in those characteristics, which may affect their earnings. How should you use this data to uncover gender differences that are not due to differences in those other characteristics? And can you use regression analysis to uncover patterns of associations between earnings and those other characteristics that may help understand the origins of gender differences in earnings? How should you present your results in a conscious, way that is easy to update as well? How to format your report in a compact and easy-to-read way?

## This lecture

This lecture shows the tricks and tips on how to write and format a complete report for data analysis, using the [cps-earnings](https://gabors-data-analysis.com/datasets/#cps-earnings) dataset in RMarkdown. Using RMarkdown in our experience is one of the most challenging and time-consuming parts of the work when creating a complete data analysis. This lecture uses a script file to prepare the analysis on the topic (see [`advanced_rmarkdown_prep.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown_prep.R) ) and when the main results and messages are crystallized, we propose to create an `.Rmd` file to present and communicate the results.
During this lecture, students will learn, what is the general structure of a data analysis report, and how to format figures and tables to efficiently communicate the results.

This lecture is based on [Chapter 10, A: Understanding the gender difference in earnings](https://gabors-data-analysis.com/casestudies/#ch10a-understanding-the-gender-difference-in-earnings).

As an [extra](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture19-advaced-rmarkdown/extra), this lecture contains an additional example for causal analysis. We investigate fourth-graders in Massachusetts public schools in the spring of 1998. We estimate the effect of the student per teacher ratio on the (averaged) test results of the fourth graders.

## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

[`advanced_rmarkdown.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown.Rmd)
  - General understanding of the structure of a data analysis report
  - Naming code chunks and why is it beneficial (jumping, referencing, etc)
  - Set options for 
    - general formatting in the output document
    - for each chunks
    - store data in `cache`
    - use multi-line setting for a chunk of code
  - Formatting figures:
    - Set size of the figure (`fig.width`, `fig.height`, `fig.extra`, `fig.aligned`)
    - Caption (`fig.cap`), labeling and referencing a figure
    - Change the figure's resolution, knitted size, or use a random sample to reduce the size of the output document
  - Format descriptive tables (`datasummary`):
    - Rename variables
    - Caption, labeling, and referencing a `datasummary` table
    - `kable_styling` to hold position, set to page width, or set the font size 
  - Format model comparison tables (`etable`):
    - `drop` or `keep` variables that are reported
    - Create groups with `group` argument, to create multiple controls in different groups
    - Rename variables with `dict` argument (even if `drop` or `keep` is used)
    - Set the reported digits, align the standard errors 
    - Set the reported summary statistics
    - Rename models and hide dependent variable
    - Caption, labeling, and referencing a `datasummary` table
    - `kable_styling` to hold position, set to page width, or set the font size
 - Formatting inline text:
    - Equations
    - Greek letters 
    - Hypothesis testing briefly
 - Organizing appendix

## Lecture Time

Ideal overall time: **100 mins**.

Going through [`advanced_rmarkdown.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown.Rmd) takes around *70-90 minutes* as there are many discussions of different coding styles. Solving the tasks takes the remaining *10-30 minutes*.


## Homework

*Type*: quick practice, approx 20-30 mins

Create a pdf, generated by an RMarkdown, where you replicate (but report better!) the tables and figures of [hotels_analysis.pdf](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/hotels_analysis.pdf). You can use the codes from [lecture15-advanced_linear_regression](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture15-advanced-linear-regression). You do not need to have an exact match in the tables, that is not the aim of this homework, but to practice formatting and reporting in RMarkdown. Improve on the [hotels_analysis.pdf](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/hotels_analysis.pdf) with a unified presentation of tables and graphs. Pay attention to colors, axis, alignment, variable names, caption, etc.


## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch10-gender-earnings-understand](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch10-gender-earnings-understand)
  - Hadley Wickham and Garrett Grolemund: R for Data Science: [Chapter 27](https://r4ds.had.co.nz/r-markdown.html) reviews the basics of RMarkdown such as chunks, general setup, problem-solving, and citation. [Chapter 29](https://r4ds.had.co.nz/r-markdown-formats.html) shows different types of outputs, that are not covered in this lecture but can be handy.
  - [Yihui Xie, Christophe Dervieux, Emily Riederer: R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) is a detailed book on all RMarkdown topics and issues.
  - Great ideas and further tips for RMarkdown can be found in the [blog of RStudio](https://www.rstudio.com/blog/) (also worth checking other posts), especially [tips-1](https://www.rstudio.com/blog/r-markdown-tips-tricks-1-rstudio-ide/), [tips-2](https://www.rstudio.com/blog/r-markdown-tips-tricks-2-cleaning-up-your-code/), and [tips-3](https://www.rstudio.com/blog/r-markdown-tips-and-tricks-3-time-savers/).

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture19-advaced-rmarkdown/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`advanced_rmarkdown_prep.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown_prep.R) shows the prepared analysis in a script.
    - [`advanced_rmarkdown.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown.Rmd) is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/edit/main/lecture19-advaced-rmarkdown/complete_codes) includes 
    - code with solution for [`advanced_rmarkdown.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown.Rmd) as [`advanced_rmarkdown_fin.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/complete_codes/advanced_rmarkdown_fin.Rmd)
    - [`advanced_rmarkdown_fin.pdf`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/complete_codes/advanced_rmarkdown_fin.pdf) is the produced pdf file
    - auxillary files to knit pdf: [`advanced_rmarkdown_fin.log`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/complete_codes/advanced_rmarkdown_fin.log) as the log file and folder [advanced_rmarkdown_fin_files/figure-latex](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture19-advaced-rmarkdown/complete_codes/advanced_rmarkdown_fin_files/figure-latex) includes figures and others.
  - [extra](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture19-advaced-rmarkdown/extra) contains extra material on MA schools. Note it is not as developed as [`advanced_rmarkdown_prep.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/raw_codes/advanced_rmarkdown_prep.R), but useful to see another example.
    - [`maschools_prep.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/extra/maschools_prep.R) is the analysis for MA schools in a script format.
    - [`maschools_report.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture19-advaced-rmarkdown/extra/maschools_report.Rmd) is the RMarkdown report on the topic.

