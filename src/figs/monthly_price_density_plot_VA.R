################################################################
# Script Name: Monthly Price Density Sina PLot
# Author: SP
# GitHub:
# Date Created: 10/07/25
#
# Purpose: 
#


################################################################
# Load necessary libraries/source any function directories

library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)

#read in data
PRICES <- read_rds(here("data", "processed", "monthly_price_density_clean_VA.rds"))



PRICES <- PRICES |>
  mutate(
    month = factor(month,
                   levels = c("Dec", "Nov", "Oct", "Sep", "Aug", "Jul",
                 "Jun", "May", "Apr", "Mar", "Feb", "Jan"),
             ordered = TRUE
    )
  )




# make violin plot
(price_violin <- PRICES |>
    mutate(Sector = factor(Sector,
                    levels = c("residential", "commercial", "industrial"),
                    labels = c("Residential", "Commercial", "Industrial")
      ))
       |>
    ggplot(mapping = aes(y = price, x = month, fill = Sector)) +
    geom_violin(alpha = 0.7) +
    coord_flip() +
    facet_wrap(facets = vars(Sector),
               ncol = 1)  +
    scale_y_continuous(breaks = seq(4, 16, 1)) +
    labs(title = "Seasonal Variation in Virginia Electricity by Sector",
        y = "Price (cents per kilowatt-hour)",
        x = "Month") +
    guides(fill = "none") +
    theme_minimal() +
    scale_fill_manual(values = c(
      Commercial  = "#F8766D",
      Industrial  = "#00BA38",
      Residential = "#619CFF"
    )) +
    stat_summary(
      fun = median,
      geom = "point",
      color = "black",
      size = 1,
      show.legend = FALSE
    )
)

# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = price_violin,
  file_name = "monthly_price_density_by_sect_plot_VA.png",
  height = 2000,
  width = 1700
)
