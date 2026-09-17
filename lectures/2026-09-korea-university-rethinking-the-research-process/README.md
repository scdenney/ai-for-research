# Rethinking the Research Process

**Resuming in a new session:** read [HANDOFF.md](HANDOFF.md), then [planning/13-resume-context.md](planning/13-resume-context.md). That file consolidates the decisions, author feedback, current delivery, source locations and next actions. Imported context is indexed [here](planning/context-2026-09-17/README.md).


Korea University, *AI Literacy for Social Scientists*, lecture 01. Steven Denney, Leiden University. 18 September 2026, 1:30–3:30 PM KST, online via Zoom. Moderator: Sung Eun Kim.

The lecture explains where to automate routine work, protect learning and judgment, and collaborate with AI in research and teaching. The introduction establishes a working vocabulary and explains why research requires more than executable feedback. Part 1 develops the three modes. Part 2 shows how Open Science Skills support the lecturer’s workflow: research-repo establishes a source-based knowledge base, citation-check and fact-check use it, conjoint checks and paper-review-lite extend it, and a numerical example distinguishes reading from running and comparing results. The v2.31 verifier checks package conditions and execution; replication-package prepares the publication handoff. A historical claim is introduced at the end of the introduction and revisited in Part 3.

## Current deck

The latest pass simplifies introductory slide 4 and Part 1 while preserving the author’s other intro edits. Part 2’s content is retained but its visual design needs substantial revision; it has not been accepted as presentation-ready.

The approved serif design is implemented in the full deck: **38 main pages including the cover, three part dividers and three mode transitions, plus six appendix pages; 44 PDF pages total.** The cover and dividers are unnumbered; ordinary slides run 1–37, including the appendix. The speaker notes budget 55 minutes, with diagram walkthroughs and source-reading time. Rehearsal remains necessary.

| File | Purpose |
|---|---|
| `overleaf/main.tex` | Full lecture entry point; inputs `preamble.tex` and seven part files |
| `overleaf/main.pdf` | Local compiled deck, ignored by git |
| `overleaf/design-preview.tex` | Original five-slide review checkpoint, kept separately |
| `overleaf/figures/source-excerpt.png` | Real source-PDF excerpt; provenance in the adjacent README |
| `notes.md` | Matching notes, cumulative timings, evidence locators, and guardrails |
| `planning/02-rebuild-storyboard.md` | Approved narrative and implementation record |
| `planning/review-part1-simplification-2026-09-17/README.md` | Current Intro/Part 1 simplification and scoped visual review |
| `overleaf/figures/evidence-plot-provenance.md` | Verified estimates, intervals, and limitations for both evidence figures |
| `overleaf/figures/browser-capture-provenance.md` | Real Chrome-extension screenshots and source revisions |
| `planning/preview/` | Approved preview PDF and five page images |
| `HANDOFF.md`, `deliverable.yml` | Session state and deliverable manifest |

## Overleaf and local build

Overleaf project: <https://www.overleaf.com/project/6aaa697efc7ddb608ab4c4d1>.

Select **main.tex** as the Overleaf main document, with **XeLaTeX**, to compile the full lecture. `design-preview.tex` still compiles only the five-page preview.

Locally, in `overleaf/`:

```sh
latexmk -xelatex -interaction=nonstopmode main.tex
```

Fonts: EB Garamond and Noto Sans Mono. 16:9 Beamer, light ivory, near-black ink, oxblood structure, teal emphasis. No overlays, dark dividers, or Korean text. All current text/background colors clear 4.5:1 sRGB contrast.

The latest requested delivery is to **Overleaf only**. The GitHub Pages PDF in `docs/lectures/rethinking-the-research-process/slides.pdf` remains the earlier published version; it has not been replaced or republished by this rebuild. The parent GitHub branch is not pushed in this step.
