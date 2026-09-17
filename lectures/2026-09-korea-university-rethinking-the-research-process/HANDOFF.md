# Korea University talk (18 September 2026) — Handoff

## 2026-09-17 · Presentation-ready package
_agent: codex · 2026-09-17T20:51:14Z_

**Decision:** Treat the current Overleaf revision as the presentation source for 18 September. Preserve the full planning and evidence record, while keeping tomorrow's presentation files in a separate, easy-to-find local folder.

**Completed:** Fast-forwarded the Overleaf submodule to `7ef72a9`, compiled the 46-page XeLaTeX deck, and confirmed the PDF metadata and 16:9 page size. Created `/Users/scdenney/Documents/Korea University Presentation - 2026-09-18/` containing the presentation PDF, speaker notes, exact Overleaf source ZIP, and a short README with the PDF hash. Removed disposable LaTeX auxiliaries, `.DS_Store` files, and the script cache from the lecture folder; retained `overleaf/main.pdf` as the local build artifact.

**Finding:** Final PDF SHA-256 is `77df287d171afc60657e6df23022626b1bc9e2b0d97f70ccc68a6da50acd5112`. The Overleaf source and local build are clean. Unrelated parent-repository changes remain untouched.

**Next actions:** Open the packaged PDF once in the presentation app, confirm full-screen display and link behavior, and rehearse with `Speaker-notes.md`. No further deck edits are required unless the rehearsal reveals a concrete problem.

## 2026-09-17 · Part 2 refocused on skill development
_agent: codex_

**Author direction:** Part 2 must address verifiability through skill development. It should begin with a knowledge base, establish the research repository as the foundation, and then bring the skill material previously stored at the back of the deck into the main argument. Part 3 was to remain unchanged.

**Completed:** Rebuilt the ten-page Part 2 sequence around persistent project memory, the research repository, source intake, the relationship among the repository, skill, agent, LLM, tools, and result, supervision arrangements, skill invocation, Git with finished and sitrep, paper-review-lite, and the broader verification skill stack. Promoted and simplified the former appendix slides numbered 33--37. Reduced the appendix from eleven pages to six. Part 3 is unchanged.

**Validation and delivery:** The deck has 38 main pages and six appendix pages, 44 total. Timed notes remain continuous and total 55 minutes. XeLaTeX succeeds with embedded fonts. Full renders find no out-of-page text or text overlaps. Overleaf main was pushed and remote-verified at `7860f8bcd950740d94211ebe7d0593f47dd939c6`. PDF SHA-256 is `b4f718ff042944c53b4aeb201917e75d32a2259b57c4a8e06df33f4c7c2c0821`. See `planning/review-part2-skills-2026-09-17/README.md`.

**Next:** Author review of Part 2, then the separate Part 3 demo discussion. No website replacement or parent GitHub push was performed.

---

## 2026-09-17 · Part One visual and interpretation follow-up
_agent: codex_

**Author feedback:** The labels and descriptions on printed slide 7 were not centered within their rows. The green conclusions beneath the two evidence plots also described fragments of the results instead of interpreting the plotted comparisons. Colon and semicolon constructions were unwanted in the slide prose.

**Completed:** Replaced the top-anchored row text with shared midpoint anchors for both columns. Each label now centers against its description as a unit. Rewrote both green plot conclusions as concise interpretations of the assisted and later unaided results. Removed colon and semicolon constructions from the surrounding Part One prose and tightened the adjacent evidence table to retain clean row spacing. Matched the research-terrain axes to the preceding quadrant slide with Complexity, Hard, Easy, Verifiability, Subjective, and Objective. Preserved the author's concurrent Overleaf edits, including the revised order and Automate and Protect language.

**Validation and delivery:** The combined 49-page deck compiles without an overfull box. Physical pages 10, 13--15, and 20 were rendered and inspected at full size. Overleaf main was pushed and remote-verified at `9395428be46adc4bbdba25dad10cf54113459a64`. Local PDF SHA-256: `764ed130bf0ede2aa0814bdf11564ff91f92d39ae9cdcc8146fb350928c47a39`. No website replacement or parent GitHub push.

---

## 2026-09-17 · Research-pipeline bridge and Part 2/3 rebuild
_agent: codex · Astra-led orchestrate with Sol and Terra implementation and independent Astra review_

**Author direction:** Part 2 had become crowded and catalog-like. The author wanted it to flow from machine collaboration into complexity and verifiability across the research process, then show how repositories and skills improve checking conditions. The demo needed to reconnect the opening source claim and add a separate analysis/output case.

**Completed:** Replaced the final Part 1 role table with a seven-stage research risk-terrain slide and moved the table to the appendix. Rebuilt Part 2 as ten slides organized around the research repository, source evidence, reusable procedures, reference identity, claim support, manuscript-reading limits, and distinct reading/running/comparing checks. Expanded Part 3 to six slides: the authentic historical source correction followed by an explicitly illustrative 0.31-versus-0.28 consistency check and human-agent correction loop. Added a reproducible vector comparison figure generated from the retained illustrative CSV and stale report. Expanded the appendix to eleven pages and synchronized notes, storyboard, manifest, resume context, and open questions.

