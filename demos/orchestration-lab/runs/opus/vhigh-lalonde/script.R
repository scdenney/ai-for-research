# =============================================================================
# Task VHIGH — Adjudicating Dehejia-Wahba (1999/2002) vs. Smith-Todd (2005)
# Does propensity-score matching on CPS controls recover the NSW experimental
# benchmark? Specification curve over covariate set x estimator detail.
#
# Self-contained: `Rscript script.R` writes figures/spec-curve.png and spec-table.md
# =============================================================================

suppressWarnings(suppressMessages({
  library(causaldata)   # nsw_mixtape, cps_mixtape
  library(MatchIt)      # propensity-score matching (ATT, with replacement)
  library(sandwich)     # heteroskedasticity- and cluster-robust vcov
  library(lmtest)       # coeftest()
  library(ggplot2)      # figure
}))

# ---- Okabe-Ito colour-blind-safe palette + house theme (top of script) ------
okabe_ito <- c(black   = "#000000", orange = "#E69F00", skyblue = "#56B4E9",
               green   = "#009E73", yellow = "#F0E442", blue    = "#0072B2",
               vermill = "#D55E00", purple = "#CC79A7", grey    = "#999999")
theme_set(
  theme_minimal(base_size = 12) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank(),
          axis.text.x = element_text(angle = 20, hjust = 1),
          legend.position = "top",
          legend.box = "vertical",
          legend.margin = margin(0, 0, 0, 0),
          legend.spacing.y = unit(1, "pt"),
          plot.margin = margin(12, 18, 12, 14))
)

# set.seed() BEFORE anything stochastic (matching tie-breaking / any sampling) --
set.seed(20260713)

# ---- Data --------------------------------------------------------------------
nsw <- causaldata::nsw_mixtape    # 445 = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape    # 15,992 CPS observational controls

# Observational composite: NSW *treated* + CPS controls (experimental controls discarded)
comp <- rbind(nsw[nsw$treat == 1, ], cps)

covs_demo <- c("age", "educ", "black", "hisp", "marr", "nodegree")
covs_earn <- c(covs_demo, "re74", "re75")     # + two years pre-treatment earnings
f_demo <- reformulate(covs_demo, response = "treat")
f_earn <- reformulate(covs_earn, response = "treat")

# ---- (1) Experimental benchmark & (a) naive observational estimate -----------
# Both are simple treated-minus-control means; HC3-robust SEs.
diff_est <- function(data, label, covset = "-", estimator = "unadjusted") {
  ct <- coeftest(lm(re78 ~ treat, data = data), vcov = vcovHC, type = "HC3")
  data.frame(label = label, covset = covset, estimator = estimator,
             est = ct["treat", 1], se = ct["treat", 2],
             n_treat = sum(data$treat == 1), stringsAsFactors = FALSE)
}
benchmark <- diff_est(nsw,  "Experimental benchmark")   # unbiased target
naive     <- diff_est(comp, "Naive (observational)")    # raw composite gap

# ---- (2b) Propensity-score matching estimators -------------------------------
# 1-NN, ATT, WITH replacement. SEs: pair + reused-unit cluster-robust on the
# long get_matches() data. The ordinary nonparametric bootstrap is NOT valid for
# NN-matching variances (Abadie-Imbens 2008), so it is deliberately avoided.
nn_att <- function(f, discard, label, covset) {
  m  <- matchit(f, data = comp, method = "nearest", distance = "glm",
                estimand = "ATT", replace = TRUE, discard = discard)
  gm <- MatchIt::get_matches(m)                       # long: id (orig unit) + subclass (pair)
  fit <- lm(re78 ~ treat, data = gm, weights = weights)
  ct  <- coeftest(fit, vcov = vcovCL, cluster = ~ subclass + id)
  data.frame(label = label, covset = covset, estimator = "1-NN (replace)",
             est = ct["treat", 1], se = ct["treat", 2],
             n_treat = sum(m$treat == 1 & !m$discarded), stringsAsFactors = FALSE)
}

# Score subclassification (6 strata), ATT. Marginal effect via subclass weights;
# HC3-robust SEs (pair-clustering is a few-cluster trap with only 6 strata).
strat_att <- function(f, label, covset) {
  m  <- matchit(f, data = comp, method = "subclass", distance = "glm",
                estimand = "ATT", subclass = 6)
  md <- match.data(m)
  fit <- lm(re78 ~ treat, data = md, weights = weights)
  ct  <- coeftest(fit, vcov = vcovHC, type = "HC3")
  data.frame(label = label, covset = covset, estimator = "Stratification (6)",
             est = ct["treat", 1], se = ct["treat", 2],
             n_treat = sum(m$treat == 1), stringsAsFactors = FALSE)
}

specs <- rbind(
  nn_att   (f_demo, "none", "NN · demog. · no-trim",     "Demographics only"),
  nn_att   (f_demo, "both", "NN · demog. · trim",        "Demographics only"),
  strat_att(f_demo,         "Strat · demog.",            "Demographics only"),
  nn_att   (f_earn, "none", "NN · +re74/75 · no-trim",   "Demographics + re74/re75"),
  nn_att   (f_earn, "both", "NN · +re74/75 · trim",      "Demographics + re74/re75"),
  strat_att(f_earn,         "Strat · +re74/75",          "Demographics + re74/re75")
)

# ---- (3) Assemble table: every estimate laid against the benchmark -----------
bench_val <- benchmark$est
all_est <- rbind(naive, specs)
all_est$lo  <- all_est$est - 1.96 * all_est$se
all_est$hi  <- all_est$est + 1.96 * all_est$se
all_est$gap <- all_est$est - bench_val                       # signed distance to benchmark
all_est$covers_bench <- (all_est$lo <= bench_val) & (bench_val <= all_est$hi)

