# Script Name: Fuel Mix PLot
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
GEN <- read_rds(here("data", "processed", "fuel_mix_gen_clean_VA.rds"))

View(GEN)

#stacked bar plot
FUEL_MIX <- GEN |>
  mutate(fueltypeid = recode(fueltypeid,
                             COW = "Coal",
                             NG  = "Natural Gas",
                             HYC = "Hydroelectric",
                             SUN = "Solar"
  )) |>
  mutate(fueltypeid = factor(fueltypeid,
                             levels = c("Coal", "Natural Gas", "Hydroelectric", "Solar")
  )) |>
  filter(Year >= max(Year) - 4) |>
  group_by(Year) |>
  mutate(total_gen = sum(generation),
         share = generation / total_gen) |>
  ungroup()
  
View(FUEL_MIX)

# omit WND and ALl (WND too small to be visible in stacked bar plot)
(fuel_mix_plot <- FUEL_MIX |>
  ggplot(aes(x = factor(Year),
             y = share,
             fill = fueltypeid)) +
  geom_bar(stat = "identity", width = 0.9) +
  scale_y_continuous(labels = scales::percent_format(),
                     expand = c(0, 0)) +
  labs(
    title = "Virginia Electricity Generation Fuel Mix by Year",
    subtitle = "Fuel types arranged from higher- to lower-emissions sources",
    x = "Year",
    y = "Fuel Share (%)",
    fill = "Fuel Type"
  ) +
    scale_fill_manual(
      values = c(
        "Coal"          = "#4D4D4D",
        "Natural Gas"   = "#1F78B4",
        "Hydroelectric" = "#1B9E77",
        "Solar"         = "#FDBF11"
      )
    ) +
  theme_minimal())


# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = fuel_mix_plot,
  file_name = "fuel_mix_plot_VA.png"
)

