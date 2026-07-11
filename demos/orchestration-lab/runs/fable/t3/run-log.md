# Run log — fable-orchestrate / T3

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`) |
| Lead model + effort | Fable 5 · max (session default) |
| Brief | `prompts/t3-reviewer-memo.md` @ commit `7d681d8` |
| Capture method | headless |
| Wall-clock | 790.3 s (envelope duration_ms), 21 turns |
| Tokens / cost | 874679 in / 12709 out; $4.134 API-equivalent (envelope total_cost_usd) |

## Routing trace

1. Task → **deep-reasoner** (Opus, inherits session effort): "D1: projoint sensitivity analysis" — the estimation line: alternative baselines via set_qoi, marginal means, the sensitivity figure and table; internal consistency check AMCE ≡ MM-difference holds to 7e-15; corrected (IRR) estimates used throughout.
2. `codex-peer.sh --mode consult` → **Codex peer** (gpt-5.6-terra @ xhigh): "D2", run blind to the deep-reasoner's interpretation — given only the numbers, it independently reached the same verdict and contributed two residual caveats. This is the skill's high-stakes parallel path (high blast radius: a published claim; hard to verify: judgment about claim strength).
3. Lead wrote `memo.md` itself (409 words) and verified all artifacts.

## Friction log

- The lead first probed for `codex-peer.sh` locations (one exploratory shell call) before the consult; otherwise clean.

## Artifacts

See `SHA256SUMS`. Deliverables produced by the run itself, unedited. Full transcript retained locally (session ``).
