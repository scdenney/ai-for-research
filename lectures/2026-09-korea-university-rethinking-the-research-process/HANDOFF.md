# Korea University talk (18 September 2026) — Handoff

## 2026-09-16 · Full serif rebuild after preview approval

**Current state:** the five-page design was approved and the user requested the full deck pushed to the existing Overleaf project. The full source now implements 30 content slides, three dividers, and three appendix slides, with matching speaker notes budgeted to 55 minutes. The source library and collaboration infrastructure occupy Part 2; a single historical claim correction occupies Part 3. Replication-package is one slide. All Korean text is removed from the main deck.

**Validation:** all 36 pages rendered and visually inspected at 1280 × 720; five dense/source pages inspected under simulated compression. Font embedding, text bounds, content numbering, note timings, source excerpts, and final compile checked. See `planning/03-full-deck-validation.md`. Source-PDF crop provenance is in `overleaf/figures/README.md`.

**Delivery scope:** Overleaf only. Full entry point is `main.tex`, not the retained `design-preview.tex`. Parent-repository changes are committed locally. The website's previously published PDF remains unchanged.

**Next:** author review and a timed rehearsal, then an actual Zoom screen-share check. Publish the replacement website PDF when requested. Prior sections below describe superseded versions and remain as history.


Read by `/sitrep` (start of session) and updated by `/finished` (end of session).
Newest entry at the top; don't rewrite history — append.

---

## 2026-09-16 (rebuilt in Beamer from the wiki)

**Decision:** the HTML deck was rejected and the talk was rebuilt from
`planning/01-framework-and-structure.md`. Beamer on Overleaf (submodule at `overleaf/`), XeLaTeX,
Codex's Chalk and Mulberry palette, no overlays, one artifact per slide. NWO is the single running
example. Real Paper 2 evidence is on the slides by name; the one self-critical slide is the gate
blind spot; the three infrastructure incidents stay off.

**Completed:**
- `overleaf/main.tex`, `preamble.tex`, `parts/00-open.tex` to `05-appendix.tex`: 43 content slides,
  3 dividers, 6 appendix pages, 52 in all. Compiles clean locally with the Noto casks installed.
- `notes.md`: one section per slide, cumulative timings ending at 57:00, guardrails block.
- Every page rendered and inspected; slides 25, 36, and 39 checked at 720p JPEG quality 55.
- `deliverable.yml` repointed at the Beamer sources; gate passes (manifest, credentials, prose tells).
- Site page `docs/lectures/rethinking-the-research-process/` now embeds `slides.pdf`.
- The HTML deck moved to `_superseded/html-deck/`.

**Finding:** the Overleaf project was an empty article stub (`ku-talk-3bins`); it was replaced
wholesale. The gate's citations check is not configured for the Beamer sources (the deck cites by
prose, not by cite keys); every citation is instead listed in the guardrails block of `notes.md`.

**Next actions:** apply the Codex blind-review findings; push the submodule to Overleaf and the
branch to GitHub only on the author's say-so; one rehearsal against the clock; derive the Substack
post from `notes.md` after the talk.

## 2026-09-16 (opened and built in one pass)

**Decision:** build the Korea University lecture as a `kind: talk` deliverable inside
`ai-for-research/lectures/`, the first deck to live in that folder, using the house deck
template re-skinned to the Pixels-to-Patterns palette (cream, oxblood structure, teal emphasis,
sage/ochre/brick verdict marks). Demonstrations are captured on slides, not run live, because
the talk is over Zoom. The middle of the three spaces is "apprenticeship", not "sandbox", because
to an AI-literate audience "sandbox" names where the machine is contained. Plan of record:
`~/.claude/plans/find-the-slides-on-inherited-honey.md`.

**Completed:**
- `content.md` (34 slides + 4 appendix), `src/deck.html` (re-skinned shell with the new
  classes: divider, box, terminal, quote, def, flow, bigs, cards3), `src/charts.py` (eight SVG
  diagrams: three spaces, Kenny's grid, the gate, the knowledge-base stack, the textbook
  pipeline with and without the decision questions, cross-model divergence).
- `notes.md` with cumulative timings and the accuracy guardrails block.
- `references.bib` with the seven works cited on slides; `deliverable.yml`; `planning/`;
  `inbox/`; `checks/`.
- Figures copied from `research/projects/gei_textbooks/talk/c_design/figures/` (Polish 1951
  title page, Korean 1956 page).

**Finding:** the by-language cross-model divergence figures (Polish about 2 percent, Korean
about 25 percent) live in the GEI technical report but not yet in the committed analysis file;
the slide and the notes say "preliminary". No CER or WER exists for that corpus by a recorded
decision, and the slides never use those terms.

**Next actions:** rehearse once against the clock; send the PDF to the moderator as the
fallback; after the talk, dictate reactions into `inbox/` and run `/oss:deliverable-intake`;
derive the Substack post from `notes.md`.
