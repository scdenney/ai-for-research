# What Are We Thinking? AI in Research and Supervision

Public seminar, Leiden University. Steven Denney. 21 October 2026, 15:00–17:00, DH Lab, Huizinga 0.09. Moderator: Aron van de Pol.

> What should we shamelessly automate, what should we ruthlessly guard from AI, and where should we collaborate with the machine? This seminar offers a conceptual framework for thinking about AI in research and supervision, followed by practical and responsible ways to put AI and its agents to work in both settings.

This talk was rebuilt from the Korea University lecture ([`../2026-09-korea-university-rethinking-the-research-process/`](../2026-09-korea-university-rethinking-the-research-process/)): simplified, re-themed to the seminar poster, and re-centred on an opening audience survey, the three modes applied to research and supervision, and a live knowledge-base demonstration. The Korea University folder stays untouched as the record of that talk.

| Path | Purpose |
|---|---|
| `slides/main.tex` | Deck entry point (XeLaTeX); 35 pages, poster palette in `preamble.tex` |
| `slides/parts/` | One file per section; `01-surveys.tex` holds the published figures, `05-demo-fallback.tex` the appendix pages that appear once `slides/figures/demo/*.png` exist |
| `notes.md` | Speaker notes for the 10 + 45 minute plan, the break, and the discussion |
| `survey/` | The anonymous Qualtrics opener: spec, build and export scripts, QR for page 2, `results.py` for the break; see `survey/README.md` |
| `visual/knowledge-base.html` | The four-state knowledge-base visual opened in a browser at page 23 (arrow keys; F for fullscreen) |
| `planning/` | `01-update-brief.md` (what changed from Korea), `02-survey-evidence.md` (the surveys behind pages 4–5) |
| `inbox/` | Raw captures (dictation, reactions) for intake |
| `HANDOFF.md`, `deliverable.yml` | Session state and deliverable manifest |
| `scripts/render-review.py` | Page-render review helper (`python3 scripts/render-review.py --out DIR`) |

Poster and social graphics: `../../output/seminar-posters-2026-10-21/`.

## Build

```sh
cd slides && latexmk -xelatex -interaction=nonstopmode main.tex
```

Fonts: EB Garamond and Noto Sans Mono (both in TeX Live); kickers use Arial on the Mac and TeX Gyre Heros elsewhere.

## Overleaf

`slides/` is the working tree of the Overleaf project [6ad774de8e56718e506f28a5](https://www.overleaf.com/project/6ad774de8e56718e506f28a5) (remote `origin`, branch `main`; set the compiler to XeLaTeX in the project menu). Pull before editing locally, push after; build output and the unused Korea figures are excluded in `slides/.git/info/exclude`. When the lecture folder is committed to this repository, register the deck as a submodule: `git submodule add https://git@git.overleaf.com/6ad774de8e56718e506f28a5 lectures/2026-10-leiden-what-are-we-thinking/slides`.