**Validation:** 49 physical pages: 38 main and eleven appendix. Timed notes contain 38 continuous allocations totaling 55:00, with Part 2 at 20 minutes and Part 3 at 9. XeLaTeX succeeds with embedded fonts; every page was rendered and contact-sheet/full-size inspected. Geometry finds no out-of-page text or text overlaps. The numerical receipt suite passes: stale report fails, corrected report passes, and failed generation plus invalid, missing, non-finite, and out-of-range outputs fail closed. Independent Astra review found no blocking layout, code, or provenance defect after documentation drift was corrected. See `planning/review-part2-rebuild-2026-09-17/`.

**Delivery:** Overleaf main pushed and remote-verified at `bf1351df4fe5f4eb76702bad8faa31165d8e6ab4`. Local PDF SHA-256: `7082c65af7e57dde384fb0e8fbfd75fa551ced108fb0edb342bdfaa89ac6c2f9`. No website PDF replacement or parent GitHub push.

**Remaining:** Author review, timed rehearsal, real Zoom screen-share test, and authenticated Overleaf browser preview. The historical source case and illustrative numerical case must remain visibly distinct in any later edits.

---

## 2026-09-17 · Concrete Protect rationale and applied X/Y grid
_agent: codex · Astra-led orchestrate with Sol editorial/render review_

**Feedback:** The author rejected slide 8’s abstract work/researcher comparison and the grid’s axes and lack of connection to this talk.

**Completed:** Printed 8 now explicitly connects cognitive development to interpreting sources, weighing evidence, and constructing arguments. Printed 14 has standard arrowed axes and four illustrative research tasks. Notes connect the grid to the source repository and verification workflows, with task-specific limits and human responsibility retained. Only these two slide frames changed; Parts 2 and 3 remain deferred/unchanged.

**Checks and delivery:** Rendered both changed slides; corrected the lower-left quadrant spacing; checked exact scope and 55-minute notes. Gate passes. Overleaf main pushed at `ab8aa693614ec6a7230fc7bdd114575b17e9dac7`; parent changes committed locally. See `planning/review-protect-axes-2026-09-17/`. No website replacement or parent GitHub push.

---


## 2026-09-17 · Author-directed Intro/Part 1 simplification
_agent: codex · Astra-led orchestrate; Sol editorial review; Terra notes and visual review_

**Author feedback:** Prior slides were too crowded, especially Part 2. Technical containment was not sufficient. Part 2’s substantive design revision is deferred until requested; Part 3 is outside this pass.

**Completed:** Pulled author intro edits `86c939f`. Simplified printed slide 4; replaced Protect’s teaching-method chain with a conceptual work/capability distinction; moved old 32/33 together into Protect and clarified the table’s “Finding” column. Used “Ethical machine augmentation is the goal.” Centered and simplified the grid, followed by the former appendix role table. Added the AI-throughout-research framing to notes. All other intro frames and Parts 2/3 remain unchanged.

**Validation:** 38 main pages plus six appendices, still 44 total and 55-minute notes. Revised pages rendered and independently checked for space and readability; final evidence wording checked. Build/font, notes timing, scope-preservation and deliverable checks pass. The unchanged author baseline has one fill crossing on physical page 3 and omits printed footer 3; these were preserved and recorded. See `planning/review-part1-simplification-2026-09-17/README.md`.

**Delivery:** Overleaf main `5d9178cff819d77035b5ea011f349af4b3efab9d`; parent scoped changes committed locally. No website replacement or new parent GitHub push. Unrelated parent changes preserved.

**Next:** Author review of this narrower pass, then substantial Part 2 simplification when requested. Rehearsal, actual Zoom check, and authenticated Overleaf server preview remain.

---


## 2026-09-17 · Verifiability revision implemented and delivered
_agent: codex · Astra-led orchestrate with Sol and Terra workers_

**Completed:** Implemented the approved full-session plan across the introduction and Parts 1–3: Kenny/Swaney grid, Pocock software feedback lesson, repository-centered deep dive, citation/fact checks, conjoint illustration, paper-review-lite, executable illustrative numerical comparison, accurate OSS 2.31 verifier limits, and historical source-check/diff. Preserved the release capture, source provenance, and separate hashed OSS snapshot. Planning conflicts and corrected capability claims are recorded explicitly.

**Validation:** 44 pages (35 main, nine appendices), 55-minute notes, footers 1–37. XeLaTeX and embedded fonts verified; every page rendered; final geometry checks clear. Independent content and visual review accepted the revision. Numerical pipeline exercises stale/corrected reports and failure cases; all 36 snapshot records match. Deliverable gate passes. See `planning/review-verifiability-2026-09-17/README.md`.

**Delivery:** Overleaf main pushed to `8e35336206c849eaf9ef09115167adb616eea920`. Scoped parent changes committed locally; no new parent GitHub push or website PDF replacement. Unrelated parent working-tree changes preserved.

