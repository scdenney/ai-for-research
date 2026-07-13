# `projoint` inventory for baseline sensitivity

## Scope and executed checks

All findings below come from local, read-only `Rscript` runs on 2026-07-13:

```r
library(projoint)
data(exampleData1)
pj <- reshape_projoint(
  exampleData1,
  .outcomes = c(paste0("choice", 1:8), "choice1_repeated_flipped")
)
```

Installed environment: R 4.5.1; `projoint` 1.1.1 at
`/opt/homebrew/lib/R/4.5/site-library`.

Executed schema checks: `str(pj)`, `print(pj$labels, n = Inf)`,
`names(pj$data)`, `levels()` for every factor, tables of the outcome
columns, and `length(unique(pj$data$id))`. Executed API checks:
`formals(projoint)`, `formals(set_qoi)`, package help converted with
`tools::Rd2txt()`, and successful estimation calls shown below.

## Reshaped object and identifiers

`reshape_projoint()` returns a `projoint_data` list, not a bare data frame:

* `pj$labels`: 24-row attribute/level lookup table.
* `pj$data`: 6,400 rows × 13 columns. One row is one respondent–task–profile.

Columns in `pj$data` are `id`, `task`, `profile`, `att4`, `att7`,
`att3`, `att1`, `att2`, `att5`, `att6`, `selected`,
`selected_repeated`, and `agree`.

* Respondent/cluster ID: `id` (character; 400 unique respondents). Each has
  16 rows: 8 tasks × 2 profiles. `projoint()` with defaults actually reported
  `cluster_by: id`.
* Task and profile IDs: `task` (1–8) and `profile` (1–2).
* Main choice outcome: `selected` (numeric; 3,200 zeroes, 3,200 ones).
* Repeated-task choice: `selected_repeated` (400 zeroes, 400 ones, 5,600 NA).
* Repeated-task agreement indicator: `agree` (228 zeroes, 572 ones, 5,600 NA).

## Attribute columns and observed levels

The factor values in `pj$data` are stable IDs; the corresponding display text
is from `pj$labels`.

| Attribute column | Display attribute | Levels (ID → label) | Type |
|---|---|---|---|
| `att1` | Housing Cost | `level1` → 15% of pre-tax income; `level2` → 30%; `level3` → 40% | Multi-level (3) |
| `att2` | Presidential Vote (2020) | `level1` → 30% Democrat, 70% Republican; `level2` → 50% Democrat, 50% Republican; `level3` → 70% Democrat, 30% Republican | Multi-level (3) |
| `att3` | Racial Composition | `level1` → 50% White, 50% Nonwhite; `level2` → 75% White, 25% Nonwhite; `level3` → 90% White, 10% Nonwhite; `level4` → 96% White, 4% Nonwhite | Multi-level (4) |
| `att4` | School Quality | `level1` → 5 out of 10; `level2` → 9 out of 10 | **Binary (2)** |
| `att5` | Total Daily Driving Time for Commuting and Errands | `level1` → 10 min; `level2` → 25 min; `level3` → 45 min; `level4` → 75 min | Multi-level (4) |
| `att6` | Type of Place | `level1` → City – downtown, with a mix of offices, apartments, and shops; `level2` → City, more residential area; `level3` → Rural area; `level4` → Small town; `level5` → Suburban neighborhood with houses only; `level6` → Suburban neighborhood with mix of shops, houses, businesses | Multi-level (6) |
| `att7` | Violent Crime Rate (Vs National Rate) | `level1` → 20% Less Crime Than National Average; `level2` → 20% More Crime Than National Average | **Binary (2)** |

The actual factor levels include the column prefix, e.g., `levels(pj$data$att7)`
is `c("att7:level1", "att7:level2")`. In `set_qoi()` calls, however, the
installed estimator successfully accepted the suffixes `"level1"` and
`"level2"`; passing full IDs such as `"att7:level2"` produced “No rows match
the specified attribute/level combination(s).”

## Installed AMCE/MM API

There are no exported `amce()`, `AMCE()`, `mm()`, `MM()`, or
`marginal_means()` functions. The relevant exported functions are:

```r
projoint(
  .data, .qoi = NULL, .by_var = NULL,
  .structure = "choice_level", .estimand = "mm",
  .se_method = "analytical", .irr = NULL, .remove_ties = TRUE,
  .ignore_position = NULL, .n_sims = NULL, .n_boot = NULL,
  .weights_1 = NULL, .clusters_1 = NULL, .se_type_1 = NULL,
  .weights_2 = NULL, .clusters_2 = NULL, .se_type_2 = NULL,
  .auto_cluster = TRUE, .seed = NULL
)

set_qoi(
  .structure = "choice_level", .estimand = "mm",
  .att_choose, .lev_choose,
  .att_notchoose = NULL, .lev_notchoose = NULL,
  .att_choose_b = NULL, .lev_choose_b = NULL,
  .att_notchoose_b = NULL, .lev_notchoose_b = NULL
)
```

For an all-attribute baseline-sensitivity inventory, the working public calls
are profile-level:

