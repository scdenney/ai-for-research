---
name: korea-university-talk-deck
description: The 18 Sept 2026 Korea University lecture deck (automate/protect/collaborate) built 2026-09-16 in ai-for-research/lectures/; where it lives, the design decisions, what remains (push, rehearsal, Substack)
metadata:
  type: project
---

**Deck (v2, Beamer, 2026-09-16 afternoon):** `resources/ai-for-research/lectures/2026-09-korea-university-rethinking-the-research-process/overleaf/` is a git submodule of Overleaf project `6aaa697efc7ddb608ab4c4d1` (`main.tex` + `preamble.tex` + `parts/00..05`), XeLaTeX, Noto fonts (installed locally via brew casks). 43 numbered slides + 3 dividers + 6 appendix pages. Notes with timings (end 57:00) and the guardrails block in `notes.md`. Published `docs/lectures/rethinking-the-research-process/slides.pdf` + index page. The rejected HTML deck sits in `_superseded/html-deck/`. Branch `korea-university-lecture`, committed in both repos, **nothing pushed** (Overleaf push and GitHub push only on the owner's say-so). The argument of record is `planning/01-framework-and-structure.md`; the build plan `~/.claude/plans/find-the-slides-on-inherited-honey.md`.

**Why v1 failed (owner's words):** "pretty terrible", "obnoxious and hard to understand tone (very claude-like)", one template repeated, text cards for demos, and it diverged from his handwritten outline. v2 rules: plain labels (Automate/Protect/Collaborate), no metaphor, one artifact per slide, real NWO evidence by name, only the gate blind spot as self-criticism.

**v3 (evening 2026-09-16, built by the Codex peer in herdr pane w46:p1, Claude advising):** Steven rejected v2's palette and structure too. v3 = 30 content slides + 3 dividers + 3 appendix (36 pages), Kenny-led serif hybrid (EB Garamond editorial influence), no Korean glosses; Part 1 Automate/Protect/Collaborate across research and teaching; Part 2 a sustained HOW: agent, project instructions, skills, research-repo intake, knowledge base vs Kenny/Karpathy LLM wiki, citation-check then fact-check, one supervision slide, one replication-package slide; Part 3 ONE NWO claim (Christenson & Kriner 2017, submodule commit 75366c6, before/after in front_matter.tex, labelled reconstructed). Storyboard `planning/02-rebuild-storyboard.md`; preview `planning/preview/design-preview.pdf`. **Overleaf main pushed (cc5198c); GitHub branch NOT pushed; site PDF still v2.** Process lesson: the first deliverable that worked was an outline plus five rendered sample slides, not a whole deck.

**Occasion:** Korea University "AI Literacy for Social Scientists" lecture 01, Fri 18 Sept 2026 1:30–3:30 PM KST, Zoom, moderator Sung Eun Kim. 45-min talk + discussion. Poster title on the cover; thesis line "Automate, Protect, Collaborate".

**Decisions (owner's):** three spaces = assembly line · **apprenticeship** (not "sandbox": AI audiences read it as containing the machine) · workbench; demos captured on slides, not live; deck system = house deck-template re-skinned to the Pixels-to-Patterns palette (cream/ink/oxblood/teal, sage-ochre-brick verdict marks only); assertion headlines, one focal object, no bullets, builds only on slides 18/24 (fragments), Zoom contrast floors. Kenny's 2×2 (slide 12, credited "Kenny 2026, adapting Swaney 2026") + our "gate before the grid" (slide 13). Slide 31 (students vs professors) delivers the poster title.

**Guardrails baked into notes.md:** no CER/WER (cross-model divergence Polish ≈2%, Korean ≈25%, preliminary); 438 volumes / 98,295 pages / 1948–2020 / 24 GB; bulk OCR not run; Gemma 4 E4B; textbook_kr 67 books 11,287,661 chars; dictation 662/54,796/$8; ALARM guidelines unverifiable (never quote); Swaney's four modes attributed via Kenny.

**Codex blind review (2026-09-16):** 52 findings; the real catches were the slide-25 hanja gloss (the June deck's Korean line added 檀君 the page does not print; now Claude Sonnet 4.6's verbatim P034 line), "accuracy" wording on slide 27, the 438-volumes-transcribed implication, and the unmarked switch to the separate 67-book corpus on slide 28. On the owner's instruction every remaining finding was then applied too (2026-09-16, commit 'Apply the rest'): slide 28 split into corpus (28) + finding (29), 35 slides total, timings end 42:45, labels cut to one line, end-year off the slides.

**Why:** first deck ever placed in `ai-for-research/lectures/` (earlier decks live on the personal site); the Substack post derives from `notes.md`.
**How to apply:** edit `content.md`/`charts.py`, rebuild, run `check_deliverable.py --root .` (passes 4/4), copy `index.html` to `docs/lectures/rethinking-the-research-process/`. Related: [[open-science-skills-repo]], [[orchestration-lab-demo-build]].

## 2026-09-16 evening: v4 (foundations + evidence), Codex peer
- Overleaf main 180d608 (from cc5198c): 40 pages = 32 main incl. cover + 3 dividers + 5 appendix. Seven foundation slides precede the three modes; Autor/Bastani plots (Autor juniors BIFURCATED, never "declined"; Bastani "without guardrails", Bassner qualifies); Melumad & Yun in appendix/notes; Chrome captures of OSS/Hub pages (provenance in overleaf/figures/browser-capture-provenance.md).
- Parent local commit 408b219 (planning/10-foundations-validation.md, HANDOFF.md). GitHub still NOT pushed; site slides.pdf still v2.
- planning/09-evidence-protect.md holds both literature batches (ddb02f3, a878607) incl. DO-NOT-CITE list.
- Next: Steven reviews on Overleaf; timed rehearsal; push GitHub + site PDF only on say-so.
