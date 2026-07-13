# Run log — fable-orchestrate / HIGH (AJR IV replication) (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/high-ajr.md` |
| Capture method | headless |
| Wall-clock | 6.4 min (envelope duration_ms), 18 turns |
| Tokens / cost | 19552 output; 73334 tokens excl. cache reads; $1.929464 API-equivalent (envelope) |
| Score | Distinction (6/6). All items: replication exact (2SLS 0.944 / OLS 0.522 / F 22.95), four stress specs correct, weak-IV flagged, no overclaim, claim ceiling, unified table. |

## Routing trace

1. Task → **deep-reasoner** (Opus): "Write and run AJR IV script" — the numeric backbone: replication and stress-test spec grid.
2. `codex-peer.sh --mode consult` → **Codex peer** (via the fable-orchestrate skill's Codex integration): asked to independently write the interpretive memo, run blind to the deep-reasoner's read.
3. Task → **deep-reasoner** (Opus): "Write independent AJR memo" — the lead ran this in parallel with the Codex consult, both blind to each other, then synthesized the two into `memo.md`. This is the skill's high-stakes parallel path (high blast radius: a published claim; hard to verify: judgment about claim strength).

## Score vs rubric (SCORING.md)

Distinction (6/6). All items: replication exact (2SLS 0.944 / OLS 0.522 / F 22.95), four stress specs correct, weak-IV flagged, no overclaim, claim ceiling, unified table.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
