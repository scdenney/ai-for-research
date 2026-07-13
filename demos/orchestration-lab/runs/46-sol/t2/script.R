suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(projoint)
})

# Okabe-Ito palette and a compact, publication-oriented plotting theme.
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
               "#0072B2", "#D55E00", "#CC79A7")
theme_amce <- theme_minimal(base_size = 10) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey92", colour = NA),
    strip.text = element_text(face = "bold", hjust = 0),
    axis.title.y = element_blank(),
    legend.position = "none",
    plot.margin = margin(8, 12, 8, 12)
  )

set.seed(20260713)

data(exampleData1, package = "projoint")
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

fit <- projoint(
  out,
  .structure = "profile_level",
  .estimand = "amce",
  .se_method = "analytical",
  .auto_cluster = TRUE
)

stopifnot(identical(fit$cluster_by, "id"))
stopifnot(identical(attr(fit$estimates, "cluster_by"), "id"))

# The label table defines both the attribute sequence and within-attribute level sequence.
labels <- fit$labels %>%
  mutate(
    attribute_order = match(attribute_id, unique(attribute_id)),
    level_order = row_number(),
    is_reference = grepl(":level1$", level_id)
  )
stopifnot(n_distinct(labels$attribute_id) == 7L)

corrected <- fit$estimates %>%
  filter(estimand == "amce_corrected") %>%
  select(att_level_choose, estimate, se, conf.low, conf.high)

# Joining from labels retains every level, including the seven first-listed references.
plot_data <- labels %>%
  left_join(corrected, by = c("level_id" = "att_level_choose")) %>%
  mutate(
    estimate = if_else(is_reference, 0, estimate),
    conf.low = if_else(is_reference, 0, conf.low),
    conf.high = if_else(is_reference, 0, conf.high),
    level_display = if_else(is_reference,
                            paste0(level, " (reference)"), level),
    level_display = factor(level_display, levels = rev(level_display)),
    attribute = factor(attribute, levels = unique(attribute))
  )

stopifnot(nrow(plot_data) == 24L)
stopifnot(sum(plot_data$is_reference) == 7L)
stopifnot(all(is.finite(plot_data$estimate)))
stopifnot(all(is.finite(plot_data$conf.low)))
stopifnot(all(is.finite(plot_data$conf.high)))

dir.create("figures", showWarnings = FALSE, recursive = TRUE)

plot <- ggplot(plot_data, aes(x = estimate, y = level_display, colour = attribute)) +
  geom_vline(xintercept = 0, colour = "grey30", linewidth = 0.45) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.20,
                linewidth = 0.55, orientation = "y") +
  geom_point(size = 2.15) +
  facet_wrap(
    vars(attribute), ncol = 1, scales = "free_y", space = "free_y",
    strip.position = "top"
  ) +
  scale_colour_manual(values = setNames(okabe_ito, levels(plot_data$attribute))) +
  scale_x_continuous(labels = function(x) paste0(round(100 * x), " pp"),
                     breaks = seq(-0.4, 0.3, by = 0.1),
                     expand = expansion(mult = c(0.03, 0.08))) +
  labs(x = "Corrected AMCE (percentage points)") +
  theme_amce

ggsave("figures/amce-dotwhisker.png", plot, width = 9.25, height = 14.5,
       units = "in", dpi = 320, bg = "white")

pp <- function(x) sprintf("%.1f", 100 * x)
pp_abs <- function(x) sprintf("%.1f", abs(100 * x))
effect <- function(level_id) {
  plot_data %>% filter(level_id == !!level_id) %>% pull(estimate)
}

housing <- effect("att1:level3")
commute <- effect("att5:level4")
place_small_town <- effect("att6:level4")
place_suburb_mix <- effect("att6:level6")
crime <- effect("att7:level2")

paragraph <- paste0(
  "Using the conjoint profiles, we estimated corrected average marginal component effects (AMCEs) on profile choice, with each level interpreted relative to the first-listed level of its attribute. ",
  "The correction uses the repeated task to account for imperfect intra-respondent reliability (estimated tau = ", sprintf("%.3f", fit$tau), "). ",
  "The clearest negative response was to a violent-crime rate 20% above the national average: it reduced the probability of choosing a profile by ", pp_abs(crime), " percentage points relative to a rate 20% below the national average. ",
  "Longer daily travel also mattered substantially. A 75-minute commute reduced choice by ", pp_abs(commute), " percentage points relative to 10 minutes, while housing costs equal to 40% of pre-tax income reduced choice by ", pp_abs(housing), " points relative to 15%. ",
  "Place type generated the largest positive shifts: a small town increased choice by ", pp(place_small_town), " points and a suburban neighborhood mixing shops, houses, and businesses increased it by ", pp(place_suburb_mix), " points, each compared with a downtown city setting with mixed offices, apartments, and shops. ",
  "Several remaining attribute-level contrasts were substantively more modest. The 95% intervals use respondent-clustered analytical standard errors; intervals for many of these smaller contrasts crossed zero."
)

writeLines(c(
  paragraph,
  "",
  "![Corrected AMCEs by conjoint attribute](figures/amce-dotwhisker.png)",
  "Corrected AMCEs on profile choice relative to the first-listed level of each attribute; dots are estimates and whiskers are respondent-clustered 95% intervals."
), "report.md")
