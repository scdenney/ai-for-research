# Rethinking the Research Process

**Resuming in a new session:** read [HANDOFF.md](HANDOFF.md), then [planning/13-resume-context.md](planning/13-resume-context.md). That file consolidates the decisions, author feedback, current delivery, source locations and next actions. Imported context is indexed [here](planning/context-2026-09-17/README.md).


Korea University, *AI Literacy for Social Scientists*, lecture 01. Steven Denney, Leiden University. 18 September 2026, 1:30–3:30 PM KST, online via Zoom. Moderator: Sung Eun Kim.

The lecture explains where to automate routine work, protect learning and judgment, and collaborate with AI in research and teaching. The introduction establishes a working vocabulary and explains why research requires more than executable feedback. Part 1 develops the three modes and applies complexity and verifiability across the research process. Part 2 begins with a source-check failure, then shows how a persistent knowledge base, research repository, reusable skills, and distinct reading, execution, and comparison checks make collaboration more inspectable.

## Current deck

The latest pass rebuilds Part 2 around the research repository as a project knowledge base. It moves the authentic source-check result directly after Part 1, defines how skills focus agents using LLMs and tools, and brings the historical revision and numerical consistency workflow forward. The separate Part 3 source remains preserved but is excluded from this working build pending its own review.

The approved serif design is implemented in the working deck: **30 main pages including the cover and three mode transitions, plus fifteen appendix pages; 45 PDF pages total.** Main-deck footers end at 25. Physical page 4 intentionally omits printed footer 3. The speaker notes budget 55 minutes, with diagram walkthroughs and source-reading time. Rehearsal remains necessary.

| File | Purpose |
|---|---|
| `overleaf/main.tex` | Full lecture entry point; inputs `preamble.tex` and seven part files |
| `overleaf/main.pdf` | Local compiled deck, ignored by git |
| `overleaf/design-preview.tex` | Original five-slide review checkpoint, kept separately |
| `overleaf/figures/source-excerpt.png` | Real source-PDF excerpt; provenance in the adjacent README |
| `notes.md` | Matching notes, cumulative timings, evidence locators, and guardrails |
| `planning/02-rebuild-storyboard.md` | Approved narrative and implementation record |
| `planning/review-part2-rebuild-2026-09-17/README.md` | Current Part 1 bridge, Part 2/3 rebuild, and validation |
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
