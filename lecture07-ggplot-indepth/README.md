# Lecture 07: ggplot in depth
*Coding course to complete Data Analysis in R*

This lecture extends the tools to create plots with `ggplot2` from `tidyverse`.


## Learning outcomes
After completing the code in *raw_codes* students should be able to:

[`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R)
  - use pre-written themes (`tidyverse` and `ggthemes`)
  - write own theme and call it via `source()` function
  - manipulating axis:
    - set limits
    - set break points
  - add lines and text to a plot
  - bar charts:
    - simple
    - stacked
    - stacked with percentages
  - box plot
  - violine plot

## Datasets used
* [Hotel Europe](https://gabors-data-analysis.com/datasets/#hotels-europe)

## Lecture Time

Ideal overall time: **30-60mins**.

Showing [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R) takes around *30 minutes* while doing the tasks would take approx *10-15 minutes*. [`theme_bluewhite.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_bluewhite.R) would take another *5-15 minutes*.
 

## Homework

*Type*: quick practice, approx 15 mins
  - students need to create their own theme. Encourage them to use it during the course (and others).
  - Two files: 
    - [`homework_ggpplot_runfile.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/homework_ggpplot_runfile.R) is the evaluation file, where students need to call their theme file and do some partial coding.
    - [`theme_RENAMEME.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_RENAMEME.R) is the skeleton for the theme and the student need to change the name of this script. This includes the main task: the creation of the theme.


## Further material

  - Kieran Healy: Data Visualization, [Chapter 3](https://socviz.co/makeplot.html#makeplot) ggplot in general, [Chapter 4](https://socviz.co/groupfacettx.html#groupfacettx) lines, histograms, and bar graphs [Chapter 5](https://socviz.co/workgeoms.html#workgeoms) labels, coloring and transforming [Chapter 8](https://socviz.co/refineplots.html#refineplots) custom colors, themes, complex and stacked graphs.
  - Hadley Wickham and Garrett Grolemund: R for Data Science, [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) introduces `ggplot` and show some features of how to visualize data. [Chapter 28](https://r4ds.had.co.nz/graphics-for-communication.html) discusses some more advanced topics with `ggplot` and communicating with a good graph.  
  - [Winston Chang: R Graphics Cookbook](https://r-graphics.org/) is a great book all about graphics in general with R.
  - Andrew Heiss: [Data Visualization with R](https://datavizs21.classes.andrewheiss.com/lesson/) in general focuses on visualization with ggplot.
  - [Official webpage of `ggplot2`](https://ggplot2.tidyverse.org/) is very well documented and can be handy. Also look at the references there, which point to online courses and youtube material.

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    -[`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R) is the main course material.
    - [`theme_bluewhite.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_bluewhite.R) shows an example for a user defined theme for `ggplot`.
    - [`homework_ggpplot_runfile.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/homework_ggpplot_runfile.R) is the homework main file.
    - [`theme_RENAMEME.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_RENAMEME.R) is the skeleton for the theme and the student need to change the name of this script.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/complete_codes) includes one code with solutions for
    -[`ggplot_indepth.R_fin`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/complete_codes/ggplot_indepth_fin.R) is the completed file for [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R)
