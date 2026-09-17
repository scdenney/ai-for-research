# Plan: rebuild the Korea University talk in Beamer

## Context

The first deck (35 HTML slides) was rejected. It read as a document set in slide format, repeated one template, and diverged from the handwritten outline. The argument was rebuilt in conversation and recorded in the planning wiki at `ai-for-research/lectures/2026-09-korea-university-rethinking-the-research-process/planning/01-framework-and-structure.md`. That file is the source of record for the argument. This plan turns it into a deck.

Occasion: Korea University, *AI Literacy for Social Scientists* lecture 01, Friday 18 September 2026, 1:30 to 3:30 PM KST, Zoom. Up to an hour of talk, then discussion. Graduate students and faculty, largely Korean-speaking, watching a compressed stream.

Decisions already made and not reopened here: the three modes are Automate, Protect, Collaborate, plain labels, no metaphor; the mechanism is that software has a free correctness check and research does not; Part 2 is the weight of the talk and shows skills as controls; Part 3 is the NWO project start to finish; Beamer on Overleaf, XeLaTeX, the Chalk and Mulberry palette; no recordings, so every demonstration is a rendered artifact; a little Korean on the framework slide; NWO is the single running example and clears the fact-check gate; the real Paper 2 evidence goes on the slides by name; the one self-critical slide is the gate blind spot, the three infrastructure incidents stay off.

## The deck in one line

Forty-three content slides plus three dividers and five appendix slides. Each content slide carries one artifact: a statement, a table, a diagram, a code box, or a before-and-after pair. No slide carries two of those. Frame titles are assertions where the slide makes a claim and short labels where the slide shows an artifact.

## Time budget

| Block | Slides | Minutes |
|---|---|---|
| Open and self-introduction | 1–3 | 4 |
| Part 1, where we are | 4–13 | 14 |
| Part 2, building the check | 14–35 | 30 |
| Part 3, one project start to finish | 36–40 | 9 |
| Close | 41–43 | 3 |

## Slide by slide

Facts in brackets name the file the number comes from. Every such fact is also listed in the guardrails section below and goes into `notes.md`.

### Open

1. **Title.** Poster title. Eyebrow: AI Literacy for Social Scientists · Special Lecture 01, with the Korean series line. Steven Denney, Leiden University. Korea University, 18 September 2026.
2. **Who I am.** Institute for Area Studies, Leiden. Experimental social science, Korea and East Asia. Two public repositories this talk draws on: open-science-skills and AI for Research. Draft from the profile; the author edits.
3. **What this talk is about.** The research pipeline, as we teach it and as we do it: idea, sources, data, analysis, writing, citation, claim. Three parts, one line each.

### Part 1. Where we are (divider)

4. **These tools were built for software.** Kenny's loop: task, model, tool, result, model, output. TikZ, six nodes. Credit: after Kenny 2026.
5. **Code runs or it fails. A claim does not.** Two-row diagram. Top: the software loop with a "compiler and tests" node that closes it. Bottom: the research pipeline with the same node drawn dashed and empty. This is the mechanism in one picture.
6. **Three consequences.** Three panels, one line each: errors are silent and compound; checking often needs the skill you handed over; the inputs are not in the training data.
7. **Three modes.** The framework table: AUTOMATE 자동화 · PROTECT 보호 · COLLABORATE 협업; second row hand off / preserve / combine; third row efficiency / learning and judgment / reach. The governing sentence under it: *The question is not whether AI can do a task, but what role human cognition should play in doing it.* No arrows.
8. **Each mode has a mechanism.** Statement slide, three lines: automate where a wrong answer is cheap or obvious; protect where the only check is having the skill; collaborate where you can build the check.
9. **Mode 1: aggressively and shamelessly automate.** The note's own register. Planning and management, categorizing email, tracking research, chores and admin. One evidence line: 662 dictations, 54,796 words, one month, two machines, about $8 [`ai-for-research/demos/talk-to-your-terminal/README.md:94`].
10. **Mode 2: protect.** Two columns rendered from the notebook's own confidence marks. Sure: grading, final manuscripts, most teaching, reading. Not sure, and put to the room: writing beyond the final manuscript, seed ideas.
11. **Who bears the cost.** Two columns. Research: your own skill formation, yours to waive. Teaching: a student's formation, not yours to waive. One line: the student has an interest and no vote.
12. **Same stage, different mode.** The pipeline stages as a row, with two rows of mode colours beneath: student, researcher. Reading sits in Protect for one and Collaborate for the other.
13. **Mode 3: collaborate where you can build the check.** The common category from the notes as a short list: research scaffolding and knowledge bases; bibliometrics and formatting; data collection, organization, analysis, visualization; ideation and QA; supervision. Bridge line: the rest of the talk is four checks, built.

