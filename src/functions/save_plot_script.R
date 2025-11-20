################################################################
# Script Name: save plot script
# Author: SP  
# GitHub:
# Date Created: 2025.09.26
#
# Purpose: This script creates a function that allows you to
# save plots per preset parameters
#
################################################################

################################################################
# Load necessary libraries/source any function directories
# Example:
library(ggplot2)
library(here)

################################################################
# create function
# save_plot_png.R
save_plot_png <- function(
    plot_name,
    file_name,
    figs_dir = NULL,       # delay evaluation
    width = 1600,
    height = 1100,
    dpi = 300
) {
  if (is.null(figs_dir)) {
    figs_dir <- here::here("report", "figs")  # namespace it
  }
  if (!dir.exists(figs_dir)) dir.create(figs_dir, recursive = TRUE)
  
  ggplot2::ggsave(
    filename = file_name,
    plot = plot_name,
    path = figs_dir,
    device = ragg::agg_png,   # allows units in pixels cleanly
    width = width,
    height = height,
    units = "px",
    dpi = dpi
  )
}

################################################################
# testing!


################################################################
# Code Instructions!
# save_plot_png() saves your plots to a predetermined location
# within your personal dataviz-exercises directory.
# the function uses ggsave() as a helper function and includes 
# paramters that allows you to specify the desired width, height of your plot
# along with the name you want to save the plot as

################################################################
# End of script
