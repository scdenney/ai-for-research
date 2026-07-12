# =============================================================================
# LaLonde (1986) / Dehejia-Wahba vs Smith-Todd specification curve
# Experimental benchmark vs observational (NSW treated + CPS controls) PSM.
# Self-contained: run with `Rscript script.R`.
# =============================================================================

suppressPackageStartupMessages({
  library(causaldata)
  library(MatchIt)
  library(sandwich)
  library(lmtest)
  library(ggplot2)
})

# ---- Palette + theme first (convention: aesthetics before analysis) ---------
okabe_ito <- c(
  orange   = "#E69F00", skyblue = "#56B4E9", green = "#009E73",
  yellow   = "#F0E442", blue    = "#0072B2", vermil = "#D55E00",
  purple   = "#CC79A7", black   = "#000000"
)

theme_clean <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.line = element_line(colour = "grey30", linewidth = 0.3),
    axis.ticks = element_line(colour = "grey30", linewidth = 0.3),
    plot.caption = element_text(hjust = 0, colour = "grey35", size = 9),
    legend.position = "top"
  )

# ---- Seed before anything stochastic (MatchIt ties / glm) -------------------
set.seed(20260712)

# ---- Data -------------------------------------------------------------------
data(nsw_mixtape,  package = "causaldata")
data(cps_mixtape,  package = "causaldata")
nsw <- as.data.frame(nsw_mixtape)
cps <- as.data.frame(cps_mixtape)

# =============================================================================
# 1. EXPERIMENTAL BENCHMARK: treated - control in re78 within randomized NSW.
#    Randomized -> simple difference-in-means (OLS) SE is valid.
# =============================================================================
bench_fit <- lm(re78 ~ treat, data = nsw)
bench_ci  <- confint(bench_fit)["treat", ]
benchmark_est  <- unname(coef(bench_fit)["treat"])
benchmark_se   <- sqrt(vcov(bench_fit)["treat", "treat"])
benchmark_low  <- unname(bench_ci[1])
benchmark_high <- unname(bench_ci[2])

# =============================================================================
# 2. OBSERVATIONAL COMPOSITE: NSW treated (treat==1) + CPS controls (treat==0).
# =============================================================================
covs <- c("age", "educ", "black", "hisp", "marr", "nodegree", "re74", "re75", "re78")
obs <- rbind(
  data.frame(treat = 1L, nsw[nsw$treat == 1, covs]),
  data.frame(treat = 0L, cps[, covs])
)
obs$treat <- as.integer(obs$treat)

# =============================================================================
# 3. NAIVE observational estimate: raw treated - control diff in re78.
# =============================================================================
naive_fit  <- lm(re78 ~ treat, data = obs)
naive_ci   <- confint(naive_fit)["treat", ]
naive_est  <- unname(coef(naive_fit)["treat"])
naive_se   <- sqrt(vcov(naive_fit)["treat", "treat"])
naive_low  <- unname(naive_ci[1])
naive_high <- unname(naive_ci[2])

# =============================================================================
# 4. PROPENSITY-SCORE MATCHING SPECIFICATIONS
#    Axis (a) covariate set: demographics-only  vs  demographics + re74 + re75
#    Axis (b) estimator detail: 1-NN (no trim) / 1-NN (common-support trim) /
#                               propensity-score subclassification (strata)
# -----------------------------------------------------------------------------
# STANDARD ERRORS.
#   For 1-NN matching we do NOT use the ordinary nonparametric bootstrap:
#   Abadie & Imbens (2008, Econometrica) prove the bootstrap distribution does
#   not converge to the correct limit for nearest-neighbor matching, because the
#   matching functional is extremely non-smooth (number of times a control is
#   reused is a step function of the data). Instead, for the NN specs we take
#   the matched pairs from get_matches(), fit a weighted lm(re78 ~ treat), and
#   report CLUSTER-ROBUST SEs clustered on the original control-unit id. Because
#   matching is with replacement, a CPS control can be reused across many treated
#   units; clustering on control id accounts for that repeated-use dependence
#   (a standard practical fix; see MatchIt docs / Abadie-Imbens discussion).
#   For the subclassification specs, SEs are cluster-robust by stratum
#   (a stratified-sampling-style variance), which IS bootstrap-compatible.
# =============================================================================

demo_covs <- c("age", "educ", "black", "hisp", "marr", "nodegree")
full_covs <- c(demo_covs, "re74", "re75")
f_demo <- reformulate(demo_covs, response = "treat")
f_full <- reformulate(full_covs, response = "treat")

