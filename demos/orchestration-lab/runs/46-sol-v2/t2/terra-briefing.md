# Terra consultation: AMCE analysis architecture

## Task

In the current project, produce a self-contained `script.R`, a 300+ dpi grouped dot-and-whisker AMCE plot, and an approximately 200-word paper-ready `report.md` for the `projoint::exampleData1` conjoint data. Estimate AMCEs for all seven attributes on profile choice with respondent-clustered uncertainty. Reference levels must appear at zero. The project forbids web access and package installation and permits at most one revision cycle.

The required data setup is:

```r
library(projoint)
data(exampleData1)
out <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
```

## Evidence gathered locally

- Installed `projoint` version: 1.1.1.
- `out$data` has 6,400 profile rows from 400 unique respondent IDs, an `id` column, seven attribute columns (`att1` through `att7`), and binary `selected`.
- `out$labels` maps 24 levels across all seven attributes.
- The direct package estimator is:

```r
fit <- projoint(
  out,
  .structure = "profile_level",
  .estimand = "amce",
  .se_method = "analytical",
  .clusters_2 = id,
  .se_type_2 = "CR2"
)
```

- That call estimates IRR from the repeated task (tau = 0.172), returns both `amce_uncorrected` and `amce_corrected`, and warns that CR2 produced non-PSD/NA variances, falling back internally to respondent-clustered `stata` SEs. The result records `se_type_used = "stata"` and `cluster_by = "id"`.
- The package documentation says that with clustering and a null SE type, its default is CR2; it can fall back as described above.
- There are 17 non-reference coefficients per estimand (34 total rows). Reference levels therefore need to be joined from `out$labels` and added at estimate/interval zero for plotting.

## Current proposed approach

Use `projoint()` directly at profile level with analytical respondent-clustered SEs, likely specify `.se_type_2 = "stata"` explicitly to avoid silent/fallback ambiguity after establishing CR2 is numerically invalid for this data. Plot and report the reliability-corrected AMCEs as the package's substantive corrected estimand, explicitly identify that choice in the caption/report, and optionally mention the estimated reliability and the clustered uncertainty. Preserve `out$labels` order within attributes and insert each first level as the zero reference. Declare the Okabe-Ito palette/theme and `set.seed()` at the top of the script.

## Alternatives considered

1. Plot/report uncorrected AMCEs, which align more closely with a conventional conjoint AMCE but underuse `projoint`'s correction design.
2. Plot both corrected and uncorrected estimates, which may violate the singular deliverable wording and overcrowd the required grouped figure.
3. Keep `.se_type_2 = "CR2"` and accept package fallback, which is reproducible but makes the requested variance estimator less transparent.

## Decision question

What single estimator/reporting architecture best satisfies the brief: corrected versus uncorrected AMCEs, explicit `stata` versus requested/default CR2-with-fallback clustered SEs, and how should zero reference rows and uncertainty language be handled so the result is statistically defensible and unambiguous?
