library(projoint)
library(dplyr)
library(ggplot2)
library(stringr)

# Reproducibility guard (the analytical estimator is deterministic).
set.seed(4602)

# Okabe-Ito colors (yellow omitted for contrast on a white background).
okabe_ito <- c(
  "#000000", "#E69F00", "#56B4E9", "#009E73",
  "#0072B2", "#D55E00", "#CC79A7"
)

# Project-wide plot theme, declared before data preparation or estimation.
theme_amce <- theme_minimal(base_size = 10.5) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "grey88", linewidth = 0.35),
    axis.text.y = element_text(color = "grey15", lineheight = 0.95),
    axis.text.x = element_text(color = "grey25"),
    axis.title.x = element_text(margin = margin(t = 8)),
    strip.placement = "outside",
    strip.text.y.left = element_text(
      angle = 0, face = "bold", color = "grey15", hjust = 1,
      margin = margin(r = 8)
    ),
    panel.spacing.y = unit(0.65, "lines"),
    plot.margin = margin(8, 14, 8, 8)
  )

# Data preparation ---------------------------------------------------------
data("exampleData1", package = "projoint")

out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

stopifnot(
  nrow(out$data) == 6400L,
  dplyr::n_distinct(out$data$id) == 400L,
  dplyr::n_distinct(out$labels$attribute_id) == 7L
)

# Estimation ---------------------------------------------------------------
# We report conventional (uncorrected) profile-level AMCEs. Stata-style
# cluster-robust SEs are requested explicitly because CR2 is numerically
# infeasible for some internal reference-vs-itself fits in projoint 1.1.1.
# Those fits are discarded by projoint; suppressWarnings() silences only the
# package's hard-coded CR2 fallback warning while retaining the requested
# respondent-clustered estimator for all reported non-reference contrasts.
fit <- suppressWarnings(
  projoint(
    out,
    .structure = "profile_level",
    .estimand = "amce",
    .se_method = "analytical",
    .clusters_2 = id,
    .se_type_2 = "stata"
  )
)

stopifnot(
  identical(fit$cluster_by, "id"),
  identical(fit$se_type_used, "stata")
)

amce <- fit$estimates |>
  filter(estimand == "amce_uncorrected") |>
  select(
    level_id = att_level_choose,
    estimate, se, conf.low, conf.high
  )

# Plot data ---------------------------------------------------------------
# Start from the package's label table so level and attribute order follow
# the original conjoint design. The first level of each attribute is the
# model reference and is added at zero for display only.
attribute_order <- unique(out$labels$attribute)

plot_data <- out$labels |>
  group_by(attribute_id) |>
  mutate(
    level_order = row_number(),
    is_reference = level_order == 1L
  ) |>
  ungroup() |>
  left_join(amce, by = "level_id") |>
  mutate(
    estimate = if_else(is_reference, 0, estimate),
    conf.low = if_else(is_reference, 0, conf.low),
    conf.high = if_else(is_reference, 0, conf.high),
    se = if_else(is_reference, NA_real_, se),
    attribute = factor(attribute, levels = attribute_order),
    row_id = factor(level_id, levels = rev(out$labels$level_id))
  )

stopifnot(
  nrow(plot_data) == 24L,
  sum(plot_data$is_reference) == 7L,
  all(is.finite(plot_data$estimate)),
  all(is.finite(plot_data$conf.low)),
  all(is.finite(plot_data$conf.high))
)

attribute_colors <- setNames(okabe_ito, attribute_order)
level_labels <- setNames(str_wrap(out$labels$level, width = 47), out$labels$level_id)

amce_plot <- ggplot(
  plot_data,
  aes(x = estimate, y = row_id, color = attribute)
) +
  geom_vline(xintercept = 0, color = "grey48", linewidth = 0.45) +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    orientation = "y", width = 0.16, linewidth = 0.65
  ) +
  geom_point(
    data = filter(plot_data, !is_reference),
    size = 2.55
  ) +
  geom_point(
    data = filter(plot_data, is_reference),
    shape = 21, fill = "white", size = 2.8, stroke = 0.85
  ) +
  facet_grid(
    rows = vars(attribute), scales = "free_y", space = "free_y",
    switch = "y",
    labeller = labeller(attribute = label_wrap_gen(width = 27))
  ) +
  scale_color_manual(values = attribute_colors, guide = "none") +
  scale_y_discrete(labels = level_labels) +
  scale_x_continuous(
    breaks = seq(-0.20, 0.15, by = 0.05),
    labels = function(x) sprintf("%d", round(100 * x)),
    expand = expansion(mult = c(0.04, 0.05))
  ) +
  coord_cartesian(xlim = c(-0.225, 0.165), clip = "off") +
  labs(
    x = "AMCE on profile-selection probability (percentage points)",
    y = NULL
  ) +
  theme_amce

dir.create("figures", recursive = TRUE, showWarnings = FALSE)
ggsave(
  filename = "figures/amce-dotwhisker.png",
  plot = amce_plot,
  width = 10.5,
  height = 10,
  units = "in",
  dpi = 360,
  bg = "white"
)

# Compact numerical output for checking the prose against the analysis.
reporting_check <- plot_data |>
  filter(!is_reference) |>
  transmute(
    attribute = as.character(attribute), level,
    estimate_pp = 100 * estimate,
    conf_low_pp = 100 * conf.low,
    conf_high_pp = 100 * conf.high
  ) |>
  arrange(desc(abs(estimate_pp)))

print(reporting_check, n = Inf)
message(
  "Saved figures/amce-dotwhisker.png at 360 dpi; ",
  "AMCE uncertainty clustered on ", fit$cluster_by,
  " using ", fit$se_type_used, " SEs."
)
