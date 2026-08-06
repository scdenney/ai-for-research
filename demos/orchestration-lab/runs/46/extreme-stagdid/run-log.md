# Run log — 46 (headless, single-tier fallback) / extreme-stagdid

| Field | Value |
|---|---|
| Date | 2026-07-17 |
| Platform + version | Codex CLI 0.144.5 |
| Lead model + effort | gpt-5.6-sol, high |
| Brief | `prompts/extreme-stagdid.md` |
| Capture method | headless (`codex exec`, `--sandbox workspace-write`) |
| Wall-clock | ~8 min |
| Tokens / cost | 157,784 tokens (single `tokens used` line; Codex reports no USD) |

This is the **single-tier headless fallback**, not a capture of `46-orchestrate`
as designed: cross-tier delegation to `gpt-5.6-terra` requires an
interactive/escalated session (nested `codex exec` fails under any sandbox),
so a headless Sol lead does everything itself in one tier — matching the same
`runs/46/` fallback convention used for the five earlier tiers. The faithful
Sol-lead-with-Terra-delegation capture is `runs/46-sol/extreme-stagdid/`.

## Routing trace

None — single-tier headless session, Sol did everything inline (no cross-tier
delegation possible without an interactive session).

## Friction log

None. Correctly recoded `first.treat == 0` to `Inf` for the `staggered`
package on the first attempt (did not hit the sentinel-value trap).

## Artifacts

See `SHA256SUMS` in this directory.
