# Reproducible AMCE estimation and figure for projoint exampleData1.
library(projoint)
library(ggplot2)

# Okabe-Ito colourblind-safe palette and shared figure theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  reddish_purple = "#CC79A7", black = "#000000"
)
theme_amce <- theme_minimal(base_size = 10, base_family = "sans") +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", colour = okabe_ito["black"]),
    strip.background = element_rect(fill = "#F2F2F2", colour = NA),
    axis.title.y = element_blank(),
    plot.margin = margin(7, 10, 7, 7)
  )
set.seed(4602)

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# `projoint` provides respondent-clustered analytical uncertainty directly.
# The uncorrected AMCE is the conventional profile-choice AMCE; the package also
# returns an interference-corrected estimand, which is not plotted here.
amce_fit <- projoint(
  out,
  .structure = "profile_level",
  .estimand = "amce",
  .se_method = "analytical",
  .clusters_1 = id,
  .se_type_1 = "stata",
  .clusters_2 = id,
  .se_type_2 = "stata",
  .auto_cluster = FALSE
)
amce <- as.data.frame(amce_fit$estimates)
amce <- amce[amce$estimand == "amce_uncorrected", ]

# Join readable labels and add the omitted first level of every attribute at zero.
labels <- as.data.frame(out$labels)
labels$level_number <- as.integer(sub(".*level", "", labels$level_id))
labels <- labels[order(labels$attribute_id, labels$level_number), ]
amce$key <- amce$att_level_choose
labels$key <- labels$level_id
plot_data <- merge(labels, amce, by = "key", all.x = TRUE, sort = FALSE)
plot_data$estimate[is.na(plot_data$estimate)] <- 0
plot_data$conf.low[is.na(plot_data$conf.low)] <- 0
plot_data$conf.high[is.na(plot_data$conf.high)] <- 0
plot_data$reference <- plot_data$level_number == 1
plot_data$level_display <- ifelse(
  plot_data$reference,
  paste0(plot_data$level, " (reference)"),
  plot_data$level
)
plot_data$estimate_pp <- 100 * plot_data$estimate
plot_data$low_pp <- 100 * plot_data$conf.low
plot_data$high_pp <- 100 * plot_data$conf.high

# Retain the source-data order within each attribute. Faceting permits that
# local ordering without forcing unrelated attributes onto one axis.
plot_data$level_display <- factor(
  plot_data$level_display,
  levels = rev(unique(plot_data$level_display))
)

dir.create("figures", showWarnings = FALSE)
p <- ggplot(plot_data, aes(x = estimate_pp, y = level_display)) +
  geom_vline(xintercept = 0, linewidth = 0.35, colour = "#777777") +
  geom_errorbar(
    data = subset(plot_data, !reference),
    aes(xmin = low_pp, xmax = high_pp), width = 0, orientation = "y", linewidth = 0.55,
    colour = okabe_ito["blue"]
  ) +
  geom_point(
    aes(shape = reference), size = 2.25, stroke = 0.65,
    colour = okabe_ito["vermillion"], fill = "white"
  ) +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 21), guide = "none") +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y", switch = "y") +
  scale_x_continuous("Average marginal component effect (percentage points)") +
  labs(x = "Average marginal component effect (percentage points)") +
  theme_amce +
  theme(strip.placement = "outside")
ggsave(
  "figures/amce-dotwhisker.png", p,
  width = 10, height = 15, units = "in", dpi = 320, bg = "white"
)

# Paper-ready report text uses values from the fitted object, avoiding hand entry.
get_pp <- function(attribute_id, level_number) {
  x <- plot_data[plot_data$attribute_id == attribute_id &
                   plot_data$level_number == level_number, "estimate_pp"]
  sprintf("%.1f", x)
}
get_abs_pp <- function(attribute_id, level_number) {
  x <- abs(plot_data[plot_data$attribute_id == attribute_id &
                     plot_data$level_number == level_number, "estimate_pp"])
  sprintf("%.1f", x)
}
report <- paste0(
  "Using the profile-level conjoint data (6,400 profiles from 400 respondents), ",
  "we estimated conventional, uncorrected average marginal component effects (AMCEs) ",
  "for all seven randomized attributes. Relative to the 15% housing-cost reference, ",
  "a 40% housing cost reduced the probability that a profile was chosen by ", get_abs_pp("att1", 3),
  " percentage points (pp), while a 30% cost reduced it by ", get_abs_pp("att1", 2),
  " pp. Commuting time was comparably consequential: a 75-minute daily commute ",
  "decreased choice by ", get_abs_pp("att5", 4), " pp relative to 10 minutes, and a ",
  "45-minute commute decreased it by ", get_abs_pp("att5", 3),
  " pp. The largest single negative effect was a violent-crime rate 20% above the ",
  "national rate, which lowered choice by ", get_abs_pp("att7", 2),
  " pp compared with the 20%-below-national-rate reference. School quality and ",
  "place type moved preferences in the opposite direction: nine of ten schools ",
  "rated excellent increased choice by ", get_pp("att4", 2), " pp relative to five. ",
  "Relative to a downtown city, a small town and a mixed-use suburban neighborhood ",
  "increased choice by ", get_pp("att6", 4), " and ", get_pp("att6", 6),
  " pp, respectively. Effects for presidential vote and ",
  "racial composition were smaller and their intervals often included zero. The ",
  "95% confidence intervals in Figure 1 use respondent-clustered analytical ",
  "standard errors, accounting for repeated profile evaluations by the same person.\n\n",
  "![Figure 1: AMCE dot-and-whisker plot](figures/amce-dotwhisker.png)\n\n",
  "*Figure 1. Profile-level AMCEs for all seven randomized conjoint attributes. Points are conventional uncorrected AMCEs in percentage points relative to the first listed level of each attribute; hollow points denote those reference levels at zero. Horizontal whiskers are 95% confidence intervals based on analytical standard errors clustered by respondent (400 respondents; 6,400 profiles).*\n"
)
writeLines(report, "report.md")

message("Estimated ", nrow(amce), " non-reference AMCEs across ",
        length(unique(plot_data$attribute_id)), " attributes; figure written at 320 dpi.")
