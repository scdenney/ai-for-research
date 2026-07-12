# Run log — advisor arm (Claude side) / T2

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`), toolkit fable-advisor.sh for the consult |
| Models | solve + revise: session default (Fable 5 · max); consult: Fable 5 · max (CLAUDE_EFFORT=max) |
| Brief | `prompts/t2-amce.md` @ commit `7d681d8` |
| Capture method | headless, three scripted steps (solve → one consult → revise) |
| Wall-clock | step 1: 2.3 min, 13 turns; step 3: 1.0 min, 14 turns (envelopes); ~13.4 min total including the consult |
| Tokens / cost | step 1: $1.257; step 3: $0.391 API-equivalent (envelopes). Consult unmetered (advisor script returns text only) |

## Routing trace

1. Plain solve (no orchestration skill): corrected AMCEs with respondent-clustered SEs via `.auto_cluster`, dot-whisker figure, ~160-word results paragraph.
2. One consult (fable-advisor, briefing = brief + report + deliverables on disk): the reviewer independently re-ran the estimation (all 17 AMCEs and CIs match to the decimal; verified `.auto_cluster` produces CR1 respondent-clustered SEs by reading the package source), then ordered four fixes — disclose the IRR correction magnitude (0.83 reliability, ×1.525 scaling, −16.5 → −25.1 pp) so a referee's uncorrected numbers don't look like a contradiction; soften "largest single effect" (crime and commuting statistically indistinguishable); drop Okabe-Ito yellow for a 7-attribute palette; document the benign CR2→stata fallback warning without silencing it (explicit `.se_type` args would disable auto-clustering).
3. Revise: all four fixes implemented.

## Friction log

- None. The consult explicitly warned against a "fix" that would have silently broken clustering — the trap-avoidance is part of the arm's value.

## Artifacts

See `SHA256SUMS`. report.md and figures/ are the REVISED versions; advice.md and briefing.md are the committed consult record. Full transcripts retained locally (envelopes carry the session ids).
