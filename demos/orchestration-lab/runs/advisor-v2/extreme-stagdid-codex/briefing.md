=== ORIGINAL BRIEF ===
# Task EXTREME — Reconcile modern staggered-adoption DiD estimators

You are working in a project directory. Use R (`Rscript`); the `did`, `fixest`, `staggered`, and `bacondecomp` packages are installed.

**Data.** The Callaway-Sant'Anna minimum-wage/teen-employment county panel, as shipped in the `did` package (their own worked example — 500 US counties, 2003–2007, employment and population in logs):

```r
library(did)
data(mpdta)
# columns: year countyreal lpop lemp first.treat treat
# first.treat: the year a county's state first raised its minimum wage above the
# federal floor (2004, 2006, or 2007); 0 = never treated in this window.
```

**Situation.** Two-way fixed-effects (TWFE) regression is the textbook difference-in-differences estimator, but under **staggered treatment timing with heterogeneous effects**, Goodman-Bacon (2021) shows TWFE implicitly averages many 2x2 comparisons — including ones where an **already-treated** unit serves as the "control" for a **later-treated** one. If effects change over time, those comparisons can carry **negative weight**, contaminating the pooled estimate. This is why Callaway & Sant'Anna (2021), Sun & Abraham (2021), and de Chaisemartin & D'Haultfœuille (2020) built heterogeneity-robust alternatives, and why "never use plain TWFE on staggered data" has become a reflexive rule of thumb in applied econometrics. Reflexive rules are not the same as checking whether the problem they guard against is actually present in a given dataset. Your job is to check, not recite.

**Task.**

1. **Estimate the ATT at least four ways**: (a) naive TWFE (a `post × ever-treated` dummy, county and year fixed effects, clustered by county), (b) Callaway-Sant'Anna (`did::att_gt` + `aggte(type="simple")`) under **both** `control_group = "notyettreated"` and `control_group = "nevertreated"`, and (c) **at least one** of Sun-Abraham (`fixest::sunab`) or the Roth-Sant'Anna estimator (`staggered::staggered`). Cluster or use the package's native county-level variance wherever an option exists.
2. **Quantify whether the negative-weighting critique actually bites here.** Run a Goodman-Bacon decomposition (`bacondecomp::bacon`) on the naive TWFE and report what share of its identifying weight sits on "later vs. earlier treated" comparisons (the type that can carry negative weight) versus clean treated-vs-never-treated comparisons.
3. **Check pre-trends.** Produce an event-study / dynamic-effects estimate (e.g. `aggte(type="dynamic")`) covering at least two pre-treatment periods and one post-treatment period, and state whether the parallel-trends assumption looks supported.
4. **Adjudicate in `memo.md`** (~350 words): given (1)-(3), does the classic "TWFE is biased under staggered adoption" critique change the substantive conclusion for *this* dataset, or not — and why? State the ATT you'd actually report and its ballpark magnitude.

**Produce, in the current working directory:**

1. `script.R` — one self-contained script; Okabe-Ito palette and theme declared at the top if it produces a plot; `set.seed()` before anything stochastic.
2. `estimates-table.md` — every estimator from step 1, its ATT, its standard error, and its control-group/comparison-group choice, in one table.
3. `figures/event-study.png` — the dynamic/event-study estimates from step 3 with 95% intervals, a vertical line or shading marking the treatment period. 300+ dpi, no in-plot title.
4. `memo.md` — the ~350-word adjudication from step 4.

**Method note.** The packages you'll use encode "never treated" differently: `did::att_gt`'s `gname` column uses **0** for never-treated (as `mpdta$first.treat` already does); `staggered::staggered`'s `g` column uses **`Inf`** for never-treated. Read each package's own documentation for its convention before reusing a column across packages — do not assume one sentinel value carries over.

**Constraints.** At most one revision cycle. If your mode delegates, use at most 3 delegations. No web access beyond what's needed to check a package's documentation/help pages already installed locally. Do not install packages (`did`, `fixest`, `staggered`, `bacondecomp` are already present). The memo must not overclaim: it is not "TWFE is always fine" or "always use the modern estimator" — the answer must be grounded in what steps 1–3 actually showed for *this* dataset.

=== PRODUCED DELIVERABLES ===
--- estimates-table.md ---
| Estimator | ATT (log points) | Standard error | Control / comparison group |
|---|---:|---:|---|
| Naive TWFE | -0.0365 | 0.0133 | Post x ever-treated; county and year FE; county-clustered SE |
| Callaway-Sant'Anna | -0.0398 | 0.0129 | Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap |
| Callaway-Sant'Anna | -0.0400 | 0.0122 | Never-treated; county-clustered multiplier bootstrap |
| Roth-Sant'Anna efficient staggered rollout | -0.0471 | 0.0116 | Package-native efficient staggered-rollout variance; documented Inf never-treated coding |

