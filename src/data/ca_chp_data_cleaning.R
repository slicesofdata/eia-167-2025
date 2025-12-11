################################################################
# Script California CHP Data cleaning script
# Author: MB
# Purpose: This script cleans the data that focuses on California CHP generation for the industrial and commercial sectors emissions from 2004-2023

################################################################
# Load necessary libraries/source any function directories

library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
eia_dir("electricity/state-electricity-profiles")
generation_CA <- eia_data(
  dir = "electricity/state-electricity-profiles/source-disposition",
  data = c("combined-heat-and-pwr-comm",
           "combined-heat-and-pwr-indust"),
  facets = list(
    state = "CA"
  ),
  freq = "annual",
  start = "2004",
  sort = list(cols = "period", order = "asc")
)
generation_CA
################################################################
# Clean data
generation_CA_cleaned <- generation_CA |>
  rename(year = period) |>
  select(
    year,
    commercial = `combined-heat-and-pwr-comm`,
    industrial = `combined-heat-and-pwr-indust`
  ) |>
  mutate(
    commercial = as.numeric(commercial),
    industrial = as.numeric(industrial),
    year = as.numeric(year) 
  )

generation_CA_cleaned

################################################################
# Pivot data for plotting
generation_long <- generation_CA_cleaned %>%
  pivot_longer(
    cols = c(commercial, industrial),
    names_to = "sector",
    values_to = "generation"
  ) %>%
  mutate(year = as.numeric(year))
generation_long

################################################################
#Compute total generation per year (Commercial + Industrial)
generation_total <- generation_CA_cleaned %>%
  mutate(total_gen = commercial + industrial) %>%
  select(year, total_gen)
generation_total

################################################################
#Store year with largest generation
peak_year <- generation_total %>%
  filter(total_gen == max(total_gen)) %>%
  pull(year)
peak_year

################################################################
# Save cleaned data
saveRDS(generation_long, here("data", "processed", "chp_cleaned_data.RDS"))
saveRDS(generation_total, here("data", "processed", "chp_peak_year_data.RDS"))