### Part 2. Building the check (divider)

14. **One project, one pipeline, four controls.** NWO 406.XS.25.01.065, Open Competition XS, €50,000, October 2025 to September 2026. Four countries, conjoint, 10,000 QC-verified respondents (DE 2,502, KR 2,500, SG 2,500, US 2,498), three papers, one APSA talk [`papers/2-legitimacy-policy-process/README.md`, `HANDOFF.md` 2026-08-31]. The repository: 447 commits, 80 handoff entries, 54 session logs.
15. **A skill is a written standard the agent loads by name.** The `citation-check` SKILL.md frontmatter (name and description) in a code box. One line: 41 skills, Open Science Skills.

*Unit A: research-repo, the infrastructure*

16. **The boring folder structure is load-bearing.** The scaffold tree from research-repo, verbatim, in a code box. Sub-line: the source library is the spine; everything else grows from it.
17. **As built.** The NWO `sources/` layout and counts as a booktabs table: 119 Markdown files (103 conversions, 15 notes for works not held, one index), 103 originals, 126 master bibliography entries, drop zone empty [measured 2026-09-16]. Growth line: 59 → 72 → 119 Markdown files, June to September.
18. **What a converted source looks like.** First lines of `hainmueller-hopkins-yamamoto-2014-causal-inference-conjoint.md` in a code box. Sub-line from `sources/README.md`: Markdown lets the model read the text directly, which is what makes source-grounded checking possible.
19. **A note is not a source.** The `.NOTE.md` banner verbatim: *THIS IS NOT A SOURCE… a fact-check must record such a claim as unverifiable.* Under it: Paper 2's 74 cited works, 62 with real text, 12 with a note, none with nothing [`notes/OVERVIEW.md` 2026-08-27].

*Unit B: citation-check, the deterministic control*

20. **The closest thing research has to a compiler.** What it queries: Crossref, OpenAlex, DOI resolution, exact-title search, author-corpus cross-check. One line in emphasis: never treat "DOI resolves" as "DOI correct."
21. **What it can say.** The verdict vocabulary as a compact table: MISSING DOI, DEAD DOI, DOI RESOLVES TO DIFFERENT WORK, METADATA MISMATCH, TITLE DRIFT, STATUS UPDATE, NEEDS AUTHOR VERIFICATION, LIKELY FABRICATED.
22. **What it found, June 2026.** 37 cited works without a source file checked; all 37 exist; 8 metadata errors corrected the same day, one of them a fully invented entry: `FitzgeraldCurtisCorliss2012`, wrong authors, wrong title, wrong journal, the real work being "Anxious Publics" in CPS 45(4) [`HANDOFF.md` 2026-06-30]. Render the eight as a short list with the invented one first.
23. **The gate runs at every commit and never calls a model.** The `check_deliverable.py` output from the APSA talk, 2026-09-09, rendered as a terminal box: three FAIL lines for citations (Aviña et al. 2026 twice, Ogura et al. 2026), numbers PASS with 147 table values present in the snapshot, four prose WARNs, exit 1 [`talks/apsa-2026/checks/2026-09-09/fast.json`].
24. **What happened next.** The commit message of 2026-09-14, verbatim: *The deliverable gate checks every slide citation against this file, so the entry lives here even though the paper does not yet cite it.* Under it, the cache now: 23 VERIFIED [`talks/apsa-2026/checks/citations.json`].

