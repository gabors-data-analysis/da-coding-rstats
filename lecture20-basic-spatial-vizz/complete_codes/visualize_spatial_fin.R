###############################################
#                                             #
#               Lecture 20                    #
#                                             #
#    Basic spatial data visualization         #
#     - Visualize world map with 'maps'       #
#     - Life expectancy on a map              #
#       - Raw values                          #
#       - Modeled deviance from 'expected'    #
#     - Hotels-Europe - with 'rgdal'          #
#       - Importing an shp file               #
#       - Visualize London Boroughs           #
#       - Show average prices on map          #
#       - Visualize Vienna districts          #
#                                             #
# Case-studies:                               #
#   CH08B How is life expectancy related      #
#     to the average income of a country?     #
#   Ch03B Comparing hotel prices in Europe:   #
#       Vienna vs London                      #
#                                             #
# Data used:                                  #
#   worldbank-lifeexpectancy                  #
#   hotels-europe                             #
#                                             #
#                                             #
###############################################


# CLEAR MEMORY
rm(list=ls())

library(tidyverse)
library(ggthemes)
library(ggpubr)
library(fixest)
# Cool package with maps
if (!require(maps)){
  install.packages('maps')
  install.packages('mapproj')
  library(maps)
}
# Import custom 'shp' file to draw maps
if (!require(rgdal)){
  install.packages('rgdal')
  library(rgdal)
}
# Cool color palettes
if (!{require(wesanderson)}){
  install.packages('wesanderson')
  library(wesanderson)
}


#################################
# Part I:                       #
#   World map and               #
#     Visualize Life-expectancy #
#################################

rm( list = ls() )

# Use the US map -> but it includes many other maps! (check ?map_data())
world_map <- map_data('world')

# What we need is a 'polygon'
# Note: it has longitude and latitude data with groups and order -> this is important to draw a map
#   regions and subregions are just for us to relate 
?geom_polygon

# It will convert Map of World:
#   - unscaled, with guides and axis labels
wm <- world_map %>% 
        ggplot( aes(x = long, y = lat, group = group ) ) +
        geom_polygon( fill = 'white', color = 'black')
wm

# Set coordinates are equally distanced
# For different projection can check: 
#   https://rdrr.io/cran/mapproj/man/mapproject.html  
wm + coord_equal( ) 

# theme_map() is great for maps as it removes all ticks
wm + coord_equal( ) + theme_map()

# Add countries as a filler:
# Note: important to remove legend!
world_map %>% 
  ggplot( aes( x = long, y = lat,
               group = group, fill = region ) ) +
  geom_polygon( ) + 
  coord_equal( ) + 
  theme_map() + 
  theme(legend.position = 'none')

### 
# We want to show life-expectancy on this map

# Load WB: life-expectancy
lfe <- read_csv('https://osf.io/sh9mu/download')

# take year 2017 only
lfe <- lfe %>% filter( year == 2017 )

# We need to match the 'region' variable from world_map 
#   and 'countryname' from lfe

# a) create a new tibble with id and country name these we need to match
countries <- distinct( world_map , region , group ) %>% rename( countryname = region ) %>% arrange() 

# b) Check not-matching observations
check <- anti_join( lfe , countries,  by = 'countryname' )

# c) From these there are some which has different names
rename_list <- tibble( old_name = c('Bahamas, The','Brunei Darussalam','Congo, Dem. Rep.',
                                    'Congo, Rep.',"Cote d'Ivoire",'Egypt, Arab Rep.',
                                    'Gambia, The','Iran, Islamic Rep.','Kyrgyz Republic',
                                    'Lao PDR','Micronesia, Fed. Sts.','Russian Federation',
                                    'Slovak Republic','St. Lucia','St. Vincent and the Grenadines',
                                    'Trinidad and Tobago','United Kingdom','United States','Yemen, Rep.'),
                       new_name = c('Bahamas','Brunei','Democratic Republic of the Congo',
                                    'Republic of Congo','Ivory Coast','Egypt','Gambia',
                                    'Iran','Kyrgyzstan','Laos','Micronesia','Russia',
                                    'Slovakia','Saint Lucia','Saint Vincent','Trinidad',
                                    'UK','USA','Yemen' ) )

