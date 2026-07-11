# Conjoint design summary

## Level-frequency figure
![Level frequencies by attribute](figures/level-frequencies.png)
*Caption: Each bar is the number of primary-design profile appearances assigned to a level; panels use their own count scales to keep level labels legible.*

## Primary design

The primary design contains 400 respondents, 8 tasks per respondent, and 2 profiles per task (6400 profile appearances).
The eight primary tasks (choice1–choice8) define all summaries. The `choice1_repeated_flipped` outcome is retained by `reshape_projoint()` as `selected_repeated` and is excluded so it does not add a task or duplicate profiles.

## Attributes and level counts

| Attribute | Levels |
|---|---:|
| Housing Cost | 3 |
| Presidential Vote (2020) | 3 |
| Racial Composition | 4 |
| School Quality | 2 |
| Total Daily Driving Time for Commuting and Errands | 4 |
| Type of Place | 6 |
| Violent Crime Rate (Vs National Rate) | 2 |

## Level frequencies

Counts are profile appearances, not respondent counts: each attribute is observed once for every primary-design profile (denominator = 6,400 within attribute). Percentages are therefore within-attribute profile shares.

| Attribute | Level | Profile appearances | Share within attribute |
|---|---|---:|---:|
| Housing Cost | 15% of pre-tax income | 2114 | 33.0% |
| Housing Cost | 30% of pre-tax income | 2155 | 33.7% |
| Housing Cost | 40% of pre-tax income | 2131 | 33.3% |
| Presidential Vote (2020) | 30% Democrat, 70% Republican | 2144 | 33.5% |
| Presidential Vote (2020) | 50% Democrat, 50% Republican | 2147 | 33.5% |
| Presidential Vote (2020) | 70% Democrat, 30% Republican | 2109 | 33.0% |
| Racial Composition | 50% White, 50% Nonwhite | 1618 | 25.3% |
| Racial Composition | 75% White, 25% Nonwhite | 1600 | 25.0% |
| Racial Composition | 90% White, 10% Nonwhite | 1605 | 25.1% |
| Racial Composition | 96% White, 4% Nonwhite | 1577 | 24.6% |
| School Quality | 5 out of 10 | 3178 | 49.7% |
| School Quality | 9 out of 10 | 3222 | 50.3% |
| Total Daily Driving Time for Commuting and Errands | 10 min | 1601 | 25.0% |
| Total Daily Driving Time for Commuting and Errands | 25 min | 1724 | 26.9% |
| Total Daily Driving Time for Commuting and Errands | 45 min | 1527 | 23.9% |
| Total Daily Driving Time for Commuting and Errands | 75 min | 1548 | 24.2% |
| Type of Place | City – downtown, with a mix of offices, apartments, and shops | 1047 | 16.4% |
| Type of Place | City, more residential area | 1032 | 16.1% |
| Type of Place | Rural area | 1117 | 17.5% |
| Type of Place | Small town | 1092 | 17.1% |
| Type of Place | Suburban neighborhood with houses only | 1045 | 16.3% |
| Type of Place | Suburban neighborhood with mix of shops, houses, businesses | 1067 | 16.7% |
| Violent Crime Rate (Vs National Rate) | 20% Less Crime Than National Average | 3225 | 50.4% |
| Violent Crime Rate (Vs National Rate) | 20% More Crime Than National Average | 3175 | 49.6% |
