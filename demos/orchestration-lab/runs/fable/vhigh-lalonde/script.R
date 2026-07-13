## script.R
## VHIGH -- LaLonde NSW experiment vs. Dehejia-Wahba / Smith-Todd dispute.
## Does propensity-score matching on an observational composite (NSW treated +
## CPS controls) recover the experimental benchmark? We run a specification
## curve over two axes -- covariate set (demographics vs. + re74/re75) and
## estimator detail (1-NN matching, 1-NN with common-support trimming, PS
## stratification) -- and lay every estimate against the benchmark.
##
## Produces: spec-table.md and figures/spec-curve.png
## Self-contained: Rscript script.R

suppressPackageStartupMessages({
  library(causaldata)
  library(MatchIt)
  library(sandwich)
  library(lmtest)
  library(ggplot2)
  library(dplyr)
})

## ---- Plotting theme (declared up top) ---------------------------------
theme_report <- theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_blank(),
    axis.title      = element_text(size = 10),
    axis.text       = element_text(size = 9),
    panel.grid.minor = element_blank(),
    legend.position = "top",
    legend.title    = element_text(size = 9),
    legend.text     = element_text(size = 9)
  )
theme_set(theme_report)

## ---- Okabe-Ito colorblind-safe palette --------------------------------
okabe_ito <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442",
  "#0072B2", "#D55E00", "#CC79A7", "#000000"
)

## ---- Fixed seed (before anything stochastic) --------------------------
set.seed(20260713)

dir.create("figures", showWarnings = FALSE)

## ---- Data (exact loading spec) ----------------------------------------
nsw <- causaldata::nsw_mixtape   # 445 = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape   # 15,992 CPS observational controls
z    <- 1.959964                 # 95% normal critical value

## =======================================================================
## 1. EXPERIMENTAL BENCHMARK  (treated - control within the NSW experiment)
## =======================================================================
bench_fit <- lm(re78 ~ treat, data = nsw)
bench_est <- unname(coef(bench_fit)["treat"])
bench_se  <- sqrt(vcovHC(bench_fit, type = "HC2")["treat", "treat"])
bench_lo  <- bench_est - z * bench_se
bench_hi  <- bench_est + z * bench_se

## =======================================================================
## 2. OBSERVATIONAL COMPOSITE  (NSW treated + CPS controls)
## =======================================================================
comp <- rbind(subset(nsw, treat == 1), cps)   # treat: NSW-treated=1, CPS=0
comp$id <- seq_len(nrow(comp))                 # stable unit id for clustering

## ---- 2a. Naive raw difference (no adjustment) -------------------------
naive_fit <- lm(re78 ~ treat, data = comp)
naive_est <- unname(coef(naive_fit)["treat"])
naive_se  <- sqrt(vcovHC(naive_fit, type = "HC2")["treat", "treat"])
naive_lo  <- naive_est - z * naive_se
naive_hi  <- naive_est + z * naive_se

## ---- Covariate sets (the first axis) ----------------------------------
f_demog <- treat ~ age + educ + black + hisp + marr + nodegree
f_earn  <- treat ~ age + educ + black + hisp + marr + nodegree + re74 + re75

## ---- 2b(i). 1-NN PS matching, ATT, with replacement -------------------
## SE: Abadie-Imbens (2008) show the ordinary nonparametric bootstrap is
## invalid for NN-matching variances, and the exact Abadie-Imbens (2006)
## analytic matching variance lives in the `Matching` package, which is not
## installed. As the defensible MatchIt-only substitute we fit the outcome on
## the matched set and take cluster-robust SEs, clustering on the matched pair
## (subclass) AND the original unit id -- the latter accounts for control units
## reused across matches under replacement (Greifer, MatchIt vignette). This is
## a design-based APPROXIMATION to the AI variance, not the AI estimator itself.
est_nn <- function(formula, data, trim) {
  m <- matchit(formula, data = data, method = "nearest", distance = "glm",
               link = "logit", estimand = "ATT", replace = TRUE,
               discard = if (trim) "both" else "none")
  gm  <- get_matches(m, id = "unit")     # one row per (pair) membership
  fit <- lm(re78 ~ treat, data = gm, weights = weights)
  V   <- vcovCL(fit, cluster = ~ subclass + unit)
  est <- unname(coef(fit)["treat"])
  se  <- sqrt(V["treat", "treat"])
  n_t <- sum(m$treat == 1 & m$weights > 0)
  list(est = est, se = se, lo = est - z * se, hi = est + z * se, n_treat = n_t)
}

