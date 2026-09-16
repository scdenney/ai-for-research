# Speaker notes

Up to an hour, 43 numbered slides (section dividers carry no number), then discussion. Times are cumulative targets and end at 57:00,
which leaves three minutes before the moderator takes over. Every number spoken here is listed at
the end with the file it was verified against. No em dashes, no semicolons.

## 1. Title (0:00 to 0:30)

Thank the moderator and the hosts. One sentence on the shape: a way of thinking first, then the
tools I actually use, then one project from grant to conference talk.

## 2. Where I am speaking from (0:30 to 2:00)

Leiden, area studies, Korea. Surveys and conjoint experiments, and text as data. Two public
repositories: a library of standards that coding agents load, and a site with the demonstrations
and lectures, including this one. One project runs through the whole talk so you learn it once.

## 3. One pipeline, taught and run (2:00 to 4:00)

The subject is the research pipeline. Idea, sources, data, analysis, writing, citation, claim. We
teach it to students and we run it ourselves, and the question of where AI belongs in it is the
same question from two sides. Three parts: where we are, building the check, one project start to
finish.

## 4. These tools were built for software (4:00 to 5:30)

A chat window answers a question. An agent is a model with tools. It reads your files, runs a
command, sees what came back, and decides the next step, and it loops until the task is done or
you stop it. That loop was built for programmers. Christopher Kenny drew it this way last week at
Princeton and I am borrowing it.

## 5. Code runs or it fails. A claim does not. (5:30 to 7:30)

This is the mechanism behind everything else. In software the loop closes because there is a
cheap, fast, mechanical correctness check: the compiler and the tests answer, and the answer is
legible without domain expertise. Tests take work to write, but once written they run for free. That is why an agent can work unsupervised on code. It can check
itself. A research claim has no compiler. Nothing errors. The mistake surfaces at peer review, in
someone else's citation of you, or never.

## 6. Three consequences (7:30 to 9:00)

Errors are silent and they compound: a bad transcription becomes a bad count becomes a claim
becomes someone's citation of your claim. Checking often needs the very skill you were handing
over: you cannot tell whether a summary of Brubaker is right unless you have read Brubaker. And
the inputs are not in the training data and should not be: your archive, your unpublished data,
a scanned textbook nobody has transcribed.

## 7. Three modes (9:00 to 11:00)

The framework, plainly. Automate: hand off the work, efficiency is the goal. Protect: keep the
cognitive work, because doing it is how knowledge, skill, or judgment develops or is
demonstrated. Collaborate: combine human judgment with machine capability, and the goal is reach,
work you could not do alone at a scale you could not reach alone. The sentence underneath is the
whole talk: the question is not whether AI can do a task, but what role human cognition should
play in doing it. Protection is the principle. Sandboxing is how you do it.

## 8. Each mode has a mechanism (11:00 to 12:00)

Now tie the three modes to slide five. Automate where a wrong answer is cheap or obvious. Protect
where the only way to check the work is to have the skill yourself. Collaborate where you can
build the check that research never had. That last line is Part 2.

## 9. Mode 1. Aggressively and shamelessly automate (12:00 to 13:30)

I mean shamelessly. Cognitive offloading is good. Planning and management. Sorting email.
Tracking what I am working on. Chores and admin. One number: in a month of heavy use I dictated
662 times, about fifty-five thousand words, on two machines, and a model cleaned every one for
about eight dollars in API fees.

## 10. Mode 2. Protect. Little to no AI (13:30 to 15:00)

Where I am sure: grading, maybe all of it. The final manuscript. Most teaching. Reading, above
all. Where I am not sure, and I would like to hear from you in the discussion: writing before the
final draft, and the seeds of ideas. I have written those two with question marks in my own
notebook and I am leaving them that way.

## 11. Who bears the cost (15:00 to 16:00)

Protection means something different in research and in teaching, and the difference is who
bears the cost. In research I am protecting my own skill formation. I can waive it, and I know
what I gave up. In teaching I am protecting a student's formation, and I cannot waive that on
their behalf. The student has an interest in the outcome, and only I can protect it. A preference
becomes an obligation.

## 12. Same stage, different mode (16:00 to 17:00)

