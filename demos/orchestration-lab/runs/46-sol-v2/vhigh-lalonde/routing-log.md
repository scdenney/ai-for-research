# Routing log

## Route table

| Workstream | Owner | Mode | Artifact / evidence | Why routed there |
|---|---|---|---|---|
| Decomposition, estimator choice, implementation, integration, and final accountability | 46-orchestrate lead | Lead reasoning and local R checks | `script.R`, `spec-table.md`, `memo.md`, `figures/spec-curve.png` | These choices are tightly coupled: the lead needed to reconcile estimands, point estimates, intervals, diagnostics, and the final claim. |
| Pre-implementation methods challenge | Terra | Read-only `gpt-5.6-terra`, high effort | `TERRA-PROMPT.md`; `terra-peer.txt` | A bounded review could independently stress-test trimming, ATT weighting, stratification, and the invalid ordinary bootstrap without risking write collisions. |
| Approach check | Sol advisor | Read-only `gpt-5.6-sol`, xhigh effort | `ADVISOR-APPROACH.md`; `advisor-approach.txt` | The advisor skill requires an independent decision-focused consult before committing to a substantive causal-inference approach. |
| Cross-vendor artifact audit | Claude peer | Read-only Anthropic `fable`, high effort | `CLAUDE-PROMPT.md`; `claude-peer.txt` | Fable provided the requested decorrelated check of the finished numbers, code, figure, and adjudication. It was blind to Terra's response. |

Three read-only consult/delegation calls were used in total, within the brief's limit. No worker edited the shared tree. The lead performed all writes and all end-to-end checks.

## What was delegated

### Terra

Terra reviewed the proposed full 2 × 2 × 2 curve and focused on failure modes: whether trimming could change the treated target, whether refitting could invalidate a support rule, and whether the proposed pair-cluster variance adequately handled matching uncertainty. Terra endorsed the eight-cell curve and the favorable-specification decision rule, and requested retained counts and balance diagnostics.

The lead adopted the useful parts: common support is defined on the initial score, that score is retained after trimming, treated/control counts and maximum absolute SMDs are reported, and interval limitations are explicit. Terra's hypothetical estimand warning does not arise in the realized data because trimming drops CPS controls only and retains all 185 NSW treated units. The lead also replaced the initially proposed CR1 pair calculation with HC3 sandwich inference recommended by the installed MatchIt documentation. Terra preferred a full Abadie–Imbens variance; that was not implemented because `Matching` is unavailable, a hand implementation would add substantial unverifiable machinery, and MatchIt's documented HC3 route is defensible when clearly labeled conditional on the estimated design.

### Claude peer (Fable)

Claude Fable audited the durable artifacts after computation. It independently reproduced all ten rows—the benchmark, naive contrast, and eight adjusted specifications—passed each requested deliverable, verified the 320 dpi figure, and agreed that the evidence warrants “recovery only under favorable specifications.” Its optional suggestion was two-way clustering by matched pair and original unit for replacement matching. The lead tested that route: it slightly narrowed, rather than widened, the four 1-NN intervals and did not affect the verdict. The final script retains HC3 because MatchIt's installed guidance presents HC3 as the standard continuous-outcome choice and describes two-way clustering as an alternative with more limited evidence.

## What the lead reasoned and verified

The lead owned the observational composite, benchmark calculation, support definition, ATT implementation, row ordering, uncertainty labels, visual design, and claim language. Direct R checks established that the randomized benchmark is $1,794.34 and the naive CPS contrast is −$8,497.52; all trimmed rows retain 185 treated units; each subclass contains treated and control observations; and all estimates, intervals, gaps, sample counts, and balance statistics are finite and reproducible.

The single revision cycle followed the Fable audit. It grouped table rows in the same order as the argument, added shape as a grayscale-safe visual cue, made the figure caption self-contained, added explicit subclass checks, and clarified that benchmark gaps are descriptive rather than formal matching-bias estimates. No web access was used and no packages were installed.
