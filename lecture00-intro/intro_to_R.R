#########################
##                     ##
## WELCOME TO R-STUDIO ##
##                     ##
##  THIS IS A SCRIPT   ##
##                     ##
##    Lecture 00       ##
##                     ##
#########################

# Cleaning the environment
#   just to be sure we are in the same setup
rm(list = ls())

# Install a package
install.packages('tidyverse')
# load a package for the work
library(tidyverse)


# There are built-in data:
# mpg is a dataset for cars with different characteristics:
mpg


# It is easy to create a plot to compare:
# engine size (displ) vs. fuel efficiency (hwy)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  labs(y = 'fuel efficiency', x = 'engine size')


# You may say that there are specific groups
#   which are not highlighted by this simple graph
#   it is easy to plot some further patterns...
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  labs(y = 'fuel efficiency', x = 'engine size')


# You may want to quantify these relations
#   First, start with the overall pattern
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  labs(y = 'fuel efficiency', x = 'engine size')

# But it is as easy to refine the graph for more complex patterns:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = class)) +
  labs(y = 'fuel efficiency', x = 'engine size')

# But it may be overcrowded... 
#   No worries, one can easily make multiple graphs as well!
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 3)
  labs(y = 'fuel efficiency', x = 'engine size')
  
  
##
# With R, we can get maps as well:
install.packages('maps')
ggplot(map_data('world'), aes(long, lat, group = group)) +
    geom_polygon(fill = 'white', colour = 'black') +
    coord_quickmap()

##
# Or other pretty cool stuff that we are going to learn through the course!


