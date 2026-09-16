# Speaker notes

Forty-five minutes, thirty-four slides, then discussion. Times are cumulative targets; the
plan leaves two minutes of slack before the moderator takes over. Every number spoken here is
listed at the end with the file it was verified against.

## 1. Cover (0:00 → 0:30)

Thank the moderator and the hosts, the Office of Graduate School, the BK21 sociology
program, the Department of Political Science and International Relations, and the SDGs
group. One sentence on the shape: a way of thinking first, then two things from my own work,
then what it means for students and for professors.

## 2. Cold open (0:30 → 1:30)

Earlier this year I ran a check over a manuscript of mine. A source I had cited twice, a book
on the meanings of democracy in East Asia, did not make the claim I had attached to it. The
reference was perfectly formed. The claim was simply not in the text. The machine that found
it was not writing anything. It was reading, on my behalf, the one thing I had not gone back to
read. I will show you the tool at slide twenty. Hold the story: the interesting uses of these
systems are often the ones that point backwards, at what we have already written.

## 3. What changed (1:30 → 3:00)

Everyone in this room has used a chat window. The tools I am talking about are different in
kind. An agent is a model with tools: it can read the files in a project, run a command, see
what came back, and decide the next step, and it loops until the task is done or you stop it.
Kenny's diagram has the loop exactly right. The consequence is that the machine now acts inside
your research environment, not beside it.

## 4. The question (3:00 → 4:00)

So the question is no longer whether academics should use AI. It already sits in the
terminal. The question is where in the process we automate, where we deliberately preserve
human cognitive effort, and where we redesign the process around collaboration. Three verbs.
I will say them once now and once at the end: automate, protect, collaborate.

## 5. The map (4:00 → 5:00)

Three spaces. The assembly line is where doing the work adds nothing to the result, and the
rule is to automate. The apprenticeship is where doing the work is how expertise forms, and
the rule is to protect. The workbench is where the machine changes the scale, speed, or form
of what can be done, and the rule is to collaborate. Part one walks the three. Part two stays
at the workbench.

## 6. Part one (5:00)

Ten minutes.

## 7. Automate (5:00 → 7:00)

These are things I actually automate, and I want to be concrete because the abstract version
sounds like a slogan. Session state lives in an append-only handoff file, so nothing important
exists only in an agent's memory. A drive of fourteen thousand scanned files became four
hundred and thirty-eight catalogued volumes under one naming scheme. In one month I dictated
six hundred and sixty-two times, fifty-five thousand words, each cleaned by a model, for about
eight dollars. One Markdown feedback letter builds to PDF and Word in one command. Every PDF a
project cites becomes a Markdown file that the checks can read. And citations and numbers are
verified at every commit before any model reads a word. Pick two of these to say aloud; the
rest can be read.

## 8. The claim (7:00 → 8:00)

The claim is not that the machine can do these things. Of course it can. The claim is that
they are poor uses of scarce attention. One condition: automation that leaves no trace is not
automation, it is loss. The plain-text log, the diff, the gate receipt: those are what make the
assembly line auditable.

## 9. Protect (8:00 → 10:00)

The same form as the last ledger, on purpose, because the rows differ in kind, not in
difficulty. Reading: the source, not the summary, because a summary cannot tell you what it
left out. First ideas, before any model has framed them. Learning a procedure by running it
yourself once, so you can tell later when it is wrong. Some writing, because editing what a
machine wrote is a different skill from thinking. Some coding, enough to read a diff and know
what it did to your data. In-class assessment. Oral reasoning. None of these is hard for the
machine. All of them are how a researcher is made.

## 10. The test (10:00 → 11:30)

Here is the test I use. The question is not whether the machine can do the task. It is whether
you must do it in order to become able to judge the machine. That is where the student and
the professor part ways. What I can responsibly offload after twenty years is often exactly
the thing a student needs to struggle through to acquire those twenty years. If there is time,
Kremer's O-ring argument in one sentence: when inputs get cheap and fast, the return to
judgment rises rather than falls, so protecting the formation of judgment matters more, not
less.

## 11. Collaborate, defined (11:30 → 12:30)

