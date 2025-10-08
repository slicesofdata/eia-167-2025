################################################################
# Script 
# Author: Miles Brodey
# GitHub:
# Date Created: 9/18/25
#
# Purpose: 

################################################################
# Load necessary libraries/source any function directories
# Import data from API
install.packages("readr")
library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(eia)
eia_dir()
eia_dir("electricity")
(DATA <- eia_data(
  dir = "electricity/retail-sales",
  data = "price",
  facets = list(sectorid = c("COM", "RES","IND"), stateid = "CA"),
  freq = "monthly",
  start = "2001",
  sort = list(cols = "period", order = "asc")
))
View(DATA)
################################################################

################################################################
#Save DATA locally

write_csv(DATA, here("data", "raw", "CA_retail_price.csv"))
DATA <- read.csv(here::here("data","raw","CA_retail_price.csv"))
head(DATA)
str(DATA)

################################################################
# Change period to date and removed unnecessary columns

DATA <- DATA |>
  rename(date = period) |>
  select(-stateDescription,-stateid,-sectorid,-'price-units') |>
  mutate(price = as.numeric(price))
DATA

################################################################
# Assign proper year/month to the date variable

DATA <- DATA |>
  mutate(
    year = sub("-.*","",date),
    month = sub(".*-", "", date)
  ) |>
  group_by(year)
DATA
View(DATA)
str(DATA)

################################################################
# Save cleaned DATA file
saveRDS(DATA, here("data", "processed", "us_energy_data_cleaned.Rds"))

DATA_AVG <- DATA |>
  group_by(sectorName,year) |>
  summarize(mean_price_by_year = mean(price, na.rm = TRUE), .groups = "drop")
DATA_AVG

################################################################
# Create Plot
DATA <- DATA |>
  mutate(year = as.numeric(year))

DATA_AVG <- DATA_AVG |>
  mutate(year = as.numeric(year))


ggplot(DATA, aes(x = year, y = price, color = sectorName)) +
  geom_jitter(alpha = 0.4, size = 1) +   
  geom_point(data = DATA_AVG, 
             aes(x = year, y = mean_price_by_year, color = sectorName), 
             size = 2.5) +               
  geom_line(data = DATA_AVG, 
            aes(x = year, y = mean_price_by_year, color = sectorName, group = sectorName),
            size = 1) +                  
  labs(
    title = "California Retail Energy Prices by Sector",
    x = "Year", 
    y = "Price (cents per kWh)",
    color = "Sector"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
  
    