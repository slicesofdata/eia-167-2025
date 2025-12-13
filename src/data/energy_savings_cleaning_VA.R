# data cleaning script for "energy savings by sector in VA"

#install packages
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
eia_set_key("BFUmQVFpwdVZiLBLFI9Ds37dDCzPwvS0TbaQj443")

# import electricity savings data
SAVINGS <- eia_data(
  dir = "electricity/state-electricity-profiles/energy-efficiency",
  data = c("energy-savings", "potential-peak-savings"),
  facets = list(state = "VA"),
  freq = "annual",
  start = "2001",
  sort = list(cols = "period", order = "desc")
)


#clean data
SAVINGS_CLEAN <- SAVINGS |>
  mutate(Year = period) |>
  select(-c(period, state, stateName, sector)) |>
  select(Year, everything()) |>
  filter(timePeriod == "Reporting Year") |>
  select(-timePeriod)



SAVINGS_CLEAN_FINAL <- SAVINGS_CLEAN |>
  select(Year, 
         sectorName,
         `energy-savings`) |>
  filter(sectorName != "transportation") |>
  mutate(energy = as.numeric(`energy-savings`)) |>
  select(-`energy-savings`)

#export as rds file
write_rds(SAVINGS_CLEAN_FINAL, here("data","processed", "energy_savings_clean_VA.rds"))