"Human in the loop" is becoming an empty phrase. Say instead who holds epistemic
responsibility. My working definition: the human retains epistemic responsibility while the
machine changes the scale, speed, or form of what can be done. Responsibility is the word.
Scale, speed, or form is what changes.

## 12. Kenny's grid (12:30 → 13:45)

Inside the workbench, how you work with the machine depends on two things: how complex the
task is and how objectively its output can be checked. This is Christopher Kenny's grid, from
his Princeton talk last week, adapting Colin Swaney's workshop. Pair programming when the task
is hard and the output is a matter of judgment. A planning commission when it is hard but
checkable: you write the plan, the machine implements. A review board when it is easy but
subjective: the machine drafts, you review. Autopilot when it is easy and checkable. Research
lives mostly in the top row.

## 13. The gate (13:45 → 14:30)

My one addition. Kenny's grid sorts how to delegate. Before the grid there is a gate: does
doing this build the judgment I need to check it? If yes, stay off the grid and do it yourself.
That is the apprenticeship. If no, enter the grid and choose a mode. There is also a fifth mode
the grid does not show, where the machine interviews you until your assumptions are explicit
and you implement. I use it to plan studies. It is the most human-agency-preserving mode there
is.

## 14. Research raises the bar (14:30 → 15:00)

Kenny again, condensed. In software the goal is a product that works, mistakes are patched in
the next release, and no one person needs to understand every part. In research the goal is
to know why or how something works, mistakes must be found before the paper is written, and
the authors must understand it all and vouch for it. So the workbench needs an audit trail.
That is Part two.

## 15. Part two (15:00)

Twenty-five minutes. Two demonstrations, then a coda.

## 16. The workbench (15:00 → 16:30)

Three things. An agent, Claude Code or Codex, that reads files, runs commands, and reports
back. A repository: sources, bibliography, manuscript, data, under git. And written standards.
The library I maintain, Open Science Skills, is forty-one of these: each a document that tells
the agent how the field thinks about a task, a conjoint design, a pre-registration, a
citation audit. A skill encodes how to think, not just what to do. It is where the standard
lives, so the machine cannot take the software shortcut on a methods question.

## 17. Disconnected objects (16:30 → 17:15)

Start from the familiar problem, not the machinery. Research runs on objects that do not talk
to each other: PDFs, notes, citations, a BibTeX file, drafts, and the claims inside them. Each
is real. None can vouch for the others. A citation key does not know whether the PDF says what
the draft says it says.

## 18. The knowledge base (17:15 → 19:00)

Build it from the bottom. Original PDFs, immutable, the source of record, rarely read
directly. Markdown conversions, verbatim and tracked in git: this is the layer every check
reads. A bibliography with one entry per source and every key resolvable to its file. A
synopsis index, one entry per cited work saying what it establishes, where its boundary is,
and which claim of mine it supports. And at the top, the manuscript's claims, each pointing
down the stack to text a reader can open. The top layer is Karpathy's LLM wiki idea, the one
Kenny demonstrated. The difference I insist on is that it sits on the verbatim layer. A wiki
page is a summary. A summary cannot verify a claim.

## 19. Retrieval (19:00 → 20:30)

One retrieval, captured from a real project of mine on nationalism in China and Taiwan. The
question: what do my sources say about ethnic and civic conceptions of the nation? The answer
cites files, not memory: Kohn, Brubaker, Connor, Smith, Tamir, each with the file it came from.
On the right is one entry from the synopsis index, Kohn 1955, so you can see what the machine
is reading. Forty-four source files, one hundred and twenty-seven bibliography entries, and
every entry marked as full text or synopsis-only, so the answer carries its own provenance.

## 20. Verification (20:30 → 22:30)

Now the direction I promised. Check whether the manuscript says what the source says. This is
the fact-check skill on a sample project with planted errors, which anyone can download from
the AI for Research site. One claim is supported, with the source passage quoted. One is
partial: the manuscript says trust causes turnout, the source documents an association and
says so. One is contradicted: the manuscript says compulsory voting raises political
knowledge, the source says whatever compulsory voting does, it does not appear to teach. Every
reference here passes every format check. Only reading the source catches the reversal. That
is the tool that found my own error in the cold open: a source cited twice for a claim it
never makes.

