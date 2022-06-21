#######################################################
#                                                     #
#              Lecture 07                             #
#                                                     #
#           ggplot in-depth                           #
#         `theme_bluewhite()`                         #
#                                                     #
#     first external function:                        #
#          creating your own theme                    #
#                                                     #
# For complete list of theme options                  #
#     see:                                            #
#  https://ggplot2.tidyverse.org/reference/theme.html #
#                                                     #
#######################################################

theme_bluewhite <- function( base_size = 11, base_family = '') {
  # Inherit the basic properties of theme_bw
  theme_bw() %+replace% 
    # Replace the following items:
    theme(
      # The grids on the background
      panel.grid.major  = element_line(color = 'white'),
      # The background color
      panel.background  = element_rect(fill = 'lightblue'),
      # the axis line
      axis.line         = element_line(color = 'red'),
      # Littel lines called ticks on the axis
      axis.ticks        = element_line(color = 'steelblue'),
      # Color and font size for the numbers on the axis
      axis.text         = element_text(color = 'navyblue', size = 8)
    )
}
