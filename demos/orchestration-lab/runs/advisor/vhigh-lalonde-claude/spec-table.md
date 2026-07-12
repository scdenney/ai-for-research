# Specification table: NSW-treated + CPS-control composite vs. experimental benchmark

**Experimental benchmark** (NSW treated - control, n = 185 / 260): $1,794 (SE $671, 95% CI [$479, $3,109]).

**Observational composite**: 185 NSW-treated units + 15,992 CPS controls (n = 16,177).

| Specification | Covariate set | Estimator | n (treated/controls used) | Estimate [95% CI] | Gap vs. benchmark | Gap (SE units) |
|---|---|---|---|---|---|---|
| Naive (no adjustment) | None | Raw difference | 185 / 15992 | -$8,498 [-$9,641, -$7,354] | -$10,292 | -17.64 |
| PSM: demo, 1-NN | Demographics only | 1-NN, full support | 185 / 120 | -$2,798 [-$4,926, -$670] | -$4,592 | -4.23 |
| PSM: demo, 1-NN, trimmed | Demographics only | 1-NN, trimmed | 185 / 120 | -$2,798 [-$4,926, -$670] | -$4,592 | -4.23 |
| PSM: demo, stratified | Demographics only | Stratification | 185 / 15992 | -$4,137 [-$5,492, -$2,782] | -$5,931 | -8.58 |
| PSM: demo+earn, 1-NN | Demographics + re74/re75 | 1-NN, full support | 185 / 127 | $1,712 [$128, $3,296] | -$82 | -0.10 |
| PSM: demo+earn, 1-NN, trimmed | Demographics + re74/re75 | 1-NN, trimmed | 185 / 127 | $1,759 [$175, $3,342] | -$36 | -0.04 |
| PSM: demo+earn, stratified | Demographics + re74/re75 | Stratification | 185 / 15992 | -$144 [-$1,439, $1,152] | -$1,938 | -2.93 |

Gap = estimate - experimental benchmark ($1,794 rounded; exact value computed in `script.R`).
"Gap (SE units)" divides by each row's own SE, not the benchmark's --
dividing by the benchmark's $671 instead will not reproduce these numbers.
Standard errors for matching estimators are HC3-robust on a weighted
linear model fit to `match_data()` output (one row per matched unit,
weighted by reuse count), per the note in `script.R`: the ordinary
bootstrap is invalid for nearest-neighbor matching variances (Abadie &
Imbens 2008), the closed-form `Matching` package is not installed, and
cluster-robust alternatives are either invalid here (too few clusters for
stratification) or understate the SE (subclass clustering under
replacement).
