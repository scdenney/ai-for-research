# Talk design: framework, structure, and build

Working document for the Korea University lecture, 18 September 2026. Written 2026-09-16 from a
design conversation that replaced the first attempt. Everything below is the state of the argument
and the plan. The first deck (self-contained HTML, 35 slides) is superseded and stays committed on
branch `korea-university-lecture` for reference only.

## Occasion

Korea University, *AI Literacy for Social Scientists* special lecture series, lecture 01.
"Rethinking the Research Process: How AI Is Changing Research for Students and Professors."
Friday 18 September 2026, 1:30 to 3:30 PM KST, online via Zoom, open to all. Moderator: Sung Eun
Kim. Hosts: Office of Graduate School, BK21 FOUR Sociology Research and Education Program,
Department of Political Science and International Relations, and the SDGs research group on AI
and social inequality. The slot is two hours. **Up to an hour of talk**, then moderated
discussion. Audience is graduate students and faculty, much of it not native English, watching
over a compressed video stream.

## What the talk is about

The research pipeline, as we teach it and as we do it, and where AI fits into it.

Idea and ideation, sources, data, analysis, writing, citation, truth claims.

## The framework (settled)

### Three modes of AI engagement

**1. Automation.** Work we are comfortable delegating extensively to machines.

**2. Protected practice.** Work we deliberately keep substantially AI-free, because doing the work
itself develops or demonstrates knowledge, skill, or judgment.

**3. Collaboration.** Work in which human judgment and machine capability are deliberately
combined.

On the slide, three panels: **AUTOMATE · PROTECT · COLLABORATE**, with a second line of what each
does and a third of what it is for.

| Automate | Protect | Collaborate |
|---|---|---|
| Hand off the work | Preserve the cognitive work | Combine human and machine |
| Efficiency is the goal | Learning and judgment are the goal | Reach is the goal |

The governing sentence, underneath:

> **The question is not whether AI can do a task, but what role human cognition should play in
> doing it.**

Naming decisions and why:

- **Plain labels, no metaphor.** Assembly line, sandbox, workbench, apprenticeship were all tried
  and dropped. The metaphors make a serious distinction feel gimmicky, and they translate badly
  for a non-native audience over Zoom.
- **"Automate", not "delegate".** Delegation transfers responsibility, and the argument is that
  responsibility never transfers.
- **"Protect", not "sandbox".** Sandboxing is the method, protection is the principle. Sandbox
  stays available as a conversational word, but it does not carry conceptual weight.
- **"Collaborate", not "augmentation".** Augmentation is one form of collaboration. The category
  has to cover retrieval, checking, corpus construction, supervision, coding, analysis, and
  visualization.
- **No arrow between the three.** An arrow reads as sequence or as a maturity model where
  collaboration is the advanced setting. Three panels or middle dots.

## Why research is the hard case (the mechanism)

This is the intellectual core, and it follows Kenny's software-versus-research contrast but goes
one step further.

Agentic AI was built for software development, and software comes with a free correctness check.
Code runs or it fails. The compiler and the test suite answer instantly, at no cost, without
domain expertise. That is why an agent can work unsupervised there: it can check itself in a loop.

A research claim has no compiler. Nothing errors. The mistake surfaces at peer review, in someone
else's citation of you, or never.

Three consequences, each of which runs through the pipeline:

1. **Errors are silent and they compound.** Bad transcription becomes a bad count, becomes a
   claim, becomes someone else's citation of your claim.
2. **Checking often requires the capability you were handing over.** You cannot tell whether a
   summary of Brubaker is right unless you have read Brubaker.
3. **The inputs are not in the training data, and should not be.** Your archive, your unpublished
   data, a 1956 textbook.

This gives the three modes a mechanism rather than a preference:

- **Automate** where a wrong answer is cheap or obvious.
- **Protect** where the only way to check is to have the skill yourself.
- **Collaborate** where you can *build* the check.

That last line is the through-line for Part 2. Every skill demonstrated is an attempt to
manufacture the correctness check that research never had.

## Teaching and research

Both are in scope, and the distinction does not bite evenly across the three modes.

