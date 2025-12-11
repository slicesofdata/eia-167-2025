################################################################################
# Script Name: California CO2 emissions Graph Plot
# Author:
# GitHub:
# Date Created:
#
# Purpose: This script creates the plot that depicts California CO2 emissions from 2001-2024
#
################################################################################
library (ggplot2)
library(dplyr)
library(here)
library(readr)
sector_colors <- c(
  "Commercial" = "#E57373",
  "Industrial" = "#4CAF50",
  "Residential" = "#64B5F6"
)

################################################################################
# Source Data
DATA_co2 <- readRDS(here::here("data", "processed", "ca_co2_emissions_cleaned.Rds"))
DATA_co2_agg <- readRDS(here::here("data", "processed", "ca_co2_emissions_sector_year.Rds"))
################################################################################
# Create Plot
ca_co2_emissions <- ggplot(DATA_co2_agg, aes(x = date, y = total_emissions, color = sectorId)) +
  geom_line(linewidth = 1.1, alpha = 0.9) +
  
  facet_wrap(~ fuel.name, scales = "free_y") +
  
  scale_color_manual(values = sector_colors) +
  
  scale_y_continuous(
    breaks = scales::pretty_breaks(n = 6),
    labels = scales::number_format(accuracy = 0.1)
  ) +
  
  labs(
    title = "California CO2 Emissions by Fuel Source (2001–2022)",
    subtitle = "Fuel related CO2 emissions for commercial, industrial, and residential sectors",
    x = "Year",
    y = "MMT CO2 Emissions",
    color = "Sector",
    caption = "Data: U.S. EIA — CO2 Emissions"
  ) +
  
  theme_minimal(base_size = 15) +
  theme(
    plot.title = element_text(
      hjust = 0.5, face = "bold", size = 20
    ),
    plot.subtitle = element_text(
      hjust = 0.5, size = 14, color = "gray20"
    ),
    plot.caption = element_text(
      size = 10, hjust = 0, color = "gray30"
    ),
    
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 11),
    legend.key.width = unit(1.4, "cm"),
    
    axis.title.y = element_text(face = "bold"),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    
    axis.ticks.x = element_line(color = "gray60"),
    axis.ticks.y = element_line(color = "gray60"),
    
    strip.text = element_text(
      size = 16, face = "bold"
    ),
    strip.background = element_rect(
      fill = "gray95", color = NA
    ),
    
    panel.grid.major.y = element_line(color = "gray85"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    
    plot.margin = margin(12, 18, 12, 12)
  )
ca_co2_emissions

################################################################################
# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = ca_co2_emissions,
  file_name = "ca_co2_emissions_plot.png",
  height = 1500,
  width = 2750
)

