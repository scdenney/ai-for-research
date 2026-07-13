# Run log — fable-orchestrate / VERY HIGH (LaLonde methods dispute) (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/vhigh-lalonde.md` |
| Capture method | headless |
| Wall-clock | 19.0 min (envelope duration_ms), 42 turns |
| Tokens / cost | 35207 output; 125983 tokens excl. cache reads; $3.4588855000000005 API-equivalent (envelope) |
| Score | Distinction (6/6). Anchors exact (+$1,794 / −$8,498), spec curve with pre-earnings, benchmark-referenced table + figure, "helps but does not settle" judgment, no overclaim. |

## Routing trace

1. Task → **deep-reasoner** (Opus): "Own, fix, run LaLonde script.R" — owned and ran the specification-curve script, verified statistical correctness, returned all numbers plus a methods self-defense (clean run, no defect in point estimates).
2. `codex-peer.sh` → **Codex peer** (GPT-5.6 `sol`): independent adversarial methods audit, run blind to the deep-reasoner's prose. This is the skill's high-stakes parallel path (high blast radius: a contested empirical claim; hard to verify: SE/inference choices). Verdict: point estimates and conclusion confirmed; defects found only in inference (SE choices) and missing diagnostics.
3. Lead applied the surviving Codex flags itself (subclass SE switched 6-cluster → HC3 robust; benchmark/naive SE switched to HC2/Neyman; added retained-treated counts and post-match balance diagnostics) and re-ran to verify — the run's one revision cycle. The HC3 fix changed the substantive adjudication: the coarse-stratification spec's CI now excludes the experimental benchmark, where it had spuriously overlapped under the prior SE.

## Score vs rubric (SCORING.md)

Distinction (6/6). Anchors exact (+$1,794 / −$8,498), spec curve with pre-earnings, benchmark-referenced table + figure, "helps but does not settle" judgment, no overclaim.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
