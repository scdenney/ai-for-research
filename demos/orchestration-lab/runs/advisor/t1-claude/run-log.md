# Run log — advisor arm (Claude side) / T1

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`), toolkit fable-advisor.sh for the consult |
| Models | solve + revise: session default (Fable 5 · max); consult: Fable 5 · max (CLAUDE_EFFORT=max) |
| Brief | `prompts/t1-descriptive.md` @ commit `7d681d8` |
| Capture method | headless, three scripted steps (solve → one consult → revise) |
| Wall-clock | step 1: 6.3 min, 28 turns; step 3: 6.9 min, 51 turns (envelopes); ~20.8 min total including the consult |
| Tokens / cost | step 1: $2.804; step 3: $2.185 API-equivalent (envelopes). Consult unmetered (advisor script returns text only) |

## Routing trace

1. Plain solve (no orchestration skill): reshape, design summary with all 24 level counts, per-attribute goodness-of-fit checks (Driving Time X² = 14.631, p = 0.00216 flagged), faceted level-frequency figure.
2. One consult (fable-advisor, briefing = brief + summary + deliverables on disk): the reviewer re-verified every number against a fresh reshape (all reproduce), then found six changes — figure lacks the uniform 1/K benchmark line so the one real finding is invisible; sort-by-share ordering scrambles ordinal levels; caption asserts what the plot should show; the repeated-task agreement rate (71.5%) is described twice but never reported; the single-pair restriction check should be the full 21-pair sweep; a hard-wired script branch could print a false Bonferroni sentence on other data.
3. Revise: all six changes implemented (benchmark lines, natural level order, precise caption, agreement rate, 21-pair sweep, conditioned script text).

## Friction log

- None. Same three-step protocol as the other advisor runs; the consult's number-verification pass again preceded its critique.

## Artifacts

See `SHA256SUMS`. summary.md and figures/ are the REVISED versions; advice.md and briefing.md are the committed consult record. Full transcripts retained locally (envelopes carry the session ids).
