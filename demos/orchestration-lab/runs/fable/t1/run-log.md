# Run log — fable-orchestrate / T1 Describe (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t1-descriptive.md` |
| Capture method | headless |
| Wall-clock | 3.7 min (envelope duration_ms), 10 turns |
| Tokens / cost | 6064 output; 37009 tokens excl. cache reads; $0.9125871000000001 API-equivalent (envelope) |
| Score | Pass (4/6). Met design counts, attribute set, level counts, repeated task. Missed the honest-balance judgment item (asserts balance "consistent with successful randomization" without naming Total Daily Driving Time as the departure) and max-deviation completeness. Regressed from Pass+ on the prior capture — a run-to-run draw. |

## Routing trace

1. Task → **fast-worker** (Sonnet): "Write conjoint design-summary R script" — the whole mechanical brief delegated in one contract.

## Score vs rubric (SCORING.md)

Pass (4/6). Met design counts, attribute set, level counts, repeated task. Missed the honest-balance judgment item (asserts balance "consistent with successful randomization" without naming Total Daily Driving Time as the departure) and max-deviation completeness. Regressed from Pass+ on the prior capture — a run-to-run draw.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
