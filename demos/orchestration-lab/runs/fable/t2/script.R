library(projoint)
library(ggplot2)
library(dplyr)

okabe_ito <- c("#000000","#E69F00","#56B4E9","#009E73","#F0E442","#0072B2","#D55E00","#CC79A7")

theme_amce <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold"),
    strip.text.y.left = element_text(angle = 0, face = "bold", size = 9, hjust = 1),
    strip.placement = "outside",
    legend.position = "none",
    plot.title = element_blank()
  )

set.seed(1234)

data(exampleData1)
out <- reshape_projoint(exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped"))
fit <- projoint(out, .estimand = "amce", .structure = "profile_level")
est <- fit$estimates          # tibble
labs <- out$labels            # data.frame: attribute, level, attribute_id, level_id

# Keep only corrected AMCE estimates
est_corrected <- est %>% filter(estimand == "amce_corrected")

# Join to labels for human-readable attribute/level
plot_df <- est_corrected %>%
  left_join(labs, by = c("att_level_choose" = "level_id")) %>%
  mutate(is_ref = FALSE) %>%
  select(attribute, level, estimate, se, conf.low, conf.high, is_ref, att_level_choose)

# Build reference rows: one per attribute, its level1
ref_rows <- labs %>%
  filter(grepl("level1$", level_id)) %>%
  mutate(
    estimate = 0,
    se = NA_real_,
    conf.low = 0,
    conf.high = 0,
    is_ref = TRUE,
    att_level_choose = level_id
  ) %>%
  select(attribute, level, estimate, se, conf.low, conf.high, is_ref, att_level_choose)

plot_df <- bind_rows(plot_df, ref_rows)

# Extract numeric attribute index and level index for ordering
plot_df <- plot_df %>%
  mutate(
    att_num = as.numeric(sub("^att(\\d+):level\\d+$", "\\1", att_level_choose)),
    level_num = as.numeric(sub("^att\\d+:level(\\d+)$", "\\1", att_level_choose))
  ) %>%
  arrange(att_num, level_num)

# Build ordered factor for y-axis: reference (level1) first within each attribute group,
# and attributes appear as contiguous groups. Reverse so that first row plots at top
# when used with facet_grid + coord where category order top-to-bottom follows factor levels reversed.
plot_df <- plot_df %>%
  mutate(level_factor = factor(att_level_choose, levels = rev(att_level_choose)))

plot_df <- plot_df %>%
  mutate(attribute = factor(attribute, levels = unique(attribute[order(att_num)])))

dir.create("figures", showWarnings = FALSE)

p <- ggplot(plot_df, aes(x = estimate, xmin = conf.low, xmax = conf.high, y = level_factor)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey60") +
  geom_pointrange(aes(color = is_ref)) +
  scale_color_manual(values = c(`FALSE` = "#0072B2", `TRUE` = "#000000")) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y", switch = "y",
             labeller = label_wrap_gen(width = 18)) +
  scale_y_discrete(labels = setNames(plot_df$level, plot_df$level_factor)) +
  labs(x = "AMCE on probability of profile selection", y = NULL) +
  theme_amce

ggsave("figures/amce-dotwhisker.png", plot = p, width = 9.5, height = 9, dpi = 300, bg = "white")

write.csv(
  plot_df %>% select(attribute, level, estimate, se, conf.low, conf.high, is_ref),
  "estimates.csv",
  row.names = FALSE
)
