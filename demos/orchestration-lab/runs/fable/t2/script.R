## script.R
## Profile-level AMCE estimation (projoint) on exampleData1, clustered SEs
## at the respondent level, with a custom ggplot2 dot-and-whisker figure.

## --- (a) palette + theme, declared up front -------------------------------
library(ggplot2)

okabe_ito <- palette.colors(palette = "Okabe-Ito")

theme_amce <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    strip.text.y = element_text(angle = 0, hjust = 0, face = "bold"),
    strip.background = element_rect(fill = "grey92", color = NA),
    legend.position = "none",
    axis.title = element_text(face = "bold"),
    plot.margin = margin(10, 15, 10, 10)
  )

## --- (b) seed before any stochastic step -----------------------------------
set.seed(20260711)

## --- (c) data reshape -------------------------------------------------------
library(projoint)

data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)

## --- (d) AMCE estimation ----------------------------------------------------
## projoint() defaults: .se_method = "analytical", .auto_cluster = TRUE,
## which clusters standard errors on the respondent-level "id" column
## whenever no explicit .clusters_2 is supplied and .se_type_2 is NULL
## (see ?projoint, argument .auto_cluster; confirmed at runtime via
## fit$cluster_by == "id"). All seven attributes/levels are estimated in a
## single call at the profile level.
fit <- projoint(
  out,
  .structure = "profile_level",
  .estimand  = "amce",
  .se_method = "analytical"
)

stopifnot(identical(fit$cluster_by, "id"))

## --- tidy the estimates -----------------------------------------------------
est <- fit$estimates
est <- est[est$estimand == "amce_corrected", ]

labels <- fit$labels  # attribute, level, attribute_id, level_id

lev_lookup <- setNames(labels$level, labels$level_id)
att_lookup <- setNames(labels$attribute, labels$attribute_id)

est$attribute_id <- sub(":.*$", "", est$att_level_choose)
est$attribute    <- att_lookup[est$attribute_id]
est$level        <- lev_lookup[est$att_level_choose]
est$is_ref       <- FALSE

## reference (baseline) rows: one per attribute, estimate fixed at 0
baseline_ids <- unique(est$att_level_choose_baseline)
ref_rows <- do.call(rbind, lapply(baseline_ids, function(bid) {
  att_id <- sub(":.*$", "", bid)
  data.frame(
    estimand = "amce_corrected",
    estimate = 0,
    se = NA_real_,
    conf.low = 0,
    conf.high = 0,
    att_level_choose = bid,
    att_level_choose_baseline = bid,
    attribute_id = att_id,
    attribute = att_lookup[[att_id]],
    level = lev_lookup[[bid]],
    is_ref = TRUE,
    stringsAsFactors = FALSE
  )
}))

plot_df <- rbind(
  ref_rows[, c("attribute_id", "attribute", "level", "estimate", "conf.low",
               "conf.high", "is_ref")],
  est[, c("attribute_id", "attribute", "level", "estimate", "conf.low",
          "conf.high", "is_ref")]
)

plot_df$level_label <- ifelse(plot_df$is_ref,
                               paste0(plot_df$level, " (ref)"),
                               plot_df$level)
## wrap long level labels so the panel keeps most of the canvas width
plot_df$level_label <- vapply(
  plot_df$level_label,
  function(s) paste(strwrap(s, width = 34), collapse = "\n"),
  character(1)
)

## order levels within attribute in the order they appear in `labels`
ord_tbl <- labels
ord_tbl$order_in_att <- ave(seq_len(nrow(ord_tbl)), ord_tbl$attribute_id,
                             FUN = seq_along)

lid_all <- c(ref_rows$att_level_choose, est$att_level_choose)
key_map <- setNames(ord_tbl$order_in_att[match(lid_all, ord_tbl$level_id)], lid_all)

plot_df$lid <- lid_all
plot_df$level_key <- key_map[plot_df$lid]

plot_df$attribute <- factor(plot_df$attribute, levels = unique(labels$attribute))
plot_df <- plot_df[order(plot_df$attribute, plot_df$level_key), ]
plot_df$level_label <- factor(plot_df$level_label, levels = rev(unique(plot_df$level_label)))

## --- (e) build the figure ----------------------------------------------------
att_colors <- rep(as.character(okabe_ito), length.out = length(levels(plot_df$attribute)))
names(att_colors) <- levels(plot_df$attribute)

p <- ggplot(plot_df, aes(x = estimate, y = level_label, color = attribute)) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey40") +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high),
                orientation = "y", width = 0, linewidth = 0.6) +
  geom_point(size = 2) +
  facet_grid(attribute ~ ., scales = "free_y", space = "free_y",
             labeller = labeller(attribute = label_wrap_gen(18))) +
  scale_color_manual(values = att_colors) +
  scale_x_continuous(breaks = round(seq(-0.3, 0.3, by = 0.1), 1),
                     labels = function(x) sprintf("%.1f", x)) +
  labs(x = "AMCE (change in probability profile chosen)", y = NULL) +
  theme_amce

## --- (f) save outputs ---------------------------------------------------------
dir.create("figures", showWarnings = FALSE)
ggsave("figures/amce-dotwhisker.png", plot = p, width = 9, height = 9,
       dpi = 300)

write.csv(
  data.frame(
    attribute = as.character(plot_df$attribute),
    level = as.character(plot_df$level),
    estimate = plot_df$estimate,
    conf.low = plot_df$conf.low,
    conf.high = plot_df$conf.high,
    is_reference = plot_df$is_ref
  ),
  file = "estimates.csv",
  row.names = FALSE
)

cat("Done. n respondents =", length(unique(out$data$id)),
    " n rows (task x profile) =", nrow(out$data), "\n")