## ---- 2b(ii). Simple PS stratification, ATT ----------------------------
## Subclassify on quintiles of the estimated propensity score (cut points at
## quantiles of the score among TREATED units, the standard DW subclassif-
## ication so each stratum holds ~37 treated). ATT = treated-count-weighted
## average of within-stratum treated-control mean differences; analytic
## (delta-method) SE from the within-stratum sampling variances.
est_strat <- function(formula, data, nq = 5) {
  ps_fit    <- glm(formula, data = data, family = binomial)
  data$ps   <- predict(ps_fit, type = "response")
  brks      <- quantile(data$ps[data$treat == 1], probs = seq(0, 1, length.out = nq + 1))
  brks[1]   <- -Inf; brks[length(brks)] <- Inf
  data$stratum <- cut(data$ps, breaks = unique(brks), include.lowest = TRUE)
  parts <- data %>%
    group_by(stratum) %>%
    summarise(
      nt = sum(treat == 1), nc = sum(treat == 0),
      mt = mean(re78[treat == 1]), mc = mean(re78[treat == 0]),
      vt = if (sum(treat == 1) > 1) var(re78[treat == 1]) else 0,
      vc = if (sum(treat == 0) > 1) var(re78[treat == 0]) else 0,
      .groups = "drop"
    ) %>%
    filter(nt > 0, nc > 0)                      # keep strata with both groups
  w   <- parts$nt / sum(parts$nt)
  est <- sum(w * (parts$mt - parts$mc))
  se  <- sqrt(sum(w^2 * (parts$vt / parts$nt + parts$vc / parts$nc)))
  list(est = est, se = se, lo = est - z * se, hi = est + z * se,
       n_treat = sum(parts$nt))
}

## ---- Run the 6 matching specifications --------------------------------
specs <- list(
  list(cov = "Demographics",       est = "1-NN",          fn = "nn",    trim = FALSE, f = f_demog),
  list(cov = "Demographics",       est = "1-NN + trim",   fn = "nn",    trim = TRUE,  f = f_demog),
  list(cov = "Demographics",       est = "Stratify (5)",  fn = "strat", trim = FALSE, f = f_demog),
  list(cov = "+ re74/re75",        est = "1-NN",          fn = "nn",    trim = FALSE, f = f_earn),
  list(cov = "+ re74/re75",        est = "1-NN + trim",   fn = "nn",    trim = TRUE,  f = f_earn),
  list(cov = "+ re74/re75",        est = "Stratify (5)",  fn = "strat", trim = FALSE, f = f_earn)
)

rows <- lapply(specs, function(s) {
  r <- if (s$fn == "nn") est_nn(s$f, comp, s$trim) else est_strat(s$f, comp)
  data.frame(covset = s$cov, estimator = s$est,
             est = r$est, se = r$se, lo = r$lo, hi = r$hi,
             n_treat = r$n_treat, stringsAsFactors = FALSE)
})
res <- do.call(rbind, rows)
res$gap <- res$est - bench_est

