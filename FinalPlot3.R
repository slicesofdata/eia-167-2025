# ==============================================================
# Percent Change in U.S. Electricity Prices by Sector (2001 baseline)
# Shows which sectors drive long-run U.S. price growth
# ==============================================================

suppressPackageStartupMessages({
  library(eia)
  library(dplyr)
  library(ggplot2)
  library(tidyr)
  library(scales)
})

# -------------------- CONFIG --------------------
EIA_KEY     <- "vdIZU7HkrdJPcABsIsWTxL2WS71R31JUV62pgNJv"
YEAR_START  <- 2001
SECTORS     <- c("RES", "COM", "IND")
SECTOR_LABS <- c(RES = "Residential", COM = "Commercial", IND = "Industrial")

COLORS <- c(
  "Residential" = "#1f77b4",
  "Commercial"  = "#d62728",
  "Industrial"  = "#2ca02c"
)

SHAPES <- c(
  "Residential" = 16,   # circle
  "Commercial"  = 17,   # triangle
  "Industrial"  = 15    # square
)

eia_set_key(EIA_KEY)

# -------------------- HELPER --------------------
fetch_us_price_sector <- function(sector_id, retries = 3) {
  for (i in seq_len(retries)) {
    res <- try(
      eia_data(
        dir    = "electricity/retail-sales",
        data   = "price",
        facets = list(sectorid = sector_id, stateid = "US"),
        freq   = "annual",
        start  = as.character(YEAR_START),
        sort   = list(cols = "period", order = "asc")
      ),
      silent = TRUE
    )
    
    if (!inherits(res, "try-error") && !is.null(res) && nrow(res) > 0) {
      return(
        res %>%
          transmute(
            year   = as.integer(substr(period, 1, 4)),
            sector = recode(sectorid, !!!SECTOR_LABS),
            price_cents_kWh = suppressWarnings(as.numeric(price))
          ) %>%
          filter(!is.na(price_cents_kWh), year >= YEAR_START)
      )
    }
    Sys.sleep(0.8 * i)
  }
  stop("Failed to pull sector ", sector_id, " after ", retries, " attempts.")
}

# -------------------- DATA --------------------
us_prices <- SECTORS %>%
  lapply(fetch_us_price_sector) %>%
  bind_rows()

first_year  <- min(us_prices$year, na.rm = TRUE)
latest_year <- max(us_prices$year, na.rm = TRUE)

# Compute percent change relative to 2001 within each sector
us_pct <- us_prices %>%
  group_by(sector) %>%
  arrange(year, .by_group = TRUE) %>%
  mutate(
    base_price   = first(price_cents_kWh),
    pct_change   = 100 * (price_cents_kWh / base_price - 1)  # in %
  ) %>%
  ungroup()

# -------------------- PLOT --------------------
p_us_pct <- ggplot(us_pct, aes(x = year, y = pct_change)) +
  geom_line(aes(color = sector), linewidth = 1.1) +
  geom_point(aes(color = sector, shape = sector), size = 2.4) +
  scale_color_manual(values = COLORS, name = "Sector") +
  scale_shape_manual(values = SHAPES, name = "Sector") +
  scale_x_continuous(
    breaks = seq(first_year, latest_year, 2),
    minor_breaks = seq(first_year, latest_year, 1)
  ) +
  scale_y_continuous(
    labels = label_number(accuracy = 1, suffix = "%")
  ) +
  labs(
    title = sprintf(
      "Percent Change in U.S. Electricity Prices by Sector (%d–%d, 2001 Baseline)",
      first_year, latest_year
    ),
    subtitle = "Percent change in average retail prices relative to 2001 (2001 = 0%)",
    x = "Year",
    y = "Price change since 2001 (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 10, hjust = 0.5),
    plot.subtitle = element_text(size = 9, hjust = 0.5, margin = margin(b = 6)),
    axis.title.x = element_text(size = 9),
    axis.title.y = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 9),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p_us_pct)

# Optional: save to file
# ggsave("us_percent_change_by_sector.png", p_us_pct,
#        width = 10, height = 6, dpi = 300)