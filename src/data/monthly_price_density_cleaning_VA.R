# data cleaning script for "monthly price density"

#install packages
install.packages("readr")
library (ggplot2)
library(here)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(forcats)
library(eia)
install.packages("eia")
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")

#import data from API
RAW_PRICES <- eia_data(
  dir = "electricity/retail-sales",
  data = "price",
  facets = list(sectorid = c("COM", "RES","IND"), stateid = "VA"),
  freq = "monthly",
  start = "2001",
  sort = list(cols = "period", order = "asc"))

glimpse(RAW_PRICES)

#clean data
CLEAN_PRICES <- RAW_PRICES |>
  mutate(
    year      = as.numeric(substr(period, 1, 4)),
    numeric_month = as.numeric(substr(period, 6, 7)),
    date  = as.Date(paste(year, numeric_month, "01", sep = "-")),
    month = factor(
    numeric_month,
    levels = 1:12,
    labels = month.abb
    )
  ) |>
  mutate(
    Sector = factor(sectorName) 
  ) |>
  mutate(price = as.numeric(price)) |>
  select(Sector, year, numeric_month, month, price)

glimpse(CLEAN_PRICES)  

# save plot as RDS
write_rds(CLEAN_PRICES, here("data","processed", "monthly_price_density_clean_VA.rds"))



