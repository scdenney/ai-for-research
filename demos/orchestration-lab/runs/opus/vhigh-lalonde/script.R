# LaLonde NSW vs CPS: does propensity-score matching recover the experimental
# benchmark? (Dehejia-Wahba 1999/2002 vs Smith-Todd 2005.)
# One self-contained script: benchmark, naive composite, 6-spec PSM curve,
# spec-curve.png, spec-table.md. Conventions follow T1/T2.

# ---- palette + theme (Okabe-Ito) --------------------------------------------
okabe_ito <- c(black = "#000000", orange = "#E69F00",
  sky_blue = "#56B4E9", bluish_green = "#009E73", yellow = "#F0E442",
  blue = "#0072B2", vermillion = "#D55E00", reddish_purple = "#CC79A7")
plot_theme <- ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_text(size = 8),
    plot.caption = ggplot2::element_text(hjust = 0, size = 8, colour = "grey30"),
    legend.position = "top", legend.title = ggplot2::element_blank())

set.seed(20260717)
suppressPackageStartupMessages({
  library(causaldata); library(MatchIt)
  library(sandwich);   library(lmtest)
})

nsw <- causaldata::nsw_mixtape          # 445 = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape          # 15,992 CPS observational controls

# ---- 1. experimental benchmark (treated - control within the NSW experiment) -
bench_fit <- lm(re78 ~ treat, data = nsw)
bench_ct  <- coeftest(bench_fit, vcov = vcovHC(bench_fit, type = "HC1"))
benchmark    <- unname(bench_ct["treat", "Estimate"])
benchmark_se <- unname(bench_ct["treat", "Std. Error"])
benchmark_lo <- benchmark - 1.96 * benchmark_se
benchmark_hi <- benchmark + 1.96 * benchmark_se

# ---- 2. observational composite: NSW *treated* + CPS controls ----------------
comp <- rbind(subset(nsw, treat == 1), cps)          # 185 treated + 15,992 controls
stopifnot(nrow(comp) == 16177L, sum(comp$treat) == 185L)

# naive (raw) observational treated-control difference, HC1-robust SE
naive_fit <- lm(re78 ~ treat, data = comp)
naive_ct  <- coeftest(naive_fit, vcov = vcovHC(naive_fit, type = "HC1"))
naive_est <- unname(naive_ct["treat", "Estimate"])
naive_se  <- unname(naive_ct["treat", "Std. Error"])

# ---- covariate sets (the first axis) -----------------------------------------
demog     <- c("age", "educ", "black", "hisp", "marr", "nodegree")
earn      <- c("re74", "re75")                       # pre-treatment earnings
f_demog   <- reformulate(demog,          response = "treat")
f_earn    <- reformulate(c(demog, earn), response = "treat")

# ---- estimator runners (the second axis) -------------------------------------
# 1-NN PSM, ATT, WITH replacement. Design-based SE: weighted outcome regression
# on get_matches() output, cluster-robust on subclass (matched set) AND id
# (reused control). NOT the ordinary nonparametric bootstrap, which is invalid
# for NN-matching variances (Abadie-Imbens 2008).
run_nn <- function(form, discard) {
  m  <- matchit(form, data = comp, method = "nearest", distance = "glm",
                estimand = "ATT", replace = TRUE, discard = discard)
  gm <- get_matches(m)
  fit <- lm(re78 ~ treat, data = gm, weights = weights)
  ct  <- coeftest(fit, vcov = vcovCL(fit, cluster = ~ subclass + id, type = "HC1"))
  n_tr <- sum(m$treat == 1 & m$weights > 0)            # treated actually matched
  list(est = unname(ct["treat", "Estimate"]),
       se  = unname(ct["treat", "Std. Error"]), n_tr = n_tr)
}
# Simple propensity-score stratification (subclassification), ATT. match.data()
# weights implement the ATT subclass estimator; cluster-robust on subclass.
run_strat <- function(form) {
  m  <- matchit(form, data = comp, method = "subclass", distance = "glm",
                estimand = "ATT", subclass = 6)
  md <- match.data(m)
  fit <- lm(re78 ~ treat, data = md, weights = weights)
  ct  <- coeftest(fit, vcov = vcovCL(fit, cluster = ~ subclass, type = "HC1"))
  n_tr <- sum(md$treat == 1)
  list(est = unname(ct["treat", "Estimate"]),
       se  = unname(ct["treat", "Std. Error"]), n_tr = n_tr)
}

# ---- the specification grid (>=4; two axes crossed) --------------------------
specs <- list(
  list(id = "S1", cov = "Demographics",        est = "1-NN PSM", trim = "none",
       run = function() run_nn(f_demog, "none")),
  list(id = "S2", cov = "Demographics",        est = "1-NN PSM", trim = "common support",
       run = function() run_nn(f_demog, "both")),
  list(id = "S3", cov = "Demographics",        est = "Stratification", trim = "6 strata",
       run = function() run_strat(f_demog)),
  list(id = "S4", cov = "Demographics + re74/re75", est = "1-NN PSM", trim = "none",
       run = function() run_nn(f_earn, "none")),
  list(id = "S5", cov = "Demographics + re74/re75", est = "1-NN PSM", trim = "common support",
       run = function() run_nn(f_earn, "both")),
  list(id = "S6", cov = "Demographics + re74/re75", est = "Stratification", trim = "6 strata",
       run = function() run_strat(f_earn))
)

