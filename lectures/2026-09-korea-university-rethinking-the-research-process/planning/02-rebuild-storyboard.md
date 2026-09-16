# Rebuild storyboard — review checkpoint, 16 September 2026

This is the current plan of record, approved for implementation as a complete outline and five rendered samples. It supersedes the build, timing, Korean-text, and skill-taxonomy decisions in `01-framework-and-structure.md`. That file remains a historical record. The current main deck and speaker notes have not yet been rewritten to this plan.

## Argument and teaching sequence

The question is what role human cognition should play in a task. Automate routine work aggressively; protect the practice through which knowledge and judgment develop; collaborate where human decisions and machine capability can be combined responsibly. These are choices, not stages. The same task can change modes with the learning objective.

The substantive middle explains how collaboration works: a persistent workspace, project instructions, reusable skills, and a source library. Research-repo supplies infrastructure. Citation-check and fact-check use that infrastructure to examine different kinds of error. Neither produces a guarantee of truth. The final demonstration shows one historical claim changing after its source became available.

Thirty content slides, three unnumbered section dividers, approximately 55 minutes. Divider transitions are included in the section budgets. Opening 3 minutes; Part 1 14; Part 2 28; Part 3 7; close 3. These are delivery budgets, not timings inferred from prose word counts. Full notes should include time to inspect the diagrams and walk through the source example.

## Visual direction

Kenny-led composition, with EB Garamond drawn from *From Pixels to Patterns*. Light ivory on every page, near-black body text, restrained oxblood headings, dark teal emphasis. No Korean text. No dark or saturated dividers, oversized headings, thick title bars, or mandatory boxes around prose.

Preview palette: page `FFFCF2`; ink `25231F`; muted `5F5A52`; structure `6E3B34`; emphasis `2E5E5B`; light fill `F2EDE3`. Body 12/15 pt where feasible, compact diagram explanations 11/13.75 pt, titles 18/22.5 pt, divider title 22/27.5 pt. Monospace only for real paths, keys, and code. Rules at least 0.9 pt. Preview labels and provenance are smaller; the spoken argument must remain readable without reading the provenance footer.

The preview is independent of `main.tex` and its preamble. It tests five distinct forms: divider, comparison, workspace diagram, source diagram, and historical before/source/after comparison. No live terminal receipts are invented. The worked comparison consolidates three future demo slides onto one review page.

## Storyboard

Evidence abbreviations below refer to the source register at the end. Each entry records teaching purpose, visual form, evidence, and spoken transition. Wording is a proposed slide title, not completed speaker notes.

### Opening — 3 minutes

**1. Rethinking the Research Process** (0:30)
- Purpose: establish the event and the question of how AI changes research for students and professors.
- Visual: quiet title, subtitle, Steven Denney, Korea University, 18 September 2026.
- Evidence: event details in the existing lecture README and planning record. Retain the poster title.
- Transition: “I want to show how I work, and what I think we should still do ourselves.”

**2. Why I am building these resources** (1:00)
- Purpose: locate this talk in the author's research and teaching practice, without an extended biography.
- Visual: two linked resource names with one sentence each: Open Science Skills supplies reusable procedures; AI for Research explains and teaches their use.
- Evidence: RES. No skill-count or productivity claim.
- Transition: “The point is to make the research process visible enough to discuss and inspect.”

**3. The process we perform and teach** (1:30)
- Purpose: put ideas, sources, data, analysis, writing, and checking in view before introducing AI categories.
- Visual: a restrained horizontal research-process drawing with a return arrow from checking to sources and writing. Explicitly illustrative, not a rigid stage model.
- Evidence: author's framework, HIST.
- Transition: “Each of these activities raises a different question about what we should do ourselves.”

### Divider: Part 1 — Automate, protect, collaborate

### Part 1 — 14 minutes

**4. What role should human cognition play?** (2:00; preview page 2)
- Purpose: distinguish the three modes and immediately qualify them by learning objective.
- Visual: three parallel columns, purposes and examples, no connecting arrows. Qualification visible below.
- Evidence: HIST and user's revised brief. This is the author's normative framework.
- Transition: “Start with the work that gains little from our attention.”

**5. Automate without guilt** (1:45)
- Purpose: make the positive case for aggressive automation of low-value routine work.
- Visual: short pairs: rename files / check naming rule; format references / inspect output; track tasks / review exceptions. Avoid implying these tasks are error-free.
- Evidence: author's workflow examples; no private email or student artifacts.
- Transition: “Saving effort is valuable, except when the effort is the point.”

