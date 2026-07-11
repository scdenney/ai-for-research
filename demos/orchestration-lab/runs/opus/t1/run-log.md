# Run log — opus-orchestrate / T1

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/t1-descriptive.md` @ commit `7d681d8` |
| Capture method | headless |
| Wall-clock | 594.0 s (envelope duration_ms), 30 turns |
| Tokens / cost | $2.262 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json) |

## Routing trace

1. Task → **fast-worker** (Sonnet, effort pinned low): "Write conjoint design-summary R script + outputs" — mechanical tier delegated per the routing rule; the Opus lead did not spend its own reasoning on trivial work.
2. Lead verified the returned artifacts and reported the design facts (24 levels across 7 attributes; balance max deviation under 2 pp).

## Friction log

- None recorded in the envelope; the run took notably longer than fable/T1 (9.9 min vs 3.4) for the same routing shape.

## Artifacts

See `SHA256SUMS`. Deliverables produced by the run itself, unedited. Full transcript retained locally (session a1e154ff-7bd2-4a9b-808e-6b0ce9f437ed).