The same pipeline stage sits in different modes depending on who is standing at it. Reading is
the clearest case: for the student it is protected, for me it is collaborative, because I have
done the reading that lets me judge what the machine gives back. Many of you are both, since
graduate students teach, so you sit on both sides of one decision.

## 13. Mode 3. Collaborate (17:00 to 18:00)

The common category from my notes: research scaffolding and knowledge bases, bibliometrics and
formatting, data collection through visualization, ideation and quality assurance, supervision.
The rest of the talk is four controls, built. Three of them on one project, the fourth at the
supervision desk.

## 14. One project, one pipeline, four controls (18:00 to 19:30)

The project. An NWO grant, fifty thousand euros, October 2025 to September 2026. Do citizens
judge immigration policy only by what it does, or also by how governments exercise authority in
making it. A conjoint experiment, ten thousand respondents after quality checks across the United
States, Germany, South Korea, and Singapore. Three papers, one conference talk, one
pre-registration. The repository holds 447 commits, 80 handoff entries, 54 session logs.

## 15. A skill is a written standard (19:30 to 20:30)

This is what a skill is: a text file with a name and a description, and then instructions. The
agent loads it when the task matches the description or when I name it. Forty-one of them in the
library. This one is the citation checker, and its description already tells you what it will
not do: it marks whatever it did not check as not checked.

## 16. The boring folder structure is load-bearing (20:30 to 22:00)

The first control is not a check. It is the folder structure that makes checking possible. This
is what the research-repo skill writes into an empty project. Originals in one folder, never
edited. Markdown conversions in another, tracked in git. A drop zone. One bibliography entry per
source. The source library is the spine and everything else grows from it. Without this, the
later checks cannot run.

## 17. As built (22:00 to 23:00)

The same structure as it stands in the project today. A hundred and nineteen Markdown files, a
hundred and three of them verbatim conversions, fifteen notes for works we do not hold. A hundred
and three originals. A hundred and twenty-six bibliography entries. Nothing waiting in the drop
zone. In June there were fifty-nine files.

## 18. What a converted source looks like (23:00 to 24:00)

Plain text. The running head, the DOI, the title, the authors. The model reads this directly.
That is the whole trick behind a grounded check: the model reads the file, not its memory.

## 19. A note is not a source (24:00 to 25:30)

When we cannot hold a work, we write a note about it from publisher pages and reviews, and every
note opens with this banner. A note is not a source. Nothing in it may verify a claim, and a
fact-check must record such a claim as unverifiable. Paper 2 cites 74 works: 62 with the real
text, 12 with a note, none with nothing. That last clause is the standard.

## 20. The nearest thing to a compiler (25:30 to 27:00)

The second control is deterministic. Do the title, author, and year match an indexed work?
Does the DOI point at this work. Does the exact title exist anywhere. Does the title appear in the
real author's list of works. One rule to take home: never treat a DOI that resolves as a DOI that
is correct. A live DOI pointing at a different real paper is the classic fabrication signature.

## 21. What citation-check can say (27:00 to 28:00)

Its whole vocabulary. Missing DOI, dead DOI, DOI resolving to a different work, metadata
mismatch, title drift, status update, needs author verification, likely fabricated. The lookups
are mechanical: an index either holds the work or it does not. The skill as a whole is run by an
agent, which is why the next slide matters: the gate strips the agent out.

## 22. What it found, June 2026 (28:00 to 30:00)

In June we checked the 37 cited works that had no source file yet. All 37 exist. But eight
bibliography entries were wrong, and one of them was invented: wrong authors, wrong title, wrong
journal, all attached to one key. The real work is Anxious Publics in Comparative Political
Studies. That entry had survived in my working bibliography until a systematic pass. All eight
were corrected the same day.

## 23. The gate never calls a model (30:00 to 32:00)

The same logic as a script that runs at every commit. This is its output on the deck I gave at
APSA two weeks ago. Three citations on slides that the script could not resolve. A hundred and forty-seven numbers
on the slides, each traced to one checksummed data snapshot. Four style warnings. Exit code one,
so the commit is blocked. It runs in seconds and it never calls a language model.

## 24. What happened next (32:00 to 33:00)

Five days later this commit landed in the paper's bibliography. Read the second sentence: the
gate checks every slide citation against this file, so the entry lives here even though the paper
does not yet cite it. The check changed what I did, not just what I knew. Twenty-three references
verified in the cache today.

