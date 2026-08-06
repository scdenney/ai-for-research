# Robustness of the AJR institutions–income IV estimate

| Specification | N | OLS: avexpr | 2SLS: avexpr | First-stage: logem4 | First-stage F | Identification |
|:--|--:|--:|--:|--:|--:|:--|
| Bivariate | 64 | 0.522 | 0.944 | -0.607 | 22.95 | Not weak by F ≥ 10 rule |
| Add latitude | 64 | 0.468 | 0.996 | -0.510 | 13.09 | Passes F ≥ 10 rule, but borderline |
| Add continent controls | 64 | 0.434 | 0.839 | -0.533 | 11.01 | Passes F ≥ 10 rule, but borderline |
| Drop neo-Europes | 60 | 0.487 | 1.281 | -0.391 | 8.65 | Weak (F < 10) |
| Africa only | 27 | 0.302 | 2.400 | -0.108 | 0.30 | Weak (F < 10) |

Notes: The outcome is log PPP GDP per capita in 1995 (`logpgp95`). OLS and 2SLS use the same complete-case analytic sample within each row. The structural regressor is institutions (`avexpr`); the excluded instrument is log settler mortality (`logem4`). The first-stage F is the one-degree-of-freedom partial F test of the excluded instrument conditional on the listed controls. `F < 10` is flagged as weak identification; 2SLS point estimates in those rows should not be interpreted as reliable. `Add latitude` controls for `lat_abst`; `Add continent controls` controls for `africa` and `asia`; the neo-Europe restriction removes AUS, CAN, NZL, and USA. 2SLS is estimated with `AER::ivreg`.
