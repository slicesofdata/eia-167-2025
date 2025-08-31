################################################################################
# Script Name: plot_cty_hwy_mpg_point.R
# Author: slicesofdata
# GitHub: slicesofdata
# Date Created:
#
# Purpose: This script will: 
# - read the cleaned data, 
# - plot highway by city mpg,
# - save the plot as png
#
################################################################################

################################################################################
# Note: When sourcing script files, if you do not want objects
# available in this script, use the source() function along with
# the local = TRUE argument. By default, source() will make
# objects available in the current environment.

################################################################################
# Load necessary libraries/source any function directories
library(ggplot2)

# source a plot saving function script for file uniformity 
# source a plot theme


################################################################################
# read the cleaned data cleaned_mpg.Rds in data/processed 
cleaned_mpg <- readRDS( <-- path and file name ))


################################################################################
# plot the cleaned data
cty_hwy_point_plot <-
  cleaned_mpg |>
  ggplot(mapping = aes(x = cty, y = hwy)) +
  geom_point()


################################################################################
# save the plot as cty_hwy_mpg_point.png to figs/
ggsave(filename = <-- path to + file name -->, 
       plot = cty_hwy_point_plot,
       units = "in",
       #width = , 
       #height = , 
       dpi = "retina",
       create.dir = TRUE
)


################################################################################
# End of script
