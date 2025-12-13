# data cleaning file for "virginia retail energy prices per sector"

#install packages

library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)

eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")


#data for energy by sector for VA
by_sector_DATA <- eia_data(
  dir = "electricity/retail-sales",
  data = "price",
  facets = list(sectorid = c("COM", "RES","IND"), stateid = "VA"),
  freq = "monthly",
  start = "2001",
  sort = list(cols = "period", order = "asc"))

by_sector_DATA <- by_sector_DATA |>
  rename(date = period) |>
  select(-stateDescription,-stateid,-sectorid,-'price-units') |>
  mutate(price = as.numeric(price))

by_sector_DATA <- by_sector_DATA |>
  mutate(
    year = sub("-.*","",date),
    month = sub(".*-", "", date)
  ) |>
  group_by(year)

#save as RDS
write_rds(by_sector_DATA, here("data","processed", "by_sector_clean_VA.rds"))
