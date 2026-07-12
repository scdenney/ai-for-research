# Run log — opus-orchestrate / VERY HIGH (LaLonde methods dispute)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/vhigh-lalonde.md` @ commit `0ae449d` |
| Capture method | headless |
| Wall-clock | 3.8 min (envelope duration_ms), 12 turns |
| Tokens / cost | $5.010 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json) — the subagent audits bill into this envelope |
| Delegations | 2 (parallel blind audits) |

## Routing trace

1. Lead (Opus 4.8) built the full analysis itself — MatchIt spec grid, both anchors exact, HC3 SEs for the stratification specs with the explicit refusal of five-cluster inference ("clustering on only 5 subclasses would be invalid few-cluster inference"), reuse-aware cluster-robust SEs for 1-NN.
2. Two parallel blind audits before shipping: **deep-reasoner** (Opus subagent) and **codex:codex-rescue** (Codex through the shared runtime), both titled "Blind methodological audit," plus one SendMessage follow-up to continue an auditor. The lead integrated and finalized.
3. Deliverables: 448-word memo, spec table with CI-coverage flags, figure with the benchmark as a literal horizontal reference line.

Wall-clock stayed at 3.8 min because the audits ran in parallel; the $5.01 envelope carries their token burn.

## Friction log

- None. Notable positive: the lead reached the defensible SE machinery on its own (HC3 for stratification, reuse-aware clustering for 1-NN, no bootstrap, with the "working SEs, not the Abadie-Imbens analytic variance" candor) — the same two inference traps the advisor arm's solve fell into and needed its consult to fix.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
