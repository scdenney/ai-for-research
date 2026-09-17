# Resume the Korea University lecture · 17 September 2026

This is a consolidated handoff from the Codex session launched in an Open Science Skills worktree. It records the current decisions and the user's feedback, not a verbatim transcript. Resume in **ai-for-research**, not that worktree.

## Latest author review · Part 2 and Part 3 rebuild

The author approved a split bridge from the Part 1 supervision grid into a research-process overview, followed by a deeper account of machine collaboration through repositories, reusable procedures, and distinct checks. The implemented deck has 38 main pages plus eleven appendices, with the 55-minute budget divided 8 / 15 / 20 / 9 / 3.

Printed slide 20 now maps seven research stages across qualitative complexity and current-verifiability terrain. Part 2 has ten slides including its divider and uses one dominant object per slide. CLI syntax, Git/session continuity, reviewer rosters, verifier internals, replication detail, and conjoint detail moved to the appendix. Part 3 has six slides including its divider and follows two separate cases: an authentic historical source correction and an explicitly illustrative 0.31-versus-0.28 numerical comparison. No protected NWO analysis output is used.

Read `review-part2-rebuild-2026-09-17/` for the current validation, `02-rebuild-storyboard.md` for the live narrative, and `notes.md` for the exact timing and qualifications. Timed rehearsal, real Zoom testing, authenticated Overleaf preview, parent GitHub push, and website PDF replacement remain separate.

## Previous author review · Intro and Part 1 simplification

The author found the deck too crowded, particularly Part 2. That criticism supersedes the prior positive validation as an assessment of presentation quality. The current pass simplifies printed slide 4 and Part 1, preserving the author’s other Overleaf intro edits (`86c939f`). Three appendix slides move into Part 1: 38 main pages, six appendices, 44 total; notes remain budgeted to 55 minutes.

The latest follow-up replaces the rejected abstract Protect comparison with an explicit explanation of how reasoning practice develops judgment. The grid now uses arrowed axes and illustrative research tasks, with a Part 2 connection in notes. The learning-evidence table and conceptual learning slide remain promoted together; the role table follows the grid. The Collaborate transition uses the author’s requested wording. Read `review-protect-axes-2026-09-17/` for the latest two-slide checks; the previous pass is recorded separately.

**Next content work is Part 2, when requested.** It is deferred and requires substantial editorial and visual simplification. Part 3 is also outside this pass. Preserve that boundary.

## Earlier implemented revision · 17 September 2026

The author approved the integrated verifiability plan and requested execution with Astra-led orchestrate. The current storyboard supersedes the 16 September sequence below. Implemented: 35 main pages, nine appendices, 55 minutes. Read the latest HANDOFF entry and `review-verifiability-2026-09-17/` for validation and delivery evidence.

New material: Kenny/Swaney complexity–verifiability quadrant; Pocock software feedback example; repository-centered Part 2; conjoint illustration; paper-review-lite; a captured project-specific .31-versus-.28 numerical check; honest v2.31 static and temporary-copy execution limits; sitrep/finished and on-demand invocation; strengthened historical Part 3 diff. Earlier broad claims about no prior code execution are corrected in the planning notes.

The source knowledge base stays central. The numerical example uses illustrative data and an explicit project comparator; OSS itself does not compare manuscript estimates with regenerated values. Main quadrant replaces the role table, now in the appendix. No live terminal demonstration, new website publication, or changes to reference research projects.

## Where to start

Repository: `/Users/scdenney/Documents/github/resources/ai-for-research`, branch `korea-university-lecture`. Lecture: `lectures/2026-09-korea-university-rethinking-the-research-process/`. Read, in order:

1. `../HANDOFF.md`, newest entry first.
2. This file and `02-rebuild-storyboard.md` for current intent.
3. `../notes.md` alongside `../overleaf/parts/*.tex` for the actual delivered version.
4. `review-part1-simplification-2026-09-17/` for current scoped checks; earlier validation reports are historical.
5. `09-evidence-protect.md` and `receipts-2026-09-16/` for evidence qualifications and historical claim receipts.
6. `context-2026-09-17/README.md` for imported external context and source files.

