# Lecture 06: Introduction to RMarkdown

This lecture introduces students to *RMarkdown*, which is a great tool to create reports in pdf or Html. The aim of this session is to prepare students to create a simple report in pdf or Html on a descriptive analysis. This lecture uses exploratory analysis of [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration) and put it into an RMarkdown document.

Case studies connected to this lecture are similar to [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration), but this lecture focuses on how to create a report and does not cover patterns of associations.
  - [Chapter 03, A: Finding a good deal among hotels: data exploration](https://gabors-data-analysis.com/casestudies/#ch03a-finding-a-good-deal-among-hotels-data-exploration) - emphasis on one variable descriptive analysis, different data
  - [Chapter 06, A: Comparing online and offline prices: testing the difference](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference) - focuses on hypothesis testing, association and one variable descriptive is not emphasized.


## Learning outcomes
After completing [`report_bpp.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/raw_codes/report_bpp.Rmd) students should be able to:

  - Knit Rmd documents into Html and pdf
  - Understanding the structure of an RMarkdown file: 
    - YAML header, chunks of (R) codes surronded by ``` and text mixes with simple formatting
  - Header of chunks of R codes:
    - Use general commands, such as `include`, `echo`, `warning` or `eval`
  - Text formatting:
    - sections and sub-sections 
    - bulleted, numbered and nested lists
    - bold and italic
    - add plain and embedded url
    - in-line reported code values
    - simple greek letters 
    - color text (in pdf)
 - Reporting descriptive statistics with `modelsummary` and `kableExtra` packages
    - rename the reported variable names 
    - add caption and notes
    - set position of the table with `kable_styling()`
 - `kable` to report a `tibble`
    - add column (or row) names
    - add caption 
    - report in pdf with setting position and convert format theme
    - report in Html with setting position, and change format theme
 - Report a `ggplot2` object
    - set size of the plot with `fig.width` and `fig.height`
    - align the plot with `fig.align` and `fig.pos` with `float` package in YAML
    - add caption
    - set plot labels, theme etc to fit the formatting

## Datasets used
* [Billion Prices](https://gabors-data-analysis.com/datasets/#billion-prices)


## Lecture Time

Ideal overall time: **20-40mins**.

Showing [`report_bpp.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/raw_codes/report_bpp.Rmd) takes around *20-30 minutes* while doing the tasks would take the rest.

Issues with RMarkdown knitting should be resolved by now.
 

## Homework

*Type*: quick practice, approx 15 mins

Use the [hotel-europe data from OSF](https://osf.io/r6uqb/) data and filter to have:
  - Time: year 2017, november and `weekday = 0`
  - Cities: London and Vienna
  - Accomodation: 3-4 stars hotels

Create a max 2-page report in pdf **and** Html, where you
  - describe the data filtering you have done with a list
  - show a histogram of the prices
  - report a descriptive table for the prices grouped by cities
  - and carry out a simple t-test to decide if the mean prices in the two cities are the same. Hint: `t.test( price ~ city, data )` would compare the prices in the two cities.
    - draw a conclusion in text with greek letters and in-line codes.   

Note: there is no need for a comprehensive argument, here focus on rather the coding and pretty-reporting part.

## Further material

  - Hadley Wickham and Garrett Grolemund: R for Data Science: [Chapter 27](https://r4ds.had.co.nz/r-markdown.html) reviews the basics of RMarkdown such as chunks, general setup, problem-solving, and citation. [Chapter 29](https://r4ds.had.co.nz/r-markdown-formats.html) shows different types of outputs, that are not covered in this lecture but can be handy.
  - [Yihui Xie, Christophe Dervieux, Emily Riederer: R Markdown Cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) is a detailed book on all RMarkdown topics and issues.
  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test)

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture06-rmarkdown101/raw_codes) includes one RMarkdown file, which is ready to use during the course but requires some live coding in class.
    - [`report_bpp.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/raw_codes/report_bpp.Rmd)
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture06-rmarkdown101/complete_codes) includes
    - [`report_bpp_fin.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/complete_codes/report_bpp_fin.Rmd) RMarkdown file with solution for: [`report_bpp.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/raw_codes/report_bpp.Rmd)
    - [`report_bpp_fin.pdf`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/complete_codes/report_bpp_fin.pdf) is the generated pdf from [`report_bpp_fin.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/complete_codes/report_bpp_fin.Rmd)
    - [`report_bpp_fin.html`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/complete_codes/report_bpp_fin.html) is the generated Html from [`report_bpp_fin.Rmd`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture06-rmarkdown101/complete_codes/report_bpp_fin.Rmd)