# --- NN estimator: weighted lm on matched pairs, cluster-robust by control id -
#   trim = FALSE : plain 1-NN with replacement (no common-support restriction).
#   trim = TRUE  : Dehejia-Wahba style common-support restriction -- a 0.1-SD
#                  propensity-score caliper plus discard="both", which drops
#                  treated units with no comparable control and controls off the
#                  treated support (estimand becomes ATT on the overlap region).
nn_estimate <- function(f, trim) {
  m <- matchit(f, data = obs, method = "nearest", distance = "glm",
               estimand = "ATT", replace = TRUE,
               discard = if (trim) "both" else "none",
               caliper = if (trim) 0.1 else NULL)
  gm <- get_matches(m, data = obs)          # one row per matched pair member
  fit <- lm(re78 ~ treat, data = gm, weights = gm$weights)
  # cluster on original control-unit id (reused controls share an id)
  V  <- sandwich::vcovCL(fit, cluster = gm$id)
  ct <- lmtest::coeftest(fit, vcov. = V)
  est <- unname(ct["treat", "Estimate"])
  se  <- unname(ct["treat", "Std. Error"])
  c(est = est, se = se, low = est - 1.96 * se, high = est + 1.96 * se)
}

# --- Subclassification (Cochran-style strata): weighted lm, cluster by stratum
sub_estimate <- function(f, nsub = 6) {
  m <- matchit(f, data = obs, method = "subclass", distance = "glm",
               estimand = "ATT", subclass = nsub, min.n = 2)
  md  <- match.data(m)
  fit <- lm(re78 ~ treat, data = md, weights = md$weights)
  V   <- sandwich::vcovCL(fit, cluster = md$subclass)
  ct  <- lmtest::coeftest(fit, vcov. = V)
  est <- unname(ct["treat", "Estimate"])
  se  <- unname(ct["treat", "Std. Error"])
  c(est = est, se = se, low = est - 1.96 * se, high = est + 1.96 * se)
}

specs <- list(
  list(id = "S1", label = "1NN, no trim (demo)",        cov = "demographics",           det = "1-NN, no trimming (SE: cluster on control id)",       fn = function() nn_estimate(f_demo, FALSE)),
  list(id = "S2", label = "1NN, no trim (demo+re7475)",  cov = "demographics+re74+re75", det = "1-NN, no trimming (SE: cluster on control id)",       fn = function() nn_estimate(f_full, FALSE)),
  list(id = "S3", label = "1NN, trim (demo)",            cov = "demographics",           det = "1-NN, common-support caliper 0.1 (SE: cluster on control id)", fn = function() nn_estimate(f_demo, TRUE)),
  list(id = "S4", label = "1NN, trim (demo+re7475)",     cov = "demographics+re74+re75", det = "1-NN, common-support caliper 0.1 (SE: cluster on control id)", fn = function() nn_estimate(f_full, TRUE)),
  list(id = "S5", label = "Strata x6 (demo)",            cov = "demographics",           det = "PS subclassification, 6 strata (SE: cluster by stratum)", fn = function() sub_estimate(f_demo)),
  list(id = "S6", label = "Strata x6 (demo+re7475)",     cov = "demographics+re74+re75", det = "PS subclassification, 6 strata (SE: cluster by stratum)", fn = function() sub_estimate(f_full))
)

rows <- lapply(specs, function(s) {
  r <- s$fn()
  data.frame(
    spec_id = s$id, label = s$label, covariate_set = s$cov,
    estimator_detail = s$det,
    estimate = unname(r["est"]), se = unname(r["se"]),
    ci_low = unname(r["low"]), ci_high = unname(r["high"]),
    stringsAsFactors = FALSE
  )
})
spec_df <- do.call(rbind, rows)
spec_df$gap_to_benchmark <- spec_df$estimate - benchmark_est

# ---- Reference rows (benchmark + naive) -------------------------------------
ref_bench <- data.frame(
  spec_id = "BENCH", label = "Experimental benchmark (NSW randomized)",
  covariate_set = "experimental", estimator_detail = "diff-in-means (OLS SE)",
  estimate = benchmark_est, se = benchmark_se,
  ci_low = benchmark_low, ci_high = benchmark_high, gap_to_benchmark = 0
)
ref_naive <- data.frame(
  spec_id = "NAIVE", label = "Naive observational (raw diff)",
  covariate_set = "none (composite)", estimator_detail = "diff-in-means (OLS SE)",
  estimate = naive_est, se = naive_se,
  ci_low = naive_low, ci_high = naive_high,
  gap_to_benchmark = naive_est - benchmark_est
)

full_table <- rbind(ref_bench, ref_naive, spec_df)

