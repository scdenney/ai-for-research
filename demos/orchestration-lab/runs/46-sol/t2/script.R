#!/usr/bin/env Rscript

# Fixed T2 AMCE analysis: profile-level estimates with respondent clustering.
library(projoint)
library(ggplot2)

okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7"
)
theme_t2 <- theme_minimal(base_size = 10.5) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.text.y = element_text(face = "bold", angle = 0),
    strip.background = element_rect(fill = "grey92", colour = NA),
    axis.title.y = element_blank(),
    plot.margin = margin(8, 12, 8, 8)
  )

set.seed(4602)
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# Estimate each level-versus-reference contrast separately so the final covariance
# method can be verified for every interval, rather than inferred from one summary.
corrected_parts <- list()
k <- 1L
for (attribute_id in unique(out$labels$attribute_id)) {
  attribute_levels <- out$labels$level_id[
    out$labels$attribute_id == attribute_id
  ]
  level_names <- sub(".*:", "", attribute_levels)

  for (j in seq.int(2L, length(level_names))) {
    qoi <- set_qoi(
      .structure = "profile_level",
      .estimand = "amce",
      .att_choose = attribute_id,
      .lev_choose = level_names[j],
      .att_choose_b = attribute_id,
      .lev_choose_b = level_names[1]
    )
    fit_j <- projoint(
      out,
      .qoi = qoi,
      .se_method = "analytical",
      .clusters_1 = id,
      .se_type_1 = "stata",
      .clusters_2 = id,
      .se_type_2 = "stata"
    )
    stopifnot(
      identical(fit_j$cluster_by, "id"),
      identical(fit_j$se_type_used, "stata")
    )
    corrected_parts[[k]] <- fit_j$estimates[
      fit_j$estimates$estimand == "amce_corrected",
      c("estimate", "conf.low", "conf.high", "att_level_choose")
    ]
    k <- k + 1L
  }
}

# Projoint's default profile-level plotting target is the reliability-corrected AMCE.
corrected <- do.call(rbind, corrected_parts)
names(corrected)[names(corrected) == "att_level_choose"] <- "level_id"
plot_data <- merge(out$labels, corrected, by = "level_id", all.x = TRUE,
                   sort = FALSE)
plot_data <- plot_data[match(out$labels$level_id, plot_data$level_id), ]

# Add the first listed level of every attribute as the zero-valued AMCE reference.
is_reference <- !duplicated(plot_data$attribute_id)
plot_data$estimate[is_reference] <- 0
plot_data$conf.low[is_reference] <- 0
plot_data$conf.high[is_reference] <- 0
plot_data$reference <- is_reference
stopifnot(
  nrow(corrected) == 17L,
  length(unique(plot_data$attribute_id)) == 7,
  nrow(plot_data) == 24,
  sum(plot_data$reference) == 7,
  sum(!plot_data$reference) == 17,
  !anyNA(plot_data$estimate)
)

# Reverse the global order so the first listed level is at the top in each facet.
plot_data$level_plot <- factor(plot_data$level, levels = rev(plot_data$level))
plot_data$attribute_plot <- factor(plot_data$attribute,
                                   levels = unique(plot_data$attribute))

p <- ggplot(plot_data, aes(x = estimate, y = level_plot, colour = attribute_plot)) +
  geom_vline(xintercept = 0, colour = "grey35", linewidth = 0.45) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), orientation = "y",
                width = 0, linewidth = 0.55) +
  geom_point(size = 2.0) +
  facet_grid(attribute_plot ~ ., scales = "free_y", space = "free_y") +
  scale_colour_manual(values = okabe_ito, guide = "none") +
  scale_x_continuous(
    labels = function(x) paste0(sprintf("%.0f", x * 100), "%"),
    name = "Reliability-corrected AMCE (percentage points)"
  ) +
  labs(caption = NULL) +
  theme_t2

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/amce-dotwhisker.png", p, width = 8.5, height = 10.5,
       units = "in", dpi = 320)

get_effect <- function(level_id) {
  plot_data$estimate[match(level_id, plot_data$level_id)] * 100
}
get_ci <- function(level_id) {
  i <- match(level_id, plot_data$level_id)
  c(plot_data$conf.low[i], plot_data$conf.high[i]) * 100
}
housing40 <- get_effect("att1:level3")
school9 <- get_effect("att4:level2")
drive75 <- get_effect("att5:level4")
town <- get_effect("att6:level4")
suburb_mix <- get_effect("att6:level6")
crime_more <- get_effect("att7:level2")
crime_ci <- get_ci("att7:level2")
drive_ci <- get_ci("att5:level4")

paragraph <- sprintf(paste0(
  "Using profile-level AMCE estimation, the conjoint results show that several ",
  "community features strongly shifted the probability that a profile was chosen. ",
  "All estimates use the repeated flipped task for reliability correction and ",
  "analytical uncertainty clustered by respondent ID. Relative to 20%% less crime ",
  "than the national average, a community with 20%% more crime reduced choice by ",
  "%.1f percentage points. Relative to a 10-minute daily driving time, 75 minutes ",
  "reduced choice by %.1f points, and relative to housing costs of 15%% of pre-tax ",
  "income, costs of 40%% reduced choice by %.1f points. Place type also mattered: ",
  "relative to a downtown mixed-use city, a small town increased choice by %.1f ",
  "points and a suburban neighborhood mixing shops, houses, and businesses ",
  "increased it by %.1f points. Better schools were favored: a rating of 9 rather ",
  "than 5 out of 10 increased choice by %.1f points. The 95%% confidence intervals ",
  "exclude zero for the largest negative effects (more crime: %.1f to %.1f points; ",
  "75-minute driving: %.1f to %.1f), while several smaller attribute-level ",
  "contrasts remain imprecise. Intervals use Stata-style respondent-clustered ",
  "standard errors, specified directly because the default CR2 covariance was ",
  "non-PSD for some contrasts."),
  abs(crime_more), abs(drive75), abs(housing40), town, suburb_mix, school9,
  crime_ci[1], crime_ci[2], drive_ci[1], drive_ci[2])

caption <- "*Figure 1. Reliability-corrected profile-level AMCEs with 95% confidence intervals clustered by respondent; first-listed attribute levels are zero-valued references.*"
writeLines(c(paragraph, "", "![Reliability-corrected AMCE dot-and-whisker plot](figures/amce-dotwhisker.png)", caption),
           "report.md")
