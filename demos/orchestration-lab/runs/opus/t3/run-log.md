# Run log — opus-orchestrate / T3

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/t3-reviewer-memo.md` @ commit `7d681d8` |
| Capture method | headless |
| Wall-clock | 1468.9 s (~24.5 min), 67 turns |
| Tokens / cost | $6.729 API-equivalent (envelope total_cost_usd; usage in claude-envelope.json) |

## Routing trace

1. No Task delegations — the Opus lead did the sensitivity analysis itself (its routing rule keeps compact hard reasoning with the lead).
2. One blind Codex consult for the decorrelated second line: the lead composed its own reviewer prompt and called `codex exec` DIRECTLY (read the toolkit's codex-peer.sh first but did not use it), omitting a `--model` pin — so the peer ran at this machine's Codex config default (gpt-5.5), not the calibrated gpt-5.6-terra @ xhigh.
3. Lead finalized memo.md (437 words), sensitivity-table.md, and the two-panel figure; bootstrap p-values computed by a ~7-minute R run the lead awaited.

## Friction log

- The envelope's final message is a mid-run status narration rather than a closing summary — the headless session ended its print-mode turn while narrating a background R wait; all artifacts are nonetheless complete and self-consistent.
- The unpinned `codex exec` call is a calibration deviation worth scoring: the skill's own docs prescribe codex-peer.sh (terra @ xhigh).

## Artifacts

See `SHA256SUMS`. Deliverables produced by the run itself, unedited. Full transcript retained locally (session 9e7144a8-4d63-4c76-80c1-95fdd456218f).
