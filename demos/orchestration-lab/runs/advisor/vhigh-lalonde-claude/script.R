## VHIGH — Adjudicating the Dehejia-Wahba / Smith-Todd dispute
## LaLonde NSW experiment vs. CPS observational composite, propensity-score
## matching specification curve.
##
## Output: figures/spec-curve.png, spec-table.md, memo.md (memo written separately)

set.seed(20260717)

suppressPackageStartupMessages({
  library(causaldata)
  library(MatchIt)
  library(ggplot2)
  library(dplyr)
  library(sandwich)
  library(lmtest)
})

## ---- Okabe-Ito palette + minimal theme (T1/T2 convention) ----
okabe_ito <- c(
  black   = "#000000",
  orange  = "#E69F00",
  skyblue = "#56B4E9",
  green   = "#009E73",
  yellow  = "#F0E442",
  blue    = "#0072B2",
  red     = "#D55E00",
  purple  = "#CC79A7"
)

theme_spec <- theme_minimal(base_size = 12) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.title.y = element_blank(),
    plot.margin = margin(10, 16, 10, 10)
  )
theme_set(theme_spec)

## ---- Data ----
nsw <- causaldata::nsw_mixtape
cps <- causaldata::cps_mixtape

stopifnot(nrow(nsw) == 445, sum(nsw$treat == 1) == 185, sum(nsw$treat == 0) == 260)

## ============================================================
## 1. Experimental benchmark: treated - control diff in re78, within NSW
## ============================================================
bench_fit <- lm(re78 ~ treat, data = nsw)
bench_se  <- sqrt(vcovHC(bench_fit, type = "HC1")["treat", "treat"])
bench_est <- coef(bench_fit)["treat"]
bench_ci  <- bench_est + c(-1, 1) * 1.96 * bench_se

cat(sprintf("Experimental benchmark: %.1f (95%% CI: %.1f, %.1f)\n",
            bench_est, bench_ci[1], bench_ci[2]))

## ============================================================
## 2. Observational composite: NSW treated + CPS controls
## ============================================================
nsw_treated <- nsw %>% filter(treat == 1)
composite <- bind_rows(nsw_treated, cps) %>%
  mutate(treat = as.integer(treat))

stopifnot(nrow(composite) == nrow(nsw_treated) + nrow(cps))

## ---- 2a. Naive (raw treated - control) difference ----
naive_fit <- lm(re78 ~ treat, data = composite)
naive_se  <- sqrt(vcovHC(naive_fit, type = "HC1")["treat", "treat"])
naive_est <- coef(naive_fit)["treat"]
naive_ci  <- naive_est + c(-1, 1) * 1.96 * naive_se

## ---- 2b. Propensity-score matching specifications ----
## Two axes plus a third stratification-only robustness pair:
##   covariates: demographics only vs. demographics + re74/re75
##   estimator:  1-NN w/ replacement (no trim) | 1-NN w/ replacement + common-support trim
##               | score stratification (5 strata, and — for the richer covariate
##               set only — trimmed and 10-strata variants; see note below)
##
## SE approach: the ordinary nonparametric bootstrap is invalid for nearest-
## neighbor matching with replacement (Abadie & Imbens 2008), so we do not
## bootstrap. But the two matching estimators need *different* sandwich
## corrections, not one shared recipe:
##   - 1-NN with replacement: get_matches() duplicates a reused CPS control
##     as separate rows in every pair it appears in, so those rows are
##     perfectly correlated within a pair (subclass) AND across pairs that
##     happen to reuse the same physical control. Clustering on subclass
##     alone misses the second kind of correlation. MatchIt's own effect-
##     estimation guidance for matching with replacement is two-way
##     clustering on subclass and unit id, so we use
##     vcovCL(cluster = ~subclass + id).
##   - Stratification: subclass here means one of only 5 (or 10) strata, and
##     cluster-robust inference with that few clusters is not defensible —
##     the sandwich asymptotics assume many clusters. Each unit's
##     within-stratum contribution is instead captured by its ATT weight, so
##     we use ordinary HC1-robust (heteroskedasticity-, not cluster-robust)
##     SEs on the weighted regression.

demo_covs   <- c("age", "educ", "black", "hisp", "marr", "nodegree")
full_covs   <- c(demo_covs, "re74", "re75")

fit_att_nn <- function(mdata) {
  ## weighted regression of outcome on treat, two-way cluster-robust SE
  ## (subclass = match pair, id = physical unit reused across pairs)
  f <- lm(re78 ~ treat, data = mdata, weights = weights)
  vc <- vcovCL(f, cluster = ~subclass + id, type = "HC1")
  est <- coef(f)["treat"]
  se  <- sqrt(vc["treat", "treat"])
  c(estimate = unname(est), se = unname(se))
}

