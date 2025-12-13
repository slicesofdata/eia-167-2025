library(eia)
library(eia)
eia_set_key("691CaCVU6nBd4z3hAYPfZ1v4sBnLtb9SNu3xc4IU")

library(dplyr)
library(ggplot2)
library(readr)    # for parse_number()
library(here)
library(fs)

################################################################################
# ...
eia_dir()
eia_dir("co2-emissions")

library(eia)
library(dplyr)
library(tidyr)
library(ggplot2)

# make sure your key is set:
# eia_set_key("YOUR_KEY")  # or via .Renviron as we discussed

# What filters (facets) does this dataset support?

# packages
library(eia)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)

# make sure your key is set (one of these should be true)
# eia_set_key("YOUR_EIA_KEY")  # or have EIA_KEY in .Renviron and restart R

# 1) sanity check the directory you’re using
library(dplyr)
library(ggplot2)
library(scales)

sector_names <- c(RES = "Residential",
                  COM = "Commercial",
                  IND = "Industrial")

tx_sales_annual <- tx_sales_raw %>%
  mutate(
    sales  = as.numeric(sales),
    Sector = dplyr::recode(sectorid, !!!sector_names),
    Year   = as.integer(substr(period, 1, 4))
  ) %>%
  group_by(Year, Sector) %>%
  summarise(Sales_MWh = sum(sales, na.rm = TRUE), .groups = "drop")

saveRDS(tx_sales_raw, "src/data/tx_sales_raw.Rds")

# -------- Year-over-year growth table used by volatility graph --------
tx_growth <- tx_sales_annual %>%
  arrange(Sector, Year) %>%
  group_by(Sector) %>%
  mutate(
    yoy_growth = (Sales_MWh / lag(Sales_MWh) - 1) * 100
  ) %>%
  ungroup()

saveRDS(tx_growth, "src/data/tx_growth.Rds")
tx_growth <- readRDS("src/data/tx_growth.Rds")