# d) re-set country names in lfe
for ( i in 1 : nrow( rename_list ) ){
  lfe$countryname[ lfe$countryname == rename_list$old_name[ i ] ] <- rename_list$new_name[ i ]
}

# e) now can match the lfe data to world_map
world_map_exp <- left_join( world_map, rename( lfe , region = countryname ) , by = 'region')

# Show the life-expectancy
lfe_map <- world_map_exp %>% 
            ggplot( aes( x = long, y = lat,
                         group = group, fill = lifeexp ) ) +
            geom_polygon( ) + 
            coord_equal( ) + 
            theme_map() 
lfe_map

# Change coloring life-expectancy: scale from green to red
lfe_map + scale_fill_gradient(low = 'red', high = 'green',
                              name = '') +
          ggtitle('Life expectancy at birth in years (2017)')


###
# Task:
#   - Plot instead of the raw life-expectancy the residuals of the following model:
#     lfeexp ~ log(gdp/capita)
# Notes: you need to use lfe to compute and re-join the tibbles
  
# Create log gdp/capita
lfe <- lfe %>% mutate( ln_gdppc = log( gdppc ) )
# Simple linear regression
reg <- feols( lifeexp ~ ln_gdppc , data = lfe , vcov = 'hetero' )
reg

# Reminder:
# Scatter plot for the model
ggplot( data = lfe, aes( x = ln_gdppc, y = lifeexp ) ) + 
  geom_point( color='blue') +
  geom_smooth( method = lm , color = 'red' , formula = y ~ x ) +
  labs( x = 'Log of GDP per Capita', y = 'Life Expectancy at birth') +
  theme_bw()

# save the residuals
lfe <- lfe %>% mutate( lfe_res = reg$residuals )

# tibble to show map
world_map_exp2 <- left_join( world_map, rename( lfe , region = countryname ) , by = 'region')

# Show the life-expectancy
world_map_exp2 %>% 
  ggplot( aes( x = long, y = lat,
               group = group, fill = lfe_res ) ) +
  geom_polygon( ) + 
  coord_equal( ) + 
  scale_fill_gradient(low = 'red', high = 'green',
                      name = 'Deviance from Life Exp.') +
  theme_map() + 
  theme(legend.position = 'top')


####
# Good-to-know:
# ggplot has `geom_map` object, which can be use along with `map_id`
#  to show the same projection, we use coord_map() with 'albers' projection
lfe %>% 
  ggplot(aes( fill = lfe_res, map_id = countryname ) ) +
  geom_map( map = world_map ) +
  expand_limits( x = world_map$long, y = world_map$lat ) +
  coord_map('albers', lat0 = 0, lat1 = 0) +
  scale_fill_gradient(low = 'red', high = 'green',
                      name = 'Deviance from Life Exp.') +
  theme_map() +
  theme(legend.position = 'top')


#################################
# Part II:                      #
#   Prices of Hotels in London  #
#     and in Vienna             #
#################################

rm( list = ls() )

###
# Import Hotels-Europe data
heu_p <- read_csv('https://osf.io/p6tyr/download')
heu_f <- read_csv('https://osf.io/utwjs/download')
heu <- left_join( heu_f, heu_p , by = 'hotel_id' ) 
rm(heu_p,heu_f)

# Filter to London and Vienna as usual
heu <- heu %>% filter( year == 2017, month == 11, weekend == 0 ) %>% 
  filter( city %in% c('London','Vienna'), city_actual %in% c( 'London','Vienna') ) %>% 
  filter( accommodation_type == 'Hotel', stars >= 3 , stars <=4 ) %>% 
  filter( price < 600 )

#####
# 1) Visualize London Boroughs

# SET WORKING PATH TO FOLDER!
setwd()

# Import shp file from
#   https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london
# Import shp file for London
# Note: you always need an 'shx' and 'dbf' file with the same name to read
london_map <- readOGR( 'data_map/London_Borough_Excluding_MHW.shp' )
# It imports as a 'S4 object'
head(london_map@data,2)

