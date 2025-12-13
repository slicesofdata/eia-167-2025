# data cleaning script for "data center plot"

#install packages

library (ggplot2)
library(here)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(forcats)
library(eia)

eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")

#import data from API
RAW_SALES <- eia_data(
  dir    = "electricity/retail-sales",
  data   = "sales",                        # <-- MWh sold
  facets = list(
    sectorid = c("IND", "COM", "RES"),     # or just "IND" if you only care about industrial
    stateid  = "VA"
  ),
  freq  = "monthly",
  start = "2001",
  sort  = list(cols = "period", order = "asc")
)



#clean data
CLEAN_SALES <- RAW_SALES |>
  filter(sectorName == "commercial") |>
  mutate(Sales = sales) |>
  select(period, Sales) |>
  mutate(Date = ym(period)) |>
  mutate(Year = year(Date)) |>
  select(Date, Year, Sales) |>
  mutate(Sales = as.numeric(Sales))



# save data as RDS
write_rds(CLEAN_SALES, here("data","processed", "industrial_sales_clean_VA.rds"))



