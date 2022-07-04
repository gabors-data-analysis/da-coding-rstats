#########################################
#                                       #
#              Lecture 07               #
#                                       #
#           ggplot in-depth             #
#                                       #
#      - themes                         #
#      - write your own theme           #
#         - call outside script/source  #
#      - manipulating axis              #
#      - adding lines and               #
#          annotations                  #
#      - Commonly used other plots:     #
#        - bar, box, violin             #
#      - theme_bg() and                 #
#         formatting principles in book #
#                                       #
#  Case study:                          #
#   Ch03B Comparing hotel prices        #
#       in Europe: Vienna vs London     #
#                                       #
# Dataset:                              #
#  hotels-europe                        #
#                                       #
#########################################

rm(list= ls())

# Load packages
library(tidyverse)
# ggthemes is providing many built in themes for ggplot
# install.library('ggthemes')
library(ggthemes)
# scales manipulate ggplot in various ways, 
#   we use it here to convert axis numbering to percentages
#install.packages('scales')
library(scales)
# devtools package is for developing tools in R (great package)
#   we use it here to import script/function from web
# Note: usually it is not a good idea to import a script directly from the web
#     due to security reasons. Code can be harmful and run hostile programs...
#     Here we use it to import theme of the book.
# install.packages('devtools')
library(devtools)

#####
# 0) Data import and filter
# Use the london-vienna dataset to introduce different aspects of ggplot

# import the prices and features of hotels
heu_price <- read_csv('https://osf.io/p6tyr/download')
heu_feature <- read_csv('https://osf.io/utwjs/download')
df <- left_join(heu_feature, heu_price, by = 'hotel_id')

# filter
df <- df %>% filter(year == 2017, month == 11, weekend == 0) %>% 
             filter(city %in% c('Vienna','London'),  city_actual %in% c('Vienna','London')) %>% 
             filter(accommodation_type == 'Hotel', stars >= 3 & stars <= 4) %>% 
             filter(price <= 600)

rm(heu_price, heu_feature)


#####
# 1) Use different themes:
#
# Mostly used: theme_bw(), theme_grey(), theme_gray(), theme_linedraw(), theme_light, theme_dark,
#              theme_minimal(), theme_classic(), theme_void()
#       See more on: https://ggplot2.tidyverse.org/reference/ggtheme.html
#
# Some `extra` or nice themes:
#   theme_economist(), theme_stata()
#
# and many others...
#

ggplot(filter(df, city == 'Vienna'), aes(x = price)) +
  geom_histogram(alpha = 0.8, binwidth = 20, color='white',
                  fill = 'navyblue') +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_bw()


##
# Task: 
#   Play around with themes!
#      using 'ggthemes' library

ggplot(filter(df, city == 'Vienna'), aes(x = price)) +
  geom_histogram(alpha = 0.8, binwidth = 20, color='white',
                  fill = 'navyblue') +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_economist()

##
# 2) Creating your own theme -> go the theme_bluewhite function

# Import your source code. 
#   Note: need to be in the working directory or specify the path!
source('theme_bluewhite.R')

# Using our new imported theme
ggplot(filter(df, city == 'Vienna'), aes(x = price)) +
  geom_histogram(alpha = 0.8, binwidth = 20) +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_bluewhite()


###
# 3) Manipulating the axis:
#
# create a ggplot variable
f1 <- ggplot(filter(df, city == 'Vienna'), aes(x = price)) +
          geom_histogram(alpha = 0.8, binwidth = 20, color='white',
                          fill = 'navyblue') +
          labs(x='Hotel Prices in  Vienna',y='Density')+
          theme_bw()
f1

# Set the axis: 
#   1) if continuous variable: `scale_()_continuous`
#   2) if discrete/categorical variable: `scale_()_discrete`

#   a) limit -> changes the limit
f1 + scale_x_continuous(limits = c(0, 300))
#   b) set tickers, called 'breaks'
f1 + scale_x_continuous(limits = c(0, 300), breaks = c(0, 100, 150, 200, 250, 300) )

