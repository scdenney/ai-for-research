# Korea University talk (18 September 2026) — Handoff

## 2026-09-16 · Narrative and skills revision

**Current state:** 31 main pages, including cover and three dividers, plus six appendices: 37 PDF pages. A historical citation-support question anchors the opening and returns in Part 3. Definitions of agents, the tool loop and context precede explicit Automate/Protect/Collaborate decision rules. Part 2 teaches skill construction, invocation and inspection using actual research-repo instructions, a source conversion, and new read-only audit receipts. Notes total 55:00.

**Validation:** all pages rendered and inspected; dense pages reviewed at full size and selected pages under 720p compression. Clean XeLaTeX build; embedded fonts; continuous footer numbers 1–33; no out-of-page text. Citation identity and claim support checked separately for two historical keys. Reference project unchanged. See `planning/11-narrative-skills-validation.md`, `planning/receipts-2026-09-16/`, and `planning/review-narrative-2026-09-16/`.

**Delivery:** full deck pushed to Overleaf main at **42ff7ff2e321c1947e22f911577717f1f203a403**; remote hash verified. Author's earlier remote edit a304738 preserved. Entry point `main.tex`, XeLaTeX. Parent GitHub branch remains local; website PDF and design-preview.tex unchanged; pre-existing untracked brief preserved.

**Remaining:** Overleaf browser shows Restricted because the connected Chrome profile is signed out, so the server-compiled PDF has not been inspected. Local PDF is validated. Author review, timed rehearsal and real Zoom screen-share check remain. Playwright Chrome extension was actually used for public-source captures. Credentials stay outside the repository.

---


## 2026-09-16 · Foundations, evidence, and cosmetic revision

**Current state:** approved consolidated plan implemented. 32 main slides including cover, three dividers, five appendices: 40 PDF pages. Seven foundations now precede Automate/Protect/Collaborate. The cover carries the title once; ordinary slides have no running title or section label and only necessary citations. Arrows, diagrams, real OSS/Hub captures, two primary-source evidence plots, and the replication handoff are in place. Notes map every slide and sum to 55:00.

**Validation:** all 40 pages rendered and inspected; independent review; six 720p compressed examples checked; numbering, source quotations, exact historical diff, units/intervals, embedded fonts, and text bounds verified. Final gate passes all three checks. Matplotlib's PDF font warning was fixed through its supported PGF/XeLaTeX backend. See `planning/10-foundations-validation.md` and `planning/review-2026-09-16/`.

**Delivery:** full deck committed and pushed to Overleaf main at **180d608**. Entry point `main.tex`, XeLaTeX, project https://www.overleaf.com/project/6aaa697efc7ddb608ab4c4d1. This parent repository remains local; no GitHub push or website PDF replacement. The standalone design preview and pre-existing untracked codex brief remain intact.

**Next:** author review, timed rehearsal, and a real Zoom screen-share check. Later presentation-skill lessons are recorded in the validation document; no new skill was created. Chrome Playwright was actually used for all public-page captures. Browser credentials and cross-machine configuration live outside the lecture repository.

---

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
