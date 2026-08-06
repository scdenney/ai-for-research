=== ORIGINAL BRIEF ===
# Task VHIGH — Adjudicate a methods dispute (very-high tier)

You are working in a project directory. Use R (`Rscript`); the `causaldata` package is installed.

**Data.** The LaLonde National Supported Work (NSW) experiment plus the CPS comparison sample:

```r
library(causaldata)
nsw <- causaldata::nsw_mixtape   # 445 obs = 185 treated + 260 control (experimental)
cps <- causaldata::cps_mixtape   # 15,992 CPS controls (observational comparison pool)
# columns (both): data_id treat age educ black hisp marr nodegree re74 re75 re78
```

**Situation.** The NSW experiment gives an unbiased estimate of the program's effect on 1978 earnings (`re78`): the treated−control difference in `nsw_mixtape` (about **+$1,794** — compute it, do not trust the figure). Dehejia and Wahba (1999, 2002) claim propensity-score methods **recover** this experimental benchmark when the experimental controls are discarded and replaced by CPS observational controls (`cps_mixtape`). Smith and Todd (2005) reply that the recovered estimate is **fragile** to the covariate set and the analysis sample. Your job is to run the specification curve and decide which claim the evidence supports.

**Task.**

1. Compute the **experimental benchmark** (treated − control difference in `re78`, within `nsw_mixtape`).
2. Construct the **observational composite** — NSW **treated** units plus CPS **controls** — and estimate the treatment effect on `re78` (a) **naively** (raw treated−control difference) and (b) by **propensity-score matching** under **at least four** specifications. Vary two axes: the **covariate set** (demographics only vs demographics **+ `re74`/`re75`** pre-treatment earnings) and an **estimator detail** (with/without trimming to common support; 1-NN matching vs simple score stratification).
3. Lay the estimates **against the benchmark** in a specification table.
4. **Adjudicate** in `memo.md` (~450 words): does matching recover the benchmark **robustly**, **only under favorable specifications**, or **not at all** — and what may a paper legitimately claim?

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; conventions as in T1/T2 (Okabe-Ito palette and theme at the top; `set.seed()` before anything stochastic).
2. `figures/spec-curve.png` — exactly ONE figure: the estimates with 95% intervals across specifications, the experimental benchmark drawn as a horizontal reference line. 300+ dpi, no in-plot title.
3. `spec-table.md` — every specification's estimate laid against the benchmark (a gap column, or the benchmark side-by-side), plus the naive observational estimate.
4. `memo.md` — the ~450-word adjudication: concede what conditioning on the covariates is and is not doing, state whether recovery is robust / favorable-specification-only / absent, and say precisely what a paper may and may not claim.

**Method note.** `MatchIt` is installed; `Matching` is not. If you use `MatchIt`, target the ATT with replacement (`estimand = "ATT"`, `replace = TRUE`) so it matches the estimand here; if neither package were installed you would hand-roll it (a logit propensity model, 1-NN on the score, with replacement). Choose a **defensible standard error** for each estimator — note that the ordinary nonparametric bootstrap is **not** valid for nearest-neighbor matching variances (Abadie-Imbens 2008).

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access. Do not install packages. The memo must not overclaim: if recovery is specification-dependent, say so plainly — neither "matching works" nor "matching fails" unqualified.

=== PRODUCED: spec-table.md ===
# Specification table: LaLonde NSW vs. CPS-composite matching estimates

Benchmark = experimental treated-control difference in `re78` within `nsw_mixtape`.
Gap = specification estimate minus benchmark (positive = overstates program effect).
Standard errors: HC1-robust for difference-in-means rows; cluster-robust (clustered on
matched subclass/pair) for matching rows, per Abadie-Imbens (2008) caution against the
ordinary nonparametric bootstrap for nearest-neighbor matching variances.

| Specification | Covariates | Estimator | Trimmed | N | Estimate | 95% CI | Gap vs. benchmark |
|---|---|---|---|---|---|---|---|
| Experimental benchmark (NSW treated - control) | — | difference in means | — | 445 | $1,794 | [$480, $3,109] | $0 |
| Naive observational (NSW treated - CPS control) | — | difference in means | — | 16177 | $-8,498 | [$-9,638, $-7,357] | $-10,292 |
| Demographics - 1-NN, no trim | demographics | nn | no | 370 | $-2,798 | [$-4,411, $-1,185] | $-4,592 |
| Demographics - 1-NN, trimmed | demographics | nn | yes | 370 | $-2,798 | [$-4,411, $-1,185] | $-4,592 |
| Demographics - Stratification | demographics | strat | no | 16177 | $-4,137 | [$-6,431, $-1,842] | $-5,931 |
| Demographics + re74/re75 - 1-NN, no trim | demographics + re74/re75 | nn | no | 370 | $1,712 | [$347, $3,077] | $-82 |
| Demographics + re74/re75 - 1-NN, trimmed | demographics + re74/re75 | nn | yes | 370 | $1,759 | [$389, $3,128] | $-36 |
| Demographics + re74/re75 - Stratification | demographics + re74/re75 | strat | no | 16177 | $-144 | [$-3,505, $3,218] | $-1,938 |

