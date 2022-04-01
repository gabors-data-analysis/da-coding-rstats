#################################
##        CLASS 4              ##
##    GGPLOT in-depth          ##
## my first external function: ##
##    your own theme           ##
#################################

theme_bluewhite <- function( base_size = 11, base_family = "") {
  # Inherit the basic properties of theme_bw
  theme_bw() %+replace% 
    # Replace the following items:
    theme(
      # The grids on the background
      panel.grid.major  = element_line(color = "white"),
      # The background color
      panel.background  = element_rect(fill = "lightblue"),
      # the axis line
      axis.line         = element_line(color = "red"),
      # Littel lines called ticks on the axis
      axis.ticks        = element_line(color = "steelblue"),
      # Numbers on the axis
      axis.text         = element_text(color = "navyblue")
    )
}
