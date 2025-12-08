################################################################
# Script Name: Electricity Prices Cleaned Data (VA)
# Author: SP
# GitHub:
# Date Created: 10/07/25
#
# Purpose: 
#

#install packages
install.packages("readr")
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
library(gridExtra)
install.packages("eia")
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")
eia_metadata("natural-gas/pri/sum")

#read in data
NATURAL_GAS_VA_PRICES_AVG <- read_rds(here("data", "processed", "ng_prices_clean_VA.rds"))
PRICES <- read_rds(here("data", "processed", "by_sector_clean_VA.rds"))

View(NATURAL_GAS_VA_PRICES_AVG)
View(PRICES)

PRICES <- PRICES |>
  filter(sectorName == "commercial" | sectorName == "residential") |>
  group_by(year, sectorName) |>
  mutate(mean_price = mean(price, na.rm = TRUE)) |>
  select(sectorName, year, mean_price) |>
  mutate(year = as.numeric(year)) |>
  unique()

View(PRICES)

PRICES2 <- PRICES |>
  mutate(process = ifelse(sectorName == "commercial", "PCS", "PRS"))

View(PRICES2)

#plot 
(natural_gas_prices_plot <- NATURAL_GAS_VA_PRICES_AVG |> 
  ggplot(aes(x = year, 
             y = mean_ng_price, 
             color = process, 
             group = process)) +
  geom_point() +
  geom_line(size = 0.8) +
  geom_line(
    data = PRICES2, 
    mapping = aes(x = year, y = mean_price, color = "Sector Price"), 
    inherit.aes = FALSE,
    size = 0.8
  ) +
  geom_point(
    data = PRICES2, 
    mapping = aes(x = year, y = mean_price, color = "Sector Price"), 
    inherit.aes = FALSE,
    size = 2
  ) +
  
  labs(
    title = "Effect of Natural Gas Price Changes on Prices",
    x = "Year",
    y = "Mean Price",
    color = "Prices"
  ) +
  
  theme_minimal(base_size = 14) +
  scale_x_continuous(breaks = seq(2001, 2025, by = 4)) +
  scale_y_continuous(breaks = seq(0, 22, by = 3)) +
  scale_color_manual(
    values = c(
      "PCS"            = "#F8766D",  
      "PRS"            = "#619CFF",  
      "Sector Price" = "black"     
    ),
    labels = c(
      "PCS"            = "Commercial NG Price ($/MCF)",
      "PRS"            = "Residential NG Price ($/MCF)",
      "Sector Price" = "Price by Sector"
    )
  ) +
  
  facet_wrap(
    ~ process,
    ncol = 1,
    labeller = labeller(process = c(PCS = "Commercial", PRS = "Residential"))
  ) +
  theme(
    legend.position    = "bottom",
    strip.text         = element_text(size = 14, face = "bold"),
    panel.grid.major.x = element_blank()
  ) +
  guides(
    color = guide_legend(
    title.position = "top",  
    nrow = 2,                
    byrow = TRUE)
  ))


#save png
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = natural_gas_prices_plot,
  file_name = "changes_in_ng_prices_plot_VA.png",
  width = 2500,
  height = 1500
)




