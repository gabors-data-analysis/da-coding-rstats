# Coding for Data Analysis with R 
Introduction to Data Analysis with R - lecture materials
by [Ágoston Reguly](https://regulyagoston.github.io/) (CEU) with [Gábor Békés](https://sites.google.com/site/bekesg/) ([CEU](https://people.ceu.edu/gabor_bekes), [KRTK](https://kti.krtk.hu/en/kutatok/gabor-bekes/5896/), [CEPR](https://voxeu.org/users/gaborbekes0)) 

This course material is a supplement to *Data Analysis for Business, Economics, and Policy 
by Gábor Békés (CEU) and Gábor Kézdi (U. Michigan),  Cambridge University Press, 2021*

Textbook information: [gabors-data-analysis.com](https://gabors-data-analysis.com/)

## Status

This is very much in development. We hope to have a beta version by August 2022. 

Comments are really welcome in email or as a github issue. 

## Overview

The course serves as an introduction to the R programming language and software environment for data exploration, data munging, data visualization, reporting, and modeling. 

Lecture 1 to 11 complements [Part I: Data Exploration (Chapter 1-6)](https://gabors-data-analysis.com/chapters/#part-i-data-exploration) -- which is the basis of Data Analysis 1 course -- and focuses on the basic programming principles, data structures, data cleaning and data exploration with descriptives and graphs, and simple hypothesis testing.

Lecture 12 to 19 complements [PART II: Regression Analysis (Chapter 7-12)](https://gabors-data-analysis.com/chapters/#part-ii-regression-analysis) -- Data Analysis 2 -- and focuses on statistical methods such as nonparametric regression, single and multiple linear cross-sections, binary models and simple time-series analysis while adding more advanced toolkit for visualization and reporting.

The material is based on 3 years of teaching a coding course as well as advice from many many great resources such as 
  - Hadley Wickham and Garrett Grolemund [R for Data Science](https://r4ds.had.co.nz) 
  - Jae Yeon Kim: [R Fundamentals for Public Policy, Course material](https://github.com/KDIS-DSPPM/r-fundamentals) 
  - Winston Chang: [R Graphics Cookbook](https://r-graphics.org/) 
  - Andrew Heiss: [Data Visualization with R ](https://datavizs21.classes.andrewheiss.com) 


## How to use

This course material may be used as a basis for course on learning coding with R for the purpose of analyzing data. It is developed to be taught simultaneously with the textbook, but may be used independently. It is rather comprehensive and thus, may be used without any textbook to prepare. 

We have not invented the coding wheel. Instead tried to adopt best practices and combine it with real life case studies from the textbook.

There are no slides. But codes are commented heavily. 

## Teaching philosophy

We believe, students will learn using R by writing scripts, solving problems on their own and we can provide and show them good practices on how to do it. 

This is not a hardcore coding course, but a course to supplement data analysis. The material focuses on specific issues in this topic and balances between higher levels of coding such as `tidyverse` -- which is more intuitive, easier to learn but less flexible -- and lower levels in form of basic coding principles -- which allows greater complexity, but requires much more practice and has a steeper learning curve. 

The material structure also reflects this principle. The majority of the lectures have pre-written codes which include in-class tasks. This enables the instructor to show a greater variety of codes, good examples for coding, and way more commands and functions than live coding while providing room for practicing. For this type of lecture, homework is essential, as it helps students to deepen their coding skills via practice. There are also few live-coding lectures, which require flexibility and more preparation from the teacher (material provides detailed instructions). These lectures are focusing on basic coding principles such as the introduction to coding, functions, loops, conditionals, etc., and show students possible paths to hardcore coding.

### Lectures, learning outcomes, and case-studies

| Lecture  | Lecture Type | Learning outcomes | Case-study | Dataset |
| -------  | -------------| ----------------- | ---------- | ------- |
| [lecture00-intro](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture00-intro) | live coding or pre-written |Setting up R and RStudio. Introduction to the interface of R-studio. Packages and tryout of `tidyverse` and knitting a pre-written Rmarkdown | - | - |
| [lecture01-coding-basics](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture01-coding-basics) | live coding |Introduction to coding with R: R-objects, basic operations, functions, vectors, lists | - | - |
| [lecture02-data-imp-n-exp](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture02-data-imp-n-exp) | pre-written | How to import and export data with `readr` and APIs | - | [hotels-vienna](https://gabors-data-analysis.com/datasets/#hotels-vienna), [football](https://gabors-data-analysis.com/datasets/#football)** |
| [lecture03-tibbles](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture03-tibbles) | pre-written | Introduces `tibble`-s as data variable. Selecting, adding or removing rows (observations) and columns (variables). Convert to wide and long formta. Merge two tibbles in multiple ways. | [Ch 02C: Football Managers](https://gabors-data-analysis.com/casestudies/#ch02c-identifying-successful-football-managers) | [football](https://gabors-data-analysis.com/datasets/#football) |
| [lecture04-data-munging](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture04-data-munging)| pre-written | Intro to data munging with `dplyr`: add, remove, separate, convert variables, filter observations, etc. | [Ch 02A: Hotels prep](https://gabors-data-analysis.com/casestudies/#ch02a-finding-a-good-deal-among-hotels-data-preparation)* | [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe)|
| [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration) | pre-written | Intro to data exploration: `modelsummary` for descriptive stats in various ways, `ggplot2` to plot one variable distributions (histogram, density) and two variable associations (scatter, bin-scatter), `t.test` for simple hypothesis testing. | Core: [Ch 06A: Online vs offline prices](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference). Related: [Ch 03A: Hotels: exploration](https://gabors-data-analysis.com/casestudies/#ch03a-finding-a-good-deal-among-hotels-data-exploration), [Ch 04A: Management & firm size](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association) | [billion-prices](https://gabors-data-analysis.com/datasets/#billion-prices), [wms-management-survey](https://gabors-data-analysis.com/datasets/#wms-management-survey)** |
| [lecture06-rmarkdown101](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture06-rmarkdown101) | pre-written | Intro to RMarkdown: knitting pdf and Html. Structure of RMarkdown, formatting text, plots and tables. | [Ch 06A: Online vs offline prices](https://gabors-data-analysis.com/casestudies/#ch06a-comparing-online-and-offline-prices-testing-the-difference)* | [billion-prices](https://gabors-data-analysis.com/datasets/#billion-prices), [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe)** |
| [lecture07-ggplot-indepth](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth) | pre-written | Tools to cutomize `ggplot2` graph. Write your own theme. Bar charts, box and violine plots. `theme_bg()` and `source()` from file and url. | [Ch03B: Hotels: Vienna vs London](https://gabors-data-analysis.com/casestudies/#ch03b-comparing-hotel-prices-in-europe-vienna-vs-london) | [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe)|
| [lecture08-conditionals](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture08-conditionals) | live coding | Conditional programming: if-else statements, logical operations with vectors, creating new variables with conditionals. | - | [wms-management](https://gabors-data-analysis.com/datasets/#wms-management-survey) |
| [lecture09-loops](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops) | live coding | Imperative programming with `for` and `while` loops. Exercise to calculate yearly sp500 returns. | [Ch05A: Loss on stock portfolio](https://gabors-data-analysis.com/casestudies/#ch05a-what-likelihood-of-loss-to-expect-on-a-stock-portfolio) | [sp500](https://gabors-data-analysis.com/datasets/#sp500) |

*case study was the base for the material, but coding material is modified

**dataset is used in homework


| [lecture14-simple_regression](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture14-simple_regression) | pre-written with tasks | Run and plot single linear regressions with transformations and prediction analysis | [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income) |

### Folder structure within lectures

Within each lecture there is the following folder structure:
  - `raw_codes`: includes codes, which are ready to use during the course but require some live coding in class.
  - `complete_codes`: includes codes with suggested solutions to codes in `raw_codes`
  - `data`: in some cases, there is a data folder, which includes data files (typically in '.csv'). I have found it crucial during live-coding classes to make sure everybody has the same data.
  - if there are no folders then:
    - lecture has a notebook format, which implies a complete live-coding class (mostly introduction or technical ''hard-core coding'' lectures)
    - lecture has a complete R-script. In this case, the lecturer should pay attention to the interpretation of the material itself rather than to coding. Typically this is for more advanced case studies (chapters 13-18), where there is no new coding technique, but interpreting the results might be challenging.

## Learning outcomes and relation to the book

Probably, the largest difference compared to the book is that data handling is the most challenging and most time-consuming part of coding, while it is a relatively little part of the book. It is always a challenge to keep up with the material if the two courses (Data Analysis and Coding) are running parallel. Experience shows that lecture 05 - data exploration in this course is the first truly common point with the book and lecture 06 - rmarkdown101 enables students to submit data analysis material via pdf or HTML. This coding material was developed such that it catches up with the book as quickly as possible, showing truly essential tools to do data handling. The result is that after 6 lectures from both courses (teaching Part I. of the book) there is room for common assignment in the form of a descriptive analysis: e.g. carry out a data-collection exercise, clean the data and do exploratory analysis. The 'cost' is that apart from some references or homework there is no true connection between the two courses before lecture 05 in coding and the data handling skills can be improved even more. Therefore do not expect students to be able to solve (all) of the data exercises from the book (however, there were some positive surprises during the years).

In contrast, Part II in the book deals with regressions of various forms. This is fairly simple from the coding perspective, which allows the lecturer to deepen students' knowledge of a) basic coding principles; b) add further data handling practices to students' toolkit, and c) provide more skills on Rmarkdown, while following the material of the book. If material is properly taught -- for Part III of the book -- there is no need for an extra coding course, but a simple seminar type of supplement, which put emphasis on *interpretation* and *practice* of machine learning methods. In principle after these materials, students should be able to code by themself and understand and work with case study materials related to Part IV.


### Case-studies and coding lectures
Or one can relate each case study from the book to specific lectures.

|Chapter | Case-study | Lecture |
| ------ | ---------  | ------- |
| Chapter 1 | [ch01-hotels-data-collect](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch01-hotels-data-collect) | [lecture03-tibbles](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture03-tibbles)**|
|           | [ch02-football-manager-success](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-football-manager-success) | [lecture03-tibbles](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture03-tibbles)*|
| Chapter 2 | [ch02-hotels-data-prep](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-hotels-data-prep) | [lecture04-data-munging](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture04-data-munging) |
|           | [ch02-immunization-crosscountry](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-immunization-crosscountry) | [lecture04-data-munging](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture04-data-munging)** |
|           | [ch03-city-size-japan](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-city-size-japan) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)** |
|           | [ch03-distributions-height-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-distributions-height-income) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)** |
| Chapter 3 | [ch03-football-home-advantage](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-football-home-advantage) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)** |
|           | [ch03-hotels-europe-compare](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-hotels-europe-compare) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)**, [lecture07-ggplot-indepth](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth) |
|           | [ch03-hotels-vienna-explore](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-hotels-vienna-explore) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)** |
|           | [ch03-simulations](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-simulations) | [lecture10-random-numbers](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture10-random-numbers) |
| Chapter 4 | [ch04-management-firm-size](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch04-management-firm-size) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)**, [lecture07-ggplot-indepth](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth)  |
| Chapter 5 | [ch05-stock-market-loss-generalize](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch05-stock-market-loss-generalize) |  [lecture09-loops](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture09-loops), [lecture10-random-numbers](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture10-random-numbers), [lecture11-functions](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture11-functions)|
| Chapter 6 | [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)*  |
|           | [ch06-stock-market-loss-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-stock-market-loss-test) | |
| Chapter 7 | [ch07-hotels-simple-reg](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch07-hotels-simple-reg)| |
|           | [ch07-ols-simulation](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch07-ols-simulation) | |
|           | [ch08-hotels-measurement-error](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-hotels-measurement-error) |  |
| Chapter 8 | [ch08-hotels-nonlinear](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-hotels-nonlinear) |  |
|           | [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income) | [00_example](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example) |
| Chapter 9 | [ch09-gender-age-earnings](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch09-gender-age-earnings) |  |
|           | [ch09-hotels-europe-stability](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch09-hotels-europe-stability) |  |
| Chapter 10 | [ch10-gender-earnings-understand](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch10-gender-earnings-understand) |  |
|            | [ch10-hotels-multiple-reg](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch10-hotels-multiple-reg) |  |
| Chapter 11 | [ch11-australia-rainfall-predict](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch11-australia-rainfall-predict) |  |
|            | [ch11-smoking-health-risk](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch11-smoking-health-risk) |  |
|            | [ch12-electricity-temperature](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch12-electricity-temperature) |  |
| Chapter 12 | [ch12-stock-returns-risk](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch12-stock-returns-risk)|  |
|            | [ch12-time-series-simulations](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch12-time-series-simulations) |  |

*partial match: case study is only used as a starting point for the lecture.

**students can understand and replicate material based on that lecture

## Our thanks

Thanks to all folks who contributed to the codebase for the course, especially Gábor Kézdi, co-author of the book. But also thanks to [Zsuzsa Holler](https://www.linkedin.com/in/zsuzsa-holler-70bba031/), [Kinga Ritter](https://www.linkedin.com/in/kinga-ritter/?originalSubdomain=es), [Ádám Víg](https://github.com/adamvig96), [Jenő Pál](https://github.com/paljenczy/), [János Divényi](https://divenyijanos.github.io/pages/about-me.html), Gábors' many students. Big thanks to [Laurent Bergé](https://sites.google.com/site/laurentrberge/software?authuser=0), [Grant McDermott](https://grantmcdermott.com/software/) and [Vincent Arel-Bundock](https://arelbundock.com/#code) for awesome packages and all the help on coding over several years.


## Found an error or have a suggestion?

Awesome, we know there are errors and bugs. Or just much better ways to do a procedure.

To make a suggestion, please open a `GitHub issue` here with a title containing the case study name. You may also [contact us directly](https://gabors-data-analysis.com/contact-us/). 
