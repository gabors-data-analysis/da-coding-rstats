# Lecture 20: Spatial data visualization

## Motivation

Visualizing data spatially can allow us to make insights as to what is going on beyond our bubble. Aside from being great visuals that immediately engage audiences, map data visualizations provide a critical context for the metrics. Combining geospatial information with data creates a greater scope of understanding. Some benefits of using maps in your data visualization include:

1. A greater ability to more easily understand the distribution of your variable across the city, state, country, or world.
2. The ability to compare the activity across several locations at a glance
3. More intuitive decision making for company leaders
4. Contextualizing your data in the real world


There is lots of room for creativity when making map dashboards because there are numerous ways to convey information with this kind of visualization. In R, we map geographical regions colored, shaded, or graded according to some variable. They are visually striking, especially when the spatial units of the map are familiar entities.

| Life expectancy map    | Hotel prices in cities  |
|-------------------------|-------------------------|
| ![alt text 1](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/output/lifeexpectancy_world.png) | ![alt text 2](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/output/heu_prices.png) |


## This lecture

This lecture introduces spatial data visualization using maps. During the lecture, students learn how to use the `maps` package which offers built-in maps with the [worldbank-lifeexpectancy](https://gabors-data-analysis.com/datasets/#worldbank-lifeexpectancy) data. Plotting the raw life expectancy at birth on a world map is already a powerful tool, but students will learn how to show deviance from the expected value given by the regression model. In the second part, students import raw `shp` files with auxiliary files, which contain the map of London boroughs and Vienna districts. With the [hotels-europe](https://gabors-data-analysis.com/datasets/#hotels-europe) dataset the average price for each unit on the map is shown.

Case studies used during the lecture:
  - [Chapter 08, B: How is life expectancy related to the average income of a country?](https://gabors-data-analysis.com/casestudies/#ch08b-how-is-life-expectancy-related-to-the-average-income-of-a-country)
  - [Chapter 03, B: Comparing hotel prices in Europe: Vienna vs London](https://gabors-data-analysis.com/casestudies/#ch03b-comparing-hotel-prices-in-europe-vienna-vs-london)

## Learning outcomes
After successfully completing [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/raw_codes/visualize_spatial.R), students should be able:

  - Part I
    - Use of `maps` package to import world map
    - Understand how `geom_polygon` works
    - Shaping the outlook of the map with `coord_equal` or `coord_map`
    - Use of `theme_map()`
    - Use different coloring with `scale_fill_gradient`
    - How to match different data tables to be able to plot a map
    - Use custom values as a filler on the map based on life-expectancy case study
  - Part II
    - Use `rgdal` package with `readOGR` function to import 'shp' files and other needed auxiliary files as 'shx' and 'dbf'
    - Convert an `S4 object` to a tibble and format, such that it can be used for `ggplot2`
    - `geom_path` to color the edges of the map
    - Map manipulations to show only inner-London boroughs
    - Add (borough) names to a map with `aggregate` and `geom_text`
    - Task for Vienna: replicate the same as for London
    - `ggarrange` with a common legend

## Lecture Time

Ideal overall time: **40-60 mins**.

Going through [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/raw_codes/visualize_spatial.R) takes around 20-40 minutes. Solving the tasks takes the remaining 20-40 minutes as there are two long tasks.


## Homework

*Type*: quick practice, approx 10 mins

Get countries' GDP growth rates with the `WDI` package. Plot the values in a world map.


## Further material

  - This lecture is based on [Kieran Healy: Data Visualization, Chapter 7](https://socviz.co/maps.html#maps). Check out for more content.
  - Great content can be found in (advanced) spatial data analysis [Edzer Pebesma, Roger Bivand: Spatial Data Science with applications in R](https://keen-swartz-3146c4.netlify.app/), specifically [a blog content](https://r-spatial.org/r/2018/10/25/ggplot2-sf.html) related to this book can be interesting.

## Folder structure
  
  - [raw_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/raw_codes) includes codes, which are ready to use during the course but requires some live coding in class.
    - [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/raw_codes/visualize_spatial.R), is the main material for this lecture.
  - [complete_codes](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/complete_codes) includes code with solution for [`visualize_spatial.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/raw_codes/visualize_spatial.R) as [`visualize_spatial_fin.R`](https://github.com/gabors-data-analysis/da-coding-rstats/blob/main/lecture20-basic-spatial-vizz/complete_codes/visualize_spatial_fin.R)
  - [data_map](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture20-basic-spatial-vizz/data_map) includes raw map data
    - [London boroughs](https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london): `London_Borough_Excluding_MHW.dbf`, `London_Borough_Excluding_MHW.shp`, `London_Borough_Excluding_MHW.shx`
    - [Vienna boroughs](https://www.data.gv.at/katalog/dataset/stadt-wien_bezirksgrenzenwien): `BEZIRKSGRENZEOGDPolygon.dbf`, `BEZIRKSGRENZEOGDPolygon.shp`, `BEZIRKSGRENZEOGDPolygon.shx`