`01-framework-and-structure.md`, the original codex brief, earlier validation reports, and imported memories/plans are historical. They contain obsolete slide counts, palettes, teaching sequences and push instructions. Later explicit user decisions, current storyboard, and current deck prevail. The lecture has not received final author approval merely because an implementation plan was approved.

## 16 September delivery baseline (historical)

39 physical PDF pages, 33 main pages including cover/transitions, six appendices, footer numbers 1–32. Speaker notes total 55 minutes: introduction 8, Part 1 15, Part 2 22, Part 3 7, closing 3. The latest deck commit is Overleaf `0486a4f144636719767ed45f834243196580565d`. The parent implementation/validation commit is `69b326d`. Later commits consolidate context only.

Overleaf: https://www.overleaf.com/project/6aaa697efc7ddb608ab4c4d1. The nested Git repository at `overleaf/` is a submodule on `main`. It was pushed and its remote hash verified. The parent GitHub branch has not been pushed, and `docs/lectures/rethinking-the-research-process/slides.pdf` is an older published deck. Do not mistake that website PDF or `design-preview.tex` for the current full deck.

## What the user wants this talk to do

Explain how AI fits into research and teaching through **Automate, Protect, Collaborate**. The audience is advanced students and researchers, especially graduate students; basic student chatbot use is not the focus. The opening must plainly state today's purpose, then establish vocabulary: generative AI, LLMs, agents and agentic AI. It must distinguish a chat exchange from an agent acting with tools and feedback, without suggesting these technologies are mutually exclusive.

Explain early why software execution/tests and research validation differ. Do not imply tests prove all software correct, or that research has no checks. Research claims require source interpretation and substantive judgment. Avoid vague maxims such as “the distinction is capability,” “available files are not current context,” and “collaborate when evidence can change the decision.”

Part 1 separates the three modes with a Mode / Use it when / Examples table and a transition for each mode. Automate routine tasks that need not consume attention: scheduling, tracking, filing and formatting. Do not turn this into a complicated source-intake audit. Protect the work through which understanding develops or is demonstrated; use firm principles and selected learning examples rather than universal bans on drafting or reading assistance. Collaborate combines human judgment with machine capability. End there so Part 2 naturally deepens the collaboration discussion.

The historical manuscript claim and its two references are useful, but introduce them at the **end of the introduction**, after the audience knows what the talk is doing. Reserve the verdict for Part 3. The user likes the four collaboration patterns table within Collaborate. Credit genuine adaptations, without repeatedly borrowing another talk's framing.

Part 2 is about the lecturer's actual infrastructure and reusable skills, not a premature run of demos. Briefly define a skill, why one writes it, and what goes into it. Show real Claude Code and Codex invocations. **research-repo builds the foundation**: originals, readable Markdown, bibliography, and persistent project files. Connect this to Karpathy's LLM Wiki as a related persistence idea, without claiming identical architectures. Show original PDF text, matching Markdown and literal BibTeX, not invented metadata or a broken drop-cap artifact. Current source-intake conversion uses OpenDataLoader for prose; bibliography registration is a separate agent-managed step. Do not claim measured speed gains without evidence.

The user's last addition is **version control**: Git records changes, GitHub keeps/shares the history. Show edit → inspect diff → commit with explanation → push. Make the benefit concrete: trace source corrections, code changes and manuscript decisions, compare versions and restore earlier work. History is not a truth guarantee.

Then show citation-check and fact-check as named, invoked skills working on that foundation. Explain reference identity/integrity versus claim support, while acknowledging overlap. Replication-package is a companion for reproducible analysis outputs and disciplinary standards, with Harvard Dataverse as a possible archive. Local preparation/audit and external upload are separate. Horiuchi's methodological contribution is credited.

## Design requirements and lessons