bench_lo <- benchmark$est - 1.96 * benchmark$se
bench_hi <- benchmark$est + 1.96 * benchmark$se

money <- function(x) sprintf("%s$%s", ifelse(x < 0, "-", "+"),
                             formatC(abs(round(x)), format = "d", big.mark = ","))

md <- c(
  "# Specification table — recovering the NSW experimental benchmark",
  "",
  sprintf("**Experimental benchmark (unbiased target):** %s  (SE %s; 95%% CI [%s, %s]).",
          money(bench_val), formatC(round(benchmark$se), big.mark = ","),
          money(bench_lo), money(bench_hi)),
  "",
  sprintf("Estimand: ATT of NSW training on 1978 earnings (re78). Composite sample = %d NSW treated + %s CPS controls. `Gap = estimate - benchmark`. `Covers?` = does the estimate's 95%% CI contain the benchmark point (%s).",
          benchmark$n_treat, formatC(nrow(cps), big.mark = ","), money(bench_val)),
  "",
  "| Specification | Covariate set | Estimator | Treated N | Estimate | 95% CI | Gap vs. benchmark | Covers? |",
  "|---|---|---|---:|---:|:---:|---:|:---:|"
)
row_md <- function(r) sprintf("| %s | %s | %s | %d | %s | [%s, %s] | %s | %s |",
                              r$label, r$covset, r$estimator, r$n_treat,
                              money(r$est), money(r$lo), money(r$hi), money(r$gap),
                              ifelse(r$covers_bench, "yes", "**no**"))
md <- c(md, sapply(seq_len(nrow(all_est)), function(i) row_md(all_est[i, ])))
md <- c(md, "",
  sprintf("**Benchmark row (reference):** Experimental | — | unadjusted | %d | %s | [%s, %s] | +$0 | yes |",
          benchmark$n_treat, money(bench_val), money(bench_lo), money(bench_hi)),
  "",
  "*SEs:* naive, stratification, and benchmark use HC3 heteroskedasticity-robust SEs; 1-NN specs use cluster-robust SEs clustered on the matched pair **and** the reused control unit (`~subclass + id` on `get_matches()`). The ordinary nonparametric bootstrap is **not** used — it is invalid for nearest-neighbour matching variances (Abadie & Imbens 2008). Cluster-robust matching SEs approximate but do not equal Abadie-Imbens analytic SEs (the `Matching` package is not installed).")
writeLines(md, "spec-table.md")

# ---- (2)/(4) Figure: spec curve with benchmark reference line ----------------
plot_df <- all_est
plot_df$label <- factor(plot_df$label, levels = plot_df$label)   # preserve order
plot_df$covset <- factor(plot_df$covset,
  levels = c("-", "Demographics only", "Demographics + re74/re75"))
levels(plot_df$covset)[1] <- "Unadjusted"
plot_df$estimator <- factor(plot_df$estimator,
  levels = c("unadjusted", "1-NN (replace)", "Stratification (6)"))

pal <- c("Unadjusted" = okabe_ito[["grey"]],
         "Demographics only" = okabe_ito[["vermill"]],
         "Demographics + re74/re75" = okabe_ito[["blue"]])
shp <- c("unadjusted" = 4, "1-NN (replace)" = 16, "Stratification (6)" = 17)

p <- ggplot(plot_df, aes(x = label, y = est, colour = covset, shape = estimator)) +
  # benchmark: horizontal reference line + its 95% CI band
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = bench_lo, ymax = bench_hi,
           fill = okabe_ito[["green"]], alpha = 0.13) +
  geom_hline(yintercept = bench_val, colour = okabe_ito[["green"]],
             linewidth = 0.9) +
  geom_hline(yintercept = 0, colour = okabe_ito[["black"]],
             linetype = "dotted", linewidth = 0.4) +
  # benchmark label anchored to the first x category (discrete-axis safe)
  geom_text(data = data.frame(label = factor(levels(plot_df$label)[1],
                                             levels = levels(plot_df$label))),
            aes(x = label, y = bench_val),
            label = "experimental benchmark", inherit.aes = FALSE,
            colour = okabe_ito[["green"]], hjust = 0, vjust = -0.7,
            size = 3.4, fontface = "italic") +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.18, linewidth = 0.7) +
  geom_point(size = 3.1, fill = "white", stroke = 1) +
  scale_colour_manual(values = pal, name = "Covariate set") +
  scale_shape_manual(values = shp, name = "Estimator") +
  scale_y_continuous(labels = function(y) paste0("$", formatC(y, format = "d", big.mark = ",")),
                     breaks = seq(-9000, 3000, 3000)) +
  labs(x = NULL, y = "Estimated ATT on 1978 earnings (re78)") +
  guides(colour = guide_legend(order = 1, override.aes = list(shape = 15, linetype = 0)),
         shape  = guide_legend(order = 2))

dir.create("figures", showWarnings = FALSE)
ggsave("figures/spec-curve.png", p, width = 9, height = 5.6, dpi = 320)

# ---- Console summary ---------------------------------------------------------
cat("\n==== Specification curve vs. experimental benchmark ====\n")
cat(sprintf("Benchmark: %s (SE %.0f)\n", money(bench_val), benchmark$se))
print(within(all_est, {
  est <- round(est); se <- round(se); gap <- round(gap)
  lo <- hi <- NULL
})[, c("label", "covset", "estimator", "est", "se", "gap", "covers_bench")], row.names = FALSE)
cat("\nWrote: figures/spec-curve.png, spec-table.md\n")
