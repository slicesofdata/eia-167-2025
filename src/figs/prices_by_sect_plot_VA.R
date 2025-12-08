################################################################
# Script Name: Electricity Prices Cleaned Data (VA)
# Author: SP
# GitHub:
# Date Created: 10/07/25
#
# Purpose: 
#


################################################################
# Load necessary libraries/source any function directories
# Import data from API
install.packages("readr")
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
install.packages("eia")
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")

PRICES <- read_rds(here("data", "processed", "by_sector_clean_VA.rds"))

PRICES_AVG <- PRICES |>
  group_by(sectorName, year) |>
  summarize(mean_price_by_year = mean(price, na.rm = TRUE), .groups = "drop")


################################################################
# Create Plot
PRICES <- PRICES |>
  mutate(year = as.numeric(year))

PRICES_AVG <- PRICES_AVG |>
  mutate(year = as.numeric(year))


(plot <- ggplot(PRICES, aes(x = year, y = price, color = sectorName)) +
  geom_jitter(alpha = 0.4, size = 1) +   
  geom_point(data = DATA_AVG, 
             aes(x = year, y = mean_price_by_year, color = sectorName), 
             size = 2.5) +               
  geom_line(data = PRICES_AVG, 
            aes(x = year, y = mean_price_by_year, color = sectorName, group = sectorName),
            size = 1) +                  
  labs(
    title = "Virginia Retail Energy Prices by Sector",
    x = "Year", 
    y = "Price (cents per kWh)",
    color = "Sector"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  scale_color_manual(
    values = c(
      commercial  = "#F8766D",
      industrial  = "#00BA38",
      residential = "#619CFF"
    ),
    labels = c(
      "commercial" = "Commercial",
      "industrial" = "Industrial",
      "residential" = "Residential")
  )
  )

#save png
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = plot,
  file_name = "energy_by_sector_plot_VA.png",
  height = 1500,
  width = 2000
)


    