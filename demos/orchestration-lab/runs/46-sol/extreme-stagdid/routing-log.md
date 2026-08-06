# Routing log

## Route table

| Workstream | Owner | Rationale | Acceptance check |
|---|---|---|---|
| Estimand and specification | Sol lead | Compact, consequential design decisions remain with the strongest tier | Common outcome/sample/timing; explicit control groups and sentinel conventions |
| R implementation and artifact generation | Terra one-shot | Bounded implementation from a fixed specification | Fresh script run; exact Bacon reconstruction; complete table; compliant PNG |
| Adversarial verification | Terra one-shot (read-only) | Independent static and numerical challenge | Formula/sentinel/table/memo/PNG parity and independent recomputation |
| Integration and final verification | Sol lead | Interpretation, conflict resolution, and final accountability | Direct fresh run, stable hashes, all BRIEF.md requirements checked |

## Out-of-band calls

### 1. Failed background implementation launch

~~~bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" "Objective: implement the bounded R computation and reproducible artifacts specified below. Inputs and authoritative paths: ./BRIEF.md and the installed local R package documentation only. In scope: create script.R, estimates-table.md, and figures/event-study.png; run the script successfully. Out of scope: memo.md, routing-log.md, web access, package installation, substantive adjudication, and files outside the current directory. Constraints and invariants: set.seed(4601) before anything stochastic; use unweighted mpdta with outcome lemp and no covariates across estimators; construct post_treated as first.treat greater than zero and year at least first.treat; naive TWFE via fixest feols with countyreal and year fixed effects and countyreal-clustered SE; did att_gt plus aggte simple for both notyettreated and nevertreated, xformla intercept only, panel true, county clustering, universal base period, multiplier bootstrap with 999 iterations and 95 percent inference; include Sun-Abraham via fixest sunab with a never-treated cohort sentinel outside 2003-2007 and county clustering, aggregated ATT; include Roth-SantAnna staggered simple as an extra row, converting only its g column from 0 to Inf and using its native se; run bacondecomp bacon on the exact naive TWFE treatment indicator and print type weight shares and weighted contributions, especially Later vs Earlier Treated and Treated vs Untreated; generate the event study from the nevertreated Callaway-SantAnna model for event times -3 through 3, with universal base period, pointwise 95 percent intervals, the normalized -1 point, and a vertical marker at event time 0. Declare an Okabe-Ito palette and a named plotting theme near the top of script.R. Save PNG at 7 by 4.5 inches and at least 300 dpi, no in-plot title. estimates-table.md must contain every five estimator rows, ATT, SE, and explicit control or comparison group. script.R must be self-contained from the current directory, create figures if needed, overwrite its generated outputs deterministically, and print the Bacon shares, dynamic estimates, joint pretrend p-value, and all ATT values for lead inspection. Do not create any other artifacts. Acceptance checks: Rscript script.R exits zero; table numbers match objects; Bacon weights sum to one and TWFE equals sum of estimate times weight within numerical tolerance; the dangerous category is exactly the Bacon label Later vs Earlier Treated; figure dimensions and dpi satisfy the brief; did never uses 0, staggered never uses Inf. Return format in the log: conclusion, evidence, changed files, residual risk. Implement the deliverables directly; do not invoke any other skill, advisory consult, or sub-orchestration." < /dev/null > terra-implementation.log 2>&1 &
~~~

tokens used: 0

The command wrapper terminated the detached child before startup. The log was empty, no process remained, and no artifacts existed. This attempt is counted toward the three-delegation cap.

### 2. Serial implementation retry

~~~bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" "Objective: implement the bounded R computation and reproducible artifacts specified below. Inputs and authoritative paths: ./BRIEF.md and the installed local R package documentation only. In scope: create script.R, estimates-table.md, and figures/event-study.png; run the script successfully. Out of scope: memo.md, routing-log.md, web access, package installation, substantive adjudication, and files outside the current directory. Constraints and invariants: set.seed(4601) before anything stochastic; use unweighted mpdta with outcome lemp and no covariates across estimators; construct post_treated as first.treat greater than zero and year at least first.treat; naive TWFE via fixest feols with countyreal and year fixed effects and countyreal-clustered SE; did att_gt plus aggte simple for both notyettreated and nevertreated, xformla intercept only, panel true, county clustering, universal base period, multiplier bootstrap with 999 iterations and 95 percent inference; include Sun-Abraham via fixest sunab with a never-treated cohort sentinel outside 2003-2007 and county clustering, aggregated ATT; include Roth-SantAnna staggered simple as an extra row, converting only its g column from 0 to Inf and using its native se; run bacondecomp bacon on the exact naive TWFE treatment indicator and print type weight shares and weighted contributions, especially Later vs Earlier Treated and Treated vs Untreated; generate the event study from the nevertreated Callaway-SantAnna model for event times -3 through 3, with universal base period, pointwise 95 percent intervals, the normalized -1 point, and a vertical marker at event time 0. Declare an Okabe-Ito palette and a named plotting theme near the top of script.R. Save PNG at 7 by 4.5 inches and at least 300 dpi, no in-plot title. estimates-table.md must contain every five estimator rows, ATT, SE, and explicit control or comparison group. script.R must be self-contained from the current directory, create figures if needed, overwrite its generated outputs deterministically, and print the Bacon shares, dynamic estimates, joint pretrend p-value, and all ATT values for lead inspection. Do not create any other artifacts. Acceptance checks: Rscript script.R exits zero; table numbers match objects; Bacon weights sum to one and TWFE equals sum of estimate times weight within numerical tolerance; the dangerous category is exactly the Bacon label Later vs Earlier Treated; figure dimensions and dpi satisfy the brief; did never uses 0, staggered never uses Inf. Return format in the log: conclusion, evidence, changed files, residual risk. Implement the deliverables directly; do not invoke any other skill, advisory consult, or sub-orchestration." < /dev/null > terra-implementation.log 2>&1
~~~

