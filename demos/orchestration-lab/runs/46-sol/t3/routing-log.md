# Routing log

## Route table

| Workstream | Owner | Why that owner | Acceptance check |
|---|---|---|---|
| Decomposition and estimand design | Sol (lead, direct) | Required the central judgment about profile-level AMCEs, binary versus multi-level reference dependence, MM ranges, and what “importance” can mean | Package interface and data inspected directly; estimands and comparison metric fixed before delegation |
| Analysis implementation | Terra out-of-band | Bounded R implementation from a complete specification, with disjoint ownership of `script.R`, `sensitivity-table.md`, `figures/sensitivity.png`, and diagnostics | `Rscript script.R` exits 0; all alternative crime and driving-time baselines estimated; numerical guardrails and file assertions pass |
| Interpretation and reviewer response | Sol (lead, direct) | Claim calibration, uncertainty, and the distinction between an observed ranking and unique dominance required lead judgment | `memo.md` concedes mechanical dependence, reports baseline-invariant evidence, and states a precise non-overclaiming revision |
| Integration and visual audit | Sol (lead, direct) | Final accountability and cross-artifact reconciliation stay with the lead | Full script read; clean rerun; PNG visually inspected; 3200×4160 at 320 dpi; table, diagnostics, figure, and memo agree |

No native Sol subagent was spawned.

## Out-of-band calls

The complete worker brief is preserved in `terra-analysis.prompt`.

1. Initial background attempt (exited immediately with an empty log):

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" "$(sed -n '1,999p' terra-analysis.prompt)" < /dev/null > terra-analysis.log 2>&1 & print $!
```

`tokens used: not reported` (the log was empty and no artifact was produced).

2. Successful persistent one-shot:

```bash
codex exec --model gpt-5.6-terra -c model_reasoning_effort=medium --sandbox workspace-write --skip-git-repo-check -C "$PWD" "$(sed -n '1,999p' terra-analysis.prompt)" < /dev/null > terra-analysis.log 2>&1
```

`tokens used: 72,701`

## What Sol reasoned directly

The lead selected conventional profile-level AMCEs because those are the quantities challenged by the reviewer; identified that crime’s binary structure makes its sole absolute contrast invariant to releveling; selected four-level driving time as the informative multi-level sensitivity case and closest substantive competitor; chose corrected estimates as primary and uncorrected estimates as a robustness check; judged MM spread to be the appropriate baseline-invariant descriptive comparison; and limited the revised claim to “one of the strongest” with the largest observed spread, not statistically or universally dominant.

## Friction and revision

- The first fire-and-forget shell launch did not survive the shell lifecycle and produced an empty log. The same brief was rerun in a persistent session; the required `< /dev/null` was retained.
- During its initial pass, Terra supplied full level IDs to `set_qoi()`, which expects bare tokens such as `level2`. Terra diagnosed and corrected this before producing the artifacts.
- Lead audit found that the diagnostics check line used `nrow()` on lists and was therefore omitted. In the single permitted revision cycle, Sol changed this to `length()` and added explicit corrected/uncorrected labels. No analytical estimates changed and no further delegation was used.

## Final verification

- `Rscript script.R` completed successfully after the revision.
- The script regenerated all required analysis artifacts and asserted 24 corrected MMs, two crime reference sets, four driving-time reference sets, and exact binary sign reversal.
- `figures/sensitivity.png` is the only figure, has no in-plot title, uses the specified Okabe–Ito highlights, includes the 0.50 MM reference line, and is 320 dpi.
- Corrected MM ranges are crime 25.1, driving time 23.7, and housing cost 19.8 percentage points; uncorrected ranges are 16.5, 15.6, and 13.0.
- The table and memo reproduce the script output, and the memo qualifies the narrow crime–driving difference.

[SOL LEAD TOKENS: 188,905]  + Terra one-shots: 72,701  = 261,606
