# Run log — opus-orchestrate / T3 Reviewer reply (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/t3-reviewer-memo.md` |
| Capture method | headless |
| Wall-clock | 33.74 min (envelope duration_ms), 37 turns |
| Tokens / cost | 76640 output; 224653 tokens excl. cache reads; $5.19 API-equivalent (envelope) |
| Score | **Pass+ (5/6).** Met A, B, C, E, and D the statistical-tie caveat. Missed both-magnitudes completeness F (corrected 25.1 only). Same as prior. |

## Routing trace

1. Bash discovery calls to locate `codex-peer.sh` (opus-orchestrate skill, v2.17.0).
2. Task → **deep-reasoner** (Opus): "Blind verdict check (Opus)".
3. Codex peer call via `codex-peer.sh --mode consult --model gpt-5.6-terra` — blind statistical-tie check on the reviewer memo, correctly pinned to the calibrated peer (terra @ xhigh).

## Score vs rubric (SCORING.md)

**Pass+ (5/6).** Met A, B, C, E, and D the statistical-tie caveat. Missed both-magnitudes completeness F (corrected 25.1 only). Same as prior.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
