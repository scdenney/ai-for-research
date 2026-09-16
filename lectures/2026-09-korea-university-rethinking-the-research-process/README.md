# Rethinking the Research Process (Korea University, 18 September 2026)

Lecture 01 in Korea University's *AI Literacy for Social Scientists* special lecture series:
"Rethinking the Research Process: How AI Is Changing Research for Students and Professors."
Friday 18 September 2026, 1:30 to 3:30 PM KST, online via Zoom, moderated by Sung Eun Kim.
Up to an hour of talk, then discussion. Graduate students and faculty in sociology and
political science.

**Abstract.** The question is not whether academics should use AI but where to automate, what
to protect, and where to collaborate. Agentic AI was built for software, which ships with a free
correctness check. Research does not, so every mistake is silent. Part 1 gives the three modes
and the mechanism behind them. Part 2 shows four controls built onto one real project's pipeline:
the source library, a deterministic citation check, a grounded claim check, and the supervision
desk. Part 3 walks that project from grant to conference talk and shows what stayed human.

| File | What it is |
|---|---|
| `overleaf/` | The deck, as a git submodule of the Overleaf project. `main.tex` inputs `preamble.tex` (the Chalk and Mulberry design system) and `parts/00-open.tex` to `05-appendix.tex`. Build: `latexmk -xelatex main.tex`. Fonts are Noto, which Overleaf ships; locally, install the Noto casks through Homebrew. |
| `overleaf/main.pdf` | The compiled deck, 52 pages: 43 content slides, 3 dividers, 6 appendix pages. Published copy: `docs/lectures/rethinking-the-research-process/slides.pdf`. |
| `notes.md` | Speaker notes, one section per slide with cumulative timings ending at 57:00, and the accuracy guardrails: every number on a slide with the file it was verified against, and what stays off the slides by decision. |
| `planning/` | The wiki. `01-framework-and-structure.md` is the argument of record; `08-open-questions.md`; `palette-options/` holds both Codex palette proposals. |
| `deliverable.yml`, `HANDOFF.md`, `inbox/`, `checks/` | The deliverable pipeline's manifest, session state, dictation inbox, and gate receipts. |
| `_superseded/html-deck/` | The first attempt, a self-contained HTML deck. Rejected on 16 September 2026 and kept for reference only. |

## Presenting

Open `overleaf/main.pdf` in a PDF viewer in presentation mode. No overlays or builds; every
slide is shown whole. The notes are in `notes.md`, not in the PDF.

## Editing and rebuilding

Edit the part files under `overleaf/parts/`, then in `overleaf/`:

    latexmk -xelatex main.tex

Overleaf is the writing surface of record for the deck; the submodule pointer in this repository
is updated after each push there. Nothing is pushed to Overleaf without the author's say-so.

## Design

Codex's Option A, Chalk and Mulberry: a cool grey-lilac page, carbon ink, mulberry for structure,
eucalyptus as the single emphasis colour, pine, bronze, and cranberry as verdict marks only. Noto
Sans throughout, English and Korean alike. Beamer's default theme, XeLaTeX, 16:9. One artifact per
slide: a statement, a table, a diagram, a code box, or a before-and-after pair. Contrast floors
were raised for Zoom screen-share, and the densest slides were checked at 720p.
