################################################################
# Script Name: Electricity Prices Cleaned Data (VA)
# Author: SP
# GitHub:
# Date Created: 10/07/25
#
# Purpose: 
#


################################################################

library(readr)
library(here)
library(ggplot2)
library(forcats)
library(dplyr)

#load in data 
SAVINGS_CLEAN_FINAL <- readRDS(here("data","processed", "energy_savings_clean_VA.rds"))
View(SAVINGS_CLEAN_FINAL)

# plot changes in energy-savings
(energy_savings_va_plot <- SAVINGS_CLEAN_FINAL |>
  mutate(Year = as.numeric(Year)) |>
  mutate(sectorName = fct_reorder(.f = sectorName,
                                  .x = energy,
                                  .fun = median,
                                  .desc = TRUE)) |>
  ggplot() +
  geom_col(mapping = aes(x= Year, y = energy, 
                         fill = sectorName),
           position = position_dodge2()) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = seq(2013, 2019, by = 1)) +
  labs(y = "Energy Savings (in megwatthours)",
       title = "Energy Savings by Sector in VA",
       fill = "Sector") +
  theme_minimal() +
  scale_fill_manual(values = c(
                            `all sectors` = "#B47CC7",
                            commercial = "#F8766D",
                            industrial = "#00BA38",
                            residential = "#619CFF"),
                    labels = c("All Sectors",
                               "Commercial",
                               "Industrial",
                               "Residential")))



#save png
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = energy_savings_va_plot,
  file_name = "energy_savings_plot_VA.png"
)


