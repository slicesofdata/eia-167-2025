################################################################
# Script Name: Monthly Price Density Sina PLot ALL
# Author: SP
# GitHub:
# Date Created: 10/07/25
#
# Purpose: 
#


################################################################
# Load necessary libraries/source any function directories
install.packages("readr")
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)

#read in data
PRICES <- read_rds(here("data", "processed", "monthly_price_density_clean_VA.rds"))

View(PRICES)

PRICES <- PRICES |>
  mutate(
    month = factor(month,
                   levels = c("Dec", "Nov", "Oct", "Sep", "Aug", "Jul",
                              "Jun", "May", "Apr", "Mar", "Feb", "Jan"),
                   ordered = TRUE
    )
  )


# all sectors violin plot
(price_violin_all <- PRICES |>
    ggplot(mapping = aes(x = month, y = price)) +
    geom_violin(fill = "#C77CFF", alpha = .7) +
    stat_summary(
      fun  = median,
      geom = "point",
      color = "black",
      size  = 1,
      show.legend = FALSE
    ) +
    scale_y_continuous(breaks = seq(4, 16, 1)) +
    coord_flip() +
    labs(
      title = "Seasonal Variation in Virginia Electricity for All Sectors",
      y     = "Price (cents per kilowatt-hour)",
      x     = "Month"
    ) +
    theme_minimal() +
    theme(legend.position = "none"))

# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = price_violin_all,
  file_name = "monthly_price_density_all_sect_plot_VA.png"
)