- Keep the approved warm serif design (EB Garamond; Noto Sans Mono for code). No Korean text, dark transitions, oversized clunky type, repeated running title or section labels.
- Title belongs on the cover. Normal slides need a clear heading and page number. Cite where evidence or adaptation needs attribution; remove decorative labels, QA language, and routine green takeaway sentences.
- Figures, tables and diagrams are welcome. Authentic OSS/Hub captures and real project artifacts are welcome when they help teach the process. A screenshot is not a substitute for a clear explanation.
- Arrows must be straight, attached to corresponding boxes, and evenly spaced. Equal coordinates matter in both axes. Variable-width nodes previously caused slanted vertical arrows even when the horizontal-arrow check passed.
- Center callouts and retain breathing room. Never judge layout from TeX alone. Render and inspect every changed page, with full-size views of diagrams and dense source/code examples plus compressed screen-share approximations.
- Avoid audit jargon in the spoken deck. Put operational caveats, source paths and verification receipts in notes/supporting records.
- A reusable presentation skill reflecting these lessons was requested for later consideration; it has not been created. Do not claim it exists.

## Evidence that must remain qualified

Autor: juniors did not decline on average; their unaided scores became more dispersed/bifurcated. Identify patent lawyers and explain redlining as reviewing/revising a patent. Distinguish assisted output from later unaided judgment.

Bastani: observed harm concerns unrestricted assistance. Guardrails mitigated that harm in this setting, not a universal learning benefit. Bassner found improved exercise performance but no conceptual-learning advantage in either AI arm. Keep domain/duration differences visible.

Relevant prior task knowledge, not general seniority, is the appropriate moderation question. Melumad and Yun is the preferred optional third evidence example on learning through LLM synthesis versus links. Do not cite Toner-Rodgers or the retracted HSSC meta-analysis DOI 10.1038/s41599-025-04787-y. Detailed source leads, warnings, and the HBIR/course-setup-announcement relay are already in `09-evidence-protect.md`. The entire promised 30-source review was not supplied to this Codex session; do not claim that unseen document was imported.

## Remaining work recorded at the earlier checkpoint (historical)

1. Await/review the author's response to the latest intro and Parts 1–2. The user repeatedly said earlier iterations were still not right; implementation is not final acceptance.
2. Revise Part 3 when requested. Its content was deliberately left unchanged during the last revision.
3. Timed rehearsal and real Zoom screen-share test remain. Notes are a budget, not measured delivery time.
4. The Chrome Playwright extension was installed/configured and actually used in the prior work. The connected Chrome profile returned Overleaf Restricted/403; the server-rendered PDF was not verified. Local build and Git delivery are verified.
5. Website replacement/GitHub publication and any Substack adaptation are later work, not completed delivery.

## Build and inspect from this repository

```sh
cd lectures/2026-09-korea-university-rethinking-the-research-process/overleaf
latexmk -xelatex -interaction=nonstopmode -halt-on-error main.tex
```

`main.tex` is the full deck; keep XeLaTeX and the named fonts. `main.pdf` is ignored but locally available. For a fresh clone initialize the submodule (requires Overleaf access). Read the latest local and remote Git state before overwriting or pushing, since the author can edit Overleaf independently. Rendered review artifacts and the recorded PDF hash are in the validation folder. `scripts/render-review.py` provides a portable copy of the last layout-check script; Python requires PyMuPDF and Pillow. Automated geometry checks supplement human visual review.

The credential-free browser setup note is imported in `context-2026-09-17/historical-memory/`. Actual tokens remain in user configuration outside Git. Do not copy Desktop credential RTFs, environment files or Chrome profiles into this repository. Configuration was previously reported for Mac and omarchy; it was not retested during this context-consolidation step.

## What was brought here

The consolidation preserves relevant Open Science Skills session memories, the external historical Claude plan, five Claude/Codex skill definitions with provenance, worker notes formerly in /tmp, and the already-local original brief (now tracked). Full reference files are copied into ignored `context-2026-09-17/local-sources/`, with paths/hashes in its manifest. The canonical deck, notes, receipts and current storyboard were already here. No wholesale unrelated session transcript, research project, credential store or browser profile was imported.

The original handwritten outline is represented by the existing framework transcription; no newly discovered original scan is asserted. The source manifest explicitly distinguishes committed context from ignored local full texts. Resume on this Mac has both; a fresh clone on another host needs those local full texts transferred or reacquired.