- **Automate is the same in both.** Formatting a feedback letter and formatting a manuscript are
  one problem. No split needed.
- **Protect is where it matters, and the difference is who bears the cost.** In research you
  protect your own skill formation, so you can waive it and you know what you gave up. In teaching
  you protect a student's formation and you cannot waive it on their behalf. The student has an
  interest and no vote. A preference becomes an obligation. This also explains "develops or
  demonstrates": development is the research side, demonstration is the teaching side, which is
  where assessment sits.
- **Collaborate splits by what is gained.** In research, reach. In teaching, the supervision
  workflow, where the judgment stays human and the machinery around it is automated.

Two notes for delivery. Many in the room are both, since graduate students teach, so the same
person sits on both sides of one decision. And the evidence is research-heavy, so teaching appears
inside each mode rather than as a second half that runs thin.

The same pipeline stage can sit in different modes depending on who is standing at it. For a
student, the stages are learning objectives, so they sit in Protect. For a working researcher, the
same stages are production steps, so they sit in Collaborate. Reading is the clearest case. This
qualification belongs directly under the framework table, not in the conclusion, or the audience
spends the middle of the talk generating counterexamples.

## Time budget

An hour of talk. Part 1 situates, Part 2 is the weight of the talk, Part 3 is lighter.

| Block | Minutes |
|---|---|
| Open and self-introduction | 4 |
| Part 1, situating plus the three modes | 14 |
| Part 2, skills as controls | 30 |
| Part 3, NWO start to finish | 9 |
| Close | 3 |

That is roughly fifty slides at academic pace, so the Part 2 production style has to be settled
early or it will not get built.

**No recordings in the deck.** It is a static PDF over a compressed stream, so every
demonstration is rendered output, a listing, a screenshot, or a before-and-after pair.

**Korean on slides, sparingly.** Glosses on the framework slide and section dividers only, not
throughout. Proposed: AUTOMATE 자동화, PROTECT 보호, COLLABORATE 협업, with 보호 to be confirmed
as the right sense for protected practice. Verbatim Korean from source material is separate and
appears wherever the material calls for it.

## Structure

From the handwritten outline, with the decisions above folded in.

### Intro
Myself. The structure of the talk. The three modes as a way of thinking about AI in research, for
students and faculty alike.

### Part 1: the three modes

**Mode 1. Aggressively and shamelessly automate. Cognitive offloading is good.**
Planning and management. Categorizing email. Tracking research. Chores and admin.
Keep the register of the note: this is a confident claim, not a hedge.

**Mode 2. Protect. Little to no AI.**
Grading, maybe all of it. Final manuscripts. Most teaching. Reading. Seed ideas.
Confidence is not uniform and the notes record it: reading carries three exclamation marks,
writing and seed ideas carry question marks. Consider presenting the uncertain ones as open
questions to the room rather than as assertions. "Final manuscripts" is a sharper line than
"some writing" and should survive.

**Mode 3. Machine collaboration.**
Ideation and QA. Supervision. Then the common category: research scaffolding and knowledge bases,
bibliometrics and formatting, data collection, organization, analysis, and visualization.

### Part 2: skills as controls on the pipeline

Demonstrated and documented through the open-science-skills repository. The argument is that the
skills are not all the same kind of control, and the differences are the point.

| Skill | What kind of thing it is | Why it matters |
|---|---|---|
| `research-repo` | **Infrastructure, not a check.** Scaffolds the project around a source library and builds the knowledge base. | Without verbatim source text on disk, fact-check cannot run at all. The boring folder structure is load-bearing. |
| `citation-check` | **Deterministic check.** Crossref and OpenAlex resolve or they do not. | No model, no judgment, costs nothing, runs every time. The closest thing in the talk to a compiler. |
| `fact-check` | **Grounded check.** A model reads the file, not its memory. | Slower and costs money. Catches the different failure: the citation exists and the claim still does not match the source. |
| supervision | **Machine collaboration from the teaching side.** | READ, ANNOTATE, DICTATE, then structure, check, format, edit. Judgment stays human; the machinery around it is automated. |