# Convert 'S4 object' to a data_frame, then to a tibble.
# Note: it only converts the variables needed for a ggplot (fortify is a func of ggplot2)
london_map_tibble <- as_tibble( fortify( london_map ) )

# allocate an id variable to the 'S4 object' to match remaining data
london_map$id <- row.names( london_map )

# Joins the data
london_map_tibble <- as_tibble( left_join( london_map_tibble, london_map@data , by = 'id' ) )

# remove and rename
london_map <- london_map_tibble %>% rename( borough = NAME )
rm( london_map_tibble )

# Show London boroughs
ggplot( london_map , aes( long , lat , group = borough ) ) +
  geom_polygon() + 
  geom_path( colour='white', lwd = 0.1 ) + 
  coord_equal() +
  ggtitle('London Boroughs') +
  theme_map()

# Define inner-London boroughs 
#   Note: City of London officially is not inner-London
inner_boroughs <- c( 'Camden','Greenwich','Hackney','Hammersmith and Fulham','Islington','Kensington and Chelsea',
                     'Lambeth','Lewisham','Southwark','Tower Hamlets','Wandsworth','Westminster',
                     'City of London')

# Defining inner boroughs for inner London
london_map <- london_map %>% mutate( inner_london = borough %in% inner_boroughs  )

# Show inner-London boroughs
iL <- ggplot( filter( london_map , inner_london ) , aes( long , lat , group = borough ) ) +
  geom_polygon( colour = 'black', fill = NA ) + 
  geom_path( colour='white', lwd = 0.01 ) + 
  coord_equal( ) +
  ggtitle('Inner-London Borough') +
  theme_map()
iL


# Create a tibble with one name and one point
#   aggregating lat and long has many other options than mean(range()), may check out

b_names <- aggregate( cbind(long, lat) ~ borough, 
                      data = london_map , FUN=function( x ){ mean( range( x ) ) } ) %>% 
  mutate( inner_london = borough %in% inner_boroughs  )

# Show London boroughs with names
iL + geom_text( data = filter( b_names, inner_london ) , aes(long, lat, label = borough), size = 2 )


###
# Add prices from London
#
# a) Create a borough variable 
#   !! Important: need to match with london_map borough !!
heu <- heu %>% mutate( borough =  neighbourhood )

# Hand-written matching...
#                     neighbour , borough  
match_london <- c(   'Blackheath', 'Lewisham',
                     'Bloomsbury','Camden',
                     'Camden Town','Camden',
                     'Canary Wharf','Tower Hamlets',
                     'Chelsea','Kensington and Chelsea',
                     'Covent Garden','Westminster',
                     'Earl\\u0027s Court','Kensington and Chelsea',
                     'Euston','Camden',
                     'Hammersmith and Fulham','Hammersmith and Fulham',
                     'Hampstead','Camden',
                     'Kensington','Kensington and Chelsea',
                     'Kings Cross','Islington',
                     'Kings Cross St. Pancras','Islington',
                     'Knightsbridge','Westminster',
                     'Lillington and Longmoore Gardens','Westminster',
                     'London','City of London',
                     'Maida Vale','Westminster',
                     'Marylebone','Westminster',
                     'Mayfair','Westminster',
                     'North Maida Vale','Westminster',
                     'Notting Hill','Kensington and Chelsea',
                     'Paddington','Westminster',
                     'Poplar','Tower Hamlets',
                     'Royal Borough of Kensington and Chelsea','Hammersmith and Fulham',
                     'Shoreditch','Hackney',
                     'Soho','Westminster',
                     'South Bank','Lambeth',
                     'St Katharine\\u0027s \\u0026 Wapping','Tower Hamlets',
                     'Stratford','Newham',
                     'The City of London','City of London',
                     'Victoria','Westminster',
                     'West End','Camden',
                     'White City','Hammersmith and Fulham')

