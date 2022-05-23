# Lecture 20: Spatial data visualization
*Coding course to complete Data Analysis in R*

This lecture introduces spatial data visualization using maps. During the lecture, students will visualize the 2016 US election results on the US map along with covid death rates on the world map.

## Learning outcomes
After successfully completing codes you should be able:

[`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic_spatial_vizz/visualize_spatial.R)
  - US 2016 election
    - Use of `socviz` package to get US election data
    - Ordered point plot to show states winners
    - Use `scale_color_manual` to manually color ggplot
    - Use of `maps` package to import US states map
    - Understand how `geom_polygon` works
    - Use different representation of US maps with `coord_map` and `scale_fill_gradient2`
  - Covid-crises
    - Use `tmap` package to get world map
    - Connect datasets with covid data
    - Visualize on world map covid data 

## Lecture Time

Ideal overall time: **20-40 mins**.

There are no extra tasks in [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic_spatial_vizz/visualize_spatial.R).


## Homework

*Type*: quick practice, approx 10 mins

Get countries' GDP growth rate with `WDI`. Plot the values in a world map.


## Further material

  - This lecture is based on [Kieran Healy: Data Visualization, Chapter 7](https://socviz.co/maps.html#maps). Check out for more content.
  - Great content can be found in (advanced) spatial data analysis [Edzer Pebesma, Roger Bivand: Spatial Data Science with applications in R](https://keen-swartz-3146c4.netlify.app/)

## Folder structure
  
  - No folders, only the main script: [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic_spatial_vizz/visualize_spatial.R)