*Unit C: fact-check, the grounded control*

25. **Formatting-clean is not the same as true.** The pre-flight gate: it refuses to run without a knowledge base, and the coverage rule, two-thirds of cited works. Render the NOT READY notice in a code box.
26. **What it can say.** SUPPORTED, PARTIALLY SUPPORTED, UNSUPPORTED, CONTRADICTED, MISATTRIBUTED, SOURCE INSUFFICIENT, NOT IN KB. The fidelity rule under it: a verbatim quote from the source, or no verdict.
27. **What it found, August 2026.** Every claim in Paper 2 checked against the source text, not the citation. Nineteen corrections [`notes/OVERVIEW.md`, Paper 2 revision pass]. Four citations supported the opposite of their source, rendered as four rows: Hangartner is Greece, not Germany; Tichenor argues immigration cut across party lines; Hooghe and Marks contain nothing on asylum; Citrin et al. 1997 is a null on personal economic competition.
28. **One finding in full.** Claim, source, fix. The Bansak et al. conjoint chapter: the text claimed an AMCE is defined over the levels a researcher writes; the chapter says an AMCE is defined with respect to a baseline and the randomization distribution; zero hits for the words the claim rested on [`notes/OVERVIEW.md`]. Sub-line: this was the last unverified citation in the paper.
29. **Two checks, two failures.** The demo's lesson rendered as a two-column contrast: citation-check passes a well-formed reference; only reading the source catches that the claim is backwards. Use the synthetic demo's CONTRADICTED row as the illustration beside the real Paper 2 case [`demos/reference-check/expected-output/fact-check-report.md`].

*Unit D: where the control failed*

30. **The gate reads what it is told to read.** Finding F011 from the APSA lint: a citation sat in a text field rather than a cite field, the script never saw it, and it stood on a deck already at a public URL. The model lint found it. Two of three by the script, the third by the model. One line: a check is only as wide as its scan [`talks/apsa-2026/checks/2026-09-09/report.md`].

*Unit E: supervision, the teaching side*

31. **The same logic runs the supervision desk.** Pipeline diagram with mode colours: READ, ANNOTATE, DICTATE in the human colour; STRUCTURE, CHECK, FORMAT and EDIT in the machine colour; the letter signed by the human.
32. **Dictation, before and after.** The pair from the cleanup log: *beckon you to engage* → *require you to engage*, one repair, nothing rewritten [`~/.config/macwhspr/cleanup_log.jsonl`, 2026-06-04].
33. **Structure and check.** Five finders, one per assessment criterion, then one cross-checker. The rule verbatim: *quote the span verbatim with its page anchor; if you cannot quote it, do not assert it.* Two facts under it: a 900-word cap; Learning Skills is never marked by the skill.
34. **The letter, before and after.** The book-chapter feedback paragraph pair, 105 words to 68, no names [`~/Desktop/temp/Book Chapter 2 - Feedback*.md`]. Headline: the judgment is unchanged; the prose is tighter.
35. **Automate the machinery, not the judgment.** Statement slide closing Part 2. The five checks recapped in one row: infrastructure, deterministic, grounded, blind spot, supervision.

### Part 3. One project, start to finish (divider)

