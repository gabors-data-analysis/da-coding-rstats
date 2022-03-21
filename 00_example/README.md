# Example case-study: life expectancy analysis
*Coding course to complete Data Analysis in R*

This is an example for a coding lecture, which provides materials for students and lecturers to analyse the association between life-expectancy and gdp mesures for various countries in 2019.

## Learning outcomes
After succesfully compliting codes in *raw_codes* you should be able:
  - Solid ground for importing and exporting data from World Bank's website via API. (`life_exp_getdata.R`)
  - Create scatter-plots for competing models.
  - Transform variables from level to log in a ggplot and scale the axis for proper interpretation.
  - Run and plot multiple single variable regressions with:
    - log transformation,
    - higher order polynomial, or
    - piecewise linear spline
  - Be able to estimate heteroscedastic robust SEs and compare specific model results with `etable` in one output.
  - Get model residuals and find the top or bottom largest *n* errors. 

## Folder structure
  - *complete_codes* includes codes with solutions.
  - *data* includes *raw* and *clean* data which are produced by codes in *complete_codes*.
    - helps lagging students to catch up, without complete codes.
  - *raw_codes* includes codes, which are ready to use during the course, but requires some live coding in class.
    - `life_exp_getdata.R`, shows how to get life-expectancy data (and gdp measure) directly from the World Bank's website via an API. It saves a raw data file.
    - `life_exp_clean.R`, is an auxilliary file, which shows how to create clean data from the raw data, produced by *life_exp_getdata.R*. Usually this code is skipped during the lecture as it is already known, but tedious material.
    - **`life_exp_analysis.R`** is the main material for this lecture. 