## 25. It refuses to run on an empty base (33:00 to 34:00)

The third control is a model reading the sources, and the first thing to know about it is when
it refuses. No knowledge base, or unconverted files, or coverage below two-thirds of the cited
works, and it stops with this notice. A check that runs around a hole gives false reassurance,
which is worse than no check.

## 26. What fact-check can say (34:00 to 35:00)

Supported, partially supported, unsupported, contradicted, misattributed, source insufficient,
not in the knowledge base. And the rule that makes the verdicts mean something: a verdict of
support or contradiction carries a verbatim quote from the source file. A missing source is
reported as missing, not judged.

## 27. What it found, August 2026 (35:00 to 37:00)

In August every claim in Paper 2 was checked against the source text where we hold it, not the
citation. Where we hold only a note, the claim was recorded as unverifiable.
Nineteen corrections. Four citations had been supporting the opposite of what their source
found. Hangartner is a study of Greece and I had it as Germany. Tichenor argues immigration cut
across party lines. Hooghe and Marks have nothing on asylum. Citrin and colleagues in 1997 report
a null on personal economic competition. Every one of those references was well formed. Every
one would have passed the deterministic check.

## 28. One finding in full (37:00 to 38:30)

One in full, because the shape matters. The claim: an AMCE is defined over the levels a
researcher writes. The source, the conjoint chapter by Bansak, Hainmueller, Hopkins and
Yamamoto: an AMCE is always defined with respect to a baseline value and the randomization
distribution. Zero hits in the chapter for the words my sentence rested on. The fix: rewrite the
sentence to what the chapter says. This was the last unverified citation in the paper.

## 29. Two checks, two different failures (38:30 to 39:30)

Side by side, from the public sample project on the site, with errors planted on purpose. The
reference is real and correctly written, so the citation check passes it. The claim runs
backwards, and only reading the source catches that. Formatting-clean is not the same as true.

## 30. The gate reads what it is told to read (39:30 to 41:00)

One place the control failed, on my own deck, and I want to show it rather than hide it. The
script reads citations from the fields marked as citations. One citation sat in a plain text
field, so the script never saw it, and it stood on a slide that was already at a public URL. The
model-based review found it. The first run that morning caught two of three. The scan was
widened the same day, and the second run caught all three. A check is only as wide as its scan,
and you have to know where the edges are.

## 31. The same logic runs the supervision desk (41:00 to 42:30)

Teaching. When I supervise a thesis, I read it, I annotate it, and I dictate my reactions. Those
three are mine. Then the machine structures the feedback against the assessment criteria, checks
every quote against the page, and formats the letter. Then I sign it. The judgment stays with
the supervisor. The machinery around the judgment is automated.

## 32. Dictation, before and after (42:30 to 43:30)

The dictation step, from my own log. The raw transcript on the left, the cleaned text a second
later on the right. One word repaired. Nothing rewritten. The words are still mine.

## 33. Structure and check (43:30 to 45:00)

Five readers in parallel, one per assessment criterion, each writing findings with a page anchor.
Then one cross-checker that verifies every quoted span appears at the page cited, and drops what
it cannot find. The rule in every reader's instructions: quote the span verbatim with its page
anchor, and if you cannot quote it, do not assert it. A hard cap of 900 words. And one criterion,
the student's learning process, is never marked by the machine. That one is mine alone.

## 34. The same letter, a third shorter (45:00 to 46:30)

The last step, on a piece of feedback about a book chapter rather than a thesis, so no student is
on the screen. The opening paragraph, first draft on the left, 89 words. After the editing pass
on the right, 61. The evaluative adverbs are gone, and the criticism that the first draft made
three paragraphs later now sits in the last sentence of the opening. The letter's judgment is
unchanged. Its shape is not.

## 35. Automate the machinery, not the judgment (46:30 to 47:00)

Read it once and stop.

## 36. Twelve months, eight stages (47:00 to 49:30)

