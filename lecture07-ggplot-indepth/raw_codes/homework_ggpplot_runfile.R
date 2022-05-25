#########################
#                       #
#   Homework for        #
#      ggplot in-depth  #
#                       #
#    Deadline:          #
#                       #
#                       #
#                       #
#########################

##
# Create your own theme for ggplot!
#   
# 0) Clear your environment

# 1) Load tidyverse 

# 2) use the same dataset as in class:
df <- read_csv( "https://raw.githubusercontent.com/gabors-data-analysis/da-coding-rstats/main/lecture07-ggplot-indepth/data/hotels-vienna-london.csv" )

# 3) Call your personalized ggplot function

# 4) Run the following piece of command:
ggplot( filter( df , city == 'Vienna' ) , aes( x = price ) ) +
  geom_histogram( alpha = 0.8, binwidth = 20 ) +
  labs(x='Hotel Prices in  Vienna',y='Density')+
  theme_YOURFUNCTIONNAME()



