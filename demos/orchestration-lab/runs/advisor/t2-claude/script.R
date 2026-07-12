# ------------------------------------------------------------------
# T2 — AMCEs for all seven attributes on profile choice (projoint)
# Self-contained: reshapes exampleData1, estimates profile-level AMCEs
# with respondent-clustered SEs and projoint's measurement-error
# correction, and writes figures/amce-dotwhisker.png.
# ------------------------------------------------------------------

library(projoint)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(ggplot2)

# --- Palette and theme (Okabe-Ito) --------------------------------
okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)
theme_amce <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_blank(),
    strip.text.y.left  = element_text(angle = 0, hjust = 1, face = "bold"),
    strip.placement    = "outside",
    axis.title.y       = element_blank(),
    legend.position    = "none",
    plot.margin        = margin(10, 14, 10, 10)
  )

set.seed(20260712)

# --- Data ----------------------------------------------------------
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

# --- Estimation ----------------------------------------------------
# projoint's estimator: profile-level AMCEs, analytical SEs clustered
# at the respondent level (.auto_cluster = TRUE), with correction for
# intra-respondent reliability measured by the repeated flipped task.
# NB: this triggers a benign warning ("CR2 produced non-PSD/NA
# variances; fell back to se_type='stata'") — projoint retries with
# clusters still supplied, so SEs remain respondent-clustered CR1
# (Stata-style). Do not pass .se_type_1/.se_type_2 to silence it: in
# projoint 1.1.1 those disable .auto_cluster's auto-detection and
# would silently drop the clustering.
fit <- projoint(
  out,
  .structure    = "profile_level",
  .estimand     = "amce",
  .se_method    = "analytical",
  .auto_cluster = TRUE,
  .seed         = 20260712
)
cat("SE type used:", fit$se_type_used, "\n")

# --- Assemble plotting data ---------------------------------------
labels <- out$labels %>%
  mutate(level_order = as.integer(str_extract(level_id, "\\d+$")))

est <- fit$estimates %>%
  filter(estimand == "amce_corrected") %>%
  select(level_id = att_level_choose, estimate, conf.low, conf.high)

plot_df <- labels %>%
  left_join(est, by = "level_id") %>%
  group_by(attribute) %>%
  mutate(
    is_ref   = level_order == min(level_order),
    estimate = if_else(is_ref, 0, estimate),
    level_lab = if_else(is_ref, paste0(level, " (ref.)"), level)
  ) %>%
  ungroup() %>%
  mutate(
    attribute = str_wrap(attribute, 22),
    level_lab = str_wrap(level_lab, 38)
  ) %>%
  arrange(attribute, level_order) %>%
  mutate(level_lab = fct_rev(fct_inorder(level_lab)))

# --- Figure --------------------------------------------------------
p <- ggplot(plot_df, aes(x = estimate, y = level_lab, colour = attribute)) +
  geom_vline(xintercept = 0, linewidth = 0.3, colour = "grey55") +
  geom_errorbar(
    aes(xmin = conf.low, xmax = conf.high),
    orientation = "y", width = 0, linewidth = 0.6, na.rm = TRUE
  ) +
  geom_point(size = 1.9) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y",
             switch = "y") +
  scale_colour_manual(values = okabe_ito[c(1:3, 5:8)]) +
  scale_x_continuous(labels = scales::label_percent(accuracy = 1)) +
  labs(x = "AMCE: change in probability of choosing the profile\n(percentage points, 95% CI, respondent-clustered)") +
  theme_amce

dir.create("figures", showWarnings = FALSE)
ggsave("figures/amce-dotwhisker.png", p,
       width = 7.5, height = 9, dpi = 300, bg = "white")

# --- Console summary for the report -------------------------------
plot_df %>%
  filter(!is_ref) %>%
  arrange(desc(abs(estimate))) %>%
  transmute(attribute, level, pp = round(100 * estimate, 1),
            lo = round(100 * conf.low, 1), hi = round(100 * conf.high, 1)) %>%
  print(n = 30)
