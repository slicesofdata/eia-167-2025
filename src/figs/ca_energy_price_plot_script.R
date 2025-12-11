################################################################################
# Script Name: California energy price plot script
# Author:
# GitHub:
# Purpose: This script creates the plot that depicts California energy prices from 2014-2025
################################################################################
library (ggplot2)
library(dplyr)
library(here)

################################################################################
# Source data
DATA_price <- readRDS(here::here("data", "processed", "ca_energy_price_cleaned.Rds"))

################################################################################
# Create plot

ca_energy_price_plot <- ggplot(prices_CA_clean, 
       aes(x = year, y = price, fill = sectorName)) +
  geom_boxplot(outlier.alpha = 0.25, width = 0.65, linewidth = 0.5) +
  
  facet_wrap(~ sectorName, scales = "free_y") +
  
  scale_y_continuous(
    labels = scales::number_format(suffix = "¢"),
    breaks = scales::pretty_breaks(n = 6)
  ) +
  
  labs(
    title = "California Monthly Electricity Prices by Sector",
    subtitle = "Monthly distribution of retail prices (2008–2024)",
    x = "Year",
    y = "Retail Price (cents per kWh)",
    caption = "Data: U.S. EIA — Retail Electricity Prices"
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
    
    strip.text = element_text(
      size = 16, face = "bold"
    ),
    strip.background = element_rect(
      fill = "gray95", color = NA
    ),
    
    axis.title = element_text(face = "bold"),
    axis.text.x = element_text(
      size = 12, angle = 45, hjust = 1
    ),
    axis.text.y = element_text(size = 12),
    
    axis.ticks.x = element_line(color = "gray60"),
    axis.ticks.y = element_line(color = "gray60"),
    
    panel.grid.major.y = element_line(color = "gray85"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    
    legend.position = "none",
    
    plot.margin = margin(12, 18, 12, 12)
  )

################################################################################
# save plot

source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = ca_energy_price_plot,
  file_name = "ca_energy_prices_plot.png",
  height = 1500,
  width = 3000
)