**6. Protect the work through which we learn** (2:00)
- Purpose: separate producing an answer from learning to reason toward it.
- Visual: reading, developing an interpretation, defending it; one question about early drafting and seed ideas.
- Evidence: HIST, including uncertainty about writing and ideation. Present as judgment and debate, not universal empirical law.
- Transition: “The choice depends partly on what this task is meant to teach.”

**7. A learning objective changes the decision** (2:00)
- Purpose: show why the same activity need not receive a permanent label.
- Visual: one reading task in two contexts: student developing interpretation; researcher comparing a familiar body of work. In both, retain responsibility for what is claimed.
- Evidence: user's framework; illustrative teaching example, not student data.
- Transition: “That brings us to work we deliberately share with the machine.”

**8. Collaborate with a decision still to make** (2:00)
- Purpose: define machine collaboration as purposeful work with review and human decisions.
- Visual: human question → machine-assisted comparison → human judgment, with a return loop. Examples: source synthesis, analysis review, supervision.
- Evidence: RR, FC; supervision workflow from HIST.
- Transition: “This is especially difficult when the output is a research claim.”

**9. Research needs more than executable checks** (2:00)
- Purpose: retain the useful research/software distinction without claiming software has free, complete correctness tests.
- Visual: code tests can check specified behavior; source checks can establish support for particular claims; neither settles every substantive question.
- Evidence: KEN comparison, corrected by the notes review. Code can pass tests and remain wrong; a claim can match a source whose design is weak.
- Transition: “The visible mistake is often not the most difficult one.”

**10. A real reference can support a wrong claim** (2:15)
- Purpose: distinguish non-existent citations, wrong metadata, unsupported attribution, and overclaiming.
- Visual: four short failure descriptions, from readily searchable record errors to interpretation and scope. Save the actual NWO passage for Part 3.
- Evidence: CC, FC, DEMO. Do not say fabrication was present in this project.
- Transition: “So how do we give collaboration a foundation we can inspect?”

### Divider: Part 2 — How machine collaboration works (preview page 1)

### Part 2 — 28 minutes

**11. A workspace the researcher can inspect** (2:00; preview page 3)
- Purpose: give a short conceptual primer on an agent and its relationship to the researcher and files.
- Visual: researcher directs/reviews; agent uses tools; instructions and skills guide work; persistent files hold outputs and evidence. Label relationships.
- Evidence: RR, CC, FC. This is an explanatory schematic, not a screenshot or a promise that every tool has identical capabilities.
- Transition: “The files matter because the conversation is temporary.”

**12. Keep context beyond the conversation** (1:30)
- Purpose: explain persistent context without treating model memory as an authoritative archive.
- Visual: new conversation drawing on sources, project decisions, and prior review records. Distinguish a decision log from evidence for a substantive claim.
- Evidence: RR, KEN.
- Transition: “Some files describe the project; others tell the agent how to work.”

**13. Instructions set context; skills specify procedures** (2:00)
- Purpose: explain the difference before naming skills.
- Visual: two brief authentic excerpts from project instructions and an OSS skill, selected during the full build and labelled by source. No installation commands.
- Evidence: RR-generated instructions and current SKILL.md files. Quote exact excerpts when built.
- Transition: “I maintain these procedures in one resource and teach their use in another.”

**14. Open Science Skills and AI for Research** (1:30)
- Purpose: plug both resources with a concrete reason to use each.
- Visual: OSS → reusable research procedures; AI for Research → walkthroughs, examples, teaching materials. Clickable resource names.
- Evidence: RES. Link to actual repositories/site; do not invent maturity or usage metrics.
- Transition: “The place to start is the project around the source library.”

**15. Research-repo builds the working environment** (2:00)
- Purpose: excavate what research-repo does before treating it as a check.
- Visual: compact actual scaffold: sources/{og,md,unprocessed}, references.bib, conversion script, local process-source instructions, project instructions, analysis/manuscript folders as needed.
- Evidence: RR. Scaffold is generic; do not pretend every historical project uses identical filenames.
- Transition: “The folder structure becomes useful through a repeatable intake process.”

**16. Bring a source into the project** (2:00)
- Purpose: explain acquire → preserve → convert → inspect → register.
- Visual: PDF excerpt and corresponding Markdown excerpt from the same source, with a note that extraction must be checked against the original.
- Evidence: RR and DEMO source; source originals must be located and checked before the full slide is built. `doc-to-markdown` belongs here, not on a separate tool-tour slide.
- Transition: “Text alone is not enough. We also need to know which reference it belongs to.”

**17. Connect the citation to the source** (2:00; preview page 4)
- Purpose: explain the traceable relationship among originals, conversions, bibliography keys, and checks.
- Visual: original → text → bibliography link → claim comparison. Derived notes branch separately.
- Evidence: RR, DEMO bibliography. Generic `references.bib` is a scaffold convention; the NWO project uses `sources/references_master.bib`.
- Transition: “This lets us distinguish evidence from what we have written about it.”

