################################################################################
# Script Name: California energy price data cleaning script
# Author:
# GitHub:
# Purpose: This script cleans the data that focuses on California energy prices from 2014-2025
################################################################################
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
library(stringr)
eia_dir("electricity/retail-sales")
sessionInfo()

prices_CA <- eia_data(
  dir = "electricity/retail-sales",
  data = "price",
  facets = list(
    stateid = "CA",
    sectorid = c("RES", "COM", "IND")   
  ),
  freq = "monthly",
  start = "2014",
  sort = list(cols = "period", order = "asc")
)

################################################################################
#Save DATA locally
write_csv(prices_CA, here("data", "raw", "ca_price_data.csv"))

################################################################################
# Clean data

prices_CA_clean <- prices_CA |>
  rename(date = period) |>
  select(-stateDescription,-stateid,-sectorid,-'price-units') |>
  mutate(price = as.numeric(price)) |>
  mutate(
    year = sub("-.*","",date),
    month = sub(".*-", "", date),
    sectorName = str_to_title(sectorName)
  )
prices_CA_clean

################################################################
# Save cleaned DATA file
saveRDS(prices_CA_clean, here("data", "processed", "ca_energy_price_cleaned.Rds"))

################################################################