for ( i in 1 : ( length( match_london ) / 2 ) ){
  heu$borough[ heu$borough == match_london[ i*2 - 1 ] ] <- match_london[ i *2 ]
}

# Calculate the average prices in each borough, London
l_bor <- heu %>% filter( city_actual == 'London' ) %>%  group_by( borough ) %>% 
  summarise( price = mean( price , na.rm = T ) )

# Check if there is perfect fit with names
all( l_bor$borough %in% sort(unique( london_map$borough )) )

# add prices to london_map
lp <- left_join( london_map , l_bor , by = 'borough' )

# Create graph with prices: London
ggplot( lp , aes( long, lat, group = borough , fill = price ) ) +
  geom_polygon( ) + 
  geom_path( colour='white', lwd=0.05 ) + 
  coord_equal( ) +
  labs(x = 'lat', y = 'lon',
       fill = 'Price') +
  scale_fill_gradient(low = 'green',high = 'red', # colors
                      name = 'Price') + # legend options
  ggtitle('Average hotel prices in London ($,2017)') +
  theme_map()


# Create graph with prices: inner-London
# first define a nice color palette with `wesanderson` package 
#   check out for more here: https://rforpoliticalscience.com/2020/07/26/make-wes-anderson-themed-graphs-with-wesanderson-package-in-r/
#     or here: https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/
pal <- wes_palette('Zissou1', 100, type = 'continuous')

# Create tibble for inner london, prices added as it is needed for graph
b_names_il <- filter( left_join( b_names, l_bor , by = 'borough' ), inner_london )

# Adjust some names and coordinate (always check the scale of coordinates before adjusting)
b_names_il$borough[ b_names_il$borough == 'Hammersmith and Fulham' ] <- 'H&F'
b_names_il$borough[ b_names_il$borough == 'Kensington and Chelsea' ] <- 'K&C'
b_names_il$borough[ b_names_il$borough == 'City of London' ] <- 'C.London'
b_names_il$lat[ b_names_il$borough == 'H&F' ] <- b_names_il$lat[ b_names_il$borough == 'H&F' ] - 1000
b_names_il$lat[ b_names_il$borough == 'K&C' ] <- b_names_il$lat[ b_names_il$borough == 'K&C' ] - 1000


# Do the graph with annotation
iL_price <- ggplot( filter( lp , inner_london ), 
                    aes(long, lat, group = borough , fill = price ) ) +
  geom_polygon() + 
  geom_path( colour='white', lwd=0.05 ) + 
  coord_equal() +
  geom_text( data = b_names_il ,
             aes( long, lat, label = borough ), size = 2 ) +
  labs(x = 'lat', y = 'lon',
       fill = 'Price') +
  scale_fill_gradientn(colours=pal,
                       na.value = 'grey', name = '',
                       limits = c( 0 , 400 )) +
  ggtitle('Average hotel prices: inner-London ($,2017)') +
  theme_map() 
iL_price

# Note: `scale_fill_gradientn()` is used to compare the prices with Vienna (have common limits),
#   if comparison is not needed, can use `scale_fill_gradient` or `scale_fill_gradient2`



#####
# Task:
#   Do the same for hotels in Vienna
#    I have let the matching in the codes not to spend time with data-munging...


# Import shp file from https://www.data.gv.at/katalog/dataset/stadt-wien_bezirksgrenzenwien
vienna_map <- readOGR('data_map/BEZIRKSGRENZEOGDPolygon.shp')
head( vienna_map@data,2 )

vienna_map_tibble <- as_tibble( fortify( vienna_map ) )

# allocate an id variable to the sp data
vienna_map$id <- row.names(vienna_map)

# joins the data
vienna_map_tibble <- as_tibble( left_join(vienna_map_tibble, vienna_map@data , by = 'id' ) )
vienna_map <- vienna_map_tibble %>% mutate( district = NAMEK )
rm( vienna_map_tibble )

# Visualize Vienna districts
ggplot( vienna_map , aes(long, lat, group = district ) ) +
  geom_polygon() + 
  geom_path( colour='white', lwd=0.05 ) + 
  coord_equal() +
  theme_bw()+
  ggtitle('Vienna districts') +
  theme_map()