##
# Task: - use only one graph!
#  1) Set limits between 0  and 500 for x axis
#  2) Set the breaks with binwidth of 50 for X. Use `seq` function instead of typing in each of them!
#  3) set the limits for Y between 0 and 100
#  4) Set the breaks with binwidth of 10 for Y

f1 + scale_x_continuous(limits = c(0, 500) ,
                         breaks = seq(from = 0, to = 500, by = 50)) +
     scale_y_continuous(limits = c(0, 100),
                         breaks = (0 : 10) * 10)



######
# 4) Adding lines, texts, ect. to your graph:
#
# a) Add mean and median as lines and annotate them!
#
# add a line as the mean:

# create a variable yval which sets the height of the line(s)
yval <- 60
f1 <- f1 + geom_segment(aes(x = mean(df$price, na.rm = T), y = 0, 
                    xend = mean(df$price, na.rm = T), yend = yval) ,
                    color = 'red', size = 1)
f1

# add annotation which says it is the mean
f1 <- f1 + 
  annotate('text', x = mean(df$price, na.rm = T) + 20 ,
            y = yval - 5, label = 'Mean', color = 'red')
f1

# Calculate the median as a 50th percentile 
#   (if you wish to add other percentiles as well, otherwise, just use `median`) 

median_price <- quantile(df$price, .50)
# Add both of them to the figure
f1 <- f1 + 
      annotate('text', x = median_price + 10, y = yval + 5 ,
                label = 'Median', color = 'blue') +
      geom_segment(aes(x = median_price, y = 0, 
                    xend = median_price, yend = yval) ,
                    color = 'blue', size = 1)
f1

# Task: 
#   add the 95th percentile to the figure
# advice: create a new variable f2 when trying to write this code
#   here we have redefined the variable f1, however when developing a code
#   it has several drawbacks to redefine a variable! Discuss!

pctg95_price <- quantile(df$price, .95)
f2 <- f1 + 
      annotate('text', x = pctg95_price - 45, y = yval - 5 ,
                label = '95th percentile', color = 'green') +
      geom_segment(aes(x = pctg95_price, y = 0, 
                        xend = pctg95_price, yend = yval) ,
                    color = 'green', size = 1)
f2


##
# 5) Other frequently used plots
#

###
# A) Bar graph:
# Summarize hotels which are close/medium or far away from the city-center:

# Let create a new factor variable
df <- df %>% mutate(dis_f = cut(distance, breaks=c(-1,2,4,100), 
                                             labels = c('close','medium','far')))

# We are curious about how these hotels distribute in the cities
# Summarize the number of close/medium/far hotels

ds0 <- df %>% 
  group_by(city, dis_f) %>% 
  summarise(numObs = n())
ds0

## Do the plot:
f3 <- ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = 'identity', position = 'dodge', width = 0.6,  size = 0.5)+ 
  labs(x = 'Citys', y = 'Number of hotels', fill = 'Distance') +
  theme_bw()
f3

# Make the legends more pretty: put to the top
f3 + scale_fill_discrete(name='Distance from city center:') +
  theme(legend.position = 'top') 


## Stacked bar
ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = 'identity', position = 'stack', width = 0.6,  size = 0.5) +
  labs(x = 'Citys', y = 'Number of hotels') +
  scale_fill_discrete(name='Distance from city center:') +
  theme(legend.position = 'top') 

## Stacked bar with percentages: using scales package
ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = 'identity', position = 'fill', width = 0.6,  size = 0.5) +
  labs(x = 'Citys', y = 'Share of the hotels') +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_discrete(name='Distance from city center:') +
  theme(legend.position = 'top') 