```r
# All 24 level MMs (baseline invariant)
mm_all <- projoint(pj, .structure = "profile_level", .estimand = "mm",
                   .se_method = "analytical")

# Default all-attribute AMCEs: hard-coded against each attribute's level1
amce_default <- projoint(pj, .structure = "profile_level", .estimand = "amce",
                         .se_method = "analytical")

# One explicit AMCE contrast
q <- set_qoi(.structure = "profile_level", .estimand = "amce",
             .att_choose = "att7", .lev_choose = "level2",
             .att_choose_b = "att7", .lev_choose_b = "level1")
crime_l2_vs_l1 <- projoint(pj, .qoi = q, .se_method = "analytical")
```

Those calls executed successfully. The MM result had 48 rows (uncorrected and
corrected estimates for all 24 levels), `cluster_by = "id"`, `se_type_used =
"CR2"`, and estimated `tau = 0.1721281`. The default AMCE result had 34 rows
(17 non-reference contrasts × uncorrected/corrected) and warned that its
analytical CR2 variances were non-PSD/NA, then fell back to `se_type = "stata"`.

## Feasible reference changes

### Violent Crime Rate (`att7`, binary)

Exactly two directed contrasts are possible; they contain the same comparison
with reversed sign (the executed corrected estimates were -0.251 and +0.251):

```r
# More crime relative to less crime
q_more_vs_less <- set_qoi("profile_level", "amce",
  .att_choose = "att7", .lev_choose = "level2",
  .att_choose_b = "att7", .lev_choose_b = "level1")

# Less crime relative to more crime
q_less_vs_more <- set_qoi("profile_level", "amce",
  .att_choose = "att7", .lev_choose = "level1",
  .att_choose_b = "att7", .lev_choose_b = "level2")
```

Thus binary attributes do not offer multiple substantively distinct comparison
sets: switching the reference only reverses direction/sign. This also applies
to School Quality (`att4`).

### Example multi-level attribute: Housing Cost (`att1`, three levels)

Any one of `level1`, `level2`, or `level3` can be set as the baseline, with a
separate profile-level QoI/fit for each non-baseline level. The installed API
requires `.lev_choose` to have length one at profile level; a vector caused
the executed error “`.lev_choose` must have length 1 for profile-level
estimands.” For example, the following two successful fits use `level2` as
the reference:

```r
q_l1_vs_l2 <- set_qoi("profile_level", "amce",
  .att_choose = "att1", .lev_choose = "level1",
  .att_choose_b = "att1", .lev_choose_b = "level2")
q_l3_vs_l2 <- set_qoi("profile_level", "amce",
  .att_choose = "att1", .lev_choose = "level3",
  .att_choose_b = "att1", .lev_choose_b = "level2")

fit_l1_vs_l2 <- projoint(pj, .qoi = q_l1_vs_l2, .se_method = "analytical")
fit_l3_vs_l2 <- projoint(pj, .qoi = q_l3_vs_l2, .se_method = "analytical")
```

## Recommended computational pattern

1. Estimate and retain `mm_all` once. Map `att_level_choose` back through
   `pj$labels`; compare the corrected MMs for every level. These estimates do
   not require choosing an AMCE reference.
2. For each desired AMCE baseline, loop over the other level suffixes and make
   one `set_qoi(..., .estimand = "amce")` plus one `projoint()` call per
   directed contrast. Combine `fit$estimates` with the selected baseline and
   human-readable labels. Keep corrected and uncorrected rows explicitly
   distinguished.
3. Specify `.structure = "profile_level"` and leave `.auto_cluster = TRUE`
   (or explicitly set `.clusters_2 = id` with a compatible `.se_type_2`) so
   repeated profiles remain clustered by respondent. Record `tau`,
   `se_type_used`, and warnings alongside results.
4. Do not treat a factor releveling as a baseline change. An executed negative
   control relevelled `pj$data$att7` to put `att7:level2` first, yet the
   default AMCE remained `att7:level2` versus `att7:level1` with an identical
   corrected estimate (-0.251). The package's default all-attribute AMCE path
   explicitly sets baseline suffix `"level1"`; use an explicit QoI instead.

## Risks / implementation cautions

* Choice-level estimation requires a non-NULL `.qoi`; profile-level estimation
  can enumerate all levels with `.qoi = NULL`. Do not copy the profile-level
  pattern into choice-level code unchanged.
* Package help describes `set_qoi()` level inputs as “level id(s),” but the
  executed implementation expects suffixes (`"level1"`), not full factor IDs
  (`"att7:level1"`). Construct and test a minimal QoI before a bulk run.
* `projoint()` estimates IRR by default here using the repeated task. The
  output reported `tau = 0.1721281`; using `.irr` changes that assumption and
  should be documented rather than silently changed.
* Default all-level analytical AMCEs emitted a variance fallback warning
  (CR2 → `stata`). Explicit single-contrast fits above used CR2. Preserve the
  returned `se_type_used` and assess SE-method sensitivity if inference—not
  only point-estimate reparameterization—is to be reported.
