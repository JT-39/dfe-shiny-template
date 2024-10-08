create_avgrev_time_series <- function(df, input_area) {
  ggplot(df, aes(
    x = year,
    y = average_revenue_balance,
    color = area_name,
    id = area_name
  )) +
    geom_line_interactive(size = 1) +
    geom_point_interactive(
      aes(
        tooltip = paste0(
          "<p><b>", area_name, ", ", year, "</b></p>",
          "<p>£", format(average_revenue_balance, big.mark = ","), "</p>"
        )
      ),
      size = 0.5
    ) +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      axis.title.x = element_text(margin = margin(t = 12)),
      axis.title.y = element_text(
        angle = 0, vjust = 0.5,
        margin = margin(r = 12)
      ),
      axis.line = element_line(size = 0.75),
      legend.position = "top"
    ) +
    scale_y_continuous(
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
    ) +
    xlab("Academic year end") +
    ylab(str_wrap("Average revenue balance", 16)) +
    scale_color_manual(
      "Area",
      breaks = unique(c("England", input_area)),
      values = gss_colour_pallette
    )
}

plotavgrevbenchmark <- function(df_revenue_balance, input_area) {
  ggplot(df_revenue_balance, aes(
    x = str_wrap(area_name, width = 12),
    y = average_revenue_balance,
    fill = area_name,
    id = area_name,
    tooltip = paste(
      "<p><b>", area_name, "</b></p>", "<p>£",
      format(average_revenue_balance, big.mark = ","), "</p>"
    )
  )) +
    geom_col_interactive() +
    theme_classic() +
    theme(
      text = element_text(size = 12),
      axis.title.x = element_blank(),
      axis.title.y = element_text(
        angle = 0, vjust = 0.5,
        margin = margin(r = 12)
      ),
      axis.line = element_line(size = 0.75),
      legend.position = "none"
    ) +
    scale_y_continuous(
      labels = scales::number_format(accuracy = 1, big = ",", prefix = "£")
    ) +
    xlab("Area") +
    ylab(str_wrap("Average revenue balance", 12)) +
    scale_fill_manual(
      "Area",
      breaks = unique(df_revenue_balance$area_name),
      values = gss_colour_pallette
    )
}
