################################################################
# Script CA Energy Customer Accounts Plot
# Author:
# GitHub:
# Date Created:
################################################################

################################################################
# Note: When sourcing script files, if you do not want objects
# available in this script, use the source() function along with
# the local = TRUE argument. By default, source() will make
# objects available in the current environment.

################################################################
# Load necessary libraries/source any function directories

library (ggplot2)
customers_CA_1 <- readRDS(here("data", "processed", "CA_customer_data_cleaned.Rds"))

Customer_average <- customers_CA_1 %>%
  group_by(sectorName, year) %>%
  summarize(mean_customers_by_year = mean(customers, na.rm = TRUE), .groups = "drop")
################################################################
# Create graph
library(scales)


ca_accounts_plot <- ggplot() +
  geom_jitter(
    data = customers_CA_1,
    aes(x = year, y = customers, color = sectorName),
    alpha = 0.35,
    size = 1.5,
    width = 0.15, height = 0
  ) +
  geom_point(
    data = Customer_average,
    aes(x = year, y = mean_customers_by_year, color = sectorName),
    size = 3
  ) +
  geom_line(
    data = Customer_average,
    aes(x = year, y = mean_customers_by_year, color = sectorName, group = sectorName),
    size = 1
  ) +
  scale_y_continuous(
    labels = label_number(scale = 1/1e6)
  ) +
  labs(
    title = "California Energy Customer Accounts by Sector",
    subtitle = "Residential customers drive the majority of account growth",
    x = "Year",
    y = "Customer Accounts (in millions)",
    color = "Sector"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 0, hjust = 0.5),
    panel.grid.major.x = element_line(color = "gray80", linewidth = 0.4),
    panel.grid.minor.x = element_blank(),
    axis.ticks.x = element_line(color = "gray80", linewidth = 0.5),
    plot.margin = margin(10, 20, 10, 10)
  )
ca_accounts_plot


################################################################################
# save plot
source(here::here("src", "functions", "save_plot_script.R"))
save_plot_png(
  figs_dir = here("figs"),
  plot_name = ca_accounts_plot,
  file_name = "ca_accounts_plot.png",
  height = 1500,
  width = 3000
)