## 21. The chain (22:30 → 23:45)

The checks run in a chain, and the cheap deterministic ones run first. Is the source file
there. Does the DOI resolve to this work. Do the BibTeX entry and the text agree. Does every
in-text citation have a reference and the reverse. Those are scripts, they cost nothing, and
they run at every commit. Only then does a model read the verbatim text and ask whether the
source says this. And whatever was not checked is reported as not checked. Nothing is assumed.

## 22. The reverse direction (23:45 → 24:30)

Most of the conversation about generative AI is about generation. I am increasingly
interested in the opposite direction: using these systems to inspect, retrieve, verify, and
challenge what I have written. The machine is not producing prose. It is keeping an audit
trail.

## 23. Not yet data (24:30 → 25:30)

The knowledge base starts from scholarship that already exists as digital documents. What
happens when the material we need is not yet data at all? This is a history textbook from
1951 in the Georg Eckert Institute's library in Braunschweig, the largest textbook collection
in the world. Four hundred and thirty-eight scanned volumes, twenty-four gigabytes of page
images, and not one searchable word.

## 24. The pipeline (25:30 → 27:00)

Seven steps. A physical textbook becomes page images. The images become an organized archive,
one naming scheme, every volume catalogued. A vision-language model transcribes the pages.
The text is validated, structured into a corpus, and analysed. Each step was possible before.
What changed is the cost of each, and therefore what a single researcher can realistically
build. Poland and South Korea, 1948 to 2020, nearly a hundred thousand pages.

## 25. The OCR demonstration (27:00 → 28:30)

Home ground. A 1956 South Korean history textbook, the page on Dangun and Gojoseon. The
vision-language model reads the whole page at once and returns the hangul and the hanja
glosses in order, with no Korean-specific setup. Traditional OCR, Tesseract, returns noise on
the same scan. For non-Latin and historical print this is the quiet revolution of the last
two years. Read the Korean aloud if the room is Korean.

## 26. Every arrow is a decision (28:30 → 30:30)

The same seven steps, with the question under each arrow. What counts as a source? What gets
scanned, and how is a page identified? How accurate is the transcription, and how would we
know? What happens to tables, captions, and marginalia? What is the unit of analysis? What
claims can this text support? None of these is answered by the machine. This is research
design, not assistance.

## 27. The proxy as warning (30:30 → 32:00)

Take the accuracy question seriously. There is no human ground truth for this corpus, by a
decision I recorded rather than hid: transcribing sixty-four pages by hand in two languages
was not worth what it would have bought. So accuracy is a proxy: how much nine different OCR
systems disagree with each other, character by character. On Polish pages they disagree by
about two percent. On Korean pages, about twenty-five percent. Say "cross-model agreement",
never a character error rate. The point is the warning. When transcription error tracks
language, it can masquerade as a cross-national difference in content.

## 28. What can become data (32:00 → 33:30)

What the corpus that already exists made possible. Sixty-seven Korean history textbooks from
1895 to 2016, eleven million characters of machine-readable text. Terms counted only when
three of four open models from four countries agree. And a finding: regime type sets the
character of change and institutions set its timing; nothing detectable moves at 1987; the
shift comes with the sixth curriculum in the nineties and the 2002 reform. Observational, not
causal. The technology changed what could become data.

## 29. Two uses (33:30 → 35:00)

Why the two demonstrations belong together. One organizes existing knowledge; the other
produces new research data. Literature against primary material. Retrieval against
extraction. Verification against transformation. Claim checking against corpus construction.
What do we know, and what can we make knowable. Both run on the same rule: automate the
machinery, not the judgment.

## 30. The supervision desk (35:00 → 36:30)

The same logic runs teaching. When I supervise a thesis, I read it, I annotate it, and I
dictate my substantive reactions. The machine then structures the feedback against the
assessment criteria, checks that every quote appears at the page I cited, and formats the
letter, which has a hard cap of nine hundred words. I sign it. The judgment stays mine. The
machinery around the judgment is increasingly automated.

