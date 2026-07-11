# Run log — fable-orchestrate / T1

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t1-descriptive.md` @ commit `7d681d8` |
| Capture method | headless |
| Wall-clock | 204.5 s (envelope duration_ms), 12 turns |
| Tokens / cost | 361015 in / 5136 out; $1.882 API-equivalent (envelope total_cost_usd) |

## Routing trace

1. Task → **fast-worker** (Sonnet, effort pinned low): "Conjoint design summary in R" — the whole mechanical brief delegated in one contract.
2. Lead quality-checked the returned artifacts, found two clipped facet strip titles in the figure, and used the brief's single revision cycle to fix it itself (`label_wrap_gen(width = 32)`), re-ran `Rscript script.R`, and visually confirmed — rather than re-delegating.

## Friction log

- The native advisor tool reported itself unavailable in the headless session (noted by the lead; verification proceeded by direct re-run and inspection).
- Figure defect on first pass (clipped facet titles) — caught by the lead's own review, fixed within the allowed revision cycle.

## Artifacts

See `SHA256SUMS`. Deliverables produced by the run itself, unedited. Full session transcript retained locally (session `0c8d774f-5556-4084-b1d8-1f4ca13d17fc`); the committed record is this log + `claude-envelope.json` (cost/usage) + `transcript-excerpt.md`.
