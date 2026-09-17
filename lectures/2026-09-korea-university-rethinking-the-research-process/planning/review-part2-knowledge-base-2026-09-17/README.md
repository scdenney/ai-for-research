# Part 2 knowledge-base rebuild validation

## Implemented sequence

Part 2 now begins immediately after the research risk-terrain slide with the source verdict introduced at the opening. It then establishes persistent project memory, the research repository as the evidence-bearing foundation, the relationship among a skill, an agent, an LLM, and tools, and three distinct forms of checking. The historical source correction and illustrative numerical mismatch follow as worked examples.

The working build contains 30 main pages and 15 appendix pages. Useful operational detail removed from the main argument is retained after an explicit Appendix transition. The separate Part 3 source file remains unchanged and preserved, but `main.tex` does not include it while that section awaits author review.

## Timing and build

- Speaker notes contain 30 timed rows covering physical pages 1 through 30.
- Allocations are continuous, each stated duration matches its interval, and the total is 3,300 seconds or 55 minutes.
- XeLaTeX produced 45 pages with embedded fonts.
- Final PDF SHA-256 is `b7a5028bb47e0e12f74cef4568274863932f117a5469e969069b529c3b482106`.
- Overleaf `main` was pushed and remote-verified at `3b6a2cc45556f99bce60a8315d6045a3193ce83e`.

## Render review

Every page was rendered at full size and at a 720p approximation. The contact sheets show a clear transition from Part 1 into the eight-slide Part 2 argument and a visibly separate appendix.

Automated geometry found no out-of-page text and no text overlaps. The three long diagonal segments on physical page 20 are the intended research-process arrows. The detector reports an inherited line on physical page 3 and the last word of a contained multiline appendix callout on physical page 39. Both were inspected in the rendered pages and are visually contained. The former appendix overflow on physical page 45 was shortened and cleared on the final run.

## Numerical example

`demos/verification/run_receipts.py` completed successfully. The retained illustrative pipeline continues to reject the stale 0.31 report against the freshly generated 0.28 result, accept the corrected report, and fail closed on missing or invalid outputs. Generated timestamp and temporary-path noise were not committed.

## Deferred work

Part 3 remains a separate author-review task. The opening roadmap still anticipates that section and should be reconciled when the demo is rebuilt. A timed rehearsal, a real Zoom screen-share check, and an authenticated Overleaf browser preview remain outside this local validation.
