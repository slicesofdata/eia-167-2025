################################################################################
# Script Name: California CO2 emissions data cleaning
# Author:
# GitHub:
# Date Created:
#
# Purpose: This script cleans the data that focuses on California CO2 emissions from 2001-2024
################################################################################
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
(DATA_new <- eia_data(
  dir = "co2-emissions/co2-emissions-aggregates",
  data = "value",
  facets = list(
    sectorId = c("CC", "RC", "IC"),  
    stateId = "CA"                    
  ),
  freq = "annual",
  start = "2001",
  sort = list(cols = "period", order = "asc")
))
################################################################################
#Save DATA locally
write_csv(DATA_new, here("data", "raw", "ca_co2_emissions.csv"))
DATA_new <- read.csv(here::here("data","raw","ca_co2_emissions.csv"))
head(DATA_new)
str(DATA_new)
################################################################################
# Change period to date and removed unnecessary columns

DATA_co2 <- DATA_new |>
  rename(date = period) |>
  select(-stateId, -sector.name, -state.name, -fuelId, -value.units) |>
  mutate(
    sectorId = recode(sectorId,
                      "CC" = "Commercial",
                      "IC" = "Industrial",
                      "RC" = "Residential")
  ) |>
  filter(fuel.name != "All Fuels")
DATA_co2
################################################################
# Save cleaned DATA file
saveRDS(DATA_co2, here("data", "processed", "ca_co2_emissions_cleaned.Rds"))

################################################################
# Aggregate emissions by year/sector/source + save data
DATA_co2_agg <- DATA_co2 |>
  group_by(date, sectorId, fuel.name) |>
  summarize(total_emissions = sum(value), .groups = "drop")

saveRDS(DATA_co2_agg, here("data", "processed", "ca_co2_emissions_sector_year.Rds"))
