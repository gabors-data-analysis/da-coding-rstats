###############################################
#                                             #
#               Lecture 20                    #
#                                             #
#    Basic spatial data visualization         #
#     - Visualize 2016 US election results    #
#         - ordered point plot by states      #
#         - custom colors                     #
#         - US map colored by winning margin  #
#     - Visualize Covid crisis                #
#         - color word map                    #
#                                             #
#                                             #
###############################################


#######################################
# Visualize 2016 US election results  #
#######################################

# CLEAR MEMORY
rm(list=ls())

# Based on Chapter 7 from Data Visualization (Kieran Healy)

library(tidyverse)
if (!require(socviz)){
  install.packages("socviz")
  library(socviz)
}
if (!require(maps)){
  install.packages("maps")
  install.packages("mapproj")
  library(maps)
}
if (!require(tmap)){
  install.packages("tmap")
  library(tmap)
}


data("election")

glimpse( election )

party_colors <- c("#2E74C0", "#CB454A") 

####
# Plotting election results

# Plot all the votes by district and reorder
p0 <- ggplot(data = election,
             mapping = aes(x = r_points, 
                           y = reorder(state, r_points), 
                           color = party ) ) + 
  geom_vline(xintercept = 0) +
  geom_point(size = 2) +
  labs( y = 'States', x = 'margins', color = "" )

p0

# %nin% 'not in' is a binary operator, which returns a logical vector 
#   indicating if there is a match or not for its left operand
p1 <- ggplot(data = filter( election, st %nin% 'DC'),
             mapping = aes(x = r_points, 
                           y = reorder(state, r_points), 
                           color = party)) + 
  geom_vline(xintercept = 0) +
  geom_point(size = 2) +
  labs( y = 'States', x = 'margins', color = "" )

p1

# Change the color
p2 <- p1 + scale_color_manual(values = party_colors)
p2

# Let separate US according to census (West, south, ect.)
p3 <- p2 + facet_wrap(~ census, ncol = 2, scales = "free_y") +
  guides(color = "none") + 
  labs(y = "", x = "Point Margin") + 
  theme(axis.text=element_text(size=8))
p3

rm(p0,p1,p2,p3,party_colors)


########
# MAPS
# Lets create some nice maps with the help of 'maps'

# Use the US map -> but it includes many other maps!
us_states <- map_data("state")
head(us_states)

# What we need is a 'polygon'
?geom_polygon

# Map of US
us_states %>% 
  ggplot(mapping = aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", color = "black")

# Fill the states with colors
g1 <- us_states %>% 
      ggplot(mapping = aes(x = long, 
                           y = lat, 
                           group = group,
                           fill = region)) +
      geom_polygon(color = "gray90", size = 0.1)
      
g1

# Remove labels with guides and use a coordinate map!
g1 + coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  guides( fill="none")

##
# We want to show the election results in this map!
#
# 1st: Join map data with election data

# a) translate upper cases to lower cases
election$region <- tolower(election$state)

# b) Check for remaining observations
anti_join(us_states, election, by = 'region')

# c) leftjoin elections and tranform everything to tibble
us_states_election <- us_states %>% 
    left_join(election, by = 'region') %>%
    as_tibble()

# Remove district of columbia and create a base ggplot (nicer if no 'extreme value')
p_pct_dem <- us_states_election %>%
  filter(region %nin% "district of columbia") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group,
             fill = d_points))

# Check the democratic votes (margins) for 2016
p_pct_dem +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white") +
  labs(title = "Democrat vote 2016", fill = "Percent")

# Or you can center the colors around purple: mid = scales::muted("purple")
p_pct_dem +
  geom_polygon(color = "gray90", size = 0.1) + 
  coord_map(projection = "albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient2(low = "red", high = "blue", mid = scales::muted("purple")) +
  labs(title = "Democrat vote 2016", fill = "Percent")


#######################################
# Visualize Covid-crises              #
#######################################

rm( list = ls() )

date <- '06-12-2021'
covid_url <- paste0('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/',
                    date,'.csv')
covid_raw <- read_csv( covid_url )

# Combine the regions to countries
countrytotal <- covid_raw %>% group_by(Country_Region) %>% 
      summarize(cumconfirmed = sum(Confirmed)/1000, 
                cumdeaths    = sum(Deaths)/1000, 
                cumrecovered = sum(Recovered)/1000)


# Get the map source - this is a new one from tmap...
data(World)


# Check countries which are not in world name
countrytotal$Country_Region[!countrytotal$Country_Region %in% World$name]
list <- which(!countrytotal$Country_Region %in% World$name)
countrytotal$country <- as.character(countrytotal$Country_Region)
countrytotal$country[list] <-
  c("Andorra", "Antigua and Barbuda", "Bahrain",
    "Barbados", "Bosnia and Herz.", "Myanmar",
    "Cape Verde", "Central African Rep.","Comoros", "Congo",
    "Dem. Rep. Congo", "Czech Rep.", "Diamond Princess",
    "Dominica", "Dominican Rep.", "Eq. Guinea",
    "Swaziland", "Grenada", "Holy See",
    "Korea", "Lao PDR", "Liechtenstein",
    "Maldives", "Malta", "Mauritius",
    "Monaco", "MS Zaandam", "Macedonia",
    "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines",
    "Samoa","San Marino", "Sao Tome and Principe", "Seychelles",
    "Singapore", "S. Sudan", "Taiwan",
    "United States", "Palestine", "W. Sahara")
countrytotal$Country_Region[!countrytotal$country %in% World$name]
World$country <- World$name

# Join the two datatables
worldmap <- left_join(World, countrytotal, by="country")

# Map for confirmed cases
ggplot( data = worldmap ) + 
  geom_sf( aes( fill = cumconfirmed ), color="black") +
  ggtitle("World Map of Confirmed Covid Cases",
          subtitle=paste0("Total Cases on ", date ) )  +
  scale_fill_gradient2(low = "white", high = "red", mid = scales::muted("green"),
                       name = "No. cases for 1000") +
  theme_bw()

# Map for death
ggplot( data = worldmap ) + 
  geom_sf( aes( fill = cumdeaths ), color="black") +
  ggtitle("World Map of Number of Death by Covid-19",
          subtitle=paste0("Total Cases on ", date ) )  +
  scale_fill_gradient2(low = "yellow", high = "red", mid = scales::muted("blue"),
                       name = "No. cases for 1000") +
  theme_bw()

