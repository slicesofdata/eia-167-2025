################################################################
# Script: CA Energy Customer Accounts script
# Author: MB
# Purpose: This script creates the plot that depicts California customer accounts for the industrial,commercial, and residential sectors from 2001-2025

################################################################


################################################################
# Load necessary libraries/source any function directories

library (ggplot2)
library(dplyr)
library(here)
library(readr)
library(scales)
library(eia)
eia_dir()
eia_dir("electricity")

customers_CA <- eia_data(
  dir = "electricity/retail-sales",
  data = "customers",   # <-- CHANGE THIS from "price" to "customers"
  facets = list(sectorid = c("COM", "RES", "IND"), stateid = "CA"),
  freq = "monthly",
  start = "2001",
  sort = list(cols = "period", order = "asc")
)
#View(customers_CA)

################################################################
#Save DATA locally

write_csv(customers_CA, here("data", "raw", "CA_customer_accounts.csv"))
customers_CA <- read.csv(here::here("data","raw","CA_customer_accounts.csv"))

################################################################
# Change period to date and removed unnecessary columns 

customers_CA_1<- customers_CA |>
  rename(date = period) |>
  select(-stateDescription,-stateid,-sectorid,-'customers.units')
customers_CA_1

################################################################
# Assign proper year/month to the date variable + filter for 2008 and on because prior dates do not have customer data

customers_CA_1 <- customers_CA_1 |>
  mutate(
    year = sub("-.*","",date),
    month = sub(".*-", "", date)
  ) |>
  filter(year >= 2008) |>
  group_by(year)
customers_CA_1

################################################################
# Save cleaned DATA file
saveRDS(customers_CA_1, here("data", "processed", "CA_customer_data_cleaned.Rds"))

Customer_average <- customers_CA_1 |>
  group_by(sectorName,year) |>
  summarize(mean_customers_by_year = mean(customers, na.rm = TRUE), .groups = "drop")
Customer_average

################################################################
# Create Plot
customers_CA_1 <- customers_CA_1 |>
  mutate(
    year = as.factor(year),
    sectorName = tools::toTitleCase(sectorName) 
  )

Customer_average <- Customer_average |>
  mutate(
    year = as.factor(year),
    sectorName = tools::toTitleCase(sectorName)
  )


ggplot(customers_CA_1, aes(x = year, y = customers, color = sectorName)) +
  geom_jitter(alpha = 0.3, size = 1.5) +   
  
  geom_point(data = Customer_average, 
             aes(x = year, y = mean_customers_by_year, color = sectorName), 
             size = 3) +               
  geom_line(data = Customer_average, 
            aes(x = year, y = mean_customers_by_year, color = sectorName, group = sectorName),
            size = .75) +    
  
  scale_y_continuous(
    labels = label_number(scale = 1e-6),
    breaks = pretty_breaks(n = 6)
  ) +
  
  labs(
    title = "California Energy Customer Accounts by Sector",
    x = "Year", 
    y = "Customer Accounts (in millions)",  
    color = "Sector"
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 0, hjust = 0.5)
  )


ggsave(
  filename = here("figs", "ca_customer_plot_final.png"),
  width = 12,
  height = 5,
  dpi = 300,
  bg = "white"
)
