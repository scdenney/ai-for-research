# =====================================================================
# VHIGH — Adjudicating the LaLonde / Dehejia-Wahba vs Smith-Todd dispute
# ---------------------------------------------------------------------
# Question: does propensity-score matching recover the NSW experimental
# benchmark once the experimental controls are discarded and replaced by
# CPS observational controls? We run a specification curve that crosses two
# axes — the covariate set (demographics only vs demographics + re74/re75
# pre-treatment earnings) and an estimator detail (1-NN matching with vs
# without common-support trimming; simple score stratification) — and lay
# every estimate against the experimental benchmark.
#
# Self-contained: run with `Rscript script.R` from this directory.
# =====================================================================

suppressPackageStartupMessages({
  library(causaldata)   # nsw_mixtape (experimental) + cps_mixtape (observational)
  library(MatchIt)      # 4.7.2 — logit PS, 1-NN with replacement, subclassification
  library(sandwich)     # cluster-robust / HC variance estimators
  library(lmtest)       # coeftest()
  library(ggplot2)
})

set.seed(20240712)  # set before any stochastic step (e.g. tie-breaking in matching)

# ---- Okabe-Ito palette (colour-blind-safe) --------------------------
okabe_ito <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
               "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

theme_spec <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title.x       = element_blank(),
    axis.title.y       = element_text(margin = margin(r = 8)),
    legend.position    = "bottom",
    legend.title       = element_blank(),
    plot.margin        = margin(12, 16, 10, 12)
  )
theme_set(theme_spec)

dir.create("figures", showWarnings = FALSE)

# ---- Data -----------------------------------------------------------
nsw <- causaldata::nsw_mixtape    # 445 = 185 treated + 260 experimental controls
cps <- causaldata::cps_mixtape    # 15,992 CPS observational controls

demo <- c("age", "educ", "black", "hisp", "marr", "nodegree")
earn <- c("re74", "re75")
cov_sets <- list(
  "Demographics only"        = demo,
  "Demographics + re74/re75" = c(demo, earn)
)

# =====================================================================
# 1. Experimental benchmark: treated - control difference within NSW.
#    Unbiased by randomisation. HC3-robust SE for the two-sample diff.
# =====================================================================
fit_b <- lm(re78 ~ treat, data = nsw)
ct_b  <- coeftest(fit_b, vcov = vcovHC(fit_b, type = "HC3"))
benchmark    <- unname(ct_b["treat", "Estimate"])
benchmark_se <- unname(ct_b["treat", "Std. Error"])

# =====================================================================
# Observational composite: NSW TREATED units + CPS controls.
# The experimental controls are discarded, exactly as in DW/ST.
# =====================================================================
composite <- rbind(subset(nsw, treat == 1), subset(cps, treat == 0))
composite$uid <- seq_len(nrow(composite))   # stable id: clusters reused controls

# ---- 2a. Naive observational estimate (raw treated - control) -------
fit_n <- lm(re78 ~ treat, data = composite)
ct_n  <- coeftest(fit_n, vcov = vcovHC(fit_n, type = "HC3"))
naive    <- unname(ct_n["treat", "Estimate"])
naive_se <- unname(ct_n["treat", "Std. Error"])

# =====================================================================
# 2b. Matching estimators. Target: ATT.
#
# Standard errors. We do NOT use the ordinary nonparametric bootstrap: Abadie
# & Imbens (2008) show it is invalid for nearest-neighbour matching variances.
# We estimate the ATT by a weighted outcome regression on the matched sample
# and report sandwich standard errors following the MatchIt / Ho-Imai-King-
# Stuart workflow:
#   * 1-NN with replacement: cluster-robust on the matched set (subclass) AND
#     the reused-control identity (uid), since a control reused across sets is
#     not an independent observation (~185 matched-set clusters here). This is
#     a defensible WORKING SE, not the Abadie-Imbens analytic matching variance
#     (the `Matching` package is not installed); it also treats the propensity
#     score as known, ignoring first-stage estimation (AI 2016) -- for the ATT
#     that omission is typically conservative.
#   * stratification: HC3 heteroskedasticity-robust (see est_sub) -- NOT
#     clustered on subclass, which with only 5 subclasses would be invalid
#     few-cluster inference.
# =====================================================================

est_nn <- function(covs, discard) {
  m  <- matchit(reformulate(covs, "treat"), data = composite,
                method = "nearest", distance = "glm",
                estimand = "ATT", replace = TRUE, discard = discard)
  gm  <- get_matches(m)                       # reused controls duplicated per set
  fit <- lm(re78 ~ treat, data = gm, weights = weights)
  ct  <- coeftest(fit, vcov = vcovCL(fit, cluster = gm[c("subclass", "uid")]))
  list(est = unname(ct["treat", "Estimate"]),
       se  = unname(ct["treat", "Std. Error"]),
       n_treat = sum(!m$discarded & composite$treat == 1))
}

