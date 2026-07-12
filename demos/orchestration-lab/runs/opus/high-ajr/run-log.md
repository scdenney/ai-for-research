# Run log — opus-orchestrate / HIGH (AJR replication and stress)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/high-ajr.md` @ commit `0ae449d` |
| Capture method | headless |
| Wall-clock | 6.2 min (envelope duration_ms), 20 turns |
| Tokens / cost | $1.600 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json). The blind Codex check ran on the local Codex CLI and is not in this envelope |
| Delegations | 1 (blind cross-vendor replication) |

## Routing trace

1. Lead (Opus 4.8) wrote and ran the full R analysis itself — no Claude subagents.
2. One delegation: a **blind cross-vendor replication check** via `codex exec` in an isolated `/tmp` directory — the checker got only the data description and the five spec definitions, no access to the lead's numbers, and returned its own estimates for comparison. The lead read the skill's `codex-peer.sh` but composed its own `codex exec` call without a `--model` flag, so the check ran on the CLI default **gpt-5.5 · medium** (not the skill's pinned gpt-5.6-terra · xhigh). The memo's "GPT-5.5 via Codex" note is accurate about what ran.
3. Lead reconciled (blind check agreed), assembled the table, memo, optional figure, and full-precision CSV.

## Friction log

- First blind-check attempt used `--sandbox read-only`; Rscript needs a writable TMPDIR, so the lead retried with `workspace-write` and an explicit TMPDIR. Cost of one wasted Codex round.
- The hand-rolled Codex call silently inherited the CLI default model instead of the skill's pinned peer — worth knowing when comparing "what the skill specifies" to "what a lead actually does."

## Artifacts

See `SHA256SUMS`. All five spec estimates match the reference key; `results.csv` carries full precision; `robustness-figure.png` is the optional figure (Okabe-Ito, no in-plot title). Full transcript retained locally (envelope carries the session id).
