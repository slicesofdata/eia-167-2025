# Script Name: Data Center PLot
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
SALES <- read_rds(here("data", "processed", "industrial_sales_clean_VA.rds"))



SALES_LAST5 <- CLEAN_SALES |>
  filter(Year >= max(Year) - 4)


# line plot
(data_center_plot <- SALES_LAST5 |>
  ggplot(mapping = aes(x = Date, y = Sales)) +
  geom_line(color = "#F28E2B", size = 1.1, alpha = 0.9) +
  geom_smooth(color = "#FF6B6B",
              se = FALSE,
              size = 1,
              alpha = 0.7) +
  scale_y_continuous(labels = scales::comma,
                     breaks = seq(4000, 7500, by = 500)) +
  labs(title = "Commercial Sector Electricity Sales in Virginia in \nLast Five Years",
       subtitle = "Rapid growth in commercial electricity demand reflects \ndata center expansion",
       x = "Time",
       y = "Electricity Sales (MWh)") +
    annotate("text",
             x = as.Date("2022-07-01"),
             y = 7100,
             label = "Monthly \n electricity use",
             color = "#E68613",
             size = 4.5,
             fontface = "bold",
             alpha = 0.8) +
    
    annotate("text",
             x = as.Date("2024-04-01"),
             y = 5700,
             label = "Smooth trend \n (data center growth)",
             color = "#FF6B6B",
             size = 4.5,
             fontface = "bold",
             alpha = .8) +
  theme_minimal()
)

# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = data_center_plot,
  file_name = "data_center_plot_VA.png"
)

