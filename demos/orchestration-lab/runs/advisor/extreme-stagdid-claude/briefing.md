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

=== PRODUCED: estimates-table.md ===
# ATT estimates: mpdta minimum-wage / teen employment panel

Outcome: `lemp` (log county teen employment). All standard errors are
county-clustered (or the package's native panel-bootstrap/analytic
county-level variance, where clustering isn't a separate argument).

| Estimator | ATT | SE | Control / comparison group |
|---|---|---|---|
| Naive TWFE (`post × ever-treated`, county + year FE) | -0.0365 | 0.0133 | All not-yet-/never-treated county-years pooled implicitly (2×2 comparisons include already-treated units as controls) |
| Callaway & Sant'Anna, simple aggregation | -0.0398 | 0.0117 | Not-yet-treated |
| Callaway & Sant'Anna, simple aggregation | -0.0400 | 0.0129 | Never-treated |
| Sun & Abraham (`fixest::sunab`), aggregated ATT | -0.0400 | 0.0118 | Not-yet-/never-treated (interacted-cohort estimator, last pre-period reference) |
| Roth & Sant'Anna (`staggered::staggered`), simple estimand | -0.0471 | 0.0116 | Not-yet-treated (efficient/doubly-robust weighting) |

## Goodman-Bacon decomposition of the naive TWFE

| Comparison type | Share of identifying weight | Weighted avg. 2×2 estimate |
|---|---|---|
| Treated vs. never-treated | 86.3% | -0.0407 |
| Earlier-treated vs. later-treated (as control) | 8.3% | -0.0198 |
| Later-treated vs. earlier-treated (as control) | 5.4% | +0.0046 |

"Contaminated" comparisons (already-treated units serving as controls, the
type Goodman-Bacon shows can carry negative weight if effects change over
time) together hold **13.7%** of total TWFE weight; the remaining **86.3%**
is clean treated-vs-never-treated variation.

=== PRODUCED: memo.md ===
# Memo: Does the TWFE critique change the conclusion for mpdta?

**Short answer: no, not substantively — though it does matter for precision and point-estimate size.**

The Goodman-Bacon decomposition shows the negative-weighting mechanism is
present but small in this dataset. Of the naive TWFE's identifying variation,
86.3% comes from clean treated-vs-never-treated comparisons; only 13.7% comes
from the "already-treated as control" comparisons that can carry negative
weight. Within that contaminated 13.7%, the two sub-components partly offset
(earlier-vs-later-treated averages -0.020; later-vs-earlier-treated averages
+0.005), so their net pull on the pooled estimate is modest rather than
sign-flipping or estimate-destroying. That's consistent with the underlying
treatment-timing structure here: 69% of ever-treated counties are treated in
the same year (2007), which mechanically limits how much "later vs. earlier"
comparison there is to contaminate.

Consistent with that, all five estimators land in a narrow, overlapping band:
naive TWFE (-0.037, SE 0.013), Callaway-Sant'Anna with not-yet-treated
controls (-0.040, SE 0.012) and never-treated controls (-0.040, SE 0.013),
Sun-Abraham (-0.040, SE 0.012), and Roth-Sant'Anna (-0.047, SE 0.012). None of
the modern estimators falls outside roughly one standard error of the naive
TWFE number, and every estimator agrees on sign and significance. The event
study (never-treated controls) shows small, statistically insignificant
pre-treatment coefficients at t=-2 and t=-1 (-0.001 and -0.025, both CIs
covering zero), so parallel trends looks reasonably supported, though the t=-1
point estimate is not trivially zero and is worth flagging rather than
ignoring. Post-treatment effects grow more negative over time (-0.02, -0.05,
-0.14 at event times 0-2), which is exactly the kind of dynamic heterogeneity
Goodman-Bacon warns can bias TWFE — but the Bacon weights show that
heterogeneity isn't concentrated in the contaminated comparisons here, so it
doesn't translate into a large TWFE bias.

**Bottom line:** for this county panel, TWFE understates the effect by only
about 0.3-1.0 percentage points relative to the heterogeneity-robust
estimators — not nothing, but not the qualitative reversal the reflexive rule
implies. I'd report the Callaway-Sant'Anna estimate as the headline number:
**ATT ≈ -0.04 log points (≈ -4% teen employment)**, both because it's
doubly robust to exactly this contamination and because it sits at the center
of the other modern estimates, while noting TWFE would have given the same
qualitative story.

=== PRODUCED: script.R ===
## script.R
## Reconciling naive TWFE against heterogeneity-robust staggered-adoption
## estimators on the Callaway-Sant'Anna mpdta (minimum wage / teen employment)
## county panel shipped with the `did` package.

set.seed(20260717)

suppressPackageStartupMessages({
  library(did)
  library(fixest)
  library(staggered)
  library(bacondecomp)
  library(ggplot2)
  library(dplyr)
})

## ---- Okabe-Ito palette + shared theme (declared up top, used by the one plot we produce) ----
okabe_ito <- c(
  black      = "#000000",
  orange     = "#E69F00",
  sky_blue   = "#56B4E9",
  bluish_grn = "#009E73",
  yellow     = "#F0E442",
  blue       = "#0072B2",
  vermillion = "#D55E00",
  purple     = "#CC79A7"
)

theme_okabe <- theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    axis.title = element_text(face = "bold"),
    plot.title = element_blank() # no in-plot titles per spec
  )