# Matching variable
#                  neighbourhood, district
match_vienna <- c('17. Hernals','Hernals',
                  'Graben','Innere Stadt',
                  'Kaerntner Strasse','Innere Stadt',
                  'Landstrasse','Landstra\xdfe',
                  'Rudolfsheim-Funfhaus','Rudolfsheim-F\xfcnfhaus',
                  'Wahring','W\xe4hring',
                  'Schonbrunn','Meidling')

# Rename the variable: if ugly name from vienna_map, use the pretty name instead!
for ( i in 1 : ( length( match_vienna ) / 2 ) ){
  if ( match_vienna[ i*2 - 1 ] %in% c('Landstrasse','Rudolfsheim-Funfhaus','Wahring') ){
    heu$borough[ heu$borough == match_vienna[ i*2 - 1 ] ] <- match_vienna[ i*2 - 1 ]
    vienna_map$district[ vienna_map$district ==  match_vienna[ i *2 ] ] <-  match_vienna[ i*2 - 1 ]
  } else{
    heu$borough[ heu$borough == match_vienna[ i*2 - 1 ] ] <- match_vienna[ i *2 ]
  }
}


# Average prices in vienna districts
v_dist <- heu %>% filter( city_actual == 'Vienna' ) %>%  group_by( borough ) %>% 
  summarise( price = mean( price , na.rm = T ) ) %>% rename( district = borough )

# Check matches ('Vienna' is not identified)
v_dist$district %in% sort(unique( vienna_map$district ))

# add prices
vp <- left_join( vienna_map , v_dist , by = 'district' )

# Get names by each district
v_names <- aggregate( cbind(long, lat) ~ district, 
                      data = vienna_map , FUN=function( x ){ mean( range( x ) ) } )

# Re-set the last ugly names and shorten the followings
v_names$district[ v_names$district == 'D\xf6bling' ] <- 'Dobling'
v_names$district[ v_names$district == 'Rudolfsheim-Funfhaus' ] <- 'R-F'
v_names$district[ v_names$district == 'Innere Stadt' ] <- 'I.S.'
v_names$district[ v_names$district == 'Josefstadt' ] <- 'Josefs.'
v_names$district[ v_names$district == 'Alsergrund' ] <- 'Agrund'
v_names$district[ v_names$district == 'Mariahilf' ] <- 'Mhilf.'
v_names$district[ v_names$district == 'Margareten' ] <- 'Mgaret.'

# Adjust some coordinates for pretty plot
v_names$long[ v_names$district == 'Penzing' ] <- v_names$long[ v_names$district == 'Penzing' ] - 0.02
v_names$long[ v_names$district == 'Hernals' ] <- v_names$long[ v_names$district == 'Hernals' ] - 0.02
v_names$lat[ v_names$district == 'Hernals' ]  <- v_names$lat[ v_names$district == 'Hernals' ] - 0.005



# Create graph for Vienna
V_price <- ggplot( vp, aes(long, lat, group = district , fill = price ) ) +
  geom_polygon() + 
  geom_path( colour='white', lwd=0.05 ) + 
  coord_equal() +
  geom_text( data = left_join( v_names, v_dist , by = 'district' ),
             aes( long, lat, label = district ), size = 2 ) +
  labs(x = 'lat', y = 'lon',
       fill = 'Price') +
  scale_fill_gradientn(colours=pal,
                       na.value = 'grey', name = '',
                       limits = c( 0 , 400 )) +
  ggtitle('Average hotel prices: Vienna ($,2017)') +
  theme_map()

V_price

# Show together with common legend (this is why we use `scale_fill_gradientn()`)
cities_plot <- ggarrange( iL_price + ggtitle('Inner-London')  , 
           V_price  + ggtitle('Vienna') ,
           ncol = 1 , common.legend = TRUE, legend='right' )

annotate_figure(cities_plot, top = text_grob('Average price of a hotel for one night ($)', 
                                      color = 'black', face = 'italic', size = 12))