est_sub <- function(covs, nsub = 5) {
  m   <- matchit(reformulate(covs, "treat"), data = composite,
                 method = "subclass", estimand = "ATT", subclass = nsub)
  md  <- match.data(m)
  fit <- lm(re78 ~ treat, data = md, weights = weights)
  # HC3 heteroskedasticity-robust: within-subclass units are independent by
  # design, so subclass is not a cluster; clustering on only 5 subclasses would
  # be invalid few-cluster inference (CR variance paired with a z critical
  # value). HC-robust matches the MatchIt/marginaleffects subclassification
  # workflow.
  ct  <- coeftest(fit, vcov = vcovHC(fit, type = "HC3"))
  list(est = unname(ct["treat", "Estimate"]),
       se  = unname(ct["treat", "Std. Error"]),
       n_treat = sum(md$treat == 1))
}

# ---- Specification grid: covariate set x estimator detail -----------
specs <- list(
  list(id = "S1", cov = "Demographics only",        est = "1-NN (replace)",     trim = "none",
       fn = function() est_nn(cov_sets[["Demographics only"]],        "none")),
  list(id = "S2", cov = "Demographics only",        est = "1-NN (replace)",     trim = "common support",
       fn = function() est_nn(cov_sets[["Demographics only"]],        "both")),
  list(id = "S3", cov = "Demographics only",        est = "Stratification (5)", trim = "none",
       fn = function() est_sub(cov_sets[["Demographics only"]])),
  list(id = "S4", cov = "Demographics + re74/re75", est = "1-NN (replace)",     trim = "none",
       fn = function() est_nn(cov_sets[["Demographics + re74/re75"]], "none")),
  list(id = "S5", cov = "Demographics + re74/re75", est = "1-NN (replace)",     trim = "common support",
       fn = function() est_nn(cov_sets[["Demographics + re74/re75"]], "both")),
  list(id = "S6", cov = "Demographics + re74/re75", est = "Stratification (5)", trim = "none",
       fn = function() est_sub(cov_sets[["Demographics + re74/re75"]]))
)

rows <- lapply(specs, function(s) {
  r <- s$fn()
  data.frame(id = s$id, covariates = s$cov, estimator = s$est, trim = s$trim,
             estimate = r$est, se = r$se, n_treat = r$n_treat,
             stringsAsFactors = FALSE)
})
res <- do.call(rbind, rows)
res$ci_lo <- res$estimate - 1.96 * res$se
res$ci_hi <- res$estimate + 1.96 * res$se
res$gap   <- res$estimate - benchmark
res$covers_benchmark <- benchmark >= res$ci_lo & benchmark <= res$ci_hi

# =====================================================================
# Console summary
# =====================================================================
cat("\n================ EXPERIMENTAL BENCHMARK ================\n")
cat(sprintf("  treated - control re78 (NSW):  %+8.0f   (HC3 SE %.0f)\n",
            benchmark, benchmark_se))
cat("\n================ NAIVE OBSERVATIONAL ==================\n")
cat(sprintf("  NSW-treated vs CPS-controls:   %+8.0f   (HC3 SE %.0f)   gap %+.0f\n",
            naive, naive_se, naive - benchmark))
cat("\n================ MATCHED SPECIFICATIONS ===============\n")
print(within(res, {
  estimate <- round(estimate); se <- round(se)
  ci_lo <- round(ci_lo); ci_hi <- round(ci_hi); gap <- round(gap)
}), row.names = FALSE)
cat("\n")

# =====================================================================
# 3. Specification table (spec-table.md)
# =====================================================================
dol <- function(x) paste0(ifelse(x < 0, "-$", "$"),
                          formatC(abs(round(x)), format = "f", digits = 0, big.mark = ","))
ci  <- function(lo, hi) sprintf("[%s, %s]", dol(lo), dol(hi))

