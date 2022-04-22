# Coding for Data Analysis with R 
Introduction to Data Analysis with R - lecture materials
by [Ágoston Reguly](https://regulyagoston.github.io/) (CEU)

This course material is a supplement to *Data Analysis for Business, Economics, and Policy 
by Gábor Békés (CEU) and Gábor Kézdi (U. Michigan)
Published on 6 May 2021 by Cambridge University Press*
[gabors-data-analysis.com](https://gabors-data-analysis.com/)

## Overview


## How to use

## Teaching philosophy

We believe, students will learn using R by writing scripts, solving problems on their own and we can provide and show them good practices on how to do it. 

This is not a hardcore coding course, but a course to supplement data analysis. The material focuses on specific issues in this topic and balances between higher levels of coding such as `tidyverse` -- which is more intuitive, easier to learn but less flexible -- and basic coding principles -- which allows greater complexity, but requires much more practice and has a steeper learning curve. 

The material structure also reflects this principle. The majority of the lectures have pre-written codes which include in-class tasks. This enables the instructor to show a greater variety of codes, good examples for coding, and way more commands and functions than live coding while providing room for practicing. For this type of lecture, homework is essential, as it helps students to deepen their coding skills. There are also few live-coding lectures, which require flexibility and more preparation from the teacher (material provides detailed instructions). These lectures are focusing on basic coding principles such as the introduction to coding, functions, loops, conditionals, etc., and show students possible paths to hardcore coding.

### Lectures, learning outcomes, and case-studies

| Lecture  | Lecture Type | Learning outcomes | Case-study |
| -------  | -------------| ----------------- | ---------- |
| [00_example](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example) | pre-written with tasks | Run and plot single variable regressions with transformations and residual analysis | [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income) |
| [lecture01-intro](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture01-intro) | live coding |Introduction to RStudio. R-objects, basic operations, functions, vectors, lists | - |

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
| Chapter 1 | [ch01-hotels-data-collect](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch01-hotels-data-collect) | |
|           | [ch02-football-manager-success](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-football-manager-success) | |
| Chapter 2 | [ch02-hotels-data-prep](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-hotels-data-prep) | |
|           | [ch02-immunization-crosscountry](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch02-immunization-crosscountry) | |
|           | [ch03-city-size-japan](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-city-size-japan) | |
|           | [ch03-distributions-height-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-distributions-height-income) | |
| Chapter 3 | [ch03-football-home-advantage](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-football-home-advantage) | |
|           | [ch03-hotels-europe-compare](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-hotels-europe-compare) | |
|           | [ch03-hotels-vienna-explore](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-hotels-vienna-explore) | |
|           | [ch03-simulations](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch03-simulations) | [lecture10-random_numbers](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture10-random_numbers) |
| Chapter 4 | [ch04-management-firm-size](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch04-management-firm-size) |  |
| Chapter 5 | [ch05-stock-market-loss-generalize](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch05-stock-market-loss-generalize) |  [lecture10-random_numbers](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture10-random_numbers), [lecture11-functions](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture11-functions)|
| Chapter 6 | [ch06-online-offline-price-test](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch06-online-offline-price-test) | [lecture05-data-exploration](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture05-data-exploration)  |
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





## Found an error or have a suggestion?

Awesome, we know there are errors and bugs. Or just much better ways to do a procedure.

To make a suggestion, please open a `GitHub issue` here with a title containing the case study name. You may also contact us directly.