The same project from grant to conference talk, stage by stage, with what the machine did and
what stayed human. Grant and ethics in 2025: nothing on record, all human. Design and the
pre-analysis plan: adversarial reviews and bibliography audits by the machine, every design
decision by me and logged. Instrument: the machine built the survey from a text specification and ran
blind translation reviews, native speakers checked the languages. Pre-registration deposited on
10 August: documents generated from the LaTeX source, the deposit itself deferred until I signed.
Fielding, first response 11 August to close on 31 August: quota grids and publish gating by the
machine, vendor letters and quota rulings by me. Analysis: figures, the numbers file, and the
runs by the machine, the estimand and the decision rule by me, handed over without the
hypothesized sign. Writing: prose passes and pre-submission review by the machine, every word
and every push by me. The talk on 4 September: the deck build by the machine, the notes and the
order by me, and the gate and the lint ran on 9 September, after delivery, and found what they
found.

## 37. What stayed human, by rule (49:30 to 51:00)

Three rules from the project's own files. Confirmatory analysis is blind to the hypothesized
sign: the agent gets the estimand and the decision rule, not the direction I hope for, so it
cannot quietly search for the specification that pleases me. Do not change a paper's confirmatory
hypothesis structure without discussion. Never push to Overleaf without my say-so.

## 38. Every number resolves to one snapshot (51:00 to 52:30)

Every result number in the paper resolves through a macro to a generated file, pinned to one
data snapshot with a timestamp. The file says do not edit at the top, and a guard compares
snapshots and reports whether any decision-level number changed verdict. In Paper 2, none of
107 guarded keys moved between the last two snapshots.

## 39. Disclosure (52:30 to 53:30)

The statement in the manuscript. Read the last sentence: all design decisions, hypotheses,
estimands, analysis, and interpretations are the author's, who carefully reviewed all input and
takes full responsibility for the content. That sentence is the point of the whole architecture.
The checks exist so that I can sign it.

## 40. What it took (53:30 to 54:30)

Four hundred and forty-seven commits. Eighty handoff entries. Fifty-four session logs. And a paper
at eleven thousand seven hundred words against a ceiling of ten thousand. The machinery was
automated. The paper is still being written.

## 41. For students, for professors (54:30 to 56:00)

The title promised this. Students: automate the clerical; protect reading, first ideas, and the
procedures you are still learning; collaborate only where you can check the output yourself.
Professors: automate more of your own machinery and leave a trace; protect the formation of your
students' judgment; collaborate where the machine changes what is feasible.

## 42. The governing sentence (56:00 to 56:30)

Read it once.

## 43. Everything shown today is public (56:30 to 57:00)

The skills, the site with the demonstrations, and these slides. Thank you. Leave this slide up
for the discussion.

---

## Accuracy guardrails (do not misstate on stage)

- **Grant.** NWO Open Competition XS 2025 round 1, 406.XS.25.01.065, €50,000, 2025-10-01 to
  2026-09-30 (`nwo26-immigration-backlash/README.md`).
- **Samples.** DE 2,502, KR 2,500, SG 2,500, US 2,498, pooled 10,000, snapshot 2026-08-31T1349Z
  (`papers/2-legitimacy-policy-process/README.md`). The root README's US 2,458 is superseded.
- **Repository.** 447 commits (first 2026-05-29, last 2026-09-15), 80 handoff entries (from
  2026-03-18), 54 session logs (git log; `HANDOFF.md`; `logs/`).
- **Design and outputs.** Within-subject conjoint, 360 cells, ten tasks plus one repeat
  (`osf/registration_2026-08-06/registration_P2_procedural-legitimacy.md`). Three papers, one
  talk, one pre-registration in three OSF submissions (`README.md`).
- **Dates.** Germany activated 2026-08-05; OSF deposit 2026-08-10; first response 2026-08-11;
  United States closed 2026-08-31 (`HANDOFF.md` entries of those dates; `logs/2026-09-15_16-12.md`).
  The talk was delivered 2026-09-04; the gate and lint first ran 2026-09-09.
- **Skills.** 41 Claude Code skills, 40 Codex skills (open-science-skills `README.md`, v2.29.1,
  2026-09-08).
- **Gate details.** 18 files scanned for credentials (`fast.json`); the pipeline guide says the
  gate "runs in seconds" (`docs/deliverable-pipeline.md`); the first run that morning
  (`checks/pilot-first-run.json`, 13:04) flagged two Aviña strings, the second (`fast.json`,
  13:20) all three.
