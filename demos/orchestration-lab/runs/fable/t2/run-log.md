# Run log — fable-orchestrate / T2

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t2-amce.md` @ commit `7d681d8` |
| Capture method | headless |
| Wall-clock | 302.6 s (envelope duration_ms), 18 turns |
| Tokens / cost | 616785 in / 8009 out; $2.267 API-equivalent (envelope total_cost_usd) |

## Routing trace

1. Task → **fast-worker** (Sonnet, effort pinned low): the estimation-and-figure implementation, delegated as one contract (1 of 3 allowed delegations used).
2. Lead verified the returned artifacts (PNG checked visually and by dimensions, 2700×2700 @ 300 dpi) and wrote `report.md` itself, retaining integration ownership.

## Friction log

- Native advisor tool unavailable in the headless session (noted by the lead; it proceeded on the low-risk mechanical path).

## Artifacts

See `SHA256SUMS`. Deliverables produced by the run itself, unedited (the run also left an extra `estimates.csv`). Full transcript retained locally (session `dfe5d0ca-3816-4332-8458-1bd6f92a0fa4`).
