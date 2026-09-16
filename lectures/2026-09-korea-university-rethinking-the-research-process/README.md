# Rethinking the Research Process (Korea University, 18 September 2026)

Lecture 01 in Korea University's *AI Literacy for Social Scientists* special lecture series:
"Rethinking the Research Process: How AI Is Changing Research for Students and Professors."
Friday 18 September 2026, 1:30 to 3:30 PM KST, online via Zoom, moderated by Sung Eun Kim.
A 45-minute talk followed by discussion; graduate students and faculty in sociology and
political science.

**Abstract.** The question is not whether academics should use AI but where to automate, what
to protect, and where to collaborate. Part one gives that three-way allocation. Part two stays
at the workbench with two demonstrations: a research knowledge base that ends in checking
whether a manuscript says what its sources say, and a textbook corpus that ends in inference
about Korean national identity. The two show the same rule from both sides: automate the
machinery, not the judgment.

| File | What it is |
|---|---|
| `index.html` | The deck. One self-contained file (fonts and figures embedded), works offline. Open in Chrome or Chromium; `F` for fullscreen. Published at `docs/lectures/rethinking-the-research-process/` on the AI for Research site. |
| `deck.pdf` | The same deck, one slide per page, 16:9. The fallback if screen-share fails. |
| `content.md` | **All slide text, editable.** Change a line here and rebuild. Diagram labels are in `src/charts.py`. |
| `notes.md` | Speaker notes with cumulative timings, and the accuracy guardrails. The Substack post derives from this file. |
| `references.bib` | The works cited on the slides; the gate resolves every `Author Year` string against it. |
| `src/` | `deck.html` (slides and CSS), `charts.py` (the diagrams as SVG), `build.py`, `runtime.js`, `fonts.css`, `figures/`, `qr.svg`. |
| `deliverable.yml`, `HANDOFF.md`, `planning/`, `inbox/`, `checks/` | The deliverable pipeline's manifest, session state, wiki, dictation inbox, and gate receipts. |

## Presenting

Open `index.html`, press `F` for fullscreen. `→` / `space` / `PageDown` advance (the three
build slides reveal step by step, then move on); `←` goes back; `Home`/`End` jump; `1`–`9`
jump to a slide, or type `#12` in the URL. `R` returns to the cover, `N` toggles the notes
overlay, `B` blacks the screen, `P` previews the print layout.

## Editing and rebuilding

    python3 src/build.py --html   # index.html only
    python3 src/build.py          # index.html + deck.pdf (needs Chrome or Chromium)

The build fails with a list of missing keys if a placeholder in `src/deck.html` has no entry in
`content.md`. The gate (`check_deliverable.py`) checks citations, credentials, and prose tells.

## Design

The house deck template (`resources/deck-template/`) re-skinned to the Pixels-to-Patterns
palette: cream page, warm ink, oxblood for structure, teal as the only emphasis, sage, ochre,
and brick as verdict marks only, oatmeal box fill, rose on the single dark slide. EB Garamond
throughout, Korean in a system gothic. Assertion headlines, one focal object per slide, no
bullet lists, builds only on the three diagram slides, contrast raised for Zoom screen-share.