## 31. Students and professors (36:30 → 38:30)

The title promised this. For students: automate the clerical, protect reading, first ideas,
and every procedure you are still learning, and collaborate only where you can check the
output yourself. For professors: automate more of your own machinery and leave a trace,
protect the formation of your students' judgment, the seminar, the exam, the supervision, and
redesign the process around what has become feasible.

## 32. Allocation, not adoption (38:30 → 40:00)

The question for universities is not whether AI belongs in research and teaching. It already
does. The question is which cognitive work we want humans to keep doing, which we are content
to hand over, and where new combinations of human judgment and machine capability make the
previously impractical practical.

## 33. Three imperatives (40:00 → 41:30)

Read the three lines slowly. Automate what does not deserve our attention. Protect the work
through which expertise is built. Collaborate where machines expand what researchers can do.
Stop on the rose line.

## 34. Working in the open (41:30 → 43:00)

Everything I showed is public. The skills library, the AI for Research site with the demos
and this deck, and the Substack where the corpus methods are written up with code. Thank you.
Leave this slide up for the discussion.

---

## Accuracy guardrails (do not misstate on stage)

- **438 volumes, 24 GB.** Verified on disk in `research/projects/gei_textbooks/corpus/`
  (438 PDFs; `du -sh` 24G). **98,295 pages** is documented in `metadata/DATA_DICTIONARY.md`
  and `overleaf/main.tex`, not checkable from the committed inventory. **1948 to 2020** is the
  corpus range; the Korean end-year disagrees between two files, so never state it.
- **Bulk OCR has not run.** Say the corpus is scanned and catalogued, never that it is
  transcribed. No token count exists for it.
- **No CER or WER exists** for the GEI corpus, by the decision recorded in
  `review/2026-06-18-decision-set-aside-ground-truth.md`. The slide-27 figures are cross-model
  divergence, character level, top-six cluster on body-text pages: Polish 2.3 percent, Korean
  24.6 percent, from `overleaf/technical_report.tex` (Table `tab:quality_lang`). They are not
  yet in the committed `preliminary_analysis.txt`; say "preliminary".
- **Nine systems, 64 pages, eight books, four decades** (`ocr_pipeline/OCR_PLAN.md`). Gemma 4
  is the **E4B** variant at BF16, not 31B.
- **14,238 files** is the pre-reorganisation manifest of scanned PDFs
  (`_archive/pre_reorg_manifest.txt`); the corpus after consolidation is 438 volumes.
- **textbook_kr: 67 books, 1895 to 2016, 11,287,661 characters** (`00_data/PREPROCESSING_REPORT.md`;
  the README's "13 million" is stale). Council: four models, 3-of-4 vote, nine terms cleared,
  six unanimous. The finding sentence follows `gei_textbooks/talk/machine-collaborators-2026-06-25.md` S25.
- **Dictation: 662 dictations, 54,796 words, one month, about $8**
  (`ai-for-research/demos/talk-to-your-terminal/README.md`).
- **Political-regimes project: 44 source files, 127 bibliography entries**, synopsis index at
  `sources/md/SOURCES_SYNOPSES.md`; Kohn, Brubaker, Connor, Smith are synopsis-only, Tamir is
  full text.
- **The cold-open catch**: `demo_nat_reconsidered/sources/CITATION_AUDIT.md` (chu2010, cited
  twice for claims it does not make; fixed). Do not name the manuscript on stage.
- **Slide 20** is the synthetic sample project (`ai-for-research/demos/reference-check/`),
  planted errors, public.
- **Kenny 2026** is verified (talk 10 September 2026, `github.com/christopherkenny/skills`,
  `csdp-llm-wiki`). The four modes are Kenny's adaptation of Swaney's 20 March 2026 workshop;
  they are not in Swaney's public materials, so attribute to Kenny. Do not quote the ALARM
  GenAI guidelines; they could not be located.
- **Supervision coda**: the finders and the cross-checker exist (private `/thesis:*` plugin);
  annotation is by hand; dictation is general infrastructure. No student material on any slide.
