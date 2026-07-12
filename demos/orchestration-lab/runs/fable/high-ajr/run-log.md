# Run log — fable-orchestrate / HIGH (AJR replication and stress)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/high-ajr.md` @ commit `0ae449d` |
| Capture method | headless |
| Wall-clock | 3.5 min (envelope duration_ms), 18 turns |
| Tokens / cost | $0.995 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json) |

## Routing trace

1. Lead (Fable 5) read the brief and the data columns, then delegated the mechanical build: **fast-worker** (Sonnet · low) — "Write and run AJR IV replication script" — returned script.R plus the executed five-spec grid (baseline 0.944/0.522, F 22.95; all five specs with first-stage Fs).
2. **deep-reasoner** (Opus) — "Write memo interpreting AJR IV stress test" — returned the ~430-word memo with the calibrated ceiling (robust to latitude/continent controls; neo-Europe drop borderline at F = 8.65 and reported as a caveat, not folded into the robust column; Africa-only collapse F = 0.30 read as uninformative, neither confirming nor overturning).
3. Lead verified the numbers against a re-run, assembled robustness-table.md, and closed. No Codex consult: the lead judged the exercise deterministic and cheaply verifiable, so the high-stakes parallel path never fired.

Two delegations of the three allowed. `AER::ivreg` path taken (stated in the table header).

## Friction log

- None. All five spec estimates match the reference key to the third decimal.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