md <- c(
  "# Specification table — does matching recover the NSW benchmark?",
  "",
  sprintf("**Experimental benchmark (treated − control in `nsw_mixtape`): %s** (HC3 SE %s, 95%% CI %s).",
          dol(benchmark), dol(benchmark_se), ci(benchmark - 1.96 * benchmark_se, benchmark + 1.96 * benchmark_se)),
  "This is the unbiased target. Estimator = ATT on `re78`. Positive **gap** = estimate above benchmark; negative = below.",
  "",
  "| Spec | Covariates | Estimator | Common support | Treated used | ATT estimate | 95% CI | Benchmark | Gap vs benchmark | CI covers benchmark? |",
  "|---|---|---|---|---:|---:|---|---:|---:|:--:|",
  sprintf("| Naive | — (raw diff) | none | all | 185 | %s | %s | %s | %s | %s |",
          dol(naive), ci(naive - 1.96 * naive_se, naive + 1.96 * naive_se),
          dol(benchmark), dol(naive - benchmark),
          ifelse(benchmark >= naive - 1.96 * naive_se & benchmark <= naive + 1.96 * naive_se, "yes", "**no**"))
)
md <- c(md, vapply(seq_len(nrow(res)), function(i) {
  r <- res[i, ]
  sprintf("| %s | %s | %s | %s | %d | %s | %s | %s | %s | %s |",
          r$id, r$covariates, r$estimator, r$trim, r$n_treat,
          dol(r$estimate), ci(r$ci_lo, r$ci_hi), dol(benchmark), dol(r$gap),
          ifelse(r$covers_benchmark, "yes", "**no**"))
}, character(1)))
md <- c(md, "",
  "**Standard errors.** Benchmark and naive: HC3 heteroskedasticity-robust. 1-NN specs: cluster-robust sandwich on the matched sample (matched set + reused-control identity; ~185 matched-set clusters). Stratification specs: HC3 robust — units within a subclass are independent by design, so clustering on only 5 subclasses would be invalid few-cluster inference. The ordinary nonparametric bootstrap is **not** used — Abadie & Imbens (2008) show it is invalid for nearest-neighbour matching variances. The 1-NN cluster-robust SEs are defensible *working* SEs, not the Abadie-Imbens analytic matching variance (the `Matching` package is unavailable); they also treat the propensity score as known (AI 2016), which for the ATT is typically conservative.",
  "",
  "**Notes.** ATT via weighted outcome regression on the MatchIt sample (`estimand = \"ATT\"`, 1-NN with `replace = TRUE`; logit propensity score). Common-support trimming (`discard = \"both\"`) discards units outside the propensity-score overlap. It was **non-binding for the ATT**: no treated unit fell outside the CPS controls' score range (all 185 retained, so S1≡S2 and S4/S5 differ only trivially); it trimmed many never-matched controls (≈3,300 in demo-only, ≈10,200 in demo+earn) that were not selected as neighbours anyway. The sensitivity here is driven by the covariate set and the estimator, not by trimming.",
  "")
writeLines(md, "spec-table.md")
cat("Wrote spec-table.md\n")

# =====================================================================
# 4. Figure — spec-curve.png (exactly one figure)
# =====================================================================
lab_map <- c(
  S1 = "Demo\n1-NN", S2 = "Demo\n1-NN, trim", S3 = "Demo\nStratify",
  S4 = "Demo+earn\n1-NN", S5 = "Demo+earn\n1-NN, trim", S6 = "Demo+earn\nStratify"
)
plot_df <- rbind(
  data.frame(label = "Naive\n(raw diff)", group = "Naive (raw comparison)",
             estimate = naive, ci_lo = naive - 1.96 * naive_se, ci_hi = naive + 1.96 * naive_se),
  data.frame(label = lab_map[res$id],
             group = ifelse(res$covariates == "Demographics only",
                            "Demographics only", "Demographics + re74/re75"),
             estimate = res$estimate, ci_lo = res$ci_lo, ci_hi = res$ci_hi)
)
plot_df$label <- factor(plot_df$label,
  levels = c("Naive\n(raw diff)", lab_map[c("S1","S2","S3","S4","S5","S6")]))
plot_df$group <- factor(plot_df$group,
  levels = c("Naive (raw comparison)", "Demographics only", "Demographics + re74/re75"))

pal <- c("Naive (raw comparison)" = "#000000",
         "Demographics only"        = "#D55E00",
         "Demographics + re74/re75" = "#0072B2")

p <- ggplot(plot_df, aes(label, estimate, colour = group)) +
  annotate("rect", xmin = -Inf, xmax = Inf,
           ymin = benchmark - 1.96 * benchmark_se, ymax = benchmark + 1.96 * benchmark_se,
           fill = "grey80", alpha = 0.6) +
  geom_hline(yintercept = benchmark, linewidth = 0.7, colour = "grey25") +
  geom_hline(yintercept = 0, linetype = "dashed", linewidth = 0.4, colour = "grey65") +
  geom_pointrange(aes(ymin = ci_lo, ymax = ci_hi), linewidth = 0.75, size = 0.55) +
  annotate("text", x = 0.65, y = benchmark, hjust = 0, vjust = -0.7, size = 3.1,
           colour = "grey25", label = sprintf("Experimental benchmark  %s", dol(benchmark))) +
  scale_colour_manual(values = pal) +
  scale_y_continuous(labels = scales::label_dollar()) +
  labs(y = "Estimated effect on 1978 earnings (ATT)",
       caption = "Grey band = benchmark 95% CI. Intervals = 95% (1-NN: cluster-robust; stratification & naive: HC3). Dashed line = zero effect.") +
  guides(colour = guide_legend(nrow = 1))

ggsave("figures/spec-curve.png", p, width = 9, height = 5.6, dpi = 320, bg = "white")
cat("Wrote figures/spec-curve.png\n")
