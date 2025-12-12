
# Electricity Price Trends: U.S., California, Texas, Virginia
# Faceted LOESS trends with peak labels (simplified + class-compatible)


library(eia)
library(dplyr)
library(ggplot2)
library(scales)

#CONFIG
EIA_KEY    <- "vdIZU7HkrdJPcABsIsWTxL2WS71R31JUV62pgNJv"
YEAR_START <- 2001

STATES <- c("US", "CA", "TX", "VA")

LINE_COLORS <- c(
  "United States" = "#1f77b4",
  "California"    = "#d62728",
  "Texas"         = "#2ca02c",
  "Virginia"      = "#9467bd"
)

eia_set_key(EIA_KEY)

# GET DATA
state_raw <- eia_data(
  dir    = "electricity/retail-sales",
  data   = "price",
  facets = list(stateid = STATES),
  freq   = "annual",
  start  = as.character(YEAR_START),
  sort   = list(cols = "period", order = "asc")
)

state_prices <- state_raw %>%
  mutate(
    year  = as.integer(substr(period, 1, 4)),
    state = case_when(
      stateid == "US" ~ "United States",
      stateid == "CA" ~ "California",
      stateid == "TX" ~ "Texas",
      stateid == "VA" ~ "Virginia"
    ),
    price_cents_kWh = as.numeric(price)
  ) %>%
  filter(!is.na(price_cents_kWh), year >= YEAR_START)

first_year  <- min(state_prices$year, na.rm = TRUE)
latest_year <- max(state_prices$year, na.rm = TRUE)

# Fix facet order
state_prices <- state_prices %>%
  mutate(state = factor(
    state,
    levels = c("United States", "California", "Texas", "Virginia")
  ))

#  PEAK LABELS 
peak_labels <- state_prices %>%
  group_by(state) %>%
  filter(price_cents_kWh == max(price_cents_kWh)) %>%
  slice(1) %>% 
  ungroup() %>%
  mutate(
    label = paste("Peak: ", round(price_cents_kWh, 1), "¢ (", year, ")"),
    label_y = case_when(
      state == "California" ~ price_cents_kWh - 2,
      TRUE                  ~ price_cents_kWh + 2
    ),
    label_x = case_when(
      state == "California" ~ year - 7,
      TRUE                  ~ year - 6.7
    )
  )

#FINAL PLOT
p_states <- ggplot(state_prices, aes(x = year, y = price_cents_kWh)) +
  geom_point(color = "grey55", size = 0.9, alpha = 0.7) +   # smaller points
  geom_smooth(
    aes(color = state),
    method = "loess",
    se = TRUE,
    span = 0.6,
    linewidth = 1.2,
    alpha = 0.35
  ) +
  geom_point(
    data = peak_labels,
    aes(x = year, y = price_cents_kWh, color = state),
    size = 2
  ) +
  geom_text(
    data = peak_labels,
    aes(x = label_x, y = label_y, label = label, color = state),
    size = 3,
    show.legend = FALSE
  ) +
  facet_wrap(~ state, ncol = 2) +
  scale_color_manual(values = LINE_COLORS, guide = "none") +
  scale_x_continuous(breaks = seq(first_year, latest_year, 4)) +
  labs(
    title = paste(
      "Electricity Price Trends in the U.S., California, Texas, and Virginia (",
      first_year, "–", latest_year, ")"
    ),
    subtitle = "Annual average retail electricity prices with LOESS trends, uncertainty bands, and peak-price labels",
    x = "Year",
    y = "Price (¢/kWh)"
  ) +
  theme_minimal(base_size = 12.5) +
  theme(
    plot.title    = element_text(face = "bold", size = 9, hjust = 0.5),
    plot.subtitle = element_text(size = 8, hjust = 0.5, margin = margin(b = 8)),
    strip.text    = element_text(face = "bold"),
    axis.title.y  = element_text(size = 9),
    axis.title.x  = element_text(size = 9),
    panel.grid.minor  = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(linewidth = 0.3, color = "grey85"),
    axis.text.x       = element_text(size = 9)
  )

print(p_states)