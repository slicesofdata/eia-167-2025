# data cleaning script for "change in natural gas prices in va"

#install packages
install.packages("readr")
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
install.packages("eia")
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")

#data for VA Natural Gas Prices
eia_metadata("natural-gas/pri/sum")

#import data
NATURAL_GAS_VA_PRICES <- eia_data(
  dir = "natural-gas/pri/rescom",
  data = "value",
  facets = list(
    duoarea = "SVA",   
    product = "EPG0",   
    process = c("PRS", "PCS") 
  ),
  freq = "monthly",
  start = "2001-07",
  sort = list(cols = "period", order = "asc")
)

# data cleaning
NATURAL_GAS_VA_PRICES <- NATURAL_GAS_VA_PRICES |>
  select(period,
         process,
         value,
         units) |>
  mutate(value = as.numeric(value)) |>
  mutate(date = period) |>
  select(-period)

NATURAL_GAS_VA_PRICES <- NATURAL_GAS_VA_PRICES |>
  mutate(
    year = sub("-.*","",date),
    month = sub(".*-", "", date)
  ) |>
  group_by(year) |>
  select(-date)

NATURAL_GAS_VA_PRICES_AVG <- NATURAL_GAS_VA_PRICES |>
  group_by(year, process) |>
  mutate(mean_ng_price = mean(value, na.rm = TRUE)) |>
  select(process, year, mean_ng_price) |>
  mutate(year = as.numeric(year)) |>
  unique()

#save data as rds file
write_rds(NATURAL_GAS_VA_PRICES_AVG, here("data","processed", "ng_prices_clean_VA.rds"))