36. **The timeline.** One horizontal timeline, October 2025 to September 2026, stages coloured by mode: grant and ethics (2025), design and pre-analysis plan (March to June), instrument (March to August), pre-registration deposited 10 August, fielding 5 to 31 August, analysis snapshot 31 August, writing on Overleaf, APSA talk 4 September. Each stage carries one word for what the machine did and one for what stayed human.
37. **What stayed human, in the project's own rules.** Three rules verbatim: *Confirmatory analysis is blind to the hypothesized sign* [`notes/agentic-analysis-integrity.md`]; *Never push to Overleaf without the PI's say-so* [`.claude/skills/finished/SKILL.md`]; *Do not change a paper's confirmatory hypothesis structure without discussion* [`CLAUDE.md`].
38. **Every number resolves to one snapshot.** The `numbers.tex` header in a code box: GENERATED FILE, DO NOT EDIT; snapshot of record 2026-08-31T1349Z; keys defined 2,018. Under it: the verdict guard, 0 of 107 guarded keys moved in Paper 2 [`HANDOFF.md` 2026-08-31].
39. **Disclosure.** The published AI-use statement from `main.tex`, verbatim, ending *takes full responsibility for the content of this manuscript.*
40. **What it took.** 447 commits, 80 handoff entries, 54 session logs, one paper at 11,772 words against a 10,000 ceiling [`HANDOFF.md` 2026-09-15]. One line: the machinery was automated; the paper is still being written.

### Close

41. **For students, for professors.** Two columns, three verbs each. Students: automate the clerical; protect reading, first ideas, and procedures still being learned; collaborate only where you can check the output. Professors: automate more of your own machinery and leave a trace; protect the formation of your students' judgment; collaborate where the machine changes what is feasible.
42. **The governing sentence**, alone, large.
43. **Resources.** Open Science Skills, AI for Research, the deck URL with a QR code.

### Appendix

A1. Kenny's four working modes on complexity and verifiability, credited to Kenny 2026 adapting Swaney 2026, for the discussion. A2. The deliverable pipeline in eight steps, from `pipeline.svg`. A3. The doc-to-markdown routing table. A4. The pre-submission review method line: nine dimension agents, two cross-checkers, zero hallucinated quotes, eight inference errors dropped [`design/p2_presubmit_review_2026-08-30.md`]. A5. References.

## Build

### Files

```
ai-for-research/lectures/2026-09-korea-university-rethinking-the-research-process/
  overleaf/                    git submodule → https://git@git.overleaf.com/6aaa697efc7ddb608ab4c4d1
    main.tex                   the deck; one \input per part
    preamble.tex               the Chalk and Mulberry system from planning/palette-options/option-a-chalk-mulberry.tex
    parts/00-open.tex … 04-close.tex, 05-appendix.tex
    figures/                   pipeline.pdf (converted from open-science-skills pipeline.svg), qr.pdf
    references.bib             the works cited on slides
  notes.md                     speaker notes, one section per slide, cumulative timings, guardrails block
  deliverable.yml              updated: build command, sources of truth, citations check on the .tex
  planning/                    unchanged, plus 02-slide-plan.md holding this slide list
docs/lectures/rethinking-the-research-process/
  index.html                   replaced by a short page that embeds and links slides.pdf
  slides.pdf                   the compiled deck
```

The Overleaf repository is a submodule, following the house rule that the manifest and wiki live in the parent beside the submodule, never inside it (the NWO papers use the same layout).

### Beamer mechanics

- Preamble is Codex's Option A as delivered: Beamer `default`, Noto Sans and Noto Sans CJK KR via fontspec and xeCJK, ten named colours, `\srcbox`, `\Pass \Partial \Fail`, the `code` verbatim environment, `pipeline node` TikZ style, light-tinted section dividers, `\statement{}`. Add three macros: `\beforeafter{}{}` (two-column pair with a rule between), `\terminal` (the code environment with a muted prompt colour), and a `\modecolor` set for the timeline (three tints derived from Structure, Emphasis, and Muted so the palette stays at ten colours).
- Korean: the three glosses on slide 7 and the series line on slide 1. Nowhere else.
- No overlays or `\pause`. The three builds from the last deck are gone; a diagram is shown whole.
- Every frame with a code box is `[fragile]`.
- Speaker notes live in `notes.md`, not in `\note{}`.

### Fonts

Overleaf ships Noto. Locally, install `font-noto-sans`, `font-noto-serif`, `font-noto-sans-mono`, and `font-noto-sans-cjk-kr` through Homebrew so local QA builds match; fall back to the substitution used in the palette test if the casks are unavailable.

