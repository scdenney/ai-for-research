# What Are We Thinking? (21 October 2026) — Handoff

Read by `/sitrep` (start of session) and updated by `/finished` (end of session).
Newest entry at the top; don't rewrite history — append.

---

## 2026-10-21 (mid-morning) · Second review round; survey rebuilt with general-audience items
_agent: claude (Fable 5.1 lead via /oss:orchestrate; one Opus thinker at high effort rebuilt the Qualtrics survey and the results pipeline)_

**Decisions (author):** every row table centered within its band; the check slide decluttered; "From an LLM wiki" split into Karpathy and a transition slide for my version; "Your answers" reduced to one line with no break announcement; "The conversation lags behind" → "We are behind"; humanities distinguished from STM on the frequency chart; a "Where the gains are" slide between "What collaboration means" and "Working together", ending with the expert fact checker and source manager; the QR slide reads "Anonymous survey" with the link (slides go on the website before the talk); the survey gains general-audience items and questions for the closing discussion.
**Decisions (agent):** colour rule for both survey charts and `results.py`: humanities deep blue `#255B79`, social sciences `#A84E2C`, STM and other fields light blue `#A9CEE1` with muted labels, "everyone" `#4F5F6C`. New `\ctxt`/`\crow` macros in `preamble.tex` (anchor=west at the band centre) replace top-anchored rows on every table slide. The demo background now states the topic, the four planted errors, and the agent's job, with "good for" moved to the footer.
**Completed, verified:** deck 42 PDF pages, `latexmk` exit 0, 0 overfull, render-review 0 flags; every changed page rendered and viewed. The survey link in the PDF resolves to `https://fra1.qualtrics.com/jfe/form/SV_e5lLvKqtLe04Yui` (read from the annotation). `notes.md`: new sections 20 and 27, every later page renumbered, header 42 pages, 39 numbered headings contiguous and each found on its PDF page by script; `demo-runsheet.md` pages 35–36.
**Survey (thinker, verified by re-fetching the live definition):** the author's Qualtrics edits were unpublished drafts from ~08:42: `field` → "What is your field of work?", a fifth `freq` option "I don't do academic research", a shorter `edit` stem, and one question per page. The first two were ported into the spec (the option also added to `edit`); the shorter `edit` stem was **not** applied because the item is borrowed from Nature verbatim, and the page breaks were not applied because the toolkit builds one page. New items: `use_general`, `use_for`, `agent` (before the research items) and `want_self`, `want_supervision` (at the end); intro says about three minutes. Pushed with `--push --update --validate` as version 6; 0 responses existed, nothing deleted; link unchanged; 15 entries match the spec. `published.yaml` has the STM, economics and computing series; `export-responses.py` knows the five new tags; `results.py` renders two new pages, excludes "not applicable" answers from the borrowed comparisons with a footnote, and uses the colour rule; rendered without error on synthetic, empty and a 50-row test file. Backups of the pre-push survey in `survey/_build/backup/`. `results-backup-empty.pdf` refreshed from the thinker's empty render.
**Findings:** Emulate is still out of words, so no new wording went through ai-rewrite. On the results writing page the `edit` comparison has eight rows and drops to minimum font size.
**Later the same morning:** author decided: no break; Emulate retried (50k words back): seven spans, two phrasings adopted ("Work we want to offload to AI"; "Collecting new types of data, with staff and students"), the rest kept because the candidates invented content or drifted register (review file in the session scratchpad). Notes, run sheet and survey README reworked for no break: the results command runs in the second terminal at page 37 while page 38 is up; discussion from about 15:57. Survey intro text changed to "at the end of the seminar" and pushed as version 7, same link, 15 entries. Deck committed and pushed to Overleaf at `441f88d` (7 files, 192+/176−), remote head verified.
**Third round (after the push):** United States bar added to page 5 (24%, n = 933, same microdata and method; Netherlands reproduced first). Footer numbers now equal PDF pages, dividers included (`\insertframenumber` in `\foot` and `\dividertext`). Titles: "Willingly offload", "What we're protecting", "Offloading hurts durable learning", "Practicing with AI and taking an exam without it", "Experts are in a position to gain", "Working with the machine", "Working together to verify" with "What the agents do", "Asking a chatbot / Using ChatGPT", "The next week, starting again", "The knowledge base idea" (four moves, callout "This serves as the basis of my agent-based work"), "How to manage your knowledge base". "Why collaborate" (19) replaces "What collaboration means" with three gains. The morning-brief row left "Examples" (its tasks folded into Email and Calendar). Karpathy (26) has two more sentences and an inline citation. The check (30) is two rows without quotes. The demo background names the draft ("Return and Re-entry") and its question. "Your answers" (37) asks "What do you think?" and "What did you answer?". Deck 42 pages, 0 overfull, 0 render flags, all changed pages viewed; notes headings match the PDF by script. **Pushed to Overleaf at `4dd3f2d`** (5 files, 56+/62−; remote head verified equal to local).
**Survey, author's decision ("fix survey, yes"):** both held-back edits applied with 0 responses on the server. `edit` stem is now "Have you ever written a draft of a research article, then used generative AI to help edit it?" (Nature's lead-in dropped; the comparison is marked indicative in notes.md page 5, the discussion plan, `planning/02-survey-evidence.md` and the spec header). The spec is one block per page: page 1 holds the intro and `role`, then one question per page (14 pages, 15 entries). `build-survey.py`'s one-block guard was relaxed to "at least one block, none empty". Pushed with `--push --update --validate`: 15 items in spec order, link unchanged. Previous spec saved as `_build/backup/leiden26_audience.v7.yaml`.
**Fourth round (after `4dd3f2d`):** slide 19 loses its callout, Quality and Reach in the author's words, columns lowered; slide 9 Collaborate reworded; Karpathy (26) as four rows (Emulate pass: two phrasings adopted, review file in the scratchpad); anatomy (28, "What it holds, and how a citation leads back") now precedes intake (29, "How a source gets in: five steps"), notes swapped. Models added to page 15 and the footers of 16–17 after an Opus thinker read each paper: Melumad & Yun Exp. 1 GPT-3.5-turbo vs real Google; Fernandes ChatGPT-4o (gpt-4o-2024-05-13); Bassner both AI arms on GPT-4 (Iris hint-first tutor, unrestricted ChatGPT); Shen & Tamkin GPT-4o (not Claude); Bastani GPT-4; Autor an unreleased Google Labs writing tool, model not stated (Gemini only as rater). Quotations and sources are in the evidence register and the scratchpad `models-check/`. Deck 42 pages, 0 overfull, 0 render flags, changed pages viewed. Fifth round (Karpathy label size, "How I assemble it", "Knowledge base scaffolding" with centered arrow labels, "How to incorporate a source in five steps", "Evaluating the question from before" with the claim and quotes restored, demo background before its divider and in plain words, dividers unnumbered, moderator's university on the cover). **Pushed to Overleaf at `02edab8`** (5 files, 70+/60−; remote head verified).
**Demo re-test (21 Oct, 11:43–11:48):** a headless run in `~/kb-demo-check` failed: intake left the SCAP scan as NEEDS OCR and asked how to proceed, so `/oss:fact-check` stopped at pre-flight (2 of 4 works, 50%). Fix: the intake line now reads `/process-source If a file is a scan with no text, transcribe it yourself into sources/md/ and note at the top that you did.` (run sheet and notes), with a spoken fallback if it still asks. Re-run in `~/kb-demo-check2` passed: intake 81 s with the transcription and its provenance note, fact-check 100 s, all four planted errors and the control as in the answer key, plus the uncited "largely stopped". `~/kb-demo` untouched.
**Survey v9 (21 Oct, 12:02):** back to one page (the author adds page breaks by hand; do not push the spec again after that, or the breaks are removed). `worry` reworded by the author to "I am worried that AI will weaken thinking, research, and writing skills." (Nature comparison now indicative). New `future` item after it with Gallup's two options verbatim (June 2025, N=2,017 US adults, 49% vs 49%); our stem "Which of these comes closer to your view?", since Gallup's page does not print its stem. `export-responses.py`, `results.py` (new page "What AI is") and `published.yaml` updated; rendered on 50 test rows (8 pages). Live: 16 items, 1 block, 0 responses, link unchanged.
**Web demo (21 Oct, ~12:15, author's decision):** the demo now runs from a click-through page, `docs/archive-check/index.html` (site commit `729c534`, pushed to GitHub `main`; Pages deploys from `/docs`). Nine steps replay the passing 11:45 run from `~/kb-demo-check2` with highlights and explainer cues; F presents, arrows step. Copyright: Kim 2021 CC BY quoted with attribution, SCAPIN scan public domain (`docs/assets/archive-check/scapin-1015.jpg`), Morris-Suzuki in short quotations only, Lee 2019 named only by its key and labelled invented. Linked from the Demos index and the knowledge-base page. Checked at 1440×900 and 390×844 (no overflow, no console errors). Deck: the demo divider (36) shows the URL and Resources (38) lists it first; pushed to Overleaf at `e1cc875`. Run sheet and notes: web page primary, live terminal backup.
**Web demo v2 (21 Oct, ~12:55, site commit `f2ac733`):** the scan is now read by local OCR, not by the agent. `~/kb-demo-ocr/` holds the run: intake from the 11:43 run (scan left as NEEDS OCR), then `scripts/ocr-scan.sh` (GLM-OCR via the Ollama API, 13 s; the CLI `ollama run` hangs on images when not interactive) and Tesseract 5.5 on the image extracted with `pdfimages` (1 s; it reads nothing from `/tmp` in this shell), then `/oss:fact-check` on the GLM-OCR text (203 s): all four planted errors caught, control supported, "largely stopped" contradicted. Tesseract garbles the words under the X; GLM-OCR reads the body cleanly but drops the header, date and pencil note and reads AGD as AGC; the filed md says so. Page steps 4, 5, 7, 8 and 9 rebuilt from these files, so every verdict shown comes from the text shown. Explainers rewritten (sci-edit deslop, public register; label-period openers removed); Emulate pass checked line by line, two phrasings adopted, rest rejected for invented content. Verified at 1440x900: 35 cues, page never scrolls, no console errors. Run sheet and notes updated.
**Web demo v3 (21 Oct, ~13:15):** author's text edits applied verbatim to steps 1–4, 7 and 9 ("rests on" changed to "based the verdict on" under R28). Tesseract dropped. New run in `~/kb-demo-ocr2/`: raw GLM-OCR text filed with a neutral provenance line; the agent then checked it against the scan (91 s, nine corrections, body text matched word for word) and the claim check ran on the corrected file (206 s): Morris-Suzuki and Kim contradicted, SCAPIN unsupported, Lee likely fabricated, cholera supported, "largely stopped" contradicted; the agent states its corrections were outside the body text. NDL record confirms the rescission. Steps 5–8 and the summary rebuilt from these files.
**Site and deck (21 Oct, ~13:30):** the Demos card for the archive-check demo rewritten in plain prose; the reference-check card hidden (commented out) and its links from Getting started, the knowledge-base page and the walkthrough repointed to the archive-check demo (`de85a72`). The deck is published at `docs/lectures/what-are-we-thinking/` (viewer page plus `slides.pdf`, 42 pages) with a card at the top of the Lectures page (`21512cd`). Slide 2 now gives that address under the survey link, both clickable; pushed to Overleaf at `c9242a9`. If the deck changes again, copy `slides/main.pdf` to `docs/lectures/what-are-we-thinking/slides.pdf` and push.
**Not done / for the author:** phone test of the survey (now one question per page, so check the Next button and Back on mobile); read-aloud of the notes; the lecture folder is still untracked in the parent repo.

---

## 2026-10-21 (late morning) · Author's review notes applied across the deck
_agent: claude (Fable 5.1 lead via /oss:orchestrate; one Opus thinker recomputed the survey figures)_

**Decisions (author, from dictated notes):** centered cover without the seminar kicker or the question line; roadmap item 4 is "Discussion"; more disciplines on the two survey pages; a fifth term (CLI, the "terminal") and a plainer agent definition; the three modes redefined (offload / protect durable learning and core skills / productivity, quality, reach); "What we guard" names the development of core skills; plainer findings on page 15; a new "What collaboration means" page before "Working together", whose columns read "What the agent does" and "What we do"; the knowledge-base divider subtitle "How agents work with my research projects"; `manuscript/main.tex` on the library page; "Your answers" points to the results report instead of restating the questions.
**Decisions (agent):** Fernandes reads "They thought they had done better than they had", not "overestimated their learning gains", because the study measures self-estimated score against actual score. Page 16 drops the line "High-school mathematics in Turkey" (read as "don't describe what it is there"); page 17 keeps its line because the notes did not mention it. The page 28 verdict stamp is straightened and moved inside the window, which I read as the "what's going on there" complaint. Git wording on page 30 corrected to "Git records each change I commit."
**Completed, verified:** deck 40 PDF pages, `latexmk -xelatex` exit 0, 0 overfull, render-review 0 flags (the two long-standing diagonal flags on the check page are gone). Every changed page rendered and viewed: 1, 4, 5, 7, 9, 11, 14, 15, 16, 19, 20, 24–28, 30, 35. Survey additions: OUP STM 35/32/19/15 (checked against PDF p. 16; OUP publishes only three discipline groups) and Nature economics 40% (n = 149), computing 37% (n = 411), recomputed from the microdata by the deck's existing method, which reproduced every figure already on the slide; script in the session scratchpad. `notes.md` rewritten for every changed page, new section 19, every later page renumbered (+1), header says 40 pages, Likely-questions item 7 corrected (real sources). `demo-runsheet.md` now says pages 33–34. A script confirmed each notes heading 1–40 appears on its PDF page.
**Findings:** Emulate returned `HTTP 402 out_of_words` (187 words left), so none of today's new wording went through ai-rewrite; the batch is saved in the session scratchpad for a rerun. `survey/published.yaml` still shows only A&H and social sciences for frequency, and no economics or computing, so `results.pdf` will not match pages 4–5 unless it is updated.
**Not done:** nothing committed or pushed since `b2d4a75`; the lecture folder is still untracked in the parent repo; phone test of the survey; read-aloud of the notes.
**Next actions:** author reviews the rendered deck, then commit `slides/parts/*.tex` and push to Overleaf; optionally add the new series to `survey/published.yaml` before the break.

---

## 2026-10-21 (morning) · Interactive demo run reviewed; background slide before the demo
_agent: claude (Opus 5.5)_

**Decisions (author):** before switching to the terminal, one plain slide says what is set up, what the sources are, what the task is, and what research it suits. Its wording goes through ai-rewrite (Emulate).
**Completed, verified:**
- The interactive demo run (session kb-demo-b4) worked as designed. I checked it against `demo/real/ANSWER-KEY.md`: all four planted errors were caught, the control held, and the extra "largely stopped" claim was flagged. Nothing was over-called. The file names match the rehearsal, the Kim Markdown is byte-identical to `~/kb-demo-done`, and the manuscript was unchanged. I read the SCAPIN transcription line by line against the scan and it matches. The run's timings were not reported.
- `~/kb-demo` was reset from `~/kb-demo-pristine.tgz`. Afterwards `sources/md`, `og` and `unprocessed` are empty, `references.bib` has only its header, and `.venv` Python 3.14.3 runs.
- New PDF page 33, "What you are about to see", in `slides/parts/04-close.tex`, right after the demo divider. Emulate's candidate reversed who does the task and misread "sources you can hold", so the final text was repaired against the original. The review file is in the session scratchpad, not the repo. `latexmk -xelatex` exits 0, there are 0 overfull boxes and render-review reports 0 overlaps. The deck is now 39 pages, and page 33 was rendered and viewed.
- `notes.md`: new section for page 33 (44:30–45:30), the terminal demo set to 45:30–52:30, and every later page reference moved up by one (Your answers 34, Resources 35, appendix 36, references 37–39). `demo-runsheet.md` now says pages 32–33, and its opening line points to page 33.

**Findings:**
- `notes.md:258` (Likely questions, item 7) still says the demo "runs the practice files from the walk-through". It runs the real sources. Not fixed.
- In `~/kb-demo`, `manuscript/README.md` says the draft cites `../sources/references.bib`, but it uses `manuscript/references.bib` with different keys. The agent noticed this live. To remove it, the README inside `~/kb-demo-pristine.tgz` also has to change. Not fixed.

**Pushed:** page 33 committed and pushed to Overleaf at `b2d4a75` (remote head verified equal to local).
**Not done:** the lecture folder is still untracked in the parent repo. There has been no phone test of the survey and no read-aloud of the notes.

**Next actions:**
- Quit the kb-demo-b4 session and start a fresh `cd ~/kb-demo && claude` for the talk.
- Phone-test the survey and delete the test responses.
- After the talk, fix `notes.md:258`, register `slides/` as a submodule and commit the lecture folder.

---

## 2026-10-20 (night) · Live demo rebuilt on real sources and rehearsed
_agent: claude (Opus 5.5)_

**Decisions (author):** the live demo (page 32) files sources and then runs a claim check, so it shows what pages 20–31 promise; the content is archival history for a LIAS room, on real sources ("you can get the sources!"), with the draft citing them written for the demo and its errors planted.
**Completed, verified:**
- Deck: further review passes pushed to Overleaf, `19a8044`, `2c8f144`, `1afbace` (morning brief simplified). The deck is 38 pages, and `notes.md` follows it.
- `demo/real/` contains three real sources in `inbox/`, `manuscript/` (draft and bibliography), and `ANSWER-KEY.md` (exact passage for each planted problem). The sources:
  - Kim Jeong-ran 2021, in Korean, CC BY, from Europe PMC
  - Morris-Suzuki 2011, *APJ: Japan Focus*, from Cambridge
  - a scan of SCAPIN 1015, 12 June 1946, NDL, public domain
- Planted problems: a reversed claim, a scope-changing mistranslation of 그들 중 약 80%, an unsupported claim about SCAPIN 1015, a fabricated `lee2019` (DOI 404 at Crossref), and one correct claim as a control.
- `demo/real/.gitignore` keeps the downloaded PDFs out of git.
- Clean headless rehearsal: intake 1:33, `/oss:fact-check` 1:41, all five caught. It also flagged the uncited "movement largely stopped" against Kim's July 1946 arrest figures.
- `demo-runsheet.md`: a minute-by-minute plan for the 8 minutes, plus the checklist for before 15:00. The page-32 notes and the setup paragraph in `notes.md` point to it.
- On-disk demo folders:
  - `~/kb-demo`: scaffolded live folder, draft in `manuscript/`, ligature step patched
  - `~/kb-demo-inbox`: the three PDFs
  - `~/kb-demo-done`: the clean rehearsal, with `intake.log` and `factcheck.log`
  - `~/kb-demo-pristine.tgz`: reset copy of `~/kb-demo`
  - fallbacks: `~/kb-demo-done-synthetic` (invented-archive version, `demo/synthetic/`) and `~/kb-demo-done-turnout` (original practice files)

**Findings:**
- The `research-repo` skill template (open-science-skills 2.37.0, `SKILL.md:271`) writes `sed -i''`. On macOS this leaves a `*.md-e` backup beside every converted file. Fixed only in `~/kb-demo`. The upstream fix is still open.
- The skill rewrites the script on each run, so two scaffolds differed. Go live only in the rehearsed folder.
- A comment in the draft's bibliography that named the fabricated entry was read by the agent. It was removed and the demo re-rehearsed. Keep `ANSWER-KEY.md` out of `~/kb-demo`.
- The SCAPIN text in the library is the agent's transcription of the image. Its header says to verify it against the scan.

**Not done:**
- No interactive (non-headless) run of the demo.
- No phone test of the survey.
- The author has not read the run sheet or notes aloud.
- The lecture folder is still uncommitted.
- `slides/` shows untracked `.gitignore` and `figures/video-poster.png`. Neither was touched this session.

**Next actions:**
- Tomorrow before 15:00, follow the checklist in `demo-runsheet.md`, and do one interactive run in `~/kb-demo`.
- Reset with `rm -rf ~/kb-demo && tar -xzf ~/kb-demo-pristine.tgz -C ~`.
- At the break, the commands are unchanged.

---

## 2026-10-20 (late) · Framework reworked, evidence back, demo as editable slides
_agent: claude (Opus 5.5)_

**Decisions (author):** no video in the talk; the demo is native slides he narrates; Automate is his real workflow (email triage, morning brief, standby calendar agent); Guard is writing and critical thinking with durable learning as the goal, backed by the Autor and Bastani figures and other studies; Collaborate states who decides and who checks.
**Completed, verified:** deck 42 pages (37 main), compiled clean, render-review 0 flags; pushed to Overleaf `9097fe7`. Demo wording all in `slides/parts/03-demo.tex` (TikZ components `\window`, `\mebubble`, `\botbubble`, `\tagbox`, `\stepbox` in `preamble.tex`). Autor and Bastani figures regenerated in the poster palette by `slides/figures/build-evidence-plots.py`. "It feels like learning" numbers checked at source (Fernandes 2026, Bassner 2026, Melumad & Yun 2025 Exp. 1, Shen & Tamkin 2026 as "17% lower"); Bassner and Fernandes quotes came from university summary pages, the publisher pages did not load. Citation-check slide uses the synthetic `demos/reference-check` project. `notes.md` rewritten to the new map (1–6 = 10:00, 7–37 = 45:00, demo 14:00).
**Superseded:** the video slide and the PNG stills; `video/` and `visual/` remain in the repo as Q&A backups only.
**Next actions:** read the notes and click through once aloud; phone-test the survey; optionally `/oss:beamer` review.

---

## 2026-10-20 (evening) · Simplified deck; video replaces the live demo
_agent: claude (Opus 5.5 lead; Opus units for the video and the notes)_

**Decisions (author):** a narrated video replaces the live terminal demo; Steven records the voice from a script tonight; hard cut to roughly 40 words per slide.
**Completed, verified:** deck now 31 pages (27 main), layout grid and column/row/callout/divider macros in `preamble.tex`, kicker word spacing fixed, 0 overfull and 0 render-review flags, contact sheet read; pushed to Overleaf at `bb65443`. `video/`: `scenes.html` + `render.mjs` + `build.sh` produce `kb-demo.mp4` (3:06 with placeholder `say` voice, 1920×1080, −16 LUFS); eight scene frames checked; `script.md` (440 words) with recording steps; poster on slide 22. `notes.md` rewritten to the new page map (1–6 = 10:00, 7–27 = 45:00 with the video).
**Not done:** Steven's voice clips; `/oss:beamer` review (reserved for the author to invoke); phone test of the survey; reading the notes.
**Next actions:** record `video/audio/scene01.m4a` … `scene08.m4a` from `video/script.md`, then `bash video/build.sh` and watch `video/kb-demo.mp4`. Optionally run `/oss:beamer` on the deck. Tomorrow: QuickTime fullscreen at slide 22; break commands unchanged.

---

## 2026-10-20 · Rebuilt for Leiden: deck, survey, visual, notes
_agent: claude (Fable lead, /oss:orchestrate; five Opus units for survey build, results renderer, visual, Nature recompute, supervision copy, notes)_

**Decisions (author):** slot split 10 + 45 + rest (survey and published picture; talk with the live demo; break; discussion). Audience survey in Qualtrics through the API, built with the ba3tad opener toolkit and the hdw26 credentials. "Lean" cut of the Korea material: one learning-evidence table and the own-manuscript claim check in two pages. Live demo with a screenshot fallback. The knowledge-base visual is a separate browser page.
**Decisions (agent):** poster palette with the orange darkened to `#A84E2C` for text (orange itself is 3.6:1 on paper); "Protect" → "Guard"; the Kenny agent-supervision slides cut because "supervision" now means students; survey items keep the published wording verbatim so the room can be compared.

**Completed, verified:** `slides/` rebuilt: 35 PDF pages (31 main, appendix divider, three reference pages), `xelatex` exit 0, 0 overfull boxes, `scripts/render-review.py` 0 overlaps/bounds/diagonals, 18 pages viewed as PNG. New `parts/01-surveys.tex` (published figures) and `parts/05-demo-fallback.tex` (appears once `figures/demo/*.png` exist); kicker macros and contrast table in `preamble.tex`; `survey-link.tex`. Survey live: `SV_e5lLvKqtLe04Yui`, anonymous, 10 elements, QR on page 2; dry run with one real anonymous submission exported (`DistributionChannel = anonymous`, UTC dates handled), rendered with n = 1, deleted through the API, re-export 0. `survey/results.py` renders 0/1/3/50 rows; `published.yaml` carries the recomputed Nature figures. `visual/knowledge-base.html` checked at 1920×1080 and 1440×900. `notes.md` rewritten (pages 1–5 = 10:00, pages 6–31 = 45:00, demo 9:00). `planning/02-survey-evidence.md`; `deliverable.yml` done/status; README; hygiene check PASS (credentials, manifest, prose tells). **Overleaf:** `slides/` is now the working tree of the Overleaf project `https://www.overleaf.com/project/6ad774de8e56718e506f28a5` (Git remote `origin`, branch `main`); the deck was pushed at `c7f85ab`, replacing Overleaf's stub `main.tex`; remote head verified equal to local. Build output and the unused Korea figures are excluded locally in `slides/.git/info/exclude`. The QR now lives at `slides/figures/qr-audience.png` (copied from `survey/`), and the kicker font falls back from Arial to TeX Gyre Heros. Not yet done on Overleaf: set the compiler to XeLaTeX in the project menu and check the first compile; register `slides/` as a submodule of the parent repository when the lecture folder is committed.

**Findings:** the research agent's Nature 2025 subgroup figures were 1 point off for overall (29, not 28) and humanities (25, not 26); slides and `published.yaml` use the recomputed values. Importing the ba3tad toolkit overwrote two `.pyc` files in `courses/ba3tad-26/instructor-workbench/surveys/__pycache__/` (untracked; no source changed); `_toolkit.py` now sets `dont_write_bytecode`. `scripts/render-review.py` now reads `slides/main.pdf`. Playwright's form filler cannot click Qualtrics radios (the label overlay intercepts), so the test response was blank but real.

**Unverified or not done:** no phone test of the survey (mobile rendering, eduroam); the demo is not rehearsed (`~/kb-demo` and `~/kb-demo-done` do not exist); `slides/figures/demo/` is empty, so the fallback pages are absent; the author has not read `notes.md`; nothing committed (the folder is untracked).

**Next actions:** tonight, in this order. (1) Demo: `mkdir -p ~/kb-demo && cd ~/kb-demo && claude`, then `/oss:research-repo .`; rehearse `demos/knowledge-base/prompts/run.md` steps 2–7 with a timer; screenshot each step into `slides/figures/demo/` using the six names in `parts/05-demo-fallback.tex`; copy the finished folder to `~/kb-demo-done`; recompile. (2) Survey: scan the QR from two phones and submit; `cd survey && python3 export-responses.py --since 2026-10-20T00:00:00+02:00`; delete the tests with `python3 export-responses.py --delete-before 2026-10-21T12:00:00+02:00 --confirm-survey-id SV_e5lLvKqtLe04Yui --execute`. (3) Open `visual/knowledge-base.html`, press F, step with →. (4) Read `notes.md`. Tomorrow at the break: `cd survey && python3 export-responses.py && python3 results.py && open results.pdf`. After the seminar: delete all responses as the notice promises, then `responses.json`. Commit when ready.

---

## 2026-10-20 · Sitrep only
_agent: claude_

**Completed:** Read-only status check. No files edited apart from this entry.

**Findings:** The copied deck has no Leiden edits yet. `slides/main.tex:4` still has the Korea title, `slides/parts/00-open.tex:5` still has the Korea venue and date, and the roadmap still says "research and teaching" and "protect" (the poster says "supervision" and "ruthlessly guard"). The inbox is empty and `deliverable.yml` has no `done` criterion. Nothing is committed.

**Next actions:** Same as the entry below. Settle the talk length and which sections to cut first, then make the title, venue and wording changes in the slides and `notes.md`, draft the supervision material, render the changed pages, and commit.

---

## 2026-10-20 · Opened from the Korea University lecture
_agent: claude_

**Decision:** Build the Leiden seminar as a new `kind: talk` deliverable that starts from the Korea University deck, rather than editing that deck in place.

**Completed:** Created this folder. Copied the Korea University Beamer source (Overleaf submodule at `57c6ef6`, which includes three reference commits made after the 18 September package at `7ef72a9`) into `slides/` without Git history or build files, and copied `notes.md` and `scripts/render-review.py`. Wrote the README, manifest, AGENTS.md, and `planning/01-update-brief.md`. The copied deck compiles locally to 50 PDF pages.

**Next actions:** Settle the talk length within the two-hour slot and what changes for supervision and an in-person Leiden audience (see the brief), then revise the deck and notes. Decide whether to link a new Overleaf project. Nothing committed.
