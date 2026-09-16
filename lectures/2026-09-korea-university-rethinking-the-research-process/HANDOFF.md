# Korea University talk (18 September 2026) — Handoff

Read by `/sitrep` (start of session) and updated by `/finished` (end of session).
Newest entry at the top; don't rewrite history — append.

---

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
