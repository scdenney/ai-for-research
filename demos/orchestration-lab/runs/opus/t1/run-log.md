# Run log — opus-orchestrate / T1 Describe (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/t1-descriptive.md` |
| Capture method | headless |
| Wall-clock | 4.77 min (envelope duration_ms), 9 turns |
| Tokens / cost | 13834 output; 55053 tokens excl. cache reads; $1.08 API-equivalent (envelope) |
| Score | **Distinction (6/6).** All items incl. the exact max-deviation completeness ("max absolute deviation = 0.0194") and the honest balance flag. Reproduces prior Distinction. |

## Routing trace

1. Task → **fast-worker** (Sonnet): "Build script.R, summary.md, figure" — mechanical tier delegated per the routing rule; the Opus lead did not spend its own reasoning on trivial work.

## Score vs rubric (SCORING.md)

**Distinction (6/6).** All items incl. the exact max-deviation completeness ("max absolute deviation = 0.0194") and the honest balance flag. Reproduces prior Distinction.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
