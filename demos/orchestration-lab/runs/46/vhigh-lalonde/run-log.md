# Run log — 46-orchestrate / VERY HIGH (LaLonde methods dispute)

| Field | Value |
|---|---|
| Date | 2026-07-12 |
| Platform + version | Codex CLI 0.144.1, headless `codex exec` per `prompts/run.md` |
| Lead model + effort | gpt-5.6-terra · medium |
| Brief | `prompts/vhigh-lalonde.md` @ commit `0ae449d` |
| Capture method | headless, full stdout in `exec-stdout.log` |
| Wall-clock | 3.6 min (file timestamps) |
| Tokens | 74,658 (log; Codex reports tokens only, no USD) |

## Routing trace

1. Lead (terra) worked the whole brief inline — zero spawns on this run (contrast with its own high-ajr run, which routed three roles). Eight-spec grid (2 covariate sets × 2 overlap rules × 2 estimators), all HC3/Welch intervals, no bootstrap.
2. Deliverables: spec table with gap column, benchmark-referenced figure, ~450-word adjudication.

## Score vs answer key (SCORING.md items)

**Distinction (6/6).** Anchors ✓ (benchmark $1,794 [479, 3,109]; naive −$8,498; composite 185 + 15,992), spec curve ✓ (demographics-only −$2,798 to −$4,137 all fail; pre-earnings 1-NN $1,712 untrimmed / $2,088 trimmed, both inside the rubric's tolerance; five-strata sensitivity shown, −$144 to +$1,266), benchmark-referenced table ✓ (content complete; see friction), no overclaim ✓ (rejects unqualified "works" and "fails categorically," rejects proximity-proves-ignorability, demands the full curve), judgment ✓ ("recovery occurs only under favorable specifications, not robustly across the defensible alternatives," pre-earnings decisive, plus the sharp line that "the specification spread is itself substantive uncertainty that the row-wise intervals do not absorb"), figure ✓ (all eight specs with intervals against the benchmark line).

## Friction log

- **Malformed spec-table rows.** The eight specification rows embed pipe characters in their label cells, so the markdown renders with shifted columns (raw text is unambiguous; the memo and figure carry the same numbers). Content complete, presentation defective — tracked as a quality note, not an item failure, consistent with how figure-convention defects are scored elsewhere in the matrix.

## Artifacts

See `SHA256SUMS`. `exec-stdout.log` is the full raw session (home paths scrubbed).
