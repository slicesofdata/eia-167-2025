################################################################################
# Script Name: plot_cty_hwy_mpg_point.R
# =Author: Adam Guggenheim
# GitHub: adamaguggenheim
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
library(quarto)


# source a plot saving function script for file uniformity 
# source a plot theme


################################################################################
# read the cleaned data cleaned_mpg.Rds in data/processed 
cleaned_mpg <- readRDS(here::here("data", "processed", "cleaned_mpg.Rds"))


################################################################################
# plot the cleaned data
cty_hwy_point_plot <-
  cleaned_mpg |>
  ggplot(mapping = aes(x = cty, y = hwy)) +
  geom_point()
cty_hwy_point_plot


################################################################################
# save the plot as cty_hwy_mpg_point.png to figs/
ggsave(filename = "figs/cty_hwy_mpg_point.png", 
       plot = cty_hwy_point_plot,
       units = "in",
       #width = , 
       #height = , 
       dpi = "retina",
       create.dir = TRUE)

here::here()
fs::file_exists(here::here("src","figs","plot_cty_hwy_mpg_point.R"))



################################################################################
# End of script