###
# B) Box-plot: great for describe the distribution of the variable in a compact way:
#   Remember: extreme values, lower/upper adjacent = 1.5*IQR, IQR(25%,75%) and median (NO MEAN!)
#
f4 <- ggplot(df, aes(y = price, x = city)) +
  geom_boxplot(color = 'blue', size = 0.5, width = 0.1, alpha = 0.5) +
  labs(x='Cities',y='Price') +
  theme_bw()
f4

# Make it a bit more fancy by adding error-bars
f4 <- f4 + stat_boxplot(geom = 'errorbar', width = 0.05,  size = 0.5, color = 'blue')
f4

# Add the mean as a dot
f4 + stat_summary(fun=mean, geom='point', shape=20, size=5, color='red', fill='red')

###
# C) Violin plot (+boxplot)
#   violin plots adds a kernel density estimator to the boxplot in a neat way
# 
ggplot(df, aes(y = price, x = city)) +
  geom_violin(size=1,  width = 0.5, color = 'blue', 
               fill = 'lightblue', trim = T, show.legend=F, alpha = 0.3) +
  geom_boxplot(color = 'black', fill='lightblue', 
               size = 0.5, width = 0.1, alpha = 0.5,  outlier.shape = NA) +
  labs(x='Cities', y='Price')+
  theme_bw()


###
# 6) theme_bg()
#

# Using devtools package to source a script from the web
source_url('https://raw.githubusercontent.com/gabors-data-analysis/da_case_studies/master/ch00-tech-prep/theme_bg.R')

f4 + theme_bg()


#####
# Extra:
# can be an extra homework or 
#   good for demonstration of a conditional box-plot graph.
#
# Task:
#   1) install and use `grid` and `pBrackets` packages
#   2) create a conditional box-plot for hotel prices, conditioning on the city
#   3) Add error bars to box-plot
#   4) Add conditional mean as dots
#   5) Annotate everything with arrows:
#       `geom_segment(aes(x=,y=,xend=,yend=),arrow=arrow(length=unit(x,'cm')),color=)`
#   6) use theme_bg()
#   7) Instead of using 'color = 'blue'', or other colors, use 'color = color[1]' or color[x]
#       these are defined colors in theme_bg()

#install.packages('grid')
library(grid)
#install.packages('pBrackets')
library(pBrackets) 

ggplot(df, aes(y = price, x = city)) +
  geom_boxplot(color = color[1], size = 0.5, width = 0.1, alpha = 0.5) +
  labs(x='Cities',y='Price') +
  stat_boxplot(geom = 'errorbar', width = 0.05,  size = 0.5) +
  stat_summary(fun=mean, geom='point', shape=20, size=5, color=color[2], fill=color[2]) +
  annotate('text', x = 1.5, y = 255, label = 'Conditional mean') + 
  geom_segment(aes(x = 1.5, y = 240, xend = 1.1, yend = 210),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[2]) +
  geom_segment(aes(x = 1.5, y = 240, xend = 1.9, yend = 120),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[2]) +
  annotate('text', x = 1.5, y = 70, label = 'Conditional median') + 
  geom_segment(aes(x = 1.5, y = 80, xend = 1.1, yend = 180),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[1]) +
  geom_segment(aes(x = 1.5, y = 80, xend = 1.9, yend = 100),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[1]) +
  annotate('text', x = 0.7, y = 100, label = '25th percentile') + 
  geom_segment(aes(x = 0.7, y = 110, xend = 0.9, yend = 130),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[1]) +
  annotate('text', x = 0.7, y = 300, label = '75th percentile') + 
  geom_segment(aes(x = 0.7, y = 280, xend = 0.9, yend = 260),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[1]) +
  annotate('text', x = 1.5, y = 510, label = 'Upper adjecent value:') +
  annotate('text', x = 1.5, y = 490, label = '75th percentile + 1.5*IQR') +
  geom_segment(aes(x = 1.5, y = 475, xend = 1.1, yend = 450),
               arrow = arrow(length = unit(0.15, 'cm')), color = color[3]) +
  theme_bg()





