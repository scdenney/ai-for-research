# Conjoint reference-category sensitivity analysis

Violent Crime Rate is a **binary** attribute (two levels); its AMCE under one baseline is
an exact sign-flip of its AMCE under the other, while its marginal means are fixed
regardless of baseline choice. Type of Place has six levels, so per-level AMCEs shift
in magnitude (not just sign) depending on which level is used as the reference category.

## Table 1 -- Violent Crime Rate: AMCE under each baseline vs. marginal means

| Level | AMCE (baseline = Less crime) | AMCE (baseline = More crime) | Marginal mean [95% CI] |
|---|---|---|---|
| 20% Less Crime Than National Average | 0 (ref) | 0.251 [0.168, 0.334] | 0.626 [0.584, 0.667] |
| 20% More Crime Than National Average | -0.251 [-0.334, -0.168] | 0 (ref) | 0.374 [0.333, 0.416] |

## Table 2 -- Type of Place: AMCEs shift with baseline

| Level | AMCE (base = City downtown / level1) | AMCE (base = Small town / level4) | AMCE (base = Rural / level3) | Marginal mean [95% CI] |
|---|---|---|---|---|
| City – downtown, with a mix of offices, apartments, and shops | 0 (ref) | -0.158 [-0.240, -0.076] | -0.135 [-0.219, -0.050] | 0.394 [0.342, 0.446] |
| City, more residential area | 0.115 [0.035, 0.195] | -0.043 [-0.128, 0.042] | -0.020 [-0.108, 0.069] | 0.509 [0.454, 0.564] |
| Rural area | 0.135 [0.050, 0.219] | -0.023 [-0.104, 0.058] | 0 (ref) | 0.529 [0.474, 0.583] |
| Small town | 0.158 [0.076, 0.240] | 0 (ref) | 0.023 [-0.058, 0.104] | 0.552 [0.499, 0.605] |
| Suburban neighborhood with houses only | 0.079 [-0.004, 0.161] | -0.079 [-0.161, 0.003] | -0.056 [-0.137, 0.025] | 0.473 [0.420, 0.526] |
| Suburban neighborhood with mix of shops, houses, businesses | 0.146 [0.068, 0.224] | -0.012 [-0.092, 0.068] | 0.012 [-0.070, 0.094] | 0.540 [0.489, 0.591] |

## Table 3 -- Baseline-free attribute importance (MM range)

| Rank | Attribute | # levels | MM range (max−min) |
|---|---|---|---|
| 1 | Violent Crime Rate (Vs National Rate) | 2 | 0.251 |
| 2 | Total Daily Driving Time for Commuting and Errands | 4 | 0.237 |
| 3 | Housing Cost | 3 | 0.198 |
| 4 | Type of Place | 6 | 0.158 |
| 5 | School Quality | 2 | 0.116 |
| 6 | Racial Composition | 4 | 0.059 |
| 7 | Presidential Vote (2020) | 3 | 0.056 |