**18. Four kinds of project knowledge** (2:00)
- Purpose: keep originals, converted source text, derived summaries, and project decisions conceptually separate.
- Visual: four rows with purpose, origin, and what it can establish. A summary is not a substitute for source evidence; decisions document choices, not their truth.
- Evidence: RR, FC; explanatory organization proposed for this lecture, not a claim that a skill always creates all four layers.
- Transition: “This resembles the knowledge-base idea in Kenny's presentation.”

**19. A knowledge base, related to the LLM wiki** (2:00)
- Purpose: explicitly connect Kenny's persistent wiki idea to this source-centred implementation.
- Visual: shared principle: context persists outside chat. Distinct organization: raw sources, source text, linked notes, project decisions. Cite Kenny by name and date.
- Evidence: KEN, RR. Related approach, not an assertion that the two systems are identical or that Kenny authored these skills.
- Transition: “What can we do once that library exists?”

**20. Work with the library** (1:45)
- Purpose: show retrieval, comparison, and synthesis as collaborations with inspectable inputs.
- Visual: question → source passages → comparison notes → researcher decision. Use `literature-review` as an application of the library, not a standalone product pitch.
- Evidence: LR, RR. Any sample output built later must be labelled illustrative or supported by a real artifact.
- Transition: “The library also lets us check two different things about a draft.”

**21. Citation-check: identify the work and inspect the citation** (2:00)
- Purpose: distinguish citation identity, metadata, reference parity, and source support.
- Visual: cited key → bibliography record → external record match; then a separate evidentiary-support question.
- Evidence: CC. Uses programmatic lookups and judgment; do not call it free, wholly deterministic, or a compiler. Record unresolved cases.
- Transition: “A correct record does not by itself establish that the sentence is supported.”

**22. Fact-check: compare the claim with the source** (2:00)
- Purpose: show claim-level comparison against available source text.
- Visual: draft claim / source passage / assessment / human decision. Explain missing source means not checked, not passed.
- Evidence: FC. Cite-check and fact-check have overlapping support checks; they are not mutually exclusive tools.
- Transition: “Even that comparison has limits.”

**23. What this foundation can and cannot establish** (1:45)
- Purpose: state the actual strength of verification.
- Visual: can inspect attribution, direction, scope; cannot guarantee source validity, causal identification, complete coverage, or sound judgment. Conversion can fail too.
- Evidence: FC, CC, notes audit. No arbitrary readiness threshold as a main-slide doctrine.
- Transition: “The same division of work applies in teaching.”

**24. Supervision: keep the judgment human** (1:30)
- Purpose: include a concrete teaching collaboration without exposing student material.
- Visual: read → annotate → dictate (human), then structure → check → format → edit. Label the final review as the supervisor's responsibility.
- Evidence: HIST. Schematic only; no private letter comparison.
- Transition: “And at the end of a project, someone else needs to be able to inspect the results.”

**25. Replication-package: make the results reproducible by others** (2:00)
- Purpose: extend infrastructure beyond the working repository to an independently usable release.
- Visual: working project → curated package: README, master script, data/codebook or access instructions, environment, outputs crosswalk → independent rerun.
- Evidence: RP. This is a separate package, not publishing every working file. FAIR does not require unrestricted release of protected data. Local creation does not imply automatic deposit.
- Transition: “Let me end with one small example of this source-based work changing a claim.”

### Divider: Part 3 — One claim, checked against its source

### Part 3 — 7 minutes

**26. The claim and its references** (2:00)
- Purpose: let the audience read the original claim and identify what must be checked.
- Visual: historical sentence excerpt, two cited works, clear date label. No terminal interface.
- Evidence: DEMO parent of commit `75366c6`, not current manuscript. Original claim concerned citizens penalizing executive relative to legislative action.
- Transition: “The references existed. We needed to read what this source actually found.”

**27. What the acquired source said** (2:30)
- Purpose: compare the claim with the actual Christenson and Kriner abstract and relevant source context.
- Visual: source excerpt with source title, authors/year and locator; highlight the claim-relevant language without deleting qualifiers.
- Evidence: DEMO source and acquisition record. This is a historical reconstruction, not a newly executed skill receipt.
- Transition: “That finding required us to separate the claims attached to these references.”

**28. Record the revision and the decision** (2:30; preview page 5 combines 26–28)
- Purpose: demonstrate correction and traceability rather than celebrate an automated pass.
- Visual: before/source/after, historical commit and date. Name what changed: particular acts judged by agreement, rather than a general penalty asserted from that paper.
- Evidence: DEMO diff `75366c6`, 27 August 2026. The revision excerpt is one clause from a larger sentence; do not present it as a complete replacement paragraph or evidence that all later versions remain fixed.
- Transition: “The value is a research process in which that correction can be made and inspected.”

