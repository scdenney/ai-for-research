# AJR replication and robustness

| Specification | Included controls | N | OLS: `avexpr` | 2SLS: `avexpr` | First stage: `logem4` | Excluded-instrument F | Weak (F < 10)? |
|:--|:--|--:|--:|--:|--:|--:|:--|
| Baseline | None | 64 | 0.522 | 0.944 | -0.607 | 22.95 | No |
| + Latitude | lat_abst | 64 | 0.468 | 0.996 | -0.510 | 13.09 | No |
| + Continent controls | africa, asia | 64 | 0.434 | 0.839 | -0.533 | 11.01 | No |
| Drop neo-Europes | None | 60 | 0.487 | 1.281† | -0.391 | 8.65 | **Yes** |
| Africa only | None | 27 | 0.302 | 2.400† | -0.108 | 0.30 | **Yes** |

Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). In every row, `avexpr` is instrumented by `logem4`; included controls enter both the structural equation and the instrument set. OLS and 2SLS use the same complete-case rows. The excluded-instrument statistic is the ordinary homoskedastic partial F test from nested first-stage `lm` models, conditional on the listed controls; it matches the weak-instrument diagnostic returned by `summary(AER::ivreg(...), diagnostics = TRUE)`. The four code-based neo-Europe exclusions exactly match observations with `rich4 == 1` in these data.

† F is below the rule-of-thumb threshold of 10. The 2SLS coefficient is shown for transparency but should not be treated as a reliable structural estimate. Estimation uses `AER::ivreg`; no generated-regressor standard-error approximation is used.