### Execution routing (Fable lead)

- Me: the slide text in `main.tex` and the part files, `notes.md`, the guardrails, integration, the final read against the wiki.
- fast-worker (Sonnet): split Option A into `preamble.tex`, the three new macros, the TikZ timeline and the two-row pipeline diagram from my node lists, `pipeline.svg` to PDF, the QR code, the Homebrew font install, the site page swap.
- Codex, blind, at the end: the same review contract as last time, run on `main.tex` and `notes.md` against the guardrails list. Reconciled by me; findings applied by me.
- Nothing is pushed to Overleaf or GitHub without the author's say-so.

### Order of work

1. Clone the Overleaf repository as a submodule; read whatever it already holds before writing.
2. `preamble.tex` and an empty `main.tex` that compiles.
3. Parts 0 and 1, compile, render every page to PNG, look at each.
4. Part 2, one unit at a time, same loop.
5. Parts 3 and close, appendix.
6. `notes.md` with timings and the guardrails block.
7. Codex review; fixes; final render and a 720p compression check on the densest slides.
8. `deliverable.yml`, gate run, site page, commit on the existing branch. Ask before any push.

## Guardrails: numbers and their sources

Use these figures and cite these files. Where two records disagree, the choice is fixed here.

- Grant: 406.XS.25.01.065, Open Competition XS 2025 round 1, €50,000, 2025-10-01 to 2026-09-30 [`README.md`].
- Samples: DE 2,502, KR 2,500, SG 2,500, US 2,498, pooled 10,000, snapshot 2026-08-31T1349Z [`papers/2-legitimacy-policy-process/README.md`]. The root README's 2,458 for the US is superseded.
- Knowledge base: 119 Markdown files, of which 103 conversions and 15 notes plus one index; 103 originals; 126 master bib entries, measured 2026-09-16. `CLAUDE.md`'s 114 is stale. Growth 59 → 72 (2026-06-30) → 119.
- June pass: 37 works checked, all exist, 8 metadata fixes, 13 open-access sources acquired per the sentence in `sources/inventory.md` (the list names 14; say 13 and cite the sentence).
- August pass: nineteen corrections per `notes/OVERVIEW.md`; `TODO.md` says seventeen. Say nineteen, cite OVERVIEW.
- Paper 2: 82 cited keys, 83 bib entries (Ogura is bib-only for the gate), 11,772 words against 10,000, main 40 pp [`HANDOFF.md` 2026-09-15].
- Gate: 147 table values, 3 citation FAILs, 4 prose WARNs, exit 1 [`checks/2026-09-09/fast.json`].
- Verdict guard: 0 of 107 Paper 2 keys moved [`HANDOFF.md` 2026-08-31]. Do not mention Paper 3's moving key.
- Dictation: 662 dictations, 54,796 words, one month, across two machines, about $8.
- Feedback letter: 596 → 484 words whole letter; 105 → 68 for the shown paragraph.
- Kenny 2026 verified; Swaney's four modes attributed via Kenny; ALARM guidelines never quoted.
- Off the slides by decision: the 2026-09-15 pretest and registration matter; the hardcoded-paths, fabricated-numbers-PDF, and live-token incidents; any student material; the unverified accent-normaliser inference about why Aviña later verified.

## Verification

1. `latexmk -xelatex` compiles clean on Overleaf with the real Noto fonts and locally with the installed casks; zero overfull warnings on content frames.
2. Every page rendered with `pdftoppm` and inspected: one artifact per slide, no text below 11 pt, no slide with more than one idea.
3. The densest slides (23, 27, 38) downscaled to 1280×720 JPEG at quality 55 and reread.
4. Every number on a slide appears in the guardrails block of `notes.md` with its file.
5. Codex blind review returns findings; each is applied or recorded as declined with a reason.
6. `check_deliverable.py --root .` passes on the updated manifest.
7. Timings in `notes.md` sum to at most 60:00.
8. The site page opens `slides.pdf`; the QR resolves to it once pushed.
