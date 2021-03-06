# Lecture 07: ggplot in depth

## Motivation

You should look at your data. Graphs and charts let you explore and learn about the structure of the information you collect. Good data visualizations also make it easier to communicate your ideas and findings to other people. Beyond that, producing effective plots from your own data is the best way to develop a good eye for reading and understanding graphs — good and bad — made by others, whether presented in research articles, business slide decks, public policy advocacy, or media reports.([Kieran Healy: Data Visualization](https://socviz.co/index.html#preface)).

To create a powerful graph, it is a good starting principle that all of our decisions should be guided by the *usage of the graph*: a summary concept to capture what we want to show and to whom. Its main elements are purpose, focus, and audience. Once usage is clear, the first set of decisions to make is about how we convey information: how to show what we want to show. For those decisions it is helpful to understand the entire graph as the
overlay of three graphical objects:

  1. Geometric object; the geometric visualization of the information we want to convey, such as a
  set of bars, a set of points, or a line; multiple geometric objects may be combined.
  2. Scaffolding: elements that support understanding the geometric object, such as axes, labels, and
  legends.
  3. Annotation: adding anything else to emphasize specific values or explain more detail.

Keeping these in mind this lecture introduces students to how to create graphs that take into account these principles.

## This lecture

This lecture extends the tools to create and manipulate plots with `ggplot2`. After the lecture students should be able to create their personalized theme and create reportable graphs for almost all cases.

Case studies used/related in/to this lecture:

  - [Chapter 03, B Comparing hotel prices in Europe: Vienna vs London](https://gabors-data-analysis.com/casestudies/#ch03b-comparing-hotel-prices-in-europe-vienna-vs-london) is the base for this lecture.
  - Some tools are used in [Chapter 04, A Management quality and firm size: describing patterns of association](https://gabors-data-analysis.com/casestudies/#ch04a-management-quality-and-firm-size-describing-patterns-of-association)
  - Understanding [theme_bg](https://github.com/gabors-data-analysis/da_case_studies/blob/master/ch00-tech-prep/theme_bg.R), which is the main theme used in [da_case_studies](https://github.com/gabors-data-analysis/da_case_studies)


## Learning outcomes
After completing [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R), students should be able to:

  - use pre-written themes from `ggplot2` and `ggthemes`
  - write own theme and call it via `source()` function
    - set different colors for background, axis, etc
    - set font size for different elements
  - manipulating axis with `scale_*_continuous` and `scale_*_discrete`, where `*` stands for `y` or `x`
    - set limits
    - set break points
  - add annotation to a plot
    - lines, dots and text
  - bar charts:
    - simple
    - stacked
    - stacked with percentages, using `scales` package
  - box plot
  - violine plot
  - import `theme_bg()` from url via `source_url()` from `devtools`
  - extra task to annotate a grouped box-plot with using:
    - `grid` and `pBrackets` packages to place annotation with arrows
    - use `color[x]` color values from `theme_bg()`

## Datasets used
* [Hotel Europe](https://gabors-data-analysis.com/datasets/#hotels-europe)

## Lecture Time

Ideal overall time: **30-60mins**.

Showing [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R) takes around *30 minutes* while doing the tasks would take approx *10-15 minutes*. [`theme_bluewhite.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_bluewhite.R) would take another *5-15 minutes*.
 

## Homework

*Type*: quick practice, approx 15 mins
  - students need to create their own theme. Encourage them to use it during the course (and in other courses).
  - Two files: 
    - [`homework_ggpplot_runfile.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/homework_ggpplot_runfile.R) is the evaluation file, where students need to call their theme file and do some partial coding.
    - [`theme_RENAMEME.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_RENAMEME.R) is the skeleton for the theme and the student need to change the name of this script. This includes the main task: the creation of the theme.


## Further material

  - Kieran Healy: Data Visualization, [Chapter 3](https://socviz.co/makeplot.html#makeplot) ggplot in general, [Chapter 4](https://socviz.co/groupfacettx.html#groupfacettx) lines, histograms, and bar graphs [Chapter 5](https://socviz.co/workgeoms.html#workgeoms) labels, coloring and transforming [Chapter 8](https://socviz.co/refineplots.html#refineplots) custom colors, themes, complex and stacked graphs.
  - Hadley Wickham and Garrett Grolemund: R for Data Science, [Chapter 3](https://r4ds.had.co.nz/data-visualisation.html) introduces `ggplot` and show some features of how to visualize data. [Chapter 28](https://r4ds.had.co.nz/graphics-for-communication.html) discusses some more advanced topics with `ggplot` and communicating with a good graph.  
  - [Winston Chang: R Graphics Cookbook](https://r-graphics.org/) is a great book all about graphics in general with R.
  - Andrew Heiss: [Data Visualization with R](https://datavizs21.classes.andrewheiss.com/lesson/) in general focuses on visualization with ggplot.
  - [Official webpage of `ggplot2`](https://ggplot2.tidyverse.org/) is very well documented and can be handy. Also look at the references there, which point to online courses and youtube material.
  - Some useful materials on creating your own theme: [datanovia](https://www.datanovia.com/en/blog/ggplot-themes-gallery/), [ggplot2's description](https://ggplot2.tidyverse.org/reference/theme.html), [Peng, Kross and Anderson: Mastering Software Development in R, Chapter 4.6](https://bookdown.org/rdpeng/RProgDA/building-a-new-theme.html) or [towardsdatascience.com](https://towardsdatascience.com/5-steps-for-creating-your-own-ggplot-theme-656e79a96b9).

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes) includes one code, which is ready to use during the course but requires some live coding in class.
    - [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R) is the main course material.
    - [`theme_bluewhite.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_bluewhite.R) shows an example for a user defined theme for `ggplot`.
    - [`homework_ggpplot_runfile.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/homework_ggpplot_runfile.R) is the homework main file.
    - [`theme_RENAMEME.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/raw_codes/theme_RENAMEME.R) is the skeleton for the theme and the student need to change the name of this script.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture07-ggplot-indepth/complete_codes) includes one code with solutions for
    - [`ggplot_indepth.R_fin`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/complete_codes/ggplot_indepth_fin.R) is the completed file for [`ggplot_indepth.R`](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture07-ggplot-indepth/raw_codes/ggplot_indepth.R)
