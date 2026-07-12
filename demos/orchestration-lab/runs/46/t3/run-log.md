# Run log — 46-orchestrate / T3 (re-run)

| Field | Value |
|---|---|
| Date | 2026-07-12 (re-run; the 2026-07-11 capture, whose marginal means were wrong, is in git history) |
| Platform + version | Codex CLI 0.144.1, headless `codex exec` per `prompts/run.md` |
| Lead model + effort | gpt-5.6-terra · medium (skill default; subagents inherit) |
| Brief | `prompts/t3-reviewer-memo.md` @ commit `7d681d8` |
| Capture method | headless, full stdout in `exec-stdout.log` |
| Wall-clock | 3.9 min (file timestamps) |
| Tokens | 92,446 (log; Codex reports tokens only, no USD) |

## Routing trace

1. Lead (terra) probed the package's estimands, committed to one explicitly selected estimand ("base the memo/table on one explicitly selected, consistent estimand and label it clearly"), and spawned independent checks (seven collab waits in the log; "The independent checks agree on the key judgment").
2. Deliverables assembled by the lead: sensitivity table (crime AMCEs under both references, full housing-cost 3×3 reference grid, all 24 IRR-corrected marginal means), ~430-word memo, figure.

## Score vs answer key (SCORING.md items)

**Pass (4/6).** Baseline-relativity conceded ✓ (housing-cost grid shows the displayed AMCE changing with the reference), binary-invariance ✓ (−0.251 ↔ +0.251, sign reversal only), marginal means as evidence ✓ (0.626/0.374 — matching the reference exactly; the 2026-07-11 capture's wrong MMs of .541/.458 do not recur), claim ceiling ✓ ("We will not say that crime 'drives' community choice ... nor claim a definitive cross-attribute importance ordering"). Misses the statistical-tie caveat — the memo calls crime's 25.1 the largest range ahead of commuting's 23.7 and hedges cross-attribute comparability structurally (levels and spacing) but never flags the 1.4pp gap as within sampling noise — and misses both-magnitudes (corrected only; tau = 0.172 disclosed, the uncorrected 16.5 never reported).

## Friction log

- One tool-router error mid-run ("timeout_ms must be at least 10000"), self-recovered.
- The estimand discipline (explicitly selected, labeled, consistent across table/memo) is the direct fix for the defect that sank the original capture.

## Artifacts

See `SHA256SUMS`. `exec-stdout.log` is the full raw session (home paths scrubbed).