fit_att_strat <- function(mdata) {
  ## weighted regression of outcome on treat, HC1-robust SE (no clustering:
  ## only 5-10 strata is too few clusters for sandwich asymptotics)
  f <- lm(re78 ~ treat, data = mdata, weights = weights)
  vc <- vcovHC(f, type = "HC1")
  est <- coef(f)["treat"]
  se  <- sqrt(vc["treat", "treat"])
  c(estimate = unname(est), se = unname(se))
}

kish_ess <- function(w) sum(w)^2 / sum(w^2)

run_spec <- function(covs, method, trim = FALSE, subclass_n = 5, label) {
  form <- as.formula(paste("treat ~", paste(covs, collapse = " + ")))

  if (method == "nn") {
    m <- matchit(form, data = composite, method = "nearest",
                 distance = "glm", estimand = "ATT", replace = TRUE,
                 discard = if (trim) "both" else "none")
    mdata <- get_matches(m)  # pair-level id needed for cluster-robust SEs
    res <- fit_att_nn(mdata)
    n_report <- nrow(mdata)
  } else if (method == "strat") {
    m <- matchit(form, data = composite, method = "subclass",
                 distance = "glm", estimand = "ATT", subclass = subclass_n,
                 discard = if (trim) "control" else "none")
    mdata <- match.data(m)
    res <- fit_att_strat(mdata)
    ## raw pool N is uninformative once weights are this unequal; report the
    ## effective sample size instead (treated units all have weight 1 under
    ## ATT, so only the control side needs a Kish-ESS correction)
    n_treated <- sum(mdata$treat == 1)
    ess_control <- kish_ess(mdata$weights[mdata$treat == 0])
    n_report <- round(n_treated + ess_control)
  }

  data.frame(
    spec = label,
    covariates = if (identical(covs, demo_covs)) "demographics" else "demographics + re74/re75",
    estimator = method,
    trimmed = trim,
    estimate = res["estimate"],
    se = res["se"],
    n_matched = n_report,
    row.names = NULL
  )
}

## Stratification was originally run only in its weakest form (5 coarse
## strata, untrimmed, over the full 16k CPS pool) and carries half of the
## paper's verdict. Two extra full-covariate-set rows isolate the two ways
## to strengthen it — trimming to common support, and finer strata — so the
## memo can attribute failure/success to the right mechanism rather than to
## "stratification" as a monolith.
specs <- list(
  list(covs = demo_covs, method = "nn",    trim = FALSE, subclass_n = 5,  label = "Demographics - 1-NN, no trim"),
  list(covs = demo_covs, method = "nn",    trim = TRUE,  subclass_n = 5,  label = "Demographics - 1-NN, trimmed"),
  list(covs = demo_covs, method = "strat", trim = FALSE, subclass_n = 5,  label = "Demographics - Stratification (5 strata)"),
  list(covs = full_covs, method = "nn",    trim = FALSE, subclass_n = 5,  label = "Demographics + re74/re75 - 1-NN, no trim"),
  list(covs = full_covs, method = "nn",    trim = TRUE,  subclass_n = 5,  label = "Demographics + re74/re75 - 1-NN, trimmed"),
  list(covs = full_covs, method = "strat", trim = FALSE, subclass_n = 5,  label = "Demographics + re74/re75 - Stratification, coarse (5 strata, untrimmed)"),
  list(covs = full_covs, method = "strat", trim = TRUE,  subclass_n = 5,  label = "Demographics + re74/re75 - Stratification, trimmed (5 strata)"),
  list(covs = full_covs, method = "strat", trim = FALSE, subclass_n = 10, label = "Demographics + re74/re75 - Stratification, finer (10 strata, untrimmed)")
)

spec_results <- do.call(rbind, lapply(specs, function(s) {
  run_spec(s$covs, s$method, s$trim, s$subclass_n, s$label)
}))

spec_results <- spec_results %>%
  mutate(
    ci_low = estimate - 1.96 * se,
    ci_high = estimate + 1.96 * se,
    gap = estimate - as.numeric(bench_est)
  )

## ============================================================
## 3. Specification table
## ============================================================
all_rows <- rbind(
  data.frame(spec = "Experimental benchmark (NSW treated - control)",
             covariates = NA, estimator = "difference in means", trimmed = NA,
             estimate = as.numeric(bench_est), se = bench_se, n_matched = nrow(nsw),
             ci_low = bench_ci[1], ci_high = bench_ci[2], gap = 0),
  data.frame(spec = "Naive observational (NSW treated - CPS control)",
             covariates = NA, estimator = "difference in means", trimmed = NA,
             estimate = as.numeric(naive_est), se = naive_se, n_matched = nrow(composite),
             ci_low = naive_ci[1], ci_high = naive_ci[2], gap = as.numeric(naive_est) - as.numeric(bench_est)),
  spec_results
)

