# Routing log

## Route table

| Workstream | Owner and route | Scope | Acceptance check | Outcome |
|:--|:--|:--|:--|:--|
| Decomposition, estimand discipline, implementation, integration | 46-orchestrate lead | Translate `BRIEF.md` into five matched-sample OLS/IV specifications; choose the F definition; write `script.R`; integrate claims and artifacts | All requested specifications and deliverables exist; controls enter both equation sides; weak rows are not treated as reliable | Completed by the lead |
| Bounded numerical replication and sample audit | Terra one-shot: `gpt-5.6-terra`, medium effort | Independently compute N, OLS, 2SLS, first-stage coefficient, partial F, weak flag; compare `rich4` with the four requested codes | Fresh R execution; all five rows to at least three decimals; same-sample and code checks | Independent recomputation matched every result; recorded in `terra-peer-rerun.md` |
| Cross-vendor inferential challenge | Claude peer via `claude-peer.sh --model fable --effort high` | Independently recompute the models, stress the weak-IV interpretation, and challenge the Africa/heterogeneity language | Numeric disagreement exposed; weak rows treated as neither confirmation nor refutation; claim language calibrated | Matched every result and endorsed the interpretation; recorded in `claude-peer.md` |
| Final completion review | Advisor skill via `gpt-5.6-sol`, xhigh, read-only | Inspect `BRIEF.md`, `script.R`, `robustness-table.md`, and `memo.md` for material statistical or compliance defects | Decisive required-versus-optional correction judgment | No material correction; optional wording refinement adopted; recorded in `advisor-review.md` |

## Why these routes

Terra received the bounded, objectively checkable work: reproduce five deterministic regressions and audit samples. This is well suited to a cheaper tier because exact numeric agreement and direct R output settle correctness. Its first read-only run could not create R's temporary directory, so `terra-peer.md` is only an artifact audit, not an independent computation. I retried the same contract with a workspace-write sandbox (while retaining explicit read-only file ownership); `terra-peer-rerun.md` then performed the fresh R run. This was an execution retry of one logical delegation, not a new workstream.

The Claude peer received the decorrelated cross-vendor check because interpretation is the main residual risk: an exaggerated causal claim, or treating a collapsed first stage as disconfirming evidence, could survive a purely mechanical audit. The call explicitly pinned `--model fable`, as requested. Claude also recomputed all five rows before judging the memo, so its interpretive advice rested on independently checked evidence.

I kept the coupled decisions in the lead context: formula construction; ensuring controls appear in both the structural and instrument sets; using the conventional homoskedastic nested-model partial F requested by the brief; deciding to display weak-IV estimates with a dagger rather than suppress them; writing the claim boundary; and building and verifying the reproducible outputs. I also adjudicated Claude's optional suggestion about stricter modern weak-IV diagnostics: it is a legitimate extension, but not part of this brief's specified F≈10 exercise, so the documents identify the reported F precisely and avoid adding an unrequested diagnostic.

## Integration, revision, and verification record

All three numerical lines—the lead, Terra, and Claude—agree to the displayed precision. There was no substantive conflict to reconcile. The independent advisor found no material statistical, internal-consistency, or brief-compliance error. The one permitted revision cycle was used only to replace “the sign and broad magnitude survive” with the less inferential “the positive estimates remain broadly similar” in the generated memo.

Delegation accounting: three logical external lines (Terra, Claude, and the read-only advisor), no native subagents. No web access, package installation, figure generation, git operation, or edit outside the current task directory was used. The lead's final checks rerun `Rscript script.R`, confirm deterministic output, verify table structure and memo length, and compare generated numbers with both peer records.