# =============================================================================
# 5. WRITE spec-table.md
# =============================================================================
fmt <- function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
md <- c(
  "# LaLonde specification curve: observational PSM vs experimental benchmark",
  "",
  sprintf("Experimental benchmark (ATT on re78): **$%s** [95%% CI %s, %s].",
          fmt(benchmark_est), fmt(benchmark_low), fmt(benchmark_high)),
  sprintf("Naive observational estimate: **$%s** [95%% CI %s, %s].",
          fmt(naive_est), fmt(naive_low), fmt(naive_high)),
  "",
  "All dollar figures are 1978 real earnings (re78). `gap` = estimate - benchmark.",
  "",
  "| Spec | Covariate set | Estimator / SE method | Estimate | SE | 95% CI low | 95% CI high | Gap to benchmark |",
  "|------|---------------|-----------------------|---------:|---:|-----------:|------------:|-----------------:|"
)
for (i in seq_len(nrow(full_table))) {
  r <- full_table[i, ]
  md <- c(md, sprintf("| %s | %s | %s | %s | %s | %s | %s | %s |",
                      r$spec_id, r$covariate_set, r$estimator_detail,
                      fmt(r$estimate), fmt(r$se), fmt(r$ci_low),
                      fmt(r$ci_high), fmt(r$gap_to_benchmark)))
}
md <- c(md, "",
        "SE note: 1-NN specifications avoid the ordinary nonparametric bootstrap,",
        "which Abadie & Imbens (2008) show is invalid for nearest-neighbor matching;",
        "they use cluster-robust SEs clustered on the reused control-unit id.",
        "Subclassification specifications use cluster-robust SEs by stratum.",
        "",
        "Trim note: on the demographics-only propensity score the common-support",
        "restriction is non-binding -- all 185 treated units find a within-caliper",
        "match and the discarded off-support controls were never nearest neighbors",
        "under matching-with-replacement -- so S1 and S3 are identical by",
        "construction. The restriction binds once re74/re75 enter (S2 vs S4).")
writeLines(md, "spec-table.md")

# =============================================================================
# 6. FIGURE: spec-curve.png
# =============================================================================
if (!dir.exists("figures")) dir.create("figures")

plot_df <- spec_df
plot_df <- rbind(
  plot_df,
  data.frame(spec_id = "NAIVE", label = "Naive (raw diff)",
             covariate_set = "none (composite)",
             estimator_detail = "diff-in-means",
             estimate = naive_est, se = naive_se,
             ci_low = naive_low, ci_high = naive_high,
             gap_to_benchmark = naive_est - benchmark_est)
)
plot_df <- plot_df[order(plot_df$estimate), ]
plot_df$label <- factor(plot_df$label, levels = plot_df$label)

pal <- c("demographics"          = okabe_ito[["vermil"]],
         "demographics+re74+re75" = okabe_ito[["blue"]],
         "none (composite)"       = okabe_ito[["black"]])

p <- ggplot(plot_df, aes(x = label, y = estimate, colour = covariate_set)) +
  annotate("rect", xmin = -Inf, xmax = Inf,
           ymin = benchmark_low, ymax = benchmark_high,
           fill = okabe_ito[["green"]], alpha = 0.15) +
  geom_hline(yintercept = benchmark_est, linetype = "dashed",
             colour = okabe_ito[["green"]], linewidth = 0.6) +
  geom_hline(yintercept = 0, colour = "grey70", linewidth = 0.3) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.18, linewidth = 0.6) +
  geom_point(size = 2.6) +
  annotate("text", x = nrow(plot_df) - 0.35, y = benchmark_est,
           label = sprintf("Experimental benchmark $%s ", fmt(benchmark_est)),
           hjust = 1, vjust = 0.5, size = 3.1, colour = okabe_ito[["green"]]) +
  scale_colour_manual(values = pal, name = "Propensity-score covariates") +
  scale_y_continuous(labels = function(x) paste0("$", formatC(x, format = "f", digits = 0, big.mark = ","))) +
  coord_flip() +
  labs(x = NULL, y = "Estimated ATT on 1978 earnings (re78), 95% CI",
       caption = paste0(
         "NSW treated + CPS controls. Green dashed line / band = randomized NSW benchmark (point, 95% CI).\n",
         "Naive raw difference shown for reference. 1-NN specs: cluster-robust SE on reused control id\n",
         "(nonparametric bootstrap invalid for NN matching, Abadie-Imbens 2008). Strata specs: cluster-robust SE by stratum.")) +
  theme_clean

ggsave("figures/spec-curve.png", p, width = 10, height = 5.8, dpi = 320)

# =============================================================================
# 7. Console summary (for memo authoring)
# =============================================================================
cat("\n===== SUMMARY =====\n")
cat(sprintf("Experimental benchmark: %.1f  [%.1f, %.1f]\n",
            benchmark_est, benchmark_low, benchmark_high))
cat(sprintf("Naive observational:    %.1f  [%.1f, %.1f]\n",
            naive_est, naive_low, naive_high))
cat("\nSpec | estimate | SE | CI | gap-to-benchmark\n")
for (i in seq_len(nrow(spec_df))) {
  r <- spec_df[i, ]
  cat(sprintf("%s %-28s est=%8.1f se=%7.1f CI=[%8.1f,%8.1f] gap=%9.1f\n",
              r$spec_id, r$label, r$estimate, r$se, r$ci_low, r$ci_high,
              r$gap_to_benchmark))
}
cat("\nDone.\n")
