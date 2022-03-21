# Example case-study: life expectancy analysis
*Coding course to complete Data Analysis in R*

This is an example of a coding lecture, which provides materials for students and lecturers to analyze the association between life expectancy and GDP measures for various countries in 2019.

This lecture is based on Chapter 08, B: *How is life expectancy related to the average income of a country?*

## Learning outcomes
After successfully completing codes in *raw_codes* you should be able:

`life_exp_getdata.R`
  - Solid ground for importing and exporting data from World Bank's website via API.


`life_exp_analysis.R`
  - Create scatter-plots for competing models.
  - Transform variables from level to log in a ggplot and scale the axis for proper interpretation.
  - Run and plot multiple single-variable regressions with:
    - log transformation,
    - higher-order polynomial, or
    - piecewise linear spline
  - Be able to estimate heteroscedastic robust SEs and compare specific model results with `etable` in one output.
  - Get model residuals and find the top or bottom largest (n) error(s). 

## Lecture Time

Ideal overall time: **60 mins**.

Solving `life_exp_getdata.R` takes around *5-10 minutes* as it builds on [lecture01-data-imp_n_exp](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture01-data-imp_n_exp). In principle it should be a quick reminder and practice.

Solving `life_exp_analysis.R` introduces the main material, and takes *40-60 minutes* depends on the student's backgroud. This lecture is mainly a theory based lecture (practice via case study) and includes easy, but many new commands in a repetative way. 

## Homework

*Type*: quick practice, approx 15 mins

Use the linear spline model:

lifeexp<sub>i</sub> = &alpha; + &beta;<sub>1</sub> ( log( gdppc<sub>i</sub> ) < 50 ) + &beta;<sub>2</sub> ( log( gdppc<sub>i</sub> &ge; 50 )

  and get the largest and positive and negative 5 errors. Create a scatter graph with the regression line. Color the largest errors with different color. 
  
Extra: annotate the largest positive and negative country within the graph.

## Further material

  - More materials on the case study can be found in Gabor's *da_case_studies* repository: [ch08-life-expectancy-income](https://github.com/gabors-data-analysis/da_case_studies/tree/master/ch08-life-expectancy-income)
  - Partially related is Chapter 3 from [James-Witten-Hastie-Tibshirani (2013) - An Introduction to Statistical Learning with Applications in R](https://www.statlearning.com/)


## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - `life_exp_getdata.R`, shows how to get life-expectancy data (and GDP measure) directly from the World Bank's website via an API. It saves a raw data file.
    - **`life_exp_analysis.R`** is the main material for this lecture. 
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/complete_codes) includes codes with solutions for
    - `life_exp_getdata.R` as `life_exp_getdata_fin.R` and
    - `life_exp_analysis.R` as `life_exp_analysis_fin.R`.
    - furthermore, it includes `life_exp_clean.R`, which is an auxiliary file. It shows how to create clean data from the raw data, produced by *life_exp_getdata.R*. Usually, this code is skipped during the lecture as it is already known, but tedious material. If needed it can be given as extra homework.
  - [data](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data) includes [raw](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data/raw) and [clean](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/data/clean) data which are produced by codes in [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/complete_codes).
    - helps lagging students to catch up, without complete codes as files in [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/00_example/raw_codes) uses data from this source.


