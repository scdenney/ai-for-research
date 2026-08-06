# Routing log

## Route table

| Workstream | Owner | Why routed there | Expected evidence | Outcome |
|---|---|---|---|---|
| Independent conjoint diagnosis | Terra (`gpt-5.6-terra`, high) | Bounded, reproducible numeric audit suited to a cheaper out-of-band worker | Crime releveling, one multi-level releveling, all MMs, claim boundary | The first read-only run could not start R because the sandbox denied R temporary-file creation. A narrower retry with workspace write for R temporary files independently reproduced the 6,400-row design, corrected MMs, AMCE sign reversal, and all seven MM spreads. |
| Cross-vendor judgment check | Claude peer (`--model fable`, high) | The headline/claim boundary is interpretive, so a genuinely different model family was useful as a blind challenge | Independent verdict, numeric checks, proposed claim, residual risks | Completed in `claude-peer.txt`; it agreed that binary crime is invariant up to sign, found the 25.1-point crime spread only narrowly above driving’s 23.7 points, and recommended dropping dominance language. |
| Estimand choice, implementation, integration, and verification | Lead | These decisions and four generated deliverables are tightly coupled; the lead retains final accountability | `script.R`, one figure, table, memo, and end-to-end checks | Completed and verified after one revision cycle. |

## Delegation record

The lead made three out-of-band delegation calls, the maximum permitted by the brief:

1. **Terra, read-only.** The contract asked for an independent R analysis and prohibited project edits. R could not create a temporary directory inside the read-only sandbox. The run was stopped rather than accepted without numeric evidence.
2. **Claude peer, blind.** The same substantive question was sent through `scripts/claude-peer.sh` with `--model fable`, without Terra conclusions or lead results. Its complete response is preserved in `claude-peer.txt`.
3. **Terra, constrained retry.** `TMPDIR` was placed under `.orchestration/` and the worker received workspace-write capability solely so R could run; the contract still prohibited edits to project deliverables. Terra independently reproduced the key estimates and used Housing Cost as its multi-level releveling check. Before producing its final memo, it attempted the advisor skill’s nested Sol check. That nested process was structurally rejected by the sandbox before launching, and the lead stopped the run. No fourth model opinion was produced and no Terra-authored deliverable was integrated.

The failed first attempt and interrupted retry are recorded because they affected routing. The usable Terra evidence came from the retry’s direct R output, not from a claimed final artifact.

## What the lead reasoned and implemented

The lead inspected `BRIEF.md`, the T1/T2 conventions, the installed `projoint` API, and the reshaped labels. It retained T2’s profile-level, reliability-corrected quantities and explicit respondent clustering with Stata-style analytical standard errors. Direct checks established:

- crime is binary, so switching its reference changes −25.1 points to +25.1 points with the same interval;
- changing the four-level driving-time reference changes the displayed coefficient set and absolute-coefficient ranking but not any pairwise difference or level ordering;
- crime MMs are 62.6% and 37.4%, a 25.1-point spread;
- the other within-attribute MM spreads are driving 23.7, housing 19.8, place 15.8, school 11.6, race 5.9, and presidential vote 5.6 points.

The lead chose a single all-level MM dot-whisker figure because it makes the baseline-invariant evidence visible and exposes the narrow crime/driving gap. It rejected the stronger peer wording that crime forms a statistically established “leading tier”: the requested script does not estimate corrected between-spread contrasts, and a 1.4-point descriptive lead cannot justify unique dominance. The final claim is therefore limited to a large crime contrast and “one of the largest” contrasts among the levels presented.

## Integration and one revision cycle

Initial artifacts were generated before the peer calls completed. After comparing the two independent lines, the lead used the one allowed revision cycle to:

- clarify that multi-level releveling changes which coefficient is largest in absolute value, not the underlying ordering of fitted levels;
- replace language implying a statistically unique crime ranking with a descriptive, design-bounded statement;
- make the revised manuscript claim exact and non-dominance-based; and
- normalize a confidence-limit display that rounded to `-0.0`.

No further content revision was made.

## Final verification

- `Rscript script.R` completed successfully from the project directory.
- The script regenerated `figures/sensitivity.png`, `sensitivity-table.md`, and `memo.md` from the specified data.
- `figures/` contains exactly one file: `sensitivity.png`.
- The PNG is 3,360 × 3,680 pixels at 320 dpi and has no in-plot title.
- `memo.md` is 398 whitespace-delimited words including its heading/caption, consistent with “roughly 400 words.”
- The final table, memo, and figure agree at the displayed precision.
- No web access or package installation was used.