- **Coverage rule.** Two-thirds of cited works (`fact-check/SKILL.md`, pre-flight gate).
- **Appendix review line.** `papers/2-legitimacy-policy-process/design/p2_presubmit_review_2026-08-30.md`:
  nine dimension agents, two cross-checkers, 0 hallucinated quotes, 8 inference errors dropped,
  9 critical, 40 recommended, about 70 minor, seven of thirteen criticals reopened.
- **Converter table.** `doc-to-markdown/SKILL.md`: fourteen formats for anydoc. The 30 ms figure
  there is not on the slide.
- **Quoted artifacts** (the skill frontmatter, the source file header, the `.NOTE.md` banner, the
  commit message, the numbers.tex header, the disclosure) are copied from the files named on each
  slide, abridged where the slide says so.
- **Knowledge base, measured 2026-09-16.** 119 Markdown files: 103 verbatim conversions, 15
  `.NOTE.md`, one index. 103 originals. 126 master bib entries (`CLAUDE.md`'s 114 is stale).
  Growth 59 → 72 (2026-06-30, `HANDOFF.md`) → 119.
- **Paper 2 coverage.** 74 cited works, 62 with real text, 12 with a note, none with nothing
  (`notes/OVERVIEW.md`, 2026-08-27).
- **June pass.** 37 cited works without a source file, all verified to exist; 8 bib fixes the same
  day, listed verbatim in `HANDOFF.md` 2026-06-30; the invented key is
  `FitzgeraldCurtisCorliss2012`, real work "Anxious Publics," CPS 45(4). 13 open-access sources
  acquired per the sentence in `sources/inventory.md` (its list names 14; say 13).
- **August pass.** Nineteen corrections per `notes/OVERVIEW.md` (`TODO.md` says seventeen; say
  nineteen). The four reversed citations and the Bansak finding are quoted from `OVERVIEW.md`.
- **Gate output.** `talks/apsa-2026/checks/2026-09-09/fast.json`: PASS 3, FAIL 3, WARN 4, INFO 1,
  exit 1; 147 table values; snapshot 2026-08-31T1349Z. Slide lines are abridged; the full FAIL
  message also names the accept command.
- **The commit.** Submodule commit `563f103`, 2026-09-14, "Add Ogura et al. 2026 to the
  bibliography." Cache `checks/citations.json`: 23 VERIFIED. Do not explain why Aviña later
  verified; the cause is not documented.
- **Lint F011.** `talks/apsa-2026/checks/2026-09-09/report.md`, 9 September 2026; the deck was
  delivered 4 September and published before the gate first ran.
- **Dictation.** 662 dictations, 54,796 words, one month, two machines, about $8
  (`ai-for-research/demos/talk-to-your-terminal/README.md`). The shown pair is the 2026-06-04
  record in `~/.config/macwhspr/cleanup_log.jsonl`.
- **Supervision.** Five finders, one cross-checker, 900-word cap, Learning Skills never marked by
  the skill (`thesis` plugin 0.3.1, `_shared/agents.md`, `_shared/output-template.md`). The
  fidelity rule is quoted verbatim.
- **Letter.** `~/Desktop/temp/Book Chapter 2 - Feedback.md` (596 words) and the sci-edited
  version (484 words); the shown opening paragraph is 89 → 61 words by whitespace count. No names.
- **numbers.tex.** Header abridged; snapshot 2026-08-31T1349Z, 2,018 keys. Verdict guard: 0 of
  107 guarded Paper 2 keys moved (`HANDOFF.md` 2026-08-31). Do not mention Paper 3's moving key.
- **Word count.** 11,772 all-in against 10,000 (`HANDOFF.md` 2026-09-15).
- **Disclosure.** Quoted verbatim from `manuscript/main.tex`, section Use of AI.
- **Kenny 2026** verified (talk 10 September 2026; `github.com/christopherkenny/skills`). The
  four working modes are Kenny's adaptation of Swaney's 20 March 2026 workshop, not in Swaney's
  public materials. Never quote the ALARM guidelines; they could not be located.
- **Off the slides by decision.** The 2026-09-15 pretest and registration matter; the hardcoded
  paths, the fabricated-numbers PDF, and the live token; any student material; text-to-data and
  the OCR corpus; research-grill and research-wayfinder.