**Held aside: `research-grill` and `research-wayfinder`.** They are upstream of any artifact, so
they are a different mechanism entirely (nothing exists yet to check; the control is being forced
to answer rather than skip). They are also the newest and least settled. Out of this talk.

**Held for later: text to data.** Idea, source, digitization, OCR, corpus, analysis. Marked "maybe
later" in the notes and treated that way here. The GEI textbook material and the OCR comparison
are not part of the current plan.

### Part 3: a recent example, start to finish

The NWO project. Ideation through writing and analysis, with the arrow running both ways.

**Open recommendation:** use NWO as the single running example for Part 2 as well as Part 3. Part 2
attaches a control to each pipeline stage; Part 3 runs the same project end to end. The audience
learns one project instead of three, and Part 3 has continuity rather than a cold start. Not yet
decided.

**The repository clears the preconditions.** Checked 2026-09-16 against the `fact-check`
pre-flight gate.

| | |
|---|---|
| `sources/md/` | 157 conversions |
| `sources/og/` | 103 originals |
| Master bibliography | `sources/references_master.bib`, 126 entries |
| Paper 2 bibliography | 83 entries, curated from the master by `tools/make_paper_bib.py` |
| Drop zone | empty, nothing unconverted |
| Crosswalk | `sources/inventory.md`, which the gate looks for by name |

An earlier sweep reported no top-level bibliography. That was wrong. The file exists under a
different name. Coverage sits well above the two-thirds threshold and the gate should run.

**Use paper 2, not paper 3.** Paper 3's bibliography is empty. Paper 2 is the most developed, and
it is the one that already went through the deliverable pipeline for APSA.

**There is a real audit on record**, which beats the synthetic example the previous deck used.
`sources/inventory.md` documents a June 2026 pass in which every cited work was web-verified,
zero fabrications were found, thirteen open-access sources were acquired and converted, and eight
bibliography metadata errors were corrected the same day. The APSA talk's own gate run separately
found three citations on slides that did not resolve in the manuscript bibliography.

## Build

- **Format: Beamer**, not the HTML deck system used for the first attempt.
- **Palette: Option A, Chalk and Mulberry.** Chosen 2026-09-16 from two Codex proposals, with the
  option of adjusting later. Cool grey-lilac page `#F7F7FA`, carbon ink `#24212B`, mulberry
  structure `#6B465F`, eucalyptus emphasis `#4D6256`, pine/bronze/cranberry verdicts, porcelain
  box fill, lilac-stone divider. Noto Sans throughout, English and Korean alike, Korean via xeCJK
  with the Noto CJK KR families. Beamer `default` theme, XeLaTeX, 16:9. Ten colors, one role each.
  Full preamble and a worked example frame: `palette-options/option-a-chalk-mulberry.tex`.
  Contrast: every text-on-background pair clears 4.5:1 measured from sRGB, though not measured
  through Zoom. Verified to compile with substitute fonts; needs one test build on Overleaf with
  the real Noto families.
  Two of Codex's decisions are open: it removed the dark standout slide in favour of a
  light-tinted divider, so the deck currently has no inverted slide, and mulberry is an unusual
  structural colour for an academic talk.
- **Home: Overleaf.** `git clone https://git@git.overleaf.com/6aaa697efc7ddb608ab4c4d1`
  The talk source lives there. Not yet cloned; nothing written to it.
- Existing house design references, for the look rather than the mechanism:
  `research/projects/gei_textbooks/talk/deck.tex` (Beamer, metropolis, xelatex, EB Garamond,
  warm palette) and `resources/deck-template/` (the HTML system, for its typography and its
  one-focal-object rule).

## What went wrong the first time

Recorded so it does not recur. The first deck was 35 slides of one repeated template: the same
box-and-arrow row on eight slides, an oxblood title bar on every slide, two images in the whole
deck, and demonstrations rendered as text cards. It read as a document set in slide format. It
also diverged from the handwritten plan in five ways: text-to-data was made half the talk when the
notes marked it "maybe later"; there was no start-to-finish project section; there was no
self-introduction; "aggressively and shamelessly automate" was softened into something bloodless;
and the Protect list matched none of the five items in the notes.
