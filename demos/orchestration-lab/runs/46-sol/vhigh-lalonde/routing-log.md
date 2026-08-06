# Routing log

## Route table

| Workstream | Owner | Why this owner | Acceptance check |
|---|---|---|---|
| Decomposition, estimand, specification grid, uncertainty, and adjudication rule | Sol (lead, direct) | These are the compact, consequential analytical decisions reserved for the strongest tier. | ATT is consistent; the grid crosses two covariate sets, trimming, and estimator; ordinary NN bootstrap is not used; interpretation distinguishes point recovery from interval overlap. |
| Script and output implementation | Terra out-of-band | The design was fixed, so writing and running the R script was bounded implementation with objective checks. | `Rscript script.R` exits 0; benchmark is computed from NSW; nine observational rows; one 300+ dpi figure; memo is approximately 450 words. |
| Independent artifact audit | Terra out-of-band | A bounded read-only verification pass benefits from context isolation and does not require live orchestration. | Audit checks every file against `BRIEF.md`, recomputes or cross-checks values, and reports defects without editing. |
| Integration, one consolidated revision, visual QA, and final verification | Sol (lead, direct) | The lead owns conflict resolution, interpretation, and end-to-end accountability. | All audit defects are resolved in one revision cycle; regenerated outputs agree; figure is visually legible and uses a horizontal benchmark line. |

## Out-of-band calls

### 1. Terra implementation

Exact command:

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
  --sandbox workspace-write --skip-git-repo-check -C "$PWD" \
  'Objective: Implement the fixed LaLonde specification-curve analysis and generate all required deliverables. Inputs and authoritative paths: ./BRIEF.md; causaldata::nsw_mixtape and causaldata::cps_mixtape. Read BRIEF.md, but follow this fixed analytical contract where it is more specific. In scope: create only ./script.R, ./figures/spec-curve.png, ./spec-table.md, and ./memo.md; run script.R to generate the latter three. Out of scope: web access, package installation, edits outside the current directory, commits, routing-log.md, alternative analytical designs, or additional figures. Constraints and invariants: use Rscript; self-contained script; define an Okabe-Ito palette and plotting theme near the top; call set.seed(4601) before any potentially stochastic action; load causaldata, MatchIt, ggplot2, and sandwich only. Compute the experimental benchmark as mean re78 among NSW treated minus NSW experimental controls. Build the observational composite from all 185 NSW treated plus all 15,992 CPS controls. Use this fixed grid: naive raw difference plus eight adjusted cells crossing covariate model, trimming, and estimator. Demographics formula: treat ~ age + I(age^2) + educ + I(educ^2) + black + hisp + marr + nodegree. Earnings formula: demographics plus re74 + re75 + I(re74^2) + I(re75^2) + u74 + u75, where u74 and u75 indicate zero earnings. For each formula use MatchIt propensity logits with estimand ATT and distance glm. The 1-NN cells must use method nearest, replace TRUE, ratio 1, and m.order closest. The stratification cells must use method subclass with exactly five subclasses. No-trim cells use discard none and reestimate FALSE; common-support cells use discard both and reestimate TRUE. Extract match.data with drop.unmatched TRUE. Estimate every difference, including benchmark and naive, by lm(re78 ~ treat), weighted by MatchIt weights when adjusted; obtain HC2 standard errors with sandwich::vcovHC and normal 95 percent intervals. This is a conditional-on-estimated-score/match uncertainty analysis; do not bootstrap NN. Record estimate, SE, CI, benchmark, gap estimate-minus-benchmark, treated and unique control counts, and effective control sample size sum(w)^2/sum(w^2). The markdown table must contain the naive row and all eight adjusted rows, show dollars rounded to nearest whole dollar and include estimator, covariates, support, estimate, 95 percent CI, benchmark, gap, treated N, control N, and control ESS; state methods below it. The exactly one figure must plot naive plus all eight adjusted estimates and vertical 95 percent intervals against a horizontal benchmark line, use Okabe-Ito colors, have no in-plot title, include a figure caption rather than title, readable labels, and save figures/spec-curve.png at no less than 300 dpi. Memo target 430-500 words, based on the computed results: explicitly adjudicate robust recovery versus favorable-specification-only versus absent; concede what conditioning does and does not identify; discuss estimator, support, and covariate sensitivity; distinguish exact benchmark recovery from interval overlap; state precisely what a paper may and may not claim; note the trimmed ATT population and conditional SE limitation. Do not cite or fetch external sources. Write ownership: only script.R, figures/spec-curve.png, spec-table.md, memo.md. Expected artifact: those four complete deliverables and a clean successful Rscript run. Acceptance checks: script exits zero from current directory; benchmark is recomputed near 1794 not hard-coded; table has 9 observational rows; figure is exactly one PNG at 300+ dpi with no title; memo is 430-500 words and matches the numbers. Return in stdout: conclusion, evidence including exact benchmark and estimate range, changed files, acceptance results, and residual risk. Implement the deliverables directly; do not invoke any other skill, advisory consult, or sub-orchestration.' \
  < /dev/null > terra-implementation.log 2>&1
