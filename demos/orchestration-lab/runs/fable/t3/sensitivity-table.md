# Baseline sensitivity: AMCE vs marginal means

## 1. Headline attribute (Violent Crime Rate) under each baseline

| Reference set | Contrast estimated | AMCE (corrected) | 95% CI | AMCE (uncorrected) |
|---|---|---|---|---|
| level1 = Less Crime (default) | level2 (More Crime) vs level1 (Less Crime) | -25.1pp | [-33.4, -16.8] | -16.5pp |
| level2 = More Crime (flipped) | level1 (Less Crime) vs level2 (More Crime) | 25.1pp | [16.8, 33.4] | 16.5pp |

Note: |AMCE| is identical (25.1pp) under both baselines for this binary attribute; only the sign flips.

## 2. A multi-level attribute (Total Daily Driving Time) — where the reviewer is right

| Level | AMCE vs *10 min* (default) | AMCE vs *75 min* (alt) |
|---|---|---|
| 10 min | 0.0 *(ref)* | 23.7pp |
| 25 min | -7.0pp | 16.8pp |
| 45 min | -14.1pp | 9.7pp |
| 75 min | -23.7pp | 0.0 *(ref)* |

Note: every non-reference number changes when the baseline changes, but the overall spread (max - min across levels) is preserved regardless of which level is chosen as reference.

## 3. Marginal means for ALL levels (the baseline-invariant quantity)

| Attribute | Level | Marginal mean | 95% CI |
|---|---|---|---|
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 62.6% | [58.4, 66.7] |
|  | 20% More Crime Than National Average | 37.4% | [33.3, 41.6] |
| Total Daily Driving Time for Commuting and Errands | 10 min | 61.0% | [56.7, 65.4] |
|  | 25 min | 54.1% | [49.8, 58.4] |
|  | 45 min | 47.0% | [42.5, 51.4] |
|  | 75 min | 37.3% | [32.9, 41.7] |
| Housing Cost | 15% of pre-tax income | 61.4% | [57.1, 65.7] |
|  | 30% of pre-tax income | 47.7% | [43.6, 51.7] |
|  | 40% of pre-tax income | 41.6% | [37.2, 45.9] |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 39.4% | [34.2, 44.6] |
|  | City, more residential area | 50.9% | [45.4, 56.4] |
|  | Rural area | 52.9% | [47.4, 58.3] |
|  | Small town | 55.2% | [49.9, 60.5] |
|  | Suburban neighborhood with houses only | 47.3% | [42.0, 52.6] |
|  | Suburban neighborhood with mix of shops, houses, businesses | 54.0% | [48.9, 59.1] |
| School Quality | 5 out of 10 | 44.2% | [40.1, 48.4] |
|  | 9 out of 10 | 55.8% | [51.6, 59.9] |
| Racial Composition | 50% White, 50% Nonwhite | 50.0% | [45.6, 54.4] |
|  | 75% White, 25% Nonwhite | 53.7% | [49.2, 58.1] |
|  | 90% White, 10% Nonwhite | 47.7% | [43.7, 51.8] |
|  | 96% White, 4% Nonwhite | 48.8% | [44.2, 53.4] |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 48.3% | [43.8, 52.8] |
|  | 50% Democrat, 50% Republican | 53.6% | [49.6, 57.6] |
|  | 70% Democrat, 30% Republican | 48.0% | [43.6, 52.4] |

## 4. Attribute importance by MM range (baseline-invariant ordering)

| Rank | Attribute | MM range (max - min) |
|---|---|---|
| 1 | Violent Crime Rate (Vs National Rate) | 25.1pp |
| 2 | Total Daily Driving Time for Commuting and Errands | 23.7pp |
| 3 | Housing Cost | 19.8pp |
| 4 | Type of Place | 15.8pp |
| 5 | School Quality | 11.6pp |
| 6 | Racial Composition | 5.9pp |
| 7 | Presidential Vote (2020) | 5.6pp |

Gap between rank 1 and rank 2: 1.4pp.