**Next:** Author review, timed rehearsal, real Zoom check, and authenticated Overleaf browser preview. These are not established by the validated local PDF. The benchmark source copies remain local/ignored; provenance is tracked.

---


## 2026-09-17 (Claude session closed; branch pushed)
_agent: claude · session: 01Hsn8RLmmjDG7d2Z9woFRUB · 2026-09-17 UTC_

**Decision:** Steven asked to close and push. Branch `korea-university-lecture` pushed to GitHub with all local commits. Website `slides.pdf` deliberately left at the earlier build; replacing it is a separate author decision because the last-slide QR points at it.

**Completed:** This session recorded both relayed literature reviews in `planning/09-evidence-protect.md` (`ddb02f3`, `a878607`), including the assisted-versus-unaided axis, the Autor bifurcation correction, the Bassner qualification of guardrails, and the do-not-cite list. Relayed those corrections to the Codex peer before its foundations revision. Verified the peer's closure state: parent tree clean, Overleaf submodule at `0486a4f` (39 pages, 55-minute notes), deck free of do-not-cite items.

**Finding:** The Codex peer's revisions (`408b219` through `79cfd49`) supersede the earlier "v3, 36 pages" state that this session's memory described. `planning/13-resume-context.md` is the entry point for the next session.

**Next actions:** Author review on Overleaf (`main.tex`, XeLaTeX). Timed rehearsal and Zoom screen-share check. Replace `docs/lectures/rethinking-the-research-process/slides.pdf` with the delivered build and push, on the author's say-so. The HBIR AI-use statement still lacks Autor.

---


## 2026-09-17 (Session closed)
_agent: codex · 2026-09-17 05:40 UTC_

**Decision:** Continue in this lecture directory on `korea-university-lecture`; start with `planning/13-resume-context.md`.

**Completed:** Context consolidation committed as `bd3608f`; lecture implementation/validation is `69b326d`; delivered Overleaf deck is `0486a4f`. Verified all 29 imported file hashes, portable rendering of the unchanged 39-page PDF, and passing credential/manifest/prose checks. Parent and Overleaf working trees were clean at closure. This final entry changes only HANDOFF.md and is committed locally.

**Next actions:** Author review of Intro/Parts 1–2, then Part 3 when requested; timed rehearsal and Zoom check; Overleaf browser preview after authentication. GitHub publication and website PDF replacement remain separate. Full source copies are locally saved but Git-ignored, as documented in the source manifest. No credentials were added and no further push was performed.

---


## 2026-09-17 (Consolidate context for a new session)
_agent: codex · 2026-09-17 05:30 UTC_

**Decision:** Resume from this lecture directory in ai-for-research. The user authorized importing relevant Open Science Skills context and preserving source files. Current plan and deck take precedence over imported historical memories.

**Completed:** Added `planning/13-resume-context.md` and a local `AGENTS.md` entry point. Imported lecture/browser/replication memories, the old external Claude plan, five Claude/Codex skill snapshots, and temporary worker notes into `planning/context-2026-09-17/`, with an SHA-256 source manifest. Copied the Kenny reference PDF with text extraction and available claim-check source texts/PDFs into its ignored local-sources folder. Preserved and tracked the original codex brief. Updated README, wiki index and open-questions status. Added portable render-review tooling. No deck content changed or pushed in this consolidation.

**Finding:** Some OSS memories still describe rejected deck versions. They are archived explicitly as history. Current deck remains Overleaf `0486a4f`, 39 pages / 55 minutes, with parent implementation `69b326d`. Full acquired works stay local and ignored; credentials were not imported.

**Next actions:** Read the resume context, then continue author review of Intro/Parts 1–2 and later Part 3. Rehearsal, Zoom check and server preview remain. Parent GitHub and website publication have not occurred. Local source copies need separate transfer for a fresh clone on another machine.

---


## 2026-09-16 · Purpose, foundations, skills and version control

**Current state:** 39 PDF pages: 33 main pages including cover, three part dividers and three mode transitions; six appendices. The purpose and plain definitions precede the historical claim. Part 1 separates Automate, Protect and Collaborate. Part 2 follows research-repo through Git/GitHub history, source intake, citation-check, fact-check and replication-package. Notes remain 55:00. Part 3 content is unchanged pending the author's later review.

**Validation:** rendered all pages; inspected revised diagrams and dense source/code pages; independent Sol/Terra work and review. Clean XeLaTeX build, embedded fonts, footer sequence 1–32, no automated bounds/overlap/fill-crossing/diagonal findings. Literal Markdown/BibTeX checked; plot data unchanged. Deliverable gate passes. See `planning/12-purpose-foundations-validation.md` and `planning/review-purpose-2026-09-16/`.

**Delivery:** pushed full deck to Overleaf main at **0486a4f144636719767ed45f834243196580565d**; remote hash verified. Parent GitHub branch committed locally only. Website PDF, design-preview.tex, reference research project and untracked brief preserved.

**Remaining:** author review, timed rehearsal and screen-share check. Chrome Playwright extension used, but Overleaf browser remained Restricted/403 because that profile is signed out. Server compilation preview is not verified; local PDF is validated.

---


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
