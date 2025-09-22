################################################################################
# Script Name: clean_mpg_data.R
# Author: slicesofdata
# GitHub: slicesofdata
# Date Created:
#
# Purpose: This script will read raw data and process/clean it and write 
# out the cleaned data.

################################################################################
# Load necessary libraries/source any function directories
library(dplyr)
getwd()

################################################################################
# read the raw data
mpg <- readRDS("data/raw/mpg.Rds")
View(mpg)
################################################################################
# clean the data
cleaned_mpg <- 
  mpg |> 
  filter(manufacturer == "audi")
cleaned_mpg

################################################################################
# save the cleaned data file and apply here function
saveRDS(cleaned_mpg, 
        here::here("data", "processed", "cleaned_mpg.Rds")
        )
fs::file_exists(here::here("data", "processed", "cleaned_mpg.Rds"))

################################################################################