=== PRODUCED: memo.md ===
# Adjudication: does propensity-score matching recover the LaLonde benchmark?

The experimental benchmark — the treated–control difference in `re78` within
the randomized NSW sample — is **+$1,794** (95% CI: $480, $3,109). Replacing
the experimental controls with the full CPS comparison pool and taking a raw
difference gives **–$8,498**: selection into the CPS sample is severe enough
to flip the sign of the estimated effect. That is the problem matching is
supposed to solve.

It does not solve it unconditionally. Across six specifications that cross
two covariate sets (demographics only; demographics **plus** pre-treatment
earnings `re74`/`re75`) with three estimator details (1-NN with replacement,
1-NN with common-support trimming, propensity-score stratification), recovery
is sharply **specification-dependent**, not robust and not absent.

**Demographics-only matching never recovers the benchmark.** Age, education,
race, marital status, and degree status describe *who* is unemployed but not
*why* — they don't capture the transitory earnings shock that got someone
into a job-training program in the first place. All three demographics-only
specifications land between –$2,798 and –$4,137, gaps of $4,600–$5,900,
with confidence intervals that exclude the benchmark entirely.

**Adding `re74`/`re75` closes the gap only under 1-NN matching.** With
pre-treatment earnings included, 1-NN estimates are $1,712 (no trim) and
$1,759 (trimmed) — within $35–$82 of the benchmark, comfortably inside its
confidence interval. This is the Dehejia-Wahba result, and it replicates
here. But score **stratification** with the identical, richer covariate set
gives –$144 with a confidence interval spanning $6,700 ($-3,505 to $3,218):
it neither confirms nor rules out recovery, it is simply too imprecise and
centered far from the benchmark to call a success. Trimming to common
support barely moved the 1-NN estimates because the matched controls were
already drawn from the overlapping region; the untrimmed and trimmed 1-NN
results are nearly identical, so trimming was not the active ingredient —
the pre-treatment earnings covariates were.

**What conditioning on `re74`/`re75` is and is not doing.** Including lagged
earnings does not certify that CPS controls and NSW treated units are
exchangeable on unobservables; it only removes the observable earnings-dip
signature that predicts NSW selection into the CPS-derived pool. When that
signature is included and matching uses each treated unit's single best
match (1-NN), the naive $10,000+ bias collapses to a few dollars. When the
same covariates are pooled into five coarse strata, precision is lost and
the bias correction is far less convincing.

**Verdict:** the evidence supports Smith and Todd over an unqualified reading
of Dehejia and Wahba. Recovery is real but **favorable-specification-only**:
it requires both the richer covariate set (pre-treatment earnings) and a
close, low-bias matching estimator (1-NN), and disappears under coarser
strata even with identical covariates. A paper may legitimately claim that
matching *can* recover experimental benchmarks when pre-treatment outcomes
are available and estimator choice is not coarse — but it may not claim that
matching *generally* recovers experimental benchmarks, nor that covariate
adjustment alone (without the earnings history) is sufficient.

=== PRODUCED: script.R ===
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
## Two axes:
##   covariates: demographics only vs. demographics + re74/re75
##   estimator:  1-NN w/ replacement (no trim) | 1-NN w/ replacement + common-support trim
##               | score stratification (5 strata)
## SE approach: because the ordinary nonparametric bootstrap is invalid for
## nearest-neighbor matching with replacement (Abadie & Imbens 2008), we do
## NOT bootstrap. Instead we fit a weighted regression of re78 on treat on
## the matched/weighted analysis sample (MatchIt weights encode match
## multiplicity/stratum membership) and use cluster-robust ("sandwich")
## standard errors clustered on the matched set (subclass for NN matches,
## stratum for stratification). This is the standard applied alternative
## recommended in the MatchIt/Stuart(2010) literature when Abadie-Imbens'
## closed-form NN variance estimator (which requires the Matching package's
## bias-adjusted infrastructure) is unavailable.

