# Run log — advisor arm (Claude side) / T3

| Field | Value |
|---|---|
| Date | 2026-07-11 |
| Platform + version | Claude Code 2.1.207 (headless `claude -p`, `env -u ANTHROPIC_API_KEY`), toolkit fable-advisor.sh for the consult |
| Models | solve + revise: session default (Fable 5 · max); consult: Fable 5 · max (CLAUDE_EFFORT=max) |
| Brief | `prompts/t3-reviewer-memo.md` @ commit `7d681d8` |
| Capture method | headless, three scripted steps (solve → one consult → revise) |
| Wall-clock | step 1: 42 turns; step 3: 12 turns (durations in the two envelopes) |
| Tokens / cost | step 1: $5.515; step 3: $1.566 API-equivalent (envelopes) |

## Routing trace

1. Plain solve (no orchestration skill): bootstrap analysis with respondent clustering, contrasts fixed per draw; memo with corrected AMCE ±0.251 [0.168, 0.334], MM ranges 0.251/0.237/0.198, rival-difference tests (p = .80, .33).
2. One consult (fable-advisor, briefing = brief + memo + deliverables on disk): the reviewer VERIFIED the memo's numbers against script/table/figure first, judged the analysis sound, then found the decisive missing argument — a binary attribute's displayed AMCE is invariant to every baseline configuration while rivals' displayed maxima shrink under some references (driving time falls to 14.1 pp under ref = 45 min), so the alleged artifact provably cannot put a rival above crime as a point estimate; the correct softening comes from sampling error, not baselines. Also: surface the IRR-correction magnitude, fix one notation hazard.
3. Revise: memo revised per advice.

## Friction log

- None. The consult's number-verification pass is itself a distinguishing behavior of this arm.

## Artifacts

See `SHA256SUMS`. memo.md is the REVISED memo; advice.md and briefing.md are the committed consult record. Full transcripts retained locally (envelopes carry the session ids).
