################################################################################
# Script Name: EIA Coal Data Summary
# Author: SP
# GitHub:
# Date Created: 2025.09.22
#
# Purpose: This script ...
#
################################################################################

################################################################################
# Note: When sourcing script files, if you do not want objects
# available in this script, use the source() function along with
# the local = TRUE argument. By default, source() will make
# objects available in the current environment.

################################################################################
# Load necessary libraries/source any function directories
# Example:
#R.utils::sourceDirectory(here::here("src", "functions"))
source(here::here("src", "functions", "load-libraries.R"))
library(dplyr)
library(here)
library(readr)
library(eia)

################################################################################
# read in cleaned data
DATA <- readRDS(here::here("data", "processed", "clean_coal_price_by_rank_state.Rds"))

View(DATA)

################################################################################
# find average coal price across different coal sub-types by state and year
avg_overall_price <- DATA |>
  group_by(year, state) |>
  summarize(mean_price = mean(price)) 

saveRDS(avg_overall_price, file = here::here("data", "processed", "avg_overall_coal_price.Rds"))



################################################################################
# find minimum and maximum price of each coal type across time period 
# and corresponding state
min_max_coal_price <- DATA |>
    group_by(year, coal_type) |>
    summarize(across(.cols = price,
                      .fns = list(min = ~min(.x),
                                  max = ~max(.x))),
                     min_state = state[which.min(price)],
                     max_state = state[which.max(price)]
    )
                
saveRDS(min_max_coal_price, file = here::here("data", "processed", "min_max_coal_price_across_type.Rds"))


################################################################################
# End of script
