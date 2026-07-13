# Run log — fable-orchestrate / T3 Reviewer reply (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t3-reviewer-memo.md` |
| Capture method | headless |
| Wall-clock | 3.8 min (envelope duration_ms), 13 turns |
| Tokens / cost | 11807 output; 64674 tokens excl. cache reads; $1.1837259999999998 API-equivalent (envelope) |
| Score | Pass+ (5/6). Met A baseline-relativity, B binary-invariance, C marginal means (.626/.374), E claim ceiling, and D the statistical-tie caveat ("crime and driving time … statistically indistinguishable at the top"). Missed both-magnitudes completeness F (corrected only). Improved from Pass on the prior capture — this run caught the tie. |

## Routing trace

1. Task → **deep-reasoner** (Opus): "Adversarial audit of reviewer memo" — the lead decided the numbers did not warrant escalating to the parallel Opus‖Codex path this run, so no Codex peer call was made.

## Score vs rubric (SCORING.md)

Pass+ (5/6). Met A baseline-relativity, B binary-invariance, C marginal means (.626/.374), E claim ceiling, and D the statistical-tie caveat ("crime and driving time … statistically indistinguishable at the top"). Missed both-magnitudes completeness F (corrected only). Improved from Pass on the prior capture — this run caught the tie.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
