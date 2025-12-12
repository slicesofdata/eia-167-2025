# U.S. Electricity Prices by Sector (Line Plot with Shapes + Shaded Events)


library(eia)
library(dplyr)
library(ggplot2)
library(scales)

#  CONFIG 
EIA_KEY    <- "vdIZU7HkrdJPcABsIsWTxL2WS71R31JUV62pgNJv"
YEAR_START <- 2001

SECTORS <- c("RES", "COM", "IND")

COLORS <- c(
  "Residential" = "#1f77b4",
  "Commercial"  = "#d62728",
  "Industrial"  = "#2ca02c"
)

SHAPES <- c(
  "Residential" = 16,  # circle
  "Commercial"  = 17,  # triangle
  "Industrial"  = 15   # square
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
  filter(!is.na(price_cents_kWh), year >= YEAR_START)

first_year  <- min(us_prices$year, na.rm = TRUE)
latest_year <- max(us_prices$year, na.rm = TRUE)

# LINE PLOT 
p_line <- ggplot(us_prices, aes(x = year, y = price_cents_kWh)) +
  # Shaded region: Financial Crisis
  annotate(
    "rect",
    xmin = 2008, xmax = 2009,
    ymin = -Inf, ymax = Inf,
    fill = "grey80", alpha = 0.25
  ) +
  annotate(
    "text",
    x = 2008.5, y = Inf,
    label = "Financial\nCrisis",
    vjust = 2.0,
    size = 2.5,
    color = "grey20"
  ) +
  # Shaded region: COVID-19
  annotate(
    "rect",
    xmin = 2020, xmax = 2021,
    ymin = -Inf, ymax = Inf,
    fill = "grey80", alpha = 0.25
  ) +
  annotate(
    "text",
    x = 2020.2, y = Inf,
    label = "COVID-19\nPandemic",
    vjust = 2.0,
    size = 2.5,
    color = "grey20"
  ) +
  # Lines + points
  geom_line(aes(color = sector), linewidth = 1.0) +
  geom_point(aes(color = sector, shape = sector), size = 2.2) +
  scale_color_manual(values = COLORS, name = "Sector") +
  scale_shape_manual(values = SHAPES, name = "Sector") +
  scale_x_continuous(
    breaks = seq(first_year, latest_year, 2)
  ) +
  labs(
    title = paste("U.S. Electricity Prices by Sector (", first_year, "–", latest_year, ")", sep = ""),
    subtitle = "Shaded regions highlight major economic event periods",
    x = "Year",
    y = "Price (¢/kWh)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", size = 10, hjust = 0.5),
    plot.subtitle = element_text(size = 8, hjust = 0.5, margin = margin(b = 6)),
    axis.title.x  = element_text(size = 9),
    axis.title.y  = element_text(size = 9),
    legend.title  = element_text(face = "bold", size = 9),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    axis.text.x   = element_text(angle = 45, hjust = 1)
  )

print(p_line)