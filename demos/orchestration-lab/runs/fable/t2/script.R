# --- setup ---
set.seed(1)
suppressMessages({
  library(projoint)
  library(ggplot2)
  library(dplyr)
})

# Okabe-Ito palette (colorblind-safe), declared up top
okabe_ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
                "#0072B2", "#D55E00", "#CC79A7", "#000000")

theme_amce <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "none",
    axis.title.y = element_blank(),
    plot.margin = margin(10, 15, 10, 10),
    strip.text.y = element_text(angle = 0, hjust = 0)
  )

# --- data ---
data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))

# --- estimate AMCEs (profile-level), clustered SEs at respondent level ---
# projoint() auto-clusters analytical SEs on the respondent id column by
# default (.auto_cluster = TRUE), confirmed via cluster_by = "id" in output.
# We report the IRR/measurement-error-corrected AMCE (amce_corrected), which
# is projoint's core estimator, rather than the uncorrected OLS AMCE.
fit <- projoint(out, .structure = "profile_level", .estimand = "amce",
                 .se_method = "analytical")

est <- fit$estimates %>%
  filter(estimand == "amce_corrected")

# --- step 1: join to labels for human-readable text ---
labels <- fit$labels

est_joined <- est %>%
  left_join(labels, by = c("att_level_choose" = "level_id")) %>%
  transmute(
    attribute = attribute,
    level = level,
    estimate,
    se,
    conf.low,
    conf.high,
    attribute_id,
    level_id = att_level_choose
  )

# --- step 2: add baseline (level1) rows for each attribute ---
baseline_rows <- labels %>%
  filter(grepl(":level1$", level_id)) %>%
  transmute(
    attribute = attribute,
    level = level,
    estimate = 0,
    se = NA_real_,
    conf.low = NA_real_,
    conf.high = NA_real_,
    attribute_id,
    level_id
  )

combined <- bind_rows(est_joined, baseline_rows)

# sort by attribute_id then level_id (numeric-aware)
combined <- combined %>%
  mutate(
    attribute_num = as.numeric(gsub("att", "", attribute_id)),
    level_num = as.numeric(gsub(".*level", "", level_id))
  ) %>%
  arrange(attribute_num, level_num) %>%
  select(-attribute_num, -level_num)

# --- step 3: print full table + tau + n ---
print(as.data.frame(combined), row.names = FALSE)
cat("\nfit$tau (IRR estimate):", fit$tau, "\n")
cat("Number of rows in analysis data (out$data):", nrow(out$data), "\n")
cat("Number of unique respondents:",
    length(unique(out$data[[grep("id|ResponseId", names(out$data), ignore.case = TRUE, value = TRUE)[1]]])), "\n")

# --- step 4: build dot-and-whisker plot ---
plot_df <- combined %>%
  mutate(
    attribute_num = as.numeric(gsub("att", "", attribute_id)),
    level_num = as.numeric(gsub(".*level", "", level_id))
  ) %>%
  arrange(attribute_num, level_num) %>%
  mutate(level_f = factor(level, levels = rev(unique(level))))

p <- ggplot(plot_df, aes(x = estimate, y = level_f, color = attribute)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey50") +
  geom_point(size = 2) +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  scale_color_manual(values = okabe_ito[1:length(unique(plot_df$attribute))]) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y",
             labeller = label_wrap_gen(width = 15)) +
  labs(x = "AMCE (change in probability of profile choice)") +
  theme_amce

# --- step 5: save ---
dir.create("figures", showWarnings = FALSE)
ggsave("figures/amce-dotwhisker.png", p, width = 8, height = 9, dpi = 320)