res <- do.call(rbind, lapply(specs, function(s) {
  r <- s$run()
  data.frame(id = s$id, covset = s$cov, estimator = s$est, trim = s$trim,
             est = r$est, se = r$se, n_tr = r$n_tr,
             lo = r$est - 1.96 * r$se, hi = r$est + 1.96 * r$se,
             gap = r$est - benchmark, stringsAsFactors = FALSE)
}))

# console report --------------------------------------------------------------
cat(sprintf("EXPERIMENTAL BENCHMARK: %.1f  (SE %.1f, 95%% CI [%.0f, %.0f])\n",
            benchmark, benchmark_se, benchmark_lo, benchmark_hi))
cat(sprintf("NAIVE OBSERVATIONAL:    %.1f  (SE %.1f)\n\n", naive_est, naive_se))
print(within(res, {
  est <- round(est); se <- round(se); lo <- round(lo); hi <- round(hi); gap <- round(gap)
}), row.names = FALSE)

# ---- 3. figure: spec curve with benchmark reference line ---------------------
dir.create("figures", showWarnings = FALSE, recursive = TRUE)
res$label <- factor(res$id, levels = res$id,
  labels = with(res, sprintf("%s\n%s | %s", id, estimator, trim)))
res$covset <- factor(res$covset,
  levels = c("Demographics", "Demographics + re74/re75"))
cov_cols <- c("Demographics" = unname(okabe_ito["vermillion"]),
              "Demographics + re74/re75" = unname(okabe_ito["blue"]))

fig <- ggplot2::ggplot(res, ggplot2::aes(x = label, y = est, colour = covset)) +
  ggplot2::annotate("rect", xmin = -Inf, xmax = Inf,
    ymin = benchmark_lo, ymax = benchmark_hi, fill = okabe_ito["black"], alpha = 0.08) +
  ggplot2::geom_hline(yintercept = benchmark, linetype = "solid",
    colour = okabe_ito["black"], linewidth = 0.5) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dotted",
    colour = "grey55", linewidth = 0.4) +
  ggplot2::geom_pointrange(ggplot2::aes(ymin = lo, ymax = hi),
    linewidth = 0.7, size = 0.55, fatten = 2.4) +
  ggplot2::annotate("text", x = 0.62, y = benchmark, vjust = -0.7, hjust = 0,
    label = sprintf("Experimental benchmark  +$%s", format(round(benchmark), big.mark = ",")),
    size = 3, colour = okabe_ito["black"], fontface = "bold") +
  ggplot2::scale_colour_manual(values = cov_cols) +
  ggplot2::scale_y_continuous(labels = function(x) paste0("$", format(x, big.mark = ",", trim = TRUE))) +
  ggplot2::labs(x = NULL, y = "Estimated effect on 1978 earnings (ATT)",
    caption = paste0(
      "Points: ATT with 95% CI (cluster-robust; Abadie-Imbens 2008 -> no NN bootstrap). ",
      "Band: benchmark 95% CI.\nNaive observational estimate ($",
      format(round(naive_est), big.mark = ","),
      ") is off-scale and reported in spec-table.md.")) +
  plot_theme
ggplot2::ggsave(file.path("figures", "spec-curve.png"), fig,
  width = 9.5, height = 6, units = "in", dpi = 320, bg = "white")

# ---- 4. spec-table.md --------------------------------------------------------
money <- function(x) paste0(ifelse(x < 0, "-$", "$"),
                            format(abs(round(x)), big.mark = ",", trim = TRUE))
ci    <- function(lo, hi) sprintf("[%s, %s]", money(lo), money(hi))

rows <- apply(res, 1, function(r) {
  est <- as.numeric(r["est"]); se <- as.numeric(r["se"])
  lo <- as.numeric(r["lo"]); hi <- as.numeric(r["hi"]); gap <- as.numeric(r["gap"])
  overlap <- ifelse(benchmark >= lo & benchmark <= hi, "yes", "no")
  sprintf("| %s | %s | %s | %s | %s | %s | %s | %s | %s | %s |",
    r["id"], r["covset"], r["estimator"], r["trim"], r["n_tr"],
    money(est), money(se), ci(lo, hi), money(gap), overlap)
})

tbl <- c(
  "# Specification table — does PSM recover the LaLonde experimental benchmark?",
  "",
  sprintf("**Experimental benchmark (NSW treated - NSW control, re78):** %s  (HC1 SE %s, 95%% CI %s).",
          money(benchmark), money(benchmark_se), ci(benchmark_lo, benchmark_hi)),
  "",
  sprintf("**Naive observational (NSW treated - CPS controls, raw):** %s  (HC1 SE %s, 95%% CI %s) — gap %s from benchmark.",
          money(naive_est), money(naive_se),
          ci(naive_est - 1.96 * naive_se, naive_est + 1.96 * naive_se),
          money(naive_est - benchmark)),
  "",
  "Composite = 185 NSW treated + 15,992 CPS controls (n = 16,177). Estimand: ATT.",
  "PSM: 1-NN with replacement (logit propensity). Stratification: 6 propensity strata, ATT weights.",
  "SEs cluster-robust on matched set (and reused-control id for NN); the ordinary",
  "nonparametric bootstrap is invalid for NN-matching variances (Abadie-Imbens 2008).",
  "'CI covers benchmark?' asks whether the benchmark falls inside the spec's own 95% CI.",
  "",
  "| Spec | Covariates | Estimator | Trim | Treated matched | ATT estimate | SE | 95% CI | Gap vs benchmark | CI covers benchmark? |",
  "|---|---|---|---|---|---|---|---|---|---|",
  rows
)
writeLines(tbl, "spec-table.md")
cat("\nWrote figures/spec-curve.png and spec-table.md\n")
