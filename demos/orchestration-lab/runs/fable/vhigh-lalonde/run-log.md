# Run log — fable-orchestrate / VERY HIGH (LaLonde methods dispute)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`); plugin resolved from the 2.15.1 cache |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/vhigh-lalonde.md` @ commit `0ae449d` |
| Capture method | headless |
| Wall-clock | 8.1 min (envelope duration_ms), 16 turns |
| Tokens / cost | $1.832 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json). The orphaned Codex peer session ran on the local Codex CLI and is not in this envelope |

## Routing trace

1. Lead (Fable 5) delegated the full build to **deep-reasoner** (Opus) — "Build LaLonde spec-curve analysis" — which returned script.R (MatchIt, ATT with replacement, cluster-robust SEs on reused control id per Abadie-Imbens, cluster-by-stratum for subclassification), the 8-row spec table, the figure, and memo drafting input.
2. Lead verified anchors and pattern against its own reading, wrote the final memo, then fired the **high-stakes parallel path**: the Codex peer (codex-peer.sh, gpt-5.6-terra) as a background adversarial review with a pointed four-question brief (SE validity, code correctness, over/under-claiming, figure honesty).
3. The session ended before the peer returned: print mode exits when the lead's turn ends, and the lead ended its turn to wait for a completion notification that headless mode never delivers. The orphaned peer process died mid-review; `.codex-review-out.txt` preserves its partial session log (no verdict was produced). The deliverables on disk were already final before the peer fired.

One delegation completed + one cross-check attempted (lost to the session boundary), of the three allowed.

## Friction log

- **Headless boundary ate the peer verdict.** In an interactive session the lead would have integrated the Codex review; under `claude -p` the background task orphaned at turn end. The deliverables were complete first, so the loss is a missing verification layer, not a missing artifact — but a run relying on the peer's catch would have shipped without it.
- The headless plugin resolution used the 2.15.1 cache, whose codex-peer.sh pins gpt-5.6-terra but not yet the explicit xhigh effort (the orphaned peer banner shows `reasoning effort: medium`).

## Artifacts

See `SHA256SUMS`. `.codex-review-prompt.txt` and `.codex-review-out.txt` are the committed record of the attempted cross-check (home paths scrubbed). Full transcript retained locally (envelope carries the session id).
