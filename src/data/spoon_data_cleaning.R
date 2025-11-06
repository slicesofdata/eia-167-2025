################################################################
# Script Name: HW2 Clean EIA Dataset
# Author: SP
# GitHub:
# Date Created: 2025.09.22
#
# Purpose: This script ...
#
################################################################

################################################################
# Load necessary libraries/source any function directories
install.packages("eia")
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")
library(ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)


################################################################
# Read in data

eia_dir()      
eia_dir("coal")
eia_metadata("coal/price-by-rank")

eia_facets("coal/price-by-rank", "stateRegionId")


DATA <- eia_data(
  dir    = "coal/price-by-rank",
  data   = "price",
  start = "2001",
  freq = "annual",
  sort = list(cols = "period", order = "asc")
)

View(DATA)
################################################################
# save data in data/raw
write_csv(DATA,  here::here("data", "raw", "coal_price_by_rank_state"))

COAL_DATA <- read_csv(here::here("data", "raw", "coal_price_by_rank_state"))


################################################################
# data cleaning

# price chr to num
COAL_DATA$price <- as.numeric(COAL_DATA$price)

# keep and rename relevant variables & filter out NA values for numeric price

COAL_DATA_CLEAN <- COAL_DATA |>
  select(period, stateRegionId, coalRankId, price, `price-units`) |>
  rename(price_units = `price-units`,
         state = stateRegionId,
         coal_type = coalRankId,
         year = period)|>
  filter(!is.na(price))
    
View(COAL_DATA_CLEAN) 

################################################################
# save cleaned data as .Rds
saveRDS(COAL_DATA_CLEAN, file = here::here("data", "processed", "clean_coal_price_by_rank_state.Rds"))

  
  


################################################################
# End of script


