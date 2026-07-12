# Run log — advisor arm (Claude side) / VERY HIGH (LaLonde methods dispute)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`), toolkit fable-advisor.sh for the consult |
| Models | solve + revise: session default (Fable 5 · max); consult: Fable 5 · max (CLAUDE_EFFORT=max) |
| Brief | `prompts/vhigh-lalonde.md` @ commit `0ae449d` |
| Capture method | headless, three scripted steps (solve → one consult → revise) |
| Wall-clock | step 1: 6.9 min, 44 turns; step 3: 5.0 min, 35 turns (envelopes); ~18.3 min total including the consult |
| Tokens / cost | step 1: $1.869; step 3: $1.487 API-equivalent (envelopes). Consult unmetered (advisor script returns text only) |

## Routing trace

1. Plain solve (no orchestration skill): MatchIt spec grid (both anchors exact; demographics-only fails, pre-earnings 1-NN lands on the benchmark, five-stratum subclassification at −$144), spec table, figure, ~450-word memo.
2. One consult (fable-advisor, briefing = brief + memo + artifacts on disk): the reviewer reproduced every number to the cent, then found what survived that verification — **the standard-error machinery was wrong in two places** (NN clustering on subclass ignores control reuse and understates; cluster-robust SEs on five strata are invalid — the vignette's own footnote says so), a self-contradicting trimming sentence, and a garbled verdict sentence. It also ran its own sensitivity analysis: five strata put 97.6% of CPS controls in one bin, and finer stratification climbs toward the benchmark (−$144 → +$660 at 10 → +$1,034 at 20), so the fragility is partly a coarseness artifact — a clause that makes the Smith-Todd point more accurately and pre-empts the obvious rebuttal.
3. Revise: HC3-on-`match_data()` SEs throughout, table and figure regenerated (point estimates unchanged; CIs corrected — the demo+earn stratification CI now cleanly excludes the benchmark), memo rewritten with the coarseness disclosure, the own-SE units note, and the explicit analysis-sample caveat (the Smith-Todd axis the task holds fixed).

## Friction log

- None. The consult's catch here was the deepest of any run in the matrix: not arithmetic (all reproduced) but inference machinery — exactly the failure mode a second reviewer exists for.

## Artifacts

See `SHA256SUMS`. memo.md, spec-table.md, script.R, and the figure are the REVISED versions; advice.md and briefing.md are the committed consult record (home paths scrubbed). Full transcripts retained locally (envelopes carry the session ids).
