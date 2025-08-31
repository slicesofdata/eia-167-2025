library(ggplot2)

plot_build <-
  mtcars |>
  ggplot(mapping = aes(x = wt, y = mpg)) +
  geom_point()

plot_build |>
  ggsave(filename = here::here("figs", "point_plot_mpg_by_wt.png"))

rm(plot_build)