All estimates are unadjusted for covariates and use `lemp` as the outcome, matching the requested TWFE specification.

--- memo.md ---
# Staggered-adoption DiD adjudication

For these counties, the staggered-TWFE warning is relevant but does not
materially change the result. The naive county- and
year-fixed-effects estimate is -0.0365 (SE 0.0133) log points. Robust
alternatives are close: Callaway--Sant'Anna (C&S) is -0.0398 (SE 0.0129) with
not-yet-treated controls and -0.0400 (SE 0.0122) with never-treated controls;
the Roth--Sant'Anna efficient estimator is -0.0471 (SE 0.0116). Changing the
estimator does not alter the sign or ballpark: the data indicate an employment
decline of roughly 4 percent, not a conclusion unique to TWFE.

The Goodman--Bacon decomposition is instructive: 86.28% of the naive TWFE
identifying weight is on treated-versus-never-treated 2x2
comparisons. Only 5.39% is on later-versus-earlier-treated comparisons--the
comparison in which the earlier cohort is already treated when used as a
control. The remaining 8.33% is earlier-versus-later-treated comparisons.
The Bacon component weights shown by the package are non-negative; the 5.39%
figure is exposure to the comparison type that can induce problematic implicit
weights when effects are dynamic, rather than a literal share of negative
numbers in the reported Bacon table. Robust estimates confirm it is not moving
the pooled conclusion much.

The dynamic C&S event study using not-yet-treated controls is consistent with
parallel trends. With event time -1 as the reference, the two
estimated leads are 0.027 (95% CI -0.007 to 0.061) at -3 and 0.024 (95% CI
-0.004 to 0.053) at -2. The group-time pretrend Wald test has p = 0.168. This
is not proof of parallel trends--the first lead is imprecise--but there is no
conventional detectable pre-treatment departure. Post-treatment effects are
clearly negative from event time +1 onward.

I would report the C&S simple ATT with not-yet-treated controls: -0.0398 log
points (SE 0.0129), or about a 4% reduction in teen employment. It uses valid
not-yet-treated comparison units without treating already-treated counties as
controls, and it agrees almost exactly with the never-treated version. This is
not a claim that plain TWFE is generally safe under staggered adoption. In this
short panel the problematic comparison has little weight, and robust
re-estimation shows that the inference survives it. The causal reading still
rests on parallel trends and no anticipation, which these data support only
indirectly.

--- script.R ---
set.seed(20260719)

# Packages and plot styling ---------------------------------------------------
library(did)
library(fixest)
library(staggered)
library(bacondecomp)
library(ggplot2)

# Okabe-Ito palette and a single reusable plotting theme.
okabe_ito <- c(
  orange = "#E69F00", sky_blue = "#56B4E9", bluish_green = "#009E73",
  yellow = "#F0E442", blue = "#0072B2", vermillion = "#D55E00",
  purple = "#CC79A7", grey = "#666666"
)
event_theme <- theme_minimal(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.title = element_text(color = "black"),
    axis.text = element_text(color = "black")
  )

# Data and common treatment indicator ----------------------------------------
data(mpdta, package = "did")
dat <- mpdta

# The requested textbook/TWFE regressor: post period times ever-treated.
dat$ever_treated <- as.integer(dat$first.treat > 0)
dat$post <- as.integer(dat$ever_treated == 1 & dat$year >= dat$first.treat)
dat$did_treat <- dat$ever_treated * dat$post

# (a) Naive two-way fixed effects, clustered by county.
twfe <- feols(
  lemp ~ did_treat | countyreal + year,
  data = dat,
  cluster = ~countyreal
)

# (b) Callaway-Sant'Anna. `first.treat == 0` is the documented did-package
# convention for never-treated counties. No covariates are included so that
# all estimates target the same unconditional outcome specification as TWFE.
boot_iterations <- 1999
cs_notyet <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = dat,
  control_group = "notyettreated", base_period = "universal",
  bstrap = TRUE, biters = boot_iterations, cband = FALSE,
  clustervars = "countyreal"
)
cs_never <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = dat,
  control_group = "nevertreated", base_period = "universal",
  bstrap = TRUE, biters = boot_iterations, cband = FALSE,
  clustervars = "countyreal"
)
cs_notyet_simple <- aggte(
  cs_notyet, type = "simple", bstrap = TRUE,
  biters = boot_iterations, cband = FALSE
)
cs_never_simple <- aggte(
  cs_never, type = "simple", bstrap = TRUE,
  biters = boot_iterations, cband = FALSE
)

