# Community-choice conjoint: design summary

## Design

| Component | Value |
|---|---:|
| Respondents | 400 |
| Primary randomized choice tasks per respondent | 8 |
| Repeated reliability task per respondent | 1 |
| Administered choice tasks per respondent | 9 |
| Profiles per respondent-task | 2 |
| Profile rows used for balance checks | 6400 |

Each respondent receives 8 primary randomized tasks plus 1 repeated reliability task, for 9 administered choice tasks. The repeated task reuses task-1 profiles, so it adds no new randomized profiles and is excluded from the 6,400-profile balance checks.

## Attributes and levels

| ID | Attribute | Levels |
|---|---|---:|
| `att1` | Housing Cost | 3 |
| `att2` | Presidential Vote (2020) | 3 |
| `att3` | Racial Composition | 4 |
| `att4` | School Quality | 2 |
| `att5` | Total Daily Driving Time for Commuting and Errands | 4 |
| `att6` | Type of Place | 6 |
| `att7` | Violent Crime Rate (Vs National Rate) | 2 |

## Randomization balance check

Each row below is a profile-level count (6,400 profiles total); within an attribute, percentages sum to 100%. The observed frequencies are close to the equal-allocation expectation for their respective numbers of levels.

| Attribute | Level | Profiles | Observed | Equal-allocation benchmark | Deviation |
|---|---|---:|---:|---:|---:|
| Housing Cost | 15% of pre-tax income | 2114 | 33.0% | 33.3% | -0.3 pp |
| Housing Cost | 30% of pre-tax income | 2155 | 33.7% | 33.3% | +0.3 pp |
| Housing Cost | 40% of pre-tax income | 2131 | 33.3% | 33.3% | -0.0 pp |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 2144 | 33.5% | 33.3% | +0.2 pp |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 2147 | 33.5% | 33.3% | +0.2 pp |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 2109 | 33.0% | 33.3% | -0.4 pp |
| Racial Composition | 50% White, 50% Nonwhite | 1618 | 25.3% | 25.0% | +0.3 pp |
| Racial Composition | 75% White, 25% Nonwhite | 1600 | 25.0% | 25.0% | +0.0 pp |
| Racial Composition | 90% White, 10% Nonwhite | 1605 | 25.1% | 25.0% | +0.1 pp |
| Racial Composition | 96% White, 4% Nonwhite | 1577 | 24.6% | 25.0% | -0.4 pp |
| School Quality | 5 out of 10 | 3178 | 49.7% | 50.0% | -0.3 pp |
| School Quality | 9 out of 10 | 3222 | 50.3% | 50.0% | +0.3 pp |
| Total Daily Driving Time for Commuting and Errands | 10 min | 1601 | 25.0% | 25.0% | +0.0 pp |
| Total Daily Driving Time for Commuting and Errands | 25 min | 1724 | 26.9% | 25.0% | +1.9 pp |
| Total Daily Driving Time for Commuting and Errands | 45 min | 1527 | 23.9% | 25.0% | -1.1 pp |
| Total Daily Driving Time for Commuting and Errands | 75 min | 1548 | 24.2% | 25.0% | -0.8 pp |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 1047 | 16.4% | 16.7% | -0.3 pp |
| Type of Place | City, more residential area | 1032 | 16.1% | 16.7% | -0.5 pp |
| Type of Place | Rural area | 1117 | 17.5% | 16.7% | +0.8 pp |
| Type of Place | Small town | 1092 | 17.1% | 16.7% | +0.4 pp |
| Type of Place | Suburban neighborhood with houses only | 1045 | 16.3% | 16.7% | -0.3 pp |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 1067 | 16.7% | 16.7% | +0.0 pp |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 3225 | 50.4% | 50.0% | +0.4 pp |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 3175 | 49.6% | 50.0% | -0.4 pp |

![Attribute-level frequencies](figures/level-frequencies.png)

*Figure 1. Observed shares of the 6,400 randomized profiles assigned to each attribute level; percentages sum to 100 within each facet.*

