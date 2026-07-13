# Routing log

## Route table

| Workstream | Owner | Why this owner | Acceptance check |
|---|---|---|---|
| Estimand, sample, and diagnostic design | Sol (lead, direct) | The definition of comparable samples, controls, and weak-identification evidence required analytical judgment and governed all downstream work. | Each specification uses one complete-case sample for OLS, IV, and first stage; the excluded-instrument partial F comes from the specification-specific first stage. |
| Mechanical estimation and table generation | Terra out-of-band | The implementation was bounded by fixed formulas, restrictions, outputs, and objective runtime checks. | `Rscript script.R` succeeds; five rows are produced; reruns are byte-identical; restrictions and weak flags are correct. |
| Interpretation and claim calibration | Sol (lead, direct) | Distinguishing non-robustness from weak-IV inconclusiveness and bounding the causal claim required lead-level judgment. | Memo is roughly 400 words, matches the estimates, and neither confirms nor overturns the result from weakly identified specifications. |
| Independent artifact audit | Terra out-of-band | Static review and routine recomputation were bounded verification work and benefited from a fresh context. | Formulas, samples, table, memo, and constraints checked; numerical recomputation attempted independently. |
| Integration and final verification | Sol (lead, direct) | The lead retained end-to-end accountability and had to resolve the verifier's sandbox limitation. | Independent all-specification recomputation matches every reported value; required files exist; constraints and routing record are complete. |

## Out-of-band calls

### 1. Mechanical implementation — tokens used: 33,484

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" 'Objective:
Create the deterministic R estimation artifact and the Markdown robustness table required by BRIEF.md.

Inputs and authoritative paths:
- Read ./BRIEF.md completely.
- Data are loaded only with library(ivdoctr); data(colonial, package = "ivdoctr").
- AER is confirmed available.

In scope:
- Write only ./script.R and ./robustness-table.md.
- Implement exactly five specifications: Base (no controls); Latitude (lat_abst); Continent controls (africa + asia); Drop neo-Europes (exclude AUS, CAN, NZL, USA by shortnam, no added controls); Africa only (africa == 1, no added controls).
- For each specification, build one estimation data frame by applying the restriction and complete.cases to the outcome, endogenous regressor, excluded instrument, and that specification’s controls. Fit OLS and IV on this identical sample.
- OLS: lm(logpgp95 ~ avexpr + controls).
- IV: AER::ivreg(logpgp95 ~ avexpr + controls | logem4 + controls).
- First stage: lm(avexpr ~ logem4 + controls) on that same data. Record the logem4 coefficient.
- Compute the conventional partial F for the excluded instrument by anova(restricted first stage without logem4, unrestricted first stage with logem4), extracting the F statistic. With one excluded instrument this is the standard first-stage excluded-instrument F.
- Mark F < 10 as weak. Preserve the numerical IV estimate in the table for transparency but label weak cases explicitly and ensure the note says weak-spec IV point estimates are not reliable causal estimates.
- Table must have one row/specification and columns sufficient to show N, OLS avexpr estimate, 2SLS avexpr estimate, first-stage logem4 coefficient, first-stage F, identification status. Use sensible precision and one Markdown table only.
- script.R must be self-contained, declare libraries at top, include set.seed() before estimation even though deterministic, generate robustness-table.md when run, and state/use the AER::ivreg path. No figure.

Out of scope:
- Do not write memo.md, routing-log.md, logs, figures, or any other file.
- Do not interpret manuscript claims beyond concise table notes.
- No web, no package installation, no commits.

Constraints and invariants:
- Current leaf only. Preserve unrelated files.
- Follow BRIEF.md exactly.
- Do not use robust/clustered standard errors; no SEs are requested.
- Do not substitute ivreg diagnostic output for the explicitly computed first-stage partial F.

Write ownership:
Exclusive ownership of script.R and robustness-table.md. The shared workspace may change; reread inputs immediately before editing. Use apply_patch for edits.

Expected artifact:
A clean self-contained script.R and its generated robustness-table.md.

Acceptance checks:
Run Rscript script.R successfully. Verify exactly five rows, each OLS/IV pair uses identical N, restrictions are correct, Africa-only has 27 observations before any missingness, and rerunning produces identical table bytes. Report relevant numerical results and file paths.

Return format:
Conclusion, evidence/check output, changed files, residual risk.' < /dev/null > terra-implementation.log 2>&1
```

### 2. Independent verification — tokens used: 56,775

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox read-only --skip-git-repo-check -C "$PWD" 'Objective:
Independently audit the completed AJR replication artifacts against BRIEF.md. This is a verification task, not implementation.

Inputs and authoritative paths:
Read ./BRIEF.md, ./script.R, ./robustness-table.md, and ./memo.md. Load the local ivdoctr colonial data and run read-only R commands as needed.

In scope:
- Check all five specification definitions and restrictions.
- Check that OLS and AER::ivreg formulas use the same controls and same complete-case sample per specification.
- Independently recompute OLS avexpr coefficients, IV avexpr coefficients, first-stage logem4 coefficients, excluded-instrument partial F statistics, N, and weak flags.
- Check table values/rounding against recomputation.
- Check memo claims against results, especially treatment of F < 10 cases as inconclusive rather than confirming or overturning.
- Check self-contained execution, deterministic output, the stated AER path, approximate 400-word length, one Markdown table, no required deliverable missing, and no brief violation.

Out of scope:
- Do not edit or create any file. Do not propose stylistic rewrites unless they fix a factual or constraint defect.
- No web, package installation, commits, or writes outside normal temporary system behavior.

Constraints and invariants:
The workspace is shared and may change; reread every artifact immediately before checks. Treat BRIEF.md as authoritative. Conventional F < 10 flagging is the requested rule; do not demand alternative weak-IV thresholds or unrequested standard errors.

Write ownership:
Read-only. Write no project artifact; return findings only in stdout.

Expected artifact:
A concise audit report in this call’s captured log.

Acceptance checks:
Give PASS/FAIL for (1) formulas/samples, (2) recomputed numerics, (3) weak-IV labeling/interpretation, (4) deliverable/form constraints. If any failure, cite exact file/line and exact correction. Distinguish defects from optional enhancements.

Return format:
Conclusion, evidence with recomputed values, failures if any, residual risk.' < /dev/null > terra-verification.log 2>&1
```

## What Sol reasoned directly

The lead fixed the five estimands and their sample logic; chose the conventional specification-specific partial F for the single excluded instrument; required identical OLS/IV/first-stage samples; interpreted F = 11.01 as only marginally above the rule-of-thumb threshold; and separated genuine coefficient robustness in the three stronger-first-stage specifications from the inconclusive drop-neo-Europe and Africa-only exercises. The lead also bounded the manuscript's entitlement: replication and limited control robustness are supported, but universal robustness, within-Africa evidence, and the exclusion restriction are not established.

## Friction

The read-only Terra verifier could not launch R because R could not create `R_TempDir`; it therefore passed the static/formula, weak-IV interpretation, and deliverable checks but marked independent numeric execution environment-blocked. The lead resolved this by independently recomputing all five specifications in the interactive session, using the single-instrument identity `F = t^2`; every full-precision value matched the table. No artifact correction or revision cycle was needed. During lead verification, two hash files were inadvertently created in `/tmp`; both were removed immediately, and all persistent artifacts remain confined to the current leaf.

[SOL LEAD TOKENS: 58,529]  + Terra one-shots: 90,259  = 148,788