## =======================================================================
## 3. SPECIFICATION TABLE  (spec-table.md)
## =======================================================================
fmt <- function(x) formatC(x, format = "f", digits = 0, big.mark = ",")
lines <- c(
  "# Specification table -- does PS matching recover the LaLonde benchmark?",
  "",
  sprintf("**Experimental benchmark** (NSW treated - control on `re78`): **%s** (95%% CI [%s, %s]).",
          fmt(bench_est), fmt(bench_lo), fmt(bench_hi)),
  "",
  sprintf("**Naive observational** (NSW treated - CPS controls, no adjustment): **%s** (95%% CI [%s, %s]).",
          fmt(naive_est), fmt(naive_lo), fmt(naive_hi)),
  "",
  "Composite = 185 NSW treated + 15,992 CPS controls. ATT estimand throughout.",
  "Gap = estimate - benchmark; \"recovers\" means the 95% CI covers the benchmark point.",
  "",
  "| Covariate set | Estimator | Estimate | 95% CI | Gap vs. benchmark | Benchmark | Covers? |",
  "|---|---|---:|---|---:|---:|:---:|"
)
for (i in seq_len(nrow(res))) {
  covers <- if (res$lo[i] <= bench_est && bench_est <= res$hi[i]) "yes" else "no"
  lines <- c(lines, sprintf("| %s | %s | %s | [%s, %s] | %s | %s | %s |",
    res$covset[i], res$estimator[i], fmt(res$est[i]),
    fmt(res$lo[i]), fmt(res$hi[i]), fmt(res$gap[i]), fmt(bench_est), covers))
}
lines <- c(lines, "",
  "**Standard errors.** Benchmark and naive: HC2 heteroskedasticity-robust.",
  "1-NN matching (with replacement): cluster-robust on matched pair and reused",
  "unit id -- a design-based *approximation* to the Abadie-Imbens (2006) analytic",
  "matching variance (the exact estimator lives in `Matching`, not installed);",
  "the nonparametric bootstrap is ruled out, being invalid for nearest-neighbour",
  "matching variances (Abadie & Imbens 2008). Stratification: analytic delta-method",
  "variance from within-stratum sampling variances, conditional on the estimated strata.")
writeLines(lines, "spec-table.md")

## =======================================================================
## 4. FIGURE  (figures/spec-curve.png) -- ONE figure, no in-plot title
## =======================================================================
res$label <- factor(paste(res$estimator),
                    levels = c("1-NN", "1-NN + trim", "Stratify (5)"))
res$covset <- factor(res$covset, levels = c("Demographics", "+ re74/re75"))

p <- ggplot(res, aes(x = label, y = est, color = covset)) +
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = bench_lo, ymax = bench_hi,
           fill = okabe_ito[3], alpha = 0.12) +
  geom_hline(yintercept = bench_est, color = okabe_ito[3], linewidth = 0.7) +
  geom_hline(yintercept = 0, color = "grey70", linetype = "dashed", linewidth = 0.4) +
  annotate("text", x = -Inf, y = bench_est, vjust = -0.7, hjust = -0.03,
           label = sprintf("experimental benchmark = %s", fmt(bench_est)),
           color = okabe_ito[3], size = 3.1) +
  geom_errorbar(aes(ymin = lo, ymax = hi), width = 0.18,
                position = position_dodge(width = 0.5), linewidth = 0.6) +
  geom_point(size = 2.6, position = position_dodge(width = 0.5)) +
  scale_color_manual(values = c("Demographics" = okabe_ito[6],
                                "+ re74/re75"   = okabe_ito[5]),
                     name = "Covariate set") +
  scale_y_continuous(labels = function(x) formatC(x, format = "f", digits = 0, big.mark = ",")) +
  labs(x = NULL, y = "Estimated ATT on 1978 earnings (US$)") +
  coord_cartesian(clip = "off")

ggsave("figures/spec-curve.png", p, width = 8, height = 5.2, dpi = 320)

## ---- Console summary (for the run log / verification) -----------------
cat(sprintf("\nBenchmark: %.1f  [%.1f, %.1f]\n", bench_est, bench_lo, bench_hi))
cat(sprintf("Naive    : %.1f  [%.1f, %.1f]\n", naive_est, naive_lo, naive_hi))
print(res[, c("covset", "estimator", "est", "lo", "hi", "gap", "n_treat")], row.names = FALSE)
