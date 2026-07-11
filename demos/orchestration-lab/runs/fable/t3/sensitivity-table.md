# Baseline-Sensitivity of the Violent-Crime Conjoint Finding

All estimates are IRR measurement-error-**corrected** profile-level
quantities (projoint `amce_corrected` / `mm_corrected`), using the
`choice1_repeated_flipped` task. Estimates in probability units; 95% CIs.

## (i) Crime attribute (att7) AMCE under each baseline choice

| Baseline (reference level) | Contrast level | AMCE (corrected) | 95% CI |
|---|---|---|---|
| 20% Less Crime Than National Average | 20% More Crime Than National Average | -0.251 | [-0.334, -0.168] |
| 20% More Crime Than National Average | 20% Less Crime Than National Average | 0.251 | [0.168, 0.334] |

Binary attribute: re-baselining flips the sign exactly (-0.251 vs 0.251); |AMCE| = 0.251 and CI width are identical.

## (ii) att6 (Type of Place) re-baselining: max-|AMCE| under each baseline

Alternative baseline chosen = level 2 (“City, more residential area”), the level whose MM is closest to the sample-average MM of 0.5.

| Baseline for att6 | max-\|AMCE\| (corrected) |
|---|---|
| Default (level1, “City – downtown, with a mix of offices, apartments, and shops”) | 0.158 |
| Alternative (level2, “City, more residential area”) | 0.115 |

## (iii) Attribute-importance ordering by max-|AMCE|

| Rank | Default baselines | max-\|AMCE\| | Alternative regime (att6 re-baselined) | max-\|AMCE\| |
|---|---|---|---|---|
| 1 | Violent Crime Rate | 0.251 | Violent Crime Rate | 0.251 |
| 2 | Daily Driving Time | 0.237 | Daily Driving Time | 0.237 |
| 3 | Housing Cost | 0.198 | Housing Cost | 0.198 |
| 4 | Type of Place | 0.158 | School Quality | 0.116 |
| 5 | School Quality | 0.116 | Type of Place | 0.115 |
| 6 | Presidential Vote (2020) | 0.053 | Presidential Vote (2020) | 0.053 |
| 7 | Racial Composition | 0.037 | Racial Composition | 0.037 |

## (iv) Baseline-INVARIANT importance: per-attribute MM spread

| Rank | Attribute | MM spread (max MM − min MM) |
|---|---|---|
| 1 | Violent Crime Rate | 0.251 |
| 2 | Daily Driving Time | 0.237 |
| 3 | Housing Cost | 0.198 |
| 4 | Type of Place | 0.158 |
| 5 | School Quality | 0.116 |
| 6 | Racial Composition | 0.059 |
| 7 | Presidential Vote (2020) | 0.056 |

## (v) Marginal Means with 95% CIs

### MMs — Violent Crime Rate (att7)

| Level | MM (corrected) | 95% CI |
|---|---|---|
| 20% Less Crime Than National Average | 0.626 | [0.584, 0.667] |
| 20% More Crime Than National Average | 0.374 | [0.333, 0.416] |

### MMs — Type of Place (att6)

| Level | MM (corrected) | 95% CI |
|---|---|---|
| City – downtown, with a mix of offices, apartments, and shops | 0.394 | [0.342, 0.446] |
| City, more residential area | 0.509 | [0.454, 0.564] |
| Rural area | 0.529 | [0.474, 0.583] |
| Small town | 0.552 | [0.499, 0.605] |
| Suburban neighborhood with houses only | 0.473 | [0.420, 0.526] |
| Suburban neighborhood with mix of shops, houses, businesses | 0.540 | [0.489, 0.591] |

### MMs — all attributes (compact)

| Attribute | Level | MM (corrected) | 95% CI |
|---|---|---|---|
| Housing Cost | 15% of pre-tax income | 0.614 | [0.571, 0.657] |
| Housing Cost | 30% of pre-tax income | 0.477 | [0.436, 0.517] |
| Housing Cost | 40% of pre-tax income | 0.416 | [0.372, 0.459] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 0.483 | [0.438, 0.528] |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 0.536 | [0.496, 0.576] |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 0.480 | [0.436, 0.524] |
| Racial Composition | 50% White, 50% Nonwhite | 0.500 | [0.456, 0.544] |
| Racial Composition | 75% White, 25% Nonwhite | 0.537 | [0.492, 0.581] |
| Racial Composition | 90% White, 10% Nonwhite | 0.477 | [0.437, 0.518] |
| Racial Composition | 96% White, 4% Nonwhite | 0.488 | [0.442, 0.534] |
| School Quality | 5 out of 10 | 0.442 | [0.401, 0.484] |
| School Quality | 9 out of 10 | 0.558 | [0.516, 0.599] |
| Daily Driving Time | 10 min | 0.610 | [0.567, 0.654] |
| Daily Driving Time | 25 min | 0.541 | [0.498, 0.584] |
| Daily Driving Time | 45 min | 0.470 | [0.425, 0.514] |
| Daily Driving Time | 75 min | 0.373 | [0.329, 0.417] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 0.394 | [0.342, 0.446] |
| Type of Place | City, more residential area | 0.509 | [0.454, 0.564] |
| Type of Place | Rural area | 0.529 | [0.474, 0.583] |
| Type of Place | Small town | 0.552 | [0.499, 0.605] |
| Type of Place | Suburban neighborhood with houses only | 0.473 | [0.420, 0.526] |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 0.540 | [0.489, 0.591] |
| Violent Crime Rate | 20% Less Crime Than National Average | 0.626 | [0.584, 0.667] |
| Violent Crime Rate | 20% More Crime Than National Average | 0.374 | [0.333, 0.416] |

## Table note

All quantities are IRR measurement-error-**corrected** profile-level estimates (projoint `amce_corrected` / `mm_corrected`; tau estimated from `choice1_repeated_flipped`). In (i), each column names its reference (baseline) level; the AMCE is the listed contrast level vs that reference. In (iii), the default column uses each attribute's level1 as baseline, and the alternative column re-baselines att6 to level2 (“City, more residential area”) while all other attributes stay at their default baseline. MM spread (iv) and marginal means (v) do not depend on any baseline. AMCE≡MM-difference consistency check: max discrepancy = 6.83e-15 across all default contrasts. Estimates in probability units, rounded to 3 decimals.