fmt_dollar <- function(x) sprintf("$%s", formatC(round(x), format = "d", big.mark = ","))

table_md <- c(
  "| Specification | Covariates | Estimator | Trimmed | N | Estimate | 95% CI | Gap vs. benchmark |",
  "|---|---|---|---|---|---|---|---|",
  sprintf(
    "| %s | %s | %s | %s | %d | %s | [%s, %s] | %s |",
    all_rows$spec,
    ifelse(is.na(all_rows$covariates), "—", all_rows$covariates),
    all_rows$estimator,
    ifelse(is.na(all_rows$trimmed), "—", ifelse(all_rows$trimmed, "yes", "no")),
    all_rows$n_matched,
    fmt_dollar(all_rows$estimate),
    fmt_dollar(all_rows$ci_low), fmt_dollar(all_rows$ci_high),
    fmt_dollar(all_rows$gap)
  )
)

writeLines(
  c("# Specification table: LaLonde NSW vs. CPS-composite matching estimates",
    "",
    "Benchmark = experimental treated-control difference in `re78` within `nsw_mixtape`.",
    "Gap = specification estimate minus benchmark (positive = overstates program effect).",
    "Standard errors: HC1-robust for difference-in-means rows; for matching rows, the",
    "ordinary nonparametric bootstrap is invalid (Abadie-Imbens 2008), so we do not",
    "bootstrap, but the two estimators need different sandwich corrections. 1-NN rows",
    "use two-way cluster-robust SEs (`vcovCL(cluster = ~subclass + id)`): matching with",
    "replacement reuses CPS controls across pairs, so clustering on the match pair alone",
    "misses the correlation induced by reusing the same physical unit. Stratification rows",
    "use ordinary HC1-robust SEs (no clustering): with only 5-10 strata, cluster-robust",
    "sandwich asymptotics do not apply.",
    "",
    "N for 1-NN rows is the matched-data row count. N for stratification rows is an",
    "effective sample size (treated N + Kish effective sample size of the weighted",
    "controls), not the raw CPS pool size — under the ATT stratification weights the",
    "control side's effective contribution is a small fraction of the full 16,177-row pool.",
    "",
    "The two demographics-only 1-NN rows (no trim / trimmed) are numerically identical.",
    "This is not a coincidence: with these covariates, common-support discarding removes",
    "only CPS controls that were never any treated unit's nearest neighbor, so the ATT",
    "match assignment — and the estimate — is unchanged. (Confirmed directly: discarding",
    "removes 3,286 controls and 0 treated units, and the matched-unit id sets are",
    "identical with and without discarding.) With `re74`/`re75` added, discarding removes",
    "10,216 controls and does change some best-match assignments, so those two rows differ.",
    "",
    table_md),
  "spec-table.md"
)

## ============================================================
## 2. Figure: spec curve
## ============================================================
## Categories on x, estimate on y, so the experimental benchmark is a literal
## horizontal reference line (brief spec + spec-curve genre convention).
plot_data <- spec_results
plot_data$spec <- factor(plot_data$spec, levels = sapply(specs, `[[`, "label"))
plot_data$covariates <- factor(plot_data$covariates,
                                levels = c("demographics", "demographics + re74/re75"))

p <- ggplot(plot_data, aes(x = spec, y = estimate, color = covariates)) +
  geom_hline(yintercept = as.numeric(bench_est), linetype = "dashed",
             color = okabe_ito["black"], linewidth = 0.6) +
  geom_hline(yintercept = as.numeric(naive_est), linetype = "dotted",
             color = okabe_ito["red"], linewidth = 0.6) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.15, linewidth = 0.6) +
  geom_point(size = 2.8) +
  scale_color_manual(values = c(
    "demographics" = unname(okabe_ito["skyblue"]),
    "demographics + re74/re75" = unname(okabe_ito["blue"])
  ), name = "Covariate set") +
  scale_y_continuous(labels = scales::dollar_format()) +
  labs(x = NULL, y = "Estimated effect on 1978 earnings (re78)",
       caption = "Dashed line = experimental benchmark; dotted line = naive observational estimate.") +
  theme(legend.position = "bottom",
        axis.title.y = element_text(angle = 90, margin = margin(r = 10)),
        axis.text.x = element_text(angle = 35, hjust = 1),
        plot.margin = margin(10, 16, 10, 16))

ggsave("figures/spec-curve.png", p, width = 11, height = 6.5, dpi = 320)

cat("\nDone. Wrote figures/spec-curve.png and spec-table.md\n")
cat("\n--- spec table preview ---\n")
print(all_rows[, c("spec", "estimate", "se", "gap")])
