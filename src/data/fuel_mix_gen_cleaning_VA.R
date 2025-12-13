# data cleaning script for "generation fuel mix plot"

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
RAW_GEN <- eia_data(
  dir    = "electricity/electric-power-operational-data",  
  data   = "generation",                                  
  facets = list(
    location   = "VA",                                   
    sectorid   = "98",                                   
    fueltypeid = c("ALL", "NG", "COW", "SUN", "WND", "HYC")  
  ),
  freq  = "annual",                                       
  start = "2001",
  sort  = list(cols = "period", order = "asc")
)



#clean data
CLEAN_GEN <- RAW_GEN |>
  mutate(generation = as.numeric(generation)) |>
  mutate(Year = period) |>
  mutate(Year = as.numeric(Year)) |>
  select(Year, fueltypeid, generation) |>
  filter(!fueltypeid %in% c("ALL", "WND"))



#save data as rds
write_rds(CLEAN_GEN, here("data","processed", "fuel_mix_gen_clean_VA.rds"))



