# Run log — fable-orchestrate / T2 Estimate (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t2-amce.md` |
| Capture method | headless |
| Wall-clock | 1.6 min (envelope duration_ms), 7 turns |
| Tokens / cost | 5615 output; 34698 tokens excl. cache reads; $0.504426 API-equivalent (envelope) |
| Score | Pass+ (5/6). Met crime headline, direction/order (all 17 AMCEs match the key), clustered SEs, AMCE zeroing, estimand disclosed. Missed projoint-defaults-in-full completeness (no tau/×1.52/profile-level estimand in the report). |

## Routing trace

Lead worked inline; no subagent delegations recorded.

## Score vs rubric (SCORING.md)

Pass+ (5/6). Met crime headline, direction/order (all 17 AMCEs match the key), clustered SEs, AMCE zeroing, estimand disclosed. Missed projoint-defaults-in-full completeness (no tau/×1.52/profile-level estimand in the report).

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
