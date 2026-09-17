# Brief for the Codex session, 16 September 2026

You are the design and review peer on a lecture deck that Claude built today. You have full
permissions. Work directly in the files named below, compile as you go, and commit locally.
Do not push anywhere. Report back with what you changed and what you found.

## Where everything is

The talk lives in the AI for Research repository, not in the worktree you were started in.

```
/Users/scdenney/Documents/github/resources/ai-for-research/          branch: korea-university-lecture
  lectures/2026-09-korea-university-rethinking-the-research-process/
    overleaf/                Beamer deck, a git submodule of the Overleaf project (branch main)
      main.tex               inputs preamble.tex and parts/00-open.tex ... 05-appendix.tex
      preamble.tex           the design system: colours, fonts, macros, section dividers
      parts/*.tex            every word on the slides
      figures/qr.pdf
    notes.md                 speaker notes, one section per slide, timings, and an
                             "Accuracy guardrails" block: every number with its source file
    planning/01-framework-and-structure.md   the argument of record; read this first
    planning/08-open-questions.md
    planning/palette-options/                your two earlier palette proposals and codex-brief.md
    README.md
```

Build: `cd overleaf && latexmk -xelatex main.tex`. Fonts are Noto (installed locally through
Homebrew; Overleaf ships them). Render pages with `pdftoppm -r 80 -png main.pdf /tmp/p` and look
at them; do not judge layout from source alone.

Reference material you may read but must not edit:
- `/Users/scdenney/Documents/github/research/projects/gei_textbooks/talk/deck.tex`, the author's
  previous Beamer deck (metropolis, EB Garamond, a warm palette he liked the feel of).
- `~/Desktop/temp/2026-09-10-csdp-ai.pdf`, Christopher Kenny's deck, which the author called tidy.

## The occasion

Korea University, "AI Literacy for Social Scientists" lecture 01, Friday 18 September 2026,
1:30 to 3:30 PM KST, over Zoom. Up to an hour of talk, then discussion. Graduate students and
faculty in sociology and political science, many not native English speakers, watching a
compressed video stream. The argument is in `planning/01-framework-and-structure.md`: automate
work that gains nothing from your attention, protect work through which knowledge and judgment
form, collaborate where you can build the correctness check that research lacks. Part 2 shows
four controls on one real project (the NWO immigration study). Part 3 walks that project from
grant to conference talk.

## Task 1. Replace the colour palette

The deck currently uses your Option A, "Chalk and Mulberry" (grey-lilac page `#F7F7FA`,
mulberry structure `#6B465F`, eucalyptus emphasis `#4D6256`). The author chose it this morning
with the note "maybe adjust later" and, having now seen it on real slides, finds it ugly. Replace
it.

What was decided before and still holds:
- Soft, editorial, print-like. An academic talk, not a product launch.
- One role per colour. Roles: page, ink, muted text, structure, one emphasis colour, three
  verdict colours (pass, partial, fail), one box fill, one divider tint. Ten colours, no more.
- Zoom is the dominant constraint: no pale-on-pale, rules 0.9 pt or heavier, every text-on-
  background pair at or above 4.5:1 measured from sRGB.
- No dark background. No blue as the structural colour.
- The author's previous deck was a warm palette (cream `#FBF7EF`, ink `#2E2A26`, oxblood
  `#6E3B34`, teal `#2E5E5B`, sage `#4F7046`, brick `#A6442F`, ochre `#9C6B1A`, oatmeal
  `#EFE7D6`) and he liked its feel. He asked for something new, but "new" has now been tried
  and rejected. A warm direction that does not copy that palette is the likely answer. Grey and
  lilac are out.

Deliver: the new ten colours in `preamble.tex` with the contrast table in a comment, the mode
tints (`ModeAutomate`, `ModeProtect`, `ModeCollaborate`, derived from the named colours) still
distinguishable from each other on a table cell, and a recompiled deck. Keep the fonts.

## Task 2. Spacing and alignment

The author likes the slide size and the layouts. Spacing and alignment are off and some slides
carry too much. Render every page and fix, slide by slide, with these rules:
- One artifact per slide. Where a slide has an artifact plus a lede line plus a credit line and
  the three crowd the frame, cut the credit to the notes or shorten the lede.
- Consistent vertical rhythm: the same gap under every frame title, the same gap above every lede.
- Nothing touches the frame edge. Nothing wraps to a widowed word.
- Frame titles on one line. Retitle if needed; the meaning must survive.
- Tables: booktabs, no vertical rules, cells never wrap to three lines.
- Diagrams: node labels inside their boxes with breathing room.
- The letter comparison slide ("The same letter, a third shorter") is set very small on purpose,
  as a shape comparison; if you can fit it larger, do.
Do not change slide order, slide count, or any number. Do not add overlays.

## Task 3. Review the speaker notes

Read `notes.md` end to end against the slides and against `planning/01-framework-and-structure.md`.
Report, do not rewrite:
1. Every place the spoken text and the slide disagree.
2. Every number in the notes that is not in the guardrails block, and every guardrail entry
   without a source file.
3. Timing: the sections must be monotone and the total at or under 60:00; flag any slide whose
   allotted time is implausible for the words in its section.
4. Tone. The author wants plain, direct, first-person speech, short sentences, no hedging, no
   metaphor, no em dashes, no semicolons, nothing that sounds generated. Quote every line you would
   cut or change, with the change.
5. Anything a non-native academic audience would find hard to follow when spoken.
6. The three or four questions the discussion is most likely to open with, and whether the notes
   prepare for them.

## What to leave alone

The argument, the three mode names (Automate, Protect, Collaborate), the slide order, the
numbers, the excluded material listed at the end of `notes.md` under "Off the slides by
decision". The wiki files in `planning/`.

## When you are done

Commit inside `overleaf/` (branch main) and then in the parent repository (branch
korea-university-lecture), with plain imperative commit messages. Push nothing. Write your
review of the notes to `planning/codex-notes-review-2026-09-16.md` and reply here with a short
summary: the new palette in one line, the slides you changed, and the count of notes findings by
severity.
