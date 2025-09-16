################################################################################
# Script Name: clean_mpg_data.R
# Author: slicesofdata
# GitHub: slicesofdata
# Date Created:
#
# Purpose: This script will read raw data and process/clean it and write 
# out the cleaned data.
#
################################################################################

################################################################################
# Note: When sourcing script files, if you do not want objects
# available in this script, use the source() function along with
# the local = TRUE argument. By default, source() will make
# objects available in the current environment.

################################################################################
# Load necessary libraries/source any function directories
library(dplyr)

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
saveRDS(cleaned_mpg, "cleaned_mpg.Rds")
# save the cleaned data file
cleaned_mpg |>
  saveRDS("cleaned_mpg.Rds")

################################################################################
# End of script
fs::file_exists(here::here("data", "processed", "cleaned_mpg.Rds"))


here::here()
?here::here
fs::file_exists(here::here("src", "data", "cleaned_mpg.Rds"))
git switch dev
