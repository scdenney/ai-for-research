# Run log — advisor arm (Claude side) / HIGH (AJR replication and stress)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`), toolkit fable-advisor.sh for the consult |
| Models | solve + revise: session default (Fable 5 · max); consult: Fable 5 · max (CLAUDE_EFFORT=max) |
| Brief | `prompts/high-ajr.md` @ commit `0ae449d` |
| Capture method | headless, three scripted steps (solve → one consult → revise) |
| Wall-clock | step 1: 1.5 min, 14 turns; step 3: 1.8 min, 21 turns (envelopes) |
| Tokens / cost | step 1: $0.488; step 3: $0.605 API-equivalent (envelopes). Consult unmetered (advisor script returns text only) |

## Routing trace

1. Plain solve (no orchestration skill): full five-spec grid via `AER::ivreg` (every estimate matching the reference), robustness table, memo, optional figure.
2. One consult (fable-advisor, briefing = brief + memo + artifacts on disk): the reviewer re-ran all five specifications independently (all reproduce to the last digit, and it confirmed the F is the correct partial F on the excluded instrument), then ordered ranked fixes — a **factual error** in the memo's diagnosis of the Africa collapse ("least variation in settler mortality" is wrong: within-Africa SD of `logem4` is 1.22 vs 1.26 full-sample; the slope goes flat, identification rides on the cross-continent gradient); a figure bug (axis limits from ±1 SE but bars at ±1.96 SE, silently clipping the Africa CI); softening a contested weak-IV heuristic (bias-toward-OLS is the over-identified result; the just-identified statement is invalid inference); and separating spec 4 (marginal, F between Stock-Yogo thresholds) from spec 5 (dead).
3. Revise: all four fixes implemented; the corrected flat-slope diagnosis became the memo's sharpest paragraph.

## Friction log

- None. Cheapest arm on this rung despite the consult (solve + revise $1.09).

## Artifacts

See `SHA256SUMS`. memo.md, robustness-table.md, script.R, and the figure are the REVISED versions; advice.md and briefing.md are the committed consult record (home paths scrubbed). Full transcripts retained locally (envelopes carry the session ids).