```

tokens used: 42,738

### 2. Terra verification

Exact command:

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium \
  --sandbox read-only --skip-git-repo-check -C "$PWD" \
  'Objective: Independently audit the completed LaLonde deliverables against BRIEF.md without editing any file. Inputs and authoritative paths: ./BRIEF.md, ./script.R, ./spec-table.md, ./memo.md, ./figures/spec-curve.png, and the installed causaldata, MatchIt, ggplot2, sandwich packages. In scope: read all artifacts; independently recompute or run read-only R checks for the experimental benchmark, naive contrast, all eight adjusted estimates and intervals, row counts, ATT settings, trimming behavior, unique control counts, effective sample sizes, figure orientation/reference line/palette/no-title/resolution, memo word count, numerical consistency, and whether the adjudication is warranted and appropriately qualified. Check that the covariate and estimator axes meet the brief, that ordinary bootstrap is not used for NN, and that HC2 weighted-regression uncertainty is described with its limitations. Out of scope: any file write, web access, package installation, redesign, commits, or fixes. Constraints and invariants: remain read-only; do not rely on worker claims; use independent calculations where feasible; distinguish substantive violations from optional polish. Write ownership: none. Expected artifact: stdout only, captured by the caller in terra-verification.log. Acceptance checks: report PASS or FAIL for each required deliverable and constraint; quote exact recomputed benchmark and adjusted estimate range; identify every mismatch with file and location; state whether the conclusion robust recovery, favorable-specification-only recovery, or no recovery follows from the point estimates. Return format: conclusion, evidence, per-artifact checks, defects ordered by severity, and residual risk. Implement the deliverables directly; do not invoke any other skill, advisory consult, or sub-orchestration.' \
  < /dev/null > terra-verification.log 2>&1
```

tokens used: 48,602

Terra token sum: 91,340.

## What Sol reasoned directly

Sol fixed the target as the ATT, recomputed the experimental benchmark rather than trusting the prompt, and chose an eight-cell grid crossing demographics versus demographics plus lagged earnings, no trimming versus common-support trimming, and 1-NN replacement versus five-score subclassification. Sol chose HC2 weighted-regression intervals that aggregate reuse through MatchIt control weights, explicitly treating them as conditional on the estimated scores and matches and avoiding the invalid ordinary nonparametric bootstrap for nearest-neighbor matching. Sol also set the adjudication standard: point-estimate proximity is evidence for a particular specification, interval inclusion is weaker compatibility evidence, and trimming changes the treated analysis population. The lead concluded that the large spread across reasonable fixed choices supports favorable-specification-only recovery.

## Friction

The initial fire-and-forget shell wrapper returned a PID but the execution environment reaped the background process before Codex launched; `terra-implementation.log` remained zero bytes and no Terra tokens were consumed. The same command was retried as a managed external process and completed normally. The Terra implementation produced two defects: it plotted the benchmark vertically despite the brief requiring a horizontal line, and it included the naive row in a range described as covering only the eight adjusted estimates. The read-only Terra audit independently identified the same two defects; its sandbox could not start R because R could not create a temporary session directory, so Sol supplied the fresh R rerun. Sol corrected both issues, plus clarified the earnings covariate label, in the single permitted revision cycle. No web access, package installation, spawn-agent use, or writes outside the current directory occurred.

[SOL LEAD TOKENS: 163,383]  + Terra one-shots: 91,340  = 254,723
