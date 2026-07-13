# Run log — opus-orchestrate / HIGH (AJR IV replication) (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/high-ajr.md` |
| Capture method | headless |
| Wall-clock | 8.17 min (envelope duration_ms), 28 turns |
| Tokens / cost | 29395 output; 99147 tokens excl. cache reads; $2.12 API-equivalent (envelope) |
| Score | **Distinction (6/6).** Replication exact, four stress specs with controls on both IV sides, weak-IV flagged for every spec, unified table, claim ceiling, no overclaim. |

## Routing trace

1. Bash discovery calls to locate `codex-peer.sh` (opus-orchestrate skill, v2.17.0).
2. Codex peer call via `codex-peer.sh --mode implement`, run in an isolated `/tmp/ajr-blind` sandbox — a blind cross-vendor replication check: Codex received only the data description and spec definitions, no access to the lead's files or numbers, and wrote and ran its own R independently.

## Score vs rubric (SCORING.md)

**Distinction (6/6).** Replication exact, four stress specs with controls on both IV sides, weak-IV flagged for every spec, unified table, claim ceiling, no overclaim.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