### Close — 3 minutes

**29. What to take into your own work** (1:30)
- Purpose: connect the infrastructure back to the three modes for students and professors.
- Visual: three short actions: automate routine chores; protect a learning objective; build a source-grounded workspace for one collaboration. Retain human responsibility in all three.
- Evidence: author's framework and demonstrated workflow.
- Transition: “The resources are here if you want to try this on your own project.”

**30. Resources and discussion** (1:30)
- Purpose: give a useful endpoint and open the conversation.
- Visual: AI for Research, Open Science Skills, Kenny's presentation, and one discussion prompt about what participants would protect. Prefer readable short links; optional single QR.
- Evidence: RES, KEN; verify final destinations before publication.
- Transition: invite moderated discussion.

## Appendix candidates and exclusions

Keep only material that answers likely questions: documented readiness receipts (after checking referents), converter details, Kenny's four working modes (with attribution), and disclosure. Each appendix slide needs its own evidence locator during the full build.

Remove the long NWO project chronology, activity counts, repeated audit slides, synthetic citation demo, and supervision letter comparison from the main narrative. Do not add OCR/text-to-data corpus work, research-grill, research-wayfinder, student material, pretest/registration material, or the excluded incident examples. Source PDF conversion for the knowledge base remains in scope.

## Evidence register and exact demo provenance

Paths below are author-local evidence locators, not material to project on the slides.

- **HIST:** `01-framework-and-structure.md`, retained as history; revised user directions and coordinated discussion with the original Claude session, 16 September 2026. Later decisions above take precedence.
- **KEN:** `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`, Christopher T. Kenny, 10 September 2026, 32 pages. All pages rendered during reference review. Slide 32 supplies the persistent knowledge-base/wiki comparison.
- **PIX:** `https://scdenney.github.io/assets/slides/from-pixels-to-patterns/#1`; exact local published HTML at `/Users/scdenney/Documents/github/personal/scdenney.github.io/assets/slides/from-pixels-to-patterns/index.html`. Consulted and rendered locally. Editorial serif influence only.
- **RES:** AI for Research repository README and Open Science Skills README at `/Users/scdenney/Documents/github/resources/open-science-skills/README.md`. Repositories: `https://github.com/scdenney/ai-for-research`, `https://github.com/scdenney/open-science-skills`.
- **RR / CC / FC / LR / RP:** `plugin/skills/{research-repo,citation-check,fact-check,literature-review,replication-package}/SKILL.md` in that OSS repository. Recheck changed skill specifications before the final build. Research-repo creates the project-local intake skill; process-source carries out source intake.
- **DEMO project:** `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash/`.
- Source text: `sources/md/christenson-kriner-2017-constitutional-qualms-unilateral.md`, abstract, line 7. Exact preview excerpt: “Americans do not instinctively reject unilateral action as a threat to our system of checks and balances”. The rest of that sentence explains partisan and policy preference priors.
- Bibliography: `sources/references_master.bib`, key `ChristensonKriner2017`; *Constitutional Qualms or Politics as Usual? The Factors Shaping Public Support for Unilateral Action*, AJPS 61(2), 335–349, DOI `10.1111/ajps.12262`.
- Acquisition record: `sources/ACQUIRE.md`, acquired 27 August 2026; documents the resulting correction.
- Manuscript git repository: `papers/2-legitimacy-policy-process/manuscript`; commit `75366c6ca9ecc96148acba4840a4853c73f47c43`; `sections/frontmatter/front_matter.tex`.
- Exact prior excerpt: “studies of unilateral policymaking similarly show that citizens penalize executive action relative to legislative action”. Both ReevesRogowski2016 and ChristensonKriner2017 followed it.
- Exact revision excerpt: “judging particular unilateral acts largely by whether they agree with them”. ChristensonKriner2017 follows this clause alone. The preceding clause is separately attributed to ReevesRogowski2016.

## Checkpoint and subsequent work

Review artifacts: `preview/design-preview.pdf`, `preview/page-1.png` through `page-5.png`; source `../overleaf/design-preview.tex`. Build and visual checks are recorded in `preview/README.md`.

This checkpoint leaves `main.tex`, `preamble.tex`, `parts/`, `notes.md`, and the published website PDF unchanged. After the outline and visual direction are reviewed, the next phase is to rebuild the full deck, write matching speaker notes and evidence locators, render all pages, and then update the publication artifact. No full-deck completion is claimed here.
