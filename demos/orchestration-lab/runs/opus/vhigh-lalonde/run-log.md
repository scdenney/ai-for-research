# Run log — opus-orchestrate / very hard (LaLonde methods dispute)

| Field | Value |
|---|---|
| Date | 2026-07-13 (clean re-run; supersedes an earlier headless capture that ended at a session boundary while a background audit was outstanding — that earlier deliverable was complete and Distinction-scoring, but its 2-turn / 2.3-min envelope undercounted the run, so it was re-run in a session that ran to completion) |
| Platform + version | Claude Code (headless `claude -p --model opus --effort ultracode`, `env -u ANTHROPIC_API_KEY`); oss plugin |
| Lead model + effort | Claude Opus 4.8 · ultracode |
| Brief | `prompts/vhigh-lalonde.md` |
| Capture method | headless |
| Wall-clock | 10.9 min (envelope duration_ms), 29 turns |
| Tokens / cost | 129k tokens excl. cache reads; $2.72 API-equivalent (envelope) |
| Score | **Distinction (6/6).** Blind-graded: anchors exact (benchmark +$1,794, naive −$8,498, composite 185 + 15,992 = 16,177); ≥4 propensity-score specs including pre-earnings; benchmark-referenced spec table; "favorable-specification-only recovery" judgment; no overclaim (bootstrap explicitly not used, per Abadie-Imbens 2008); benchmark-referenced spec-curve figure (Okabe-Ito, no title, 320 dpi). |

## Notes

This full run reproduces the same Distinction the earlier truncated capture scored; the difference is only the envelope — a complete 29-turn / 10.9-min run versus the earlier 2-turn / 2.3-min cutoff — which is what the page's wall-clock and token figures for this cell now use.

## Artifacts

See `SHA256SUMS`. Full transcript retained locally (envelope carries the session id).
