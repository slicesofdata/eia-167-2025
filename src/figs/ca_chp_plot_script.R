################################################################
# Script: California CHP plot script
# Author: MB
# Purpose: This script creates the plot that depicts California CHP generation for the industrial and commercial sectors emissions from 2004-2023

################################################################
# Load necessary libraries/source any function directories

library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(jsonlite)
library(tidyr)
library(eia)
library(quarto)

################################################################
# Load in cleaned data
generation_long <- readRDS(here::here("data", "processed", "chp_cleaned_data.RDS"))
generation_total <- readRDS(here::here("data", "processed", "chp_peak_year_data.RDS"))


################################################################
# Create graph
ca_chp_plot <- ggplot(generation_long, aes(x = year, y = generation)) +
  geom_col(
    aes(fill = sector),
    position = position_dodge(width = 0.6),  
    width = 0.6
  ) +
  scale_x_reverse(
    breaks = unique(generation_long$year),
    expand = expansion(mult = c(0.07, 0.07))
  )+
  scale_y_continuous(
    breaks = seq(0, 18e6, by = 2e6),
    labels = scales::label_number(scale = 1e-6, accuracy = 1),
    expand = c(0, 0), 
    name = "Net Generation (million MWh)"
  ) +  
  scale_fill_manual(
    values = c("commercial" = "#F8766D", "industrial" = "#00BA38"),
    labels = c("Commercial", "Industrial")
  ) +
  geom_smooth(
    aes(group = sector),
    method = "loess", se = FALSE,
    size = 1,
    color = "gray40",
    linetype = "solid",
    show.legend = FALSE
  ) +
  
  geom_text(
    data = generation_long |> filter(sector == "industrial", year == min(year)),
    aes(label = "Industrial Trend Line"),
    nudge_x = 1,
    color = "gray30",
    size = 3,
    fontface = "bold"
  ) +
  geom_text(
    data = generation_long |> filter(sector == "commercial", year == min(year)),
    aes(label = "Commercial Trend Line"),
    nudge_x = 1,
    color = "gray30",
    size = 3,
    fontface = "bold"
  ) +
  geom_vline(xintercept = peak_year, linetype = "dashed", color = "gray40") +
  annotate( 
    "text", 
    x = peak_year - -0.6, 
    y = max(generation_total$total_gen) * 1.03, 
    label = paste0("Highest Combined\nCHP: ", peak_year), 
    color = "gray40", fontface = "italic", 
    size = 3.8, 
    hjust = 1, 
    vjust = 1
  )+
  labs(
    title = "California Combined Heat & Power (CHP) Net Generation by Sector",
    subtitle = "Industrial CHP output has sharply declined since 2014, while Commercial CHP has remained stable",
    caption = "Source: U.S. Energy Information Administration (EIA)",
    x = "Year",
    y = "Net Generation (MWh)",
    fill = "Sector"
  ) +
  coord_flip(clip = "off") +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    panel.grid.major.x = element_line(color = "gray80", linewidth = 0.4),
    panel.grid.minor.x = element_blank(),
    axis.ticks.x = element_line(color = "gray80", linewidth = 0.5)
  )
ca_chp_plot

################################################################################
# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = ca_chp_plot,
  file_name = "ca_chp_plot.png",
  height = 1750,
  width = 2500
)