# (c) Roth-Sant'Anna's efficient staggered-rollout estimator. The installed
# staggered-package documentation specifies Inf (not 0) for never-treated g.
dat$g_staggered <- ifelse(dat$first.treat == 0, Inf, dat$first.treat)
rs_simple <- staggered(
  df = dat, i = "countyreal", t = "year", g = "g_staggered", y = "lemp",
  estimand = "simple"
)

# Goodman-Bacon decomposition of the exact TWFE treatment indicator.
bacon_results <- bacon(
  lemp ~ did_treat, data = dat, id_var = "countyreal", time_var = "year",
  quietly = TRUE
)
bacon_weights <- aggregate(weight ~ type, data = bacon_results, FUN = sum)
later_earlier_weight <- bacon_weights$weight[
  bacon_weights$type == "Later vs Earlier Treated"
]
treated_untreated_weight <- bacon_weights$weight[
  bacon_weights$type == "Treated vs Untreated"
]

# Event study: universal base period makes event time -1 the reference period.
event_dynamic <- aggte(
  cs_notyet, type = "dynamic", min_e = -3, max_e = 3,
  bstrap = TRUE, biters = boot_iterations, cband = FALSE
)
event_df <- data.frame(
  event_time = event_dynamic$egt,
  estimate = event_dynamic$att.egt,
  se = event_dynamic$se.egt
)
event_df$lower <- event_df$estimate - qnorm(0.975) * event_df$se
event_df$upper <- event_df$estimate + qnorm(0.975) * event_df$se

dir.create("figures", showWarnings = FALSE, recursive = TRUE)
event_plot <- ggplot(event_df, aes(x = event_time, y = estimate)) +
  geom_hline(yintercept = 0, color = okabe_ito[["grey"]], linewidth = 0.35) +
  geom_vline(xintercept = 0, color = okabe_ito[["orange"]],
             linetype = "dashed", linewidth = 0.6) +
  geom_errorbar(aes(ymin = lower, ymax = upper), width = 0.10,
                color = okabe_ito[["blue"]], na.rm = TRUE) +
  geom_line(color = okabe_ito[["blue"]], linewidth = 0.5, na.rm = TRUE) +
  geom_point(color = okabe_ito[["blue"]], size = 2.2, na.rm = TRUE) +
  scale_x_continuous(breaks = event_df$event_time) +
  labs(
    x = "Event time (years relative to first treatment)",
    y = "ATT on log employment"
  ) +
  event_theme
ggsave(
  filename = "figures/event-study.png", plot = event_plot,
  width = 7, height = 4.5, units = "in", dpi = 320
)

# Required estimator table ----------------------------------------------------
twfe_se <- sqrt(diag(vcov(twfe)))["did_treat"]
estimates <- data.frame(
  estimator = c(
    "Naive TWFE",
    "Callaway-Sant'Anna",
    "Callaway-Sant'Anna",
    "Roth-Sant'Anna efficient staggered rollout"
  ),
  att = c(
    unname(coef(twfe)["did_treat"]),
    cs_notyet_simple$overall.att,
    cs_never_simple$overall.att,
    rs_simple$estimate
  ),
  se = c(
    unname(twfe_se),
    cs_notyet_simple$overall.se,
    cs_never_simple$overall.se,
    rs_simple$se
  ),
  comparison = c(
    "Post x ever-treated; county and year FE; county-clustered SE",
    "Not-yet-treated (includes never-treated); county-clustered multiplier bootstrap",
    "Never-treated; county-clustered multiplier bootstrap",
    "Package-native efficient staggered-rollout variance; documented Inf never-treated coding"
  ),
  check.names = FALSE
)

table_lines <- c(
  "| Estimator | ATT (log points) | Standard error | Control / comparison group |",
  "|---|---:|---:|---|",
  vapply(seq_len(nrow(estimates)), function(i) {
    sprintf(
      "| %s | %.4f | %.4f | %s |",
      estimates$estimator[i], estimates$att[i], estimates$se[i],
      estimates$comparison[i]
    )
  }, character(1)),
  "",
  "All estimates are unadjusted for covariates and use `lemp` as the outcome, matching the requested TWFE specification."
)
writeLines(table_lines, "estimates-table.md")

# Printed values support the accompanying memo and make the decomposition
# auditable without adding an unrequested output file.
print(estimates)
print(bacon_weights)
message(sprintf(
  "Bacon weight: later-vs-earlier = %.2f%%; treated-vs-untreated = %.2f%%.",
  100 * later_earlier_weight, 100 * treated_untreated_weight
))
message(sprintf(
  "C&S pre-trend Wald-test p-value (not-yet-treated controls): %.4f.",
  cs_notyet$Wpval
))
print(event_df)

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
