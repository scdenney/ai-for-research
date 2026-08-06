# Reproducible AMCE estimation and figure production
library(projoint)
library(ggplot2)

set.seed(20260717)

# Okabe-Ito palette and common plot theme
okabe_ito <- c(
  "Housing Cost" = "#E69F00",
  "Presidential Vote (2020)" = "#56B4E9",
  "Racial Composition" = "#009E73",
  "School Quality" = "#000000",
  "Total Daily Driving Time for Commuting and Errands" = "#0072B2",
  "Type of Place" = "#D55E00",
  "Violent Crime Rate (Vs National Rate)" = "#CC79A7"
)
theme_amce <- theme_minimal(base_size = 10) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text.y = element_text(face = "bold", angle = 0),
    axis.title.y = element_blank(),
    legend.position = "none",
    plot.margin = margin(8, 12, 8, 8)
  )

data(exampleData1)
pj_data <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# projoint's profile-level AMCE estimator; clustering is respondent-level (id).
# The package estimates reliability from the repeated task and returns corrected AMCEs.
fit <- projoint(
  pj_data,
  .structure = "profile_level",
  .estimand = "amce",
  .se_method = "analytical",
  .clusters_1 = id,
  .se_type_1 = "stata",
  .clusters_2 = id,
  .se_type_2 = "stata",
  .seed = 20260717
)

est <- fit$estimates[fit$estimates$estimand == "amce_corrected", ]
labels <- as.data.frame(fit$labels)

# The first displayed level is the package's baseline for each attribute.
# Declare those baselines explicitly, rather than inferring them from a failed match.
reference_levels <- data.frame(
  attribute_id = paste0("att", 1:7),
  level_id = paste0("att", 1:7, ":level1"),
  stringsAsFactors = FALSE
)
if (!all(reference_levels$level_id %in% labels$level_id)) {
  stop("A declared reference level is absent from fit$labels.")
}
if (anyDuplicated(reference_levels$attribute_id) ||
    anyDuplicated(reference_levels$level_id)) {
  stop("Reference levels must identify exactly one baseline per attribute.")
}
if (any(est$att_level_choose %in% reference_levels$level_id)) {
  stop("The AMCE estimates unexpectedly include a declared reference level.")
}
if (!all(est$att_level_choose %in% labels$level_id)) {
  stop("An AMCE estimate could not be joined to a labeled level.")
}

non_reference <- labels[!(labels$level_id %in% reference_levels$level_id), ]
plot_data <- merge(
  non_reference,
  est[, c("att_level_choose", "estimate", "conf.low", "conf.high")],
  by.x = "level_id",
  by.y = "att_level_choose",
  all.x = TRUE,
  sort = FALSE
)
if (nrow(plot_data) != nrow(non_reference) ||
    anyNA(plot_data[, c("estimate", "conf.low", "conf.high")])) {
  stop("Checked join failed: every non-reference level must have one AMCE estimate.")
}

reference_data <- merge(
  reference_levels,
  labels,
  by = c("attribute_id", "level_id"),
  all.x = TRUE,
  sort = FALSE
)
if (nrow(reference_data) != nrow(reference_levels) || anyNA(reference_data$level)) {
  stop("Checked join failed: every declared reference must have one label.")
}
reference_data$estimate <- 0
reference_data$conf.low <- 0
reference_data$conf.high <- 0
plot_data <- rbind(plot_data, reference_data[, names(plot_data)])
plot_data$reference <- plot_data$level_id %in% reference_levels$level_id
plot_data$estimate_pp <- 100 * plot_data$estimate
plot_data$conf.low_pp <- 100 * plot_data$conf.low
plot_data$conf.high_pp <- 100 * plot_data$conf.high
plot_data$attribute <- factor(plot_data$attribute, levels = names(okabe_ito))
plot_data$level_display <- factor(plot_data$level, levels = rev(plot_data$level))

# Rank non-reference AMCEs programmatically for results reporting.
ranked_effects <- plot_data[!plot_data$reference, c("attribute", "level", "estimate_pp")]
ranked_effects <- ranked_effects[order(-abs(ranked_effects$estimate_pp)), ]
print(ranked_effects)

dir.create("figures", showWarnings = FALSE)
figure <- ggplot(plot_data, aes(x = estimate_pp, y = level_display, colour = attribute)) +
  geom_vline(xintercept = 0, colour = "grey45", linewidth = 0.35) +
  geom_segment(
    aes(x = conf.low_pp, xend = conf.high_pp, yend = level_display),
    linewidth = 0.6
  ) +
  geom_point(aes(shape = reference), size = 2.2) +
  scale_colour_manual(values = okabe_ito) +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 1)) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y") +
  labs(x = "AMCE on profile choice (percentage points)") +
  theme_amce

ggsave(
  filename = "figures/amce-dotwhisker.png",
  plot = figure,
  width = 10,
  height = 14,
  units = "in",
  dpi = 320
)
