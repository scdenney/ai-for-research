# Run log — opus-orchestrate / T2 Estimate (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/t2-amce.md` |
| Capture method | headless |
| Wall-clock | 4.98 min (envelope duration_ms), 19 turns |
| Tokens / cost | 17235 output; 71150 tokens excl. cache reads; $1.23 API-equivalent (envelope) |
| Score | **Distinction (6/6).** All items incl. the full projoint defaults (tau = 0.17, ×1.52, profile-level estimand). Reproduces prior Distinction. |

## Routing trace

Lead worked inline; no subagent delegations recorded.

## Score vs rubric (SCORING.md)

**Distinction (6/6).** All items incl. the full projoint defaults (tau = 0.17, ×1.52, profile-level estimand). Reproduces prior Distinction.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
