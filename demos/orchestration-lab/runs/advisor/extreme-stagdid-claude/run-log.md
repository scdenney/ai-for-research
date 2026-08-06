# Run log — advisor (Claude) / extreme-stagdid

| Field | Value |
|---|---|
| Date | 2026-07-17 |
| Platform + version | Claude Code, headless `claude -p` |
| Lead model + effort | Sonnet 5 (plain session, no orchestration skill), solve + revise; Fable 5 · max, one consult |
| Brief | `prompts/extreme-stagdid.md` |
| Capture method | headless, three scripted steps (solve / consult / revise) |
| Wall-clock | solve 3.1 min + consult 8.5 min + revise 6.2 min ≈ 17.9 min |
| Tokens / cost | solve $0.72 + revise $1.56 = **$2.28** (consult unmetered, per lab convention) |

## Routing trace

1. Plain Sonnet session solves the brief directly — no orchestration skill invoked.
2. `briefing.md` composed (brief + solve-step deliverables + "what would you change?"); one consult to Fable 5 · max via `fable-advisor.sh`.
3. Plain Sonnet session revises `memo.md`, `estimates-table.md`, `script.R` per the advice.

## Friction log

None mechanically, but the **solve step made a real, substantive error**: its
memo conflated `bacondecomp`'s "Earlier vs Later Treated" (8.3%, a clean
not-yet-treated comparison) with "Later vs Earlier Treated" (5.4%, the actual
negative-weight-risk type), reporting "13.7% contaminated" instead of the
correct 5.4%, and justified the Callaway-Sant'Anna headline choice by an
irrelevant "doubly robust" property (the specification uses no covariates, so
the DR machinery was never engaged). The Fable consult caught both errors
precisely (see `advice.md`), verified the surviving numbers by hand
(re-summing the three Bacon cells to the reported TWFE coefficient), flagged
that it could not independently re-run R to check the Roth-Sant'Anna figure,
and the revise step incorporated the fix cleanly. Notable because the solve
step otherwise reached the right qualitative conclusion and the right
estimator lineup — the error was in the decomposition's own bookkeeping, not
the headline judgment.

## Artifacts

See `SHA256SUMS` in this directory. `briefing.md`/`advice.md` are the consult
record; the unmetered consult is not represented in `claude-envelope-*.json`.
