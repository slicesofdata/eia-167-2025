
# U.S. Electricity Prices by Sector (Grouped Bar Chart)


library(eia)
library(dplyr)
library(ggplot2)

# CONFIG
EIA_KEY    <- "vdIZU7HkrdJPcABsIsWTxL2WS71R31JUV62pgNJv"
YEAR_START <- 2001

SECTORS <- c("RES", "COM", "IND")

COLORS <- c(
  "Residential" = "#1f77b4",  # Blue
  "Commercial"  = "#d62728",  # Red
  "Industrial"  = "#2ca02c"   # Green
)

eia_set_key(EIA_KEY)

# GET DATA 
us_raw <- eia_data(
  dir    = "electricity/retail-sales",
  data   = "price",
  facets = list(sectorid = SECTORS, stateid = "US"),
  freq   = "annual",
  start  = as.character(YEAR_START),
  sort   = list(cols = "period", order = "asc")
)

us_prices <- us_raw %>%
  mutate(
    year = as.integer(substr(period, 1, 4)),
    sector = case_when(
      sectorid == "RES" ~ "Residential",
      sectorid == "COM" ~ "Commercial",
      sectorid == "IND" ~ "Industrial"
    ),
    price_cents_kWh = as.numeric(price)
  ) %>%
  filter(!is.na(price_cents_kWh), year >= YEAR_START) %>%
  select(year, sector, price_cents_kWh)

first_year  <- min(us_prices$year, na.rm = TRUE)
latest_year <- max(us_prices$year, na.rm = TRUE)

#  PLOT 
p <- ggplot(us_prices, aes(x = factor(year), y = price_cents_kWh, fill = sector)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = COLORS, name = "Sector") +
  scale_x_discrete(
    breaks = as.character(seq(first_year, latest_year, by = 2))
  ) +
  labs(
    title = paste("U.S. Electricity Prices by Sector (", first_year, "–", latest_year, ")", sep = ""),
    subtitle = "Average retail price (¢/kWh): Residential vs Commercial vs Industrial",
    x = "Year",
    y = "Price (¢/kWh)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold"),
    plot.subtitle   = element_text(margin = margin(b = 6)),
    legend.title    = element_text(face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    axis.text.x      = element_text(angle = 45, hjust = 1)
  )

print(p)