dir.create("figures", showWarnings = FALSE)

## ---- Data ----
data(mpdta)
# columns: year countyreal lpop lemp first.treat treat
# first.treat == 0 means never-treated in did::att_gt's convention.

mpdta <- mpdta %>%
  mutate(
    ever_treated = as.integer(first.treat != 0),
    post         = as.integer(ever_treated == 1 & year >= first.treat)
  )

cat("\n=== Treatment timing structure ===\n")
print(table(mpdta$first.treat))

## =========================================================================
## 1(a) Naive TWFE: post x ever-treated dummy, county + year FE, clustered SE
## =========================================================================
twfe_fit <- feols(lemp ~ post | countyreal + year, data = mpdta,
                   cluster = ~countyreal)
cat("\n=== (1a) Naive TWFE ===\n")
print(summary(twfe_fit))

twfe_att <- coef(twfe_fit)["post"]
twfe_se  <- se(twfe_fit)["post"]

## =========================================================================
## 1(b) Callaway & Sant'Anna, both control-group choices
##      did::att_gt uses gname = 0 for never-treated -- mpdta$first.treat
##      already encodes it that way, so it is used directly.
## =========================================================================
cs_notyet <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = mpdta,
  control_group = "notyettreated", clustervars = "countyreal",
  panel = TRUE, allow_unbalanced_panel = TRUE
)
cs_notyet_simple <- aggte(cs_notyet, type = "simple")

cs_never <- att_gt(
  yname = "lemp", tname = "year", idname = "countyreal",
  gname = "first.treat", data = mpdta,
  control_group = "nevertreated", clustervars = "countyreal",
  panel = TRUE, allow_unbalanced_panel = TRUE
)
cs_never_simple <- aggte(cs_never, type = "simple")

cat("\n=== (1b) Callaway-Sant'Anna: not-yet-treated controls, simple ATT ===\n")
print(summary(cs_notyet_simple))
cat("\n=== (1b) Callaway-Sant'Anna: never-treated controls, simple ATT ===\n")
print(summary(cs_never_simple))

## =========================================================================
## 1(c) Heterogeneity-robust alternatives: Sun-Abraham AND Roth-Sant'Anna
##      (task requires at least one; both are cheap here so both are reported)
## =========================================================================

## Sun & Abraham (2021) via fixest::sunab -- last pre-treatment period is the
## reference automatically; never-treated (first.treat==0) is recoded so
## sunab treats it as the (infinite) reference cohort.
mpdta_sa <- mpdta %>% mutate(first_treat_sa = ifelse(first.treat == 0, Inf, first.treat))
sunab_fit <- feols(lemp ~ sunab(first_treat_sa, year) | countyreal + year,
                    data = mpdta_sa, cluster = ~countyreal)
sunab_agg <- summary(sunab_fit, agg = "att")
cat("\n=== (1c) Sun-Abraham (fixest::sunab), aggregated ATT ===\n")
print(sunab_agg)

sunab_att <- sunab_agg$coeftable["ATT", "Estimate"]
sunab_se  <- sunab_agg$coeftable["ATT", "Std. Error"]

## Roth & Sant'Anna (2021) efficient estimator via staggered::staggered.
## NB: staggered's `g` column uses Inf for never-treated -- a different
## sentinel than did::att_gt's gname==0 -- so it must be recoded here.
mpdta_stg <- mpdta %>%
  transmute(
    i = countyreal, t = year, y = lemp,
    g = ifelse(first.treat == 0, Inf, first.treat)
  )
stag_simple <- staggered(df = mpdta_stg, i = "i", t = "t", g = "g", y = "y",
                          estimand = "simple")
cat("\n=== (1c) Roth-Sant'Anna (staggered::staggered), simple estimand ===\n")
print(stag_simple)

## =========================================================================
## 2. Goodman-Bacon decomposition of the naive TWFE
## =========================================================================
bacon_out <- bacon(lemp ~ post, data = mpdta, id_var = "countyreal", time_var = "year")

cat("\n=== (2) Goodman-Bacon decomposition: weight by comparison type ===\n")
bacon_summary <- bacon_out %>%
  group_by(type) %>%
  summarise(total_weight = sum(weight), avg_estimate = weighted.mean(estimate, weight), .groups = "drop") %>%
  arrange(desc(total_weight))
print(bacon_summary)

later_vs_earlier_weight <- bacon_summary %>%
  filter(type %in% c("Later vs Earlier Treated", "Earlier vs Later Treated")) %>%
  summarise(w = sum(total_weight)) %>% pull(w)
treated_vs_untreated_weight <- bacon_summary %>%
  filter(type == "Treated vs Untreated") %>%
  summarise(w = sum(total_weight)) %>% pull(w)

cat(sprintf("\nShare of weight on later-vs-earlier-treated (contaminated) comparisons: %.1f%%\n",
            100 * later_vs_earlier_weight))
cat(sprintf("Share of weight on treated-vs-never-treated (clean) comparisons: %.1f%%\n",
            100 * treated_vs_untreated_weight))

## =========================================================================
## 3. Event study / dynamic effects (parallel-trends check)
##    Built off the never-treated CS aggregation (largest, cleanest control pool).
## =========================================================================
cs_dynamic <- aggte(cs_never, type = "dynamic", min_e = -2, max_e = 2, na.rm = TRUE)
cat("\n=== (3) Event-study (dynamic) estimates, never-treated controls ===\n")
print(summary(cs_dynamic))

event_df <- data.frame(
  event_time = cs_dynamic$egt,
  estimate   = cs_dynamic$att.egt,
  se         = cs_dynamic$se.egt
) %>%
  mutate(
    ci_lo = estimate - qnorm(0.975) * se,
    ci_hi = estimate + qnorm(0.975) * se,
    period = ifelse(event_time < 0, "Pre-treatment", "Post-treatment")
  )

## ---- Figure: figures/event-study.png ----
p <- ggplot(event_df, aes(x = event_time, y = estimate, color = period)) +
  geom_vline(xintercept = -0.5, linetype = "dashed", color = okabe_ito["black"], linewidth = 0.6) +
  geom_hline(yintercept = 0, color = "grey50", linewidth = 0.4) +
  geom_pointrange(aes(ymin = ci_lo, ymax = ci_hi), linewidth = 0.8, size = 0.7) +
  scale_color_manual(values = c("Pre-treatment" = unname(okabe_ito["sky_blue"]),
                                 "Post-treatment" = unname(okabe_ito["vermillion"]))) +
  scale_x_continuous(breaks = event_df$event_time) +
  labs(x = "Event time (years relative to first minimum-wage increase)",
       y = "ATT on log teen employment (95% CI)",
       color = NULL) +
  theme_okabe +
  theme(legend.position = "top")

ggsave("figures/event-study.png", p, width = 7.5, height = 5, dpi = 320)

cat("\n=== Script complete. Outputs written to figures/event-study.png ===\n")

## ---- Console dump used to hand-assemble estimates-table.md and memo.md ----
cat("\n=== SUMMARY FOR TABLE ===\n")
cat(sprintf("TWFE:                 ATT=%.4f  SE=%.4f\n", twfe_att, twfe_se))
cat(sprintf("CS not-yet-treated:   ATT=%.4f  SE=%.4f\n", cs_notyet_simple$overall.att, cs_notyet_simple$overall.se))
cat(sprintf("CS never-treated:     ATT=%.4f  SE=%.4f\n", cs_never_simple$overall.att, cs_never_simple$overall.se))
cat(sprintf("Sun-Abraham:          ATT=%.4f  SE=%.4f\n", sunab_att, sunab_se))
cat(sprintf("Roth-Sant'Anna:       ATT=%.4f  SE=%.4f\n", stag_simple$estimate, stag_simple$se))

=== QUESTION ===
This is a completed submission against the brief above. What would you change?