demo_covs   <- c("age", "educ", "black", "hisp", "marr", "nodegree")
full_covs   <- c(demo_covs, "re74", "re75")

fit_att <- function(mdata) {
  ## weighted regression of outcome on treat, cluster-robust SE by subclass
  f <- lm(re78 ~ treat, data = mdata, weights = weights)
  vc <- vcovCL(f, cluster = ~subclass, type = "HC1")
  est <- coef(f)["treat"]
  se  <- sqrt(vc["treat", "treat"])
  c(estimate = unname(est), se = unname(se))
}

run_spec <- function(covs, method, trim = FALSE, label) {
  form <- as.formula(paste("treat ~", paste(covs, collapse = " + ")))

  if (method == "nn") {
    m <- matchit(form, data = composite, method = "nearest",
                 distance = "glm", estimand = "ATT", replace = TRUE,
                 discard = if (trim) "both" else "none")
    mdata <- get_matches(m)  # pair-level id needed for cluster-robust SEs
  } else if (method == "strat") {
    m <- matchit(form, data = composite, method = "subclass",
                 distance = "glm", estimand = "ATT", subclass = 5,
                 discard = if (trim) "both" else "none")
    mdata <- match.data(m)
  }

  res <- fit_att(mdata)

  data.frame(
    spec = label,
    covariates = if (identical(covs, demo_covs)) "demographics" else "demographics + re74/re75",
    estimator = method,
    trimmed = trim,
    estimate = res["estimate"],
    se = res["se"],
    n_matched = nrow(mdata),
    row.names = NULL
  )
}

specs <- list(
  list(covs = demo_covs, method = "nn",    trim = FALSE, label = "Demographics - 1-NN, no trim"),
  list(covs = demo_covs, method = "nn",    trim = TRUE,  label = "Demographics - 1-NN, trimmed"),
  list(covs = demo_covs, method = "strat", trim = FALSE, label = "Demographics - Stratification"),
  list(covs = full_covs, method = "nn",    trim = FALSE, label = "Demographics + re74/re75 - 1-NN, no trim"),
  list(covs = full_covs, method = "nn",    trim = TRUE,  label = "Demographics + re74/re75 - 1-NN, trimmed"),
  list(covs = full_covs, method = "strat", trim = FALSE, label = "Demographics + re74/re75 - Stratification")
)

spec_results <- do.call(rbind, lapply(specs, function(s) {
  run_spec(s$covs, s$method, s$trim, s$label)
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
    "Standard errors: HC1-robust for difference-in-means rows; cluster-robust (clustered on",
    "matched subclass/pair) for matching rows, per Abadie-Imbens (2008) caution against the",
    "ordinary nonparametric bootstrap for nearest-neighbor matching variances.",
    "",
    table_md),
  "spec-table.md"
)

## ============================================================
## 2. Figure: spec curve
## ============================================================
plot_data <- spec_results
plot_data$spec <- factor(plot_data$spec, levels = rev(sapply(specs, `[[`, "label")))
plot_data$covariates <- factor(plot_data$covariates,
                                levels = c("demographics", "demographics + re74/re75"))

p <- ggplot(plot_data, aes(x = estimate, y = spec, color = covariates)) +
  geom_vline(xintercept = as.numeric(bench_est), linetype = "dashed",
             color = okabe_ito["black"], linewidth = 0.6) +
  geom_vline(xintercept = as.numeric(naive_est), linetype = "dotted",
             color = okabe_ito["red"], linewidth = 0.6) +
  geom_errorbar(aes(xmin = ci_low, xmax = ci_high), width = 0.15, linewidth = 0.6,
                orientation = "y") +
  geom_point(size = 2.8) +
  scale_color_manual(values = c(
    "demographics" = unname(okabe_ito["skyblue"]),
    "demographics + re74/re75" = unname(okabe_ito["blue"])
  ), name = "Covariate set") +
  scale_x_continuous(labels = scales::dollar_format()) +
  labs(x = "Estimated effect on 1978 earnings (re78)", y = NULL,
       caption = "Dashed line = experimental benchmark; dotted line = naive observational estimate.") +
  theme(legend.position = "bottom")

ggsave("figures/spec-curve.png", p, width = 9, height = 5.5, dpi = 320)

cat("\nDone. Wrote figures/spec-curve.png and spec-table.md\n")
cat("\n--- spec table preview ---\n")
print(all_rows[, c("spec", "estimate", "se", "gap")])

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
