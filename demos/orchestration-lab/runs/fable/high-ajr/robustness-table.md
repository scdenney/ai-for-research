# Robustness table — AJR (2001) settler-mortality instrument

Outcome: `logpgp95`. Endogenous regressor: `avexpr`. Excluded instrument: `logem4` throughout. All models estimated via `AER::ivreg` (2SLS) and `lm` (OLS, first stage). First-stage F is the F-test on the excluded instrument's exclusion restriction in the `avexpr ~ logem4 + controls` regression (`car::linearHypothesis`), not the whole-model F.

| Spec | n | OLS β(avexpr) | 2SLS β(avexpr) | First-stage β(logem4) | First-stage F | Weak instrument? |
|---|---:|---:|---:|---:|---:|:---:|
| 1. Baseline | 64 | 0.522 (0.061) | 0.944 (0.157) | −0.607 | 22.95 | No |
| 2. + latitude | 64 | 0.468 (0.064) | 0.996 (0.222) | −0.510 | 13.09 | No |
| 3. + continent (africa, asia) | 64 | 0.434 (0.054) | 0.839 (0.191) | −0.533 | 11.01 | No |
| 4. Drop neo-Europes (AUS/CAN/NZL/USA) | 60 | 0.487 (0.076) | 1.281 (0.358) | −0.391 | 8.65 | **Yes** |
| 5. Africa only (africa == 1) | 27 | 0.302 (0.106) | 2.400 (3.987) | −0.108 | 0.30 | **Yes** |

Standard errors in parentheses. Rule of thumb: first-stage F < 10 flags weak identification (Staiger–Stock).

**Reading the weak-identification rows.** In specs 4 and 5 the 2SLS point estimate is not interpretable as a reliable causal magnitude: with F = 8.65 (spec 4) the instrument is borderline-weak, and with F = 0.30 (spec 5) it is not statistically distinguishable from having no explanatory power over `avexpr` at all — the enormous 2SLS SE (3.99) on a coefficient of 2.40 is itself a symptom of this collapse, not evidence of a large effect. Neither row should be read as confirming or overturning the headline result; the design cannot speak to it in that subsample.
