# Reproducible AMCE analysis for projoint::exampleData1
# The figure compares profile-choice AMCEs with respondent-clustered 95% CIs.

required_packages <- c("projoint", "dplyr", "ggplot2")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace,
                                              logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Missing required package(s): ", paste(missing_packages, collapse = ", "))
}

# Okabe-Ito colourblind-safe palette and a single reusable plot theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
amce_theme <- ggplot2::theme_minimal(base_size = 10, base_family = "sans") +
  ggplot2::theme(
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_line(colour = "grey85", linewidth = 0.3),
    strip.background = ggplot2::element_rect(fill = "grey95", colour = NA),
    strip.text.y.left = ggplot2::element_text(face = "bold", angle = 0),
    axis.title.y = ggplot2::element_blank(),
    axis.text.y = ggplot2::element_text(size = 8),
    plot.title = ggplot2::element_blank(),
    plot.margin = ggplot2::margin(8, 12, 8, 8)
  )

set.seed(20260712)

data("exampleData1", package = "projoint")
choices <- c(paste0("choice", 1:8), "choice1_repeated_flipped")

# The repeated flipped choice is included to estimate response reliability; the
# AMCEs below use the standard (uncorrected) profile-choice estimand.
conjoint_data <- projoint::reshape_projoint(
  .dataframe = exampleData1,
  .outcomes = choices,
  .idvar = "ResponseId",
  .repeated = TRUE,
  .flipped = TRUE
)

# profile_level estimates the effect on selecting a profile. auto_cluster=TRUE
# clusters analytical uncertainty by respondent id (reported by the estimator).
amce_fit <- projoint::projoint(
  .data = conjoint_data,
  .structure = "profile_level",
  .estimand = "amce",
  .se_method = "analytical",
  .auto_cluster = TRUE,
  .seed = 20260712
)

if (!identical(amce_fit$cluster_by, "id")) {
  stop("AMCE uncertainty was not clustered by respondent id.")
}

labels <- conjoint_data$labels |>
  dplyr::mutate(
    level_number = as.integer(sub(".*:level", "", level_id)),
    is_reference = level_number == 1L,
    level_display = ifelse(is_reference, paste0(level, " (reference)"), level),
    row_id = paste(attribute_id, level_id, sep = "__")
  )

estimated_levels <- amce_fit$estimates |>
  dplyr::filter(estimand == "amce_uncorrected") |>
  dplyr::transmute(
    level_id = att_level_choose,
    estimate, se, conf.low, conf.high
  ) |>
  dplyr::left_join(labels, by = "level_id")

# Add the omitted baseline level for every attribute at its known AMCE of zero.
reference_levels <- labels |>
  dplyr::filter(is_reference) |>
  dplyr::transmute(
    level_id, estimate = 0, se = 0, conf.low = 0, conf.high = 0,
    is_reference, attribute, level, attribute_id, level_number,
    level_display, row_id
  )

plot_data <- dplyr::bind_rows(estimated_levels, reference_levels) |>
  dplyr::arrange(attribute_id, level_number) |>
  dplyr::mutate(
    row_id = factor(row_id, levels = rev(unique(row_id))),
    attribute = factor(attribute, levels = unique(labels$attribute))
  )

amce_plot <- ggplot2::ggplot(plot_data, ggplot2::aes(x = estimate, y = row_id)) +
  ggplot2::geom_vline(xintercept = 0, colour = "grey35", linewidth = 0.45) +
  ggplot2::geom_errorbar(
    ggplot2::aes(xmin = conf.low, xmax = conf.high),
    orientation = "y", width = 0, colour = okabe_ito[["blue"]], linewidth = 0.55
  ) +
  ggplot2::geom_point(
    ggplot2::aes(fill = is_reference), shape = 21, size = 2.5,
    colour = okabe_ito[["blue"]], stroke = 0.5
  ) +
  ggplot2::facet_grid(rows = ggplot2::vars(attribute), scales = "free_y", space = "free_y",
                        switch = "y") +
  ggplot2::scale_y_discrete(labels = stats::setNames(as.character(plot_data$level_display),
                                                      as.character(plot_data$row_id))) +
  ggplot2::scale_fill_manual(values = c(`FALSE` = okabe_ito[["sky_blue"]], `TRUE` = "white"), guide = "none") +
  ggplot2::labs(x = "Average marginal component effect on profile choice (probability)",
                title = NULL, subtitle = NULL) +
  amce_theme

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggplot2::ggsave(
  filename = file.path("figures", "amce-dotwhisker.png"),
  plot = amce_plot, width = 9, height = 12, units = "in", dpi = 320,
  bg = "white"
)