tokens used: 28409

### 3. Read-only verification

~~~bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox read-only --skip-git-repo-check -C "$PWD" "Objective: independently and adversarially verify the completed staggered-DiD deliverables without editing them. Inputs and authoritative paths: ./BRIEF.md, ./script.R, ./estimates-table.md, ./memo.md, ./figures/event-study.png, and installed local R package documentation. In scope: read all inputs; parse script.R; independently recompute in a non-writing inline R process the naive TWFE, both Callaway-SantAnna simple ATTs, Sun-Abraham ATT, Roth-SantAnna simple result, Bacon type shares and exact TWFE reconstruction, never-treated dynamic effects from event times -3 through 3, and the joint pretrend p-value; compare recomputation to the table and memo with reasonable tolerance; check that treatment construction is year at least first.treat, did keeps never treated as 0, staggered converts never treated to Inf, inference choices meet the brief, and the dangerous Bacon category is Later vs Earlier Treated rather than all treated-treated comparisons; inspect the script for Okabe-Ito/theme placement, no plot title, pointwise 95 percent intervals, and an event-time-zero marker; inspect PNG dimensions and stored dpi using read-only system tools; count memo words and assess whether every factual claim is supported and appropriately qualified. Out of scope: any file edit or creation, running script.R itself because it writes artifacts, web access, package installation, changing the estimand, stylistic rewriting, and files outside the current directory. Constraints and invariants: remain read-only; use only installed packages and local help; treat positive Bacon 2x2 weights separately from potentially negative implicit group-time-effect weights; accept bootstrap SE variation only if caused by independent RNG sequence and flag any material mismatch; do not create a verification report file because stdout is captured to terra-verification.log by the parent. Expected artifact: terra-verification.log only via parent redirection. Acceptance checks: state PASS or FAIL for each required deliverable and each numerical identity; quote recomputed numbers and any mismatch; identify whether a single revision is needed. Return format in the log: conclusion, evidence/check matrix, changed files (must be none), residual risk, tokens used. Implement the verification directly; do not invoke any other skill, advisory consult, or sub-orchestration." < /dev/null > terra-verification.log 2>&1
~~~

tokens used: 148584

The static audit passed the specification, sentinel, table, memo, and PNG checks. Independent R startup failed because the read-only sandbox disallowed creation of R's temporary directory. The verifier made no edits. The Sol lead therefore ran the authoritative fresh end-to-end check directly.

## Direct Sol analytical decisions

- Targeted a common unweighted, unconditional ATT on log employment across estimators; no covariates were introduced into only a subset of specifications.
- Defined treatment as `first.treat > 0 & year >= first.treat`; the dataset's constant `treat` field is an ever-treated indicator and was not misused as post-treatment status.
- Kept `first.treat = 0` for `did::att_gt`, used an out-of-window cohort for `fixest::sunab`, and created a separate `Inf` cohort only for `staggered::staggered`.
- Included both Sun-Abraham and Roth-Sant'Anna, exceeding the minimum modern-estimator requirement.
- Used never-treated Callaway-Sant'Anna dynamics with a universal base period, normalized event time -1, event times -3 through 3, and pointwise 95% intervals.
- Interpreted the 5.392% Bacon share as weight on the potentially contaminated Later vs Earlier Treated comparison type, not as literal negative 2x2 weights. Clean treated-vs-never comparisons carry 86.277%; the problematic type contributes +0.000248 and slightly offsets the negative TWFE coefficient.
- Selected the never-treated Callaway-Sant'Anna ATT (-0.03995, SE 0.01190) for substantive reporting because the never-treated pool is large and the estimate agrees with not-yet-treated C&S and Sun-Abraham.
- Judged the pretrend evidence supportive but not dispositive: event-time -3 and -2 intervals include zero and the joint pretest is p = 0.168, but the pre-period is short.

## Friction, corrections, and final checks

- The first detached Terra call was killed by the wrapper before startup; the serial retry succeeded.
- The read-only Terra verifier could not initialize R because no temporary directory was writable. This was an environment failure, not an artifact mismatch.
- No content correction was indicated, so the permitted revision cycle was not consumed by a substantive edit.
- Direct Sol execution of `Rscript script.R` exited 0 and reproduced all values. Bacon weights sum to 1.000000000000 and reconstruct TWFE exactly: -0.036548936674.
- Pre/post SHA-256 hashes were identical for `script.R`, `estimates-table.md`, `memo.md`, and `figures/event-study.png`, establishing deterministic regeneration.
- The figure is 2240 x 1440 pixels at 320 dpi with no in-plot title and a treatment-period marker. The memo is 353 words.
- No web access, package installation, commit, push, or write outside this run directory was performed by the lead.

[SOL LEAD TOKENS: 196738] + Terra one-shots: 176993 = 373731
