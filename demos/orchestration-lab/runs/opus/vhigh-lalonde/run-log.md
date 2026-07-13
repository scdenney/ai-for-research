# Run log — opus-orchestrate / VERY HIGH (LaLonde methods dispute) (re-run 2026-07-13, v2.17.0)

| Field | Value |
|---|---|
| Date | 2026-07-13 (re-run on the recalibrated v2.17.0 skill; the 2026-07-12 capture is in git history) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin v2.17.0 |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/vhigh-lalonde.md` |
| Capture method | headless |
| Wall-clock | 2.32 min (envelope duration_ms), 2 turns |
| Tokens / cost | 9314 output; 18453 tokens excl. cache reads; $3.36 API-equivalent (envelope) |
| Score | **Distinction (6/6).** NOTE: this run ended early (2 turns) at a headless session boundary while a background blind audit was outstanding, but the on-disk deliverable is complete and meets all six — anchors exact, spec curve, benchmark-referenced figure/table, "favorable-specification-only" judgment, no overclaim. |

## Routing trace

1. Task → **deep-reasoner** (Opus): "Blind methodological audit".
2. Task → **codex:codex-rescue**: "Blind methodological audit" — Codex peer/audit call routed through the codex-rescue subagent, including discovery Bash calls probing `~/.codex/` sessions and the running task before the audit was dispatched.
3. Friction: the session ended early (2 turns) at a headless session boundary while this background blind audit was still outstanding; the on-disk deliverable was already complete and did not require the audit's return to meet the rubric.

## Score vs rubric (SCORING.md)

**Distinction (6/6).** NOTE: this run ended early (2 turns) at a headless session boundary while a background blind audit was outstanding, but the on-disk deliverable is complete and meets all six — anchors exact, spec curve, benchmark-referenced figure/table, "favorable-specification-only" judgment, no overclaim.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
