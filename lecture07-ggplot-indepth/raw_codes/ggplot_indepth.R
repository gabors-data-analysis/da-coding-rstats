##################################
##                              ##
##   ggplot in-depth            ##
##      - themes                ##
##      - write own theme       ##
##      - manipulating axis     ##
##      - adding lines and      ##
##          annotations         ##
##      - Commonly used other   ##
##          plots:              ##
##        - bar, box, violin    ##
##                              ##
##    Based on:                 ##
##  Case study - Chapter 03     ##
##                              ##
##  Hotels Europe Data          ##
##                              ##
##################################

rm( list= ls())

# Load packages
library( tidyverse )

# Use the london-vienna dataset to introduce different aspects of ggplot
df <- read_csv( "https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/lecture07-ggplot-indepth/data/hotels-vienna-london.csv" )

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

ggplot( filter( df , city == 'Vienna' ) , aes( x = price ) ) +
  geom_histogram( alpha = 0.8, binwidth = 20 , color='white',
                  fill = 'navyblue') +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_bw()


##
# Task: 
#   Play around with themes!
# may import 'ggthemes' library


##
# 2) Creating your own theme -> go the theme_bluewhite function

# Import your source code. 
#   Note: need to be in the working directory or specify the path!
source("theme_bluewhite.R")

# Using our new imported theme
ggplot( filter( df , city == 'Vienna' ) , aes( x = price ) ) +
  geom_histogram( alpha = 0.8, binwidth = 20 ) +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_bluewhite()


###
# 3) Manipulating the axis:
#
# create a ggplot variable
f1 <- ggplot( filter( df , city == 'Vienna' ) , aes( x = price ) ) +
  geom_histogram( alpha = 0.8, binwidth = 20 , color='white',
                  fill = 'navyblue') +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_bw()
f1

# Set the axis: 
#   1) if continuous variable: `scale_()_continuous`
#   2) if discrete/categorical variable: `scale_()_discrete`

#   a) limit -> changes the l
f1 + scale_x_continuous( limits = c( 0 , 300 ) )
#   b) set tickers, called 'breaks'
f1 + scale_x_continuous( limits = c( 0 , 300 ) , breaks = c( 0 , 100 , 150 , 200 , 250 , 300 )  )

##
# Task: - use only one graph!
#  1) Set limits between 0  and 500 for x axis
#  2) Set the breaks with binwidth of 50 for X. Use `seq` function instead of typing in each of them!
#  3) set the limits for Y between 0 and 100
#  4) Set the breaks with binwidth of 10 for Y



######
# 4) Adding lines, texts, ect. to your graph:
#
# a) Add mean and median as lines and annotate them!
#
# add a line as the mean:

# create a variable yval which sets the height of the line(s)
yval <- 60
f1 <- f1 + geom_segment( aes(x = mean( df$price , na.rm = T ), y = 0, 
                             xend = mean( df$price , na.rm = T ), yend = yval) ,
                         color = 'red', size = 1 )
f1

# add annotation which says it is the mean
f1 <- f1 + 
  annotate( "text" , x = mean( df$price , na.rm = T ) + 20 ,
            y = yval - 5 , label = 'Mean' , color = 'red')
f1

# Calculate the median as a 50th percentile 
#   (if you wish to add other percentiles as well, otherwise, just use `median` ) 

median_price <- quantile( df$price , .50)
# Add both of them to the figure
f1 <- f1 + 
  annotate( "text" , x = median_price + 10 , y = yval + 5 ,
            label = 'Median' , color = 'blue') +
  geom_segment( aes(x = median_price, y = 0, 
                    xend = median_price, yend = yval) ,
                color = 'blue', size = 1 )
f1

# Task: 
#   add the 95th percentile to the figure
# advice: create a new variable f2 when trying to write this code
#   here we have redefined the variable f1, however when developing a code
#   it has several drawbacks to redefine a variable! Discuss!




##
# 5) Other frequently used plots
#

###
# A) Bar graph:
# Summarize hotels which are close/medium or far away from the city-center:

# Let create a new factor variable
df$dis_f <- cut( df$distance , breaks=c(-1,2,4,100) , labels = c('close','medium','far') )

# We are curious about how these hotels distribute in the cities
# Summarize the number of close/medium/far hotels

ds0 <- df %>% 
  group_by( city , dis_f ) %>% 
  summarise( numObs = n())
ds0

## Do the plot:
f3 <- ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.6,  size = 0.5)+ 
  labs(x = "Citys", y = "Number of hotels", fill = "Distance")
f3

# Make the legends more pretty: put to the top
f3 + scale_fill_discrete(name="Distance from city center:") +
  theme(legend.position = "top") 

## Stacked bar
ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = "identity", position = "stack", width = 0.6,  size = 0.5) +
  labs(x = "Citys", y = "Number of hotels") +
  scale_fill_discrete(name="Distance from city center:") +
  theme(legend.position = "top") 

## Stacked bar with percentages
ggplot(ds0, aes(x=city, y=numObs, fill = dis_f)) +
  geom_bar(stat = "identity", position = "fill", width = 0.6,  size = 0.5) +
  labs(x = "Citys", y = "Share of the hotels") +
  scale_fill_discrete(name="Distance from city center:") +
  theme(legend.position = "top") 


###
# B) Box-plot: great for describe the distribution of the variable in a compact way:
#   Remember: extreme values, lower/upper adjacent = 1.5*IQR, IQR(25%,75%) and median (NO MEAN!)
#
f4 <- ggplot(df, aes(y = price, x = city)) +
  geom_boxplot(color = "blue", size = 0.5, width = 0.1, alpha = 0.5) +
  labs(x='Cities',y='Price')
f4

# Make it a bit more fancy by adding error-bars
f4 <- f4 + stat_boxplot(geom = "errorbar", width = 0.05,  size = 0.5, color = 'blue')
f4

# Add the mean as a dot
f4 + stat_summary(fun=mean, geom="point", shape=20, size=5, color="red", fill="red")

###
# C) Violin plot (+boxplot)
#   violin plots adds a kernel density estimator to the boxplot in a neat way
# 
ggplot(df, aes(y = price, x = city)) +
  geom_violin( size=1,  width = 0.5, color = 'blue', fill = 'lightblue', trim = T, show.legend=F, alpha = 0.3) +
  geom_boxplot(color = "black", fill='lightblue', size = 0.5, width = 0.1, alpha = 0.5 ,  outlier.shape = NA) +
  xlab('Cities')+
  ylab('Price')



#####
# Extra:
# can be a homework or 
#   good for demonstration of a conditional box-plot graph.
#
# Task:
#   1) install and use `grid` and `pBrackets` packages
#   2) create a conditional box-plot for hotel prices, conditioning on the city
#   3) Add error bars to box-plot
#   4) Add conditional mean as dots
#   5) Annotate everything with arrows:
#       `geom_segment(aes(x=,y=,xend=,yend=),arrow=arrow(length=unit(x,"cm")),color=)`
#   6) use a theme

