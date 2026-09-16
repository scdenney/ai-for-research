// Slide text for "Rethinking the Research Process" (Korea University, 18 September 2026).
// Edit this file, then rebuild:
//     python3 src/build.py          # index.html + deck.pdf (needs Chrome/Chromium)
//     python3 src/build.py --html   # index.html only
// Every `@key` starts a field; the text runs until the next `@key` or `##` line.
// Inline HTML is allowed (<b>, <i>, <br>). Lines starting with // are ignored.
// Diagram labels live in src/charts.py. Citations on slides are "Author Year"
// strings in *.cite fields; check_deliverable.py resolves them against references.bib.

## 1 · Cover
@1.eyebrow
AI Literacy for Social Scientists · Special Lecture 01
@1.kr
사회과학자를 위한 AI Literacy 특강 시리즈
@1.title
Rethinking the Research Process: How AI Is Changing Research for Students and Professors
@1.author
Steven Denney
@1.aff
Leiden University
@1.meta
Korea University · Friday 18 September 2026 · Moderator: Sung Eun Kim

## 2 · Cold open
@2.big
A source I had cited twice did not say what I said it said. A machine found it.

## 3 · What changed
@3.h
The tools changed in kind, not degree. They read your files, run your code, and come back.
@3.n1
Task
@3.n2
Model
@3.n3
Tool
@3.n4
Result
@3.n5
Model
@3.n6
Output
@3.line
A chat window answers. An agent acts, sees what happened, and decides the next step, until the task is done or you stop it.
@3.cite
The loop after Kenny 2026.

## 4 · The question
@4.big
The question is not "AI or no AI." It is where to automate, what to protect, and where to collaborate.
@4.verbs
Automate · Protect · Collaborate

## 5 · Three spaces
@5.h
Research and teaching now sort into three spaces, and each has its own rule.
@5.line
The map for the rest of the talk. Part one walks the three spaces. Part two stays at the workbench.

## 6 · Divider
@6.eyebrow
Part one
@6.title
Allocating cognitive work
@6.sub
automate, protect, collaborate

## 7 · Automate
@7.h
Automate the work whose doing adds nothing to the intellectual value of the result.
@7.r1.who
Planning and tracking
@7.r1.text
An append-only handoff file records every session's decisions, so nothing lives only in an agent's memory.
@7.r2.who
Naming and filing
@7.r2.text
A drive of 14,238 scanned files became 438 catalogued volumes under one naming scheme.
@7.r3.who
Clerical
@7.r3.text
662 dictations, 54,796 words in one month, each cleaned by a model, for about eight dollars.
@7.r4.who
Formatting
@7.r4.text
One Markdown feedback letter builds to PDF and Word in a single command.
@7.r5.who
Conversion
@7.r5.text
Every PDF a project cites becomes a Markdown file that the checks can read.
@7.r6.who
Routine checks
@7.r6.text
Citations and numbers are verified at every commit, before any model reads a word.

## 8 · Automate, the claim
@8.big
The claim is not that the machine can do these. It is that they are poor uses of scarce attention.
@8.sub
Automation that leaves no trace is not automation. It is loss.

## 9 · Protect
@9.h
Protect the work through which expertise is built.
@9.r1.who
Reading
@9.r1.text
The source, not the summary. A summary cannot tell you what it left out.
@9.r2.who
First ideas
@9.r2.text
The question and the hunch, before any model has framed them for you.
@9.r3.who
Learning a procedure
@9.r3.text
Running the estimator by hand once, so you can tell when it is wrong later.
@9.r4.who
Some writing
@9.r4.text
The first draft of an argument. Editing what a machine wrote is a different skill from thinking.
@9.r5.who
Some coding
@9.r5.text
Enough to read a diff and know what it did to your data.
@9.r6.who
In-class assessment
@9.r6.text
The exam, the presentation, the seminar answer given without a prompt window.
@9.r7.who
Oral reasoning
@9.r7.text
Defending a claim in real time, which no text model can do for you.

## 10 · Protect, the test
@10.h
Whether the machine can do the task is the wrong test.
@10.q
The question is not whether the machine can do the task. It is whether you must do it to become able to judge the machine.
@10.sub
What I can offload after twenty years is what a student still has to struggle through.

## 11 · Collaborate, defined
@11.h
"Human in the loop" says nothing. Say who holds epistemic responsibility.
@11.k
Collaboration, defined
@11.v
The human retains epistemic responsibility while the machine changes the scale, speed, or form of what can be done.

## 12 · Kenny's grid
@12.h
Inside the workbench, the working mode follows complexity and verifiability.
@12.cite
Kenny 2026, adapting Swaney 2026. Complexity is how hard the task is. Verifiability is how objectively its output can be checked.

## 13 · The gate
@13.h
Before the grid, a gate.
@13.note
Kenny's grid sorts how to delegate. The gate asks whether you should.

## 14 · Research raises the bar
@14.h
Research raises the bar. The author certifies correctness.
@14.l.k
Software
@14.l.t1
The goal is a product that works.
@14.l.t2
Mistakes are patched in the next release.
@14.l.t3
No one person needs to understand every part.
@14.r.k
Research
@14.r.t1
The goal is to know why or how something works.
@14.r.t2
Mistakes must be found before the paper is written.
@14.r.t3
The authors must understand it all, and vouch for it.
@14.bridge
So the workbench needs an audit trail.
@14.cite
After Kenny 2026.

## 15 · Divider
@15.eyebrow
Part two
@15.title
At the workbench
@15.sub
two demonstrations and a coda

## 16 · The workbench
@16.h
The workbench is an agent, a repository, and written standards.
@16.n1
Agent
@16.s1
Claude Code or Codex: reads files, runs commands, reports back
@16.n2
Repository
@16.s2
Sources, bibliography, manuscript, data, and git
@16.n3
Standards
@16.s3
Open Science Skills: 41 skills, each loaded by name
@16.line
A skill encodes how the field thinks, not just what to do. It is where the standard lives.

## 17 · Disconnected objects
@17.h
Research runs on objects that do not talk to each other.
@17.n1
PDFs
@17.n2
Notes
@17.n3
Citations
@17.n4
BibTeX
@17.n5
Drafts
@17.n6
Claims
@17.line
Each is real. None can vouch for the others.

## 18 · The knowledge base
@18.h
A knowledge base connects them, with verbatim text under every citation.
@18.cite
The top layer is Karpathy 2026's LLM wiki, as in Kenny 2026's demonstration. Here it sits on the verbatim layer, never in its place.

## 19 · Retrieval
@19.h
Ask the corpus, not the model.
@19.prompt
What do my sources say about ethnic and civic conceptions of the nation?
@19.a1
<b>Kohn 1955</b> originates the dichotomy: membership by political principle versus by descent. <span class="anchor">sources/md/SOURCES_SYNOPSES.md §1</span>
@19.a2
<b>Brubaker 1992</b> grounds it in citizenship law, France against Germany, and warns that the binary is an ideal type, not a clean split.
@19.a3
<b>Connor 1994</b> and <b>Smith 1991</b> put a felt common ancestry at the core of ethnic identity.
@19.a4
<b>Tamir 2019</b> argues the boundary is blurred and that "civic" often exempts a nationalism from scrutiny. <span class="anchor">full text held</span>
@19.box.k
Kohn 1955 · one entry in the synopsis index
@19.box.e
Originates the influential dichotomy between a Western, rational, voluntarist-political (civic) nationalism and an Eastern, organic, cultural-ethnic nationalism.
@19.box.b
A foundational historical-typological essay; the West/East geography of the binary is widely critiqued as overdrawn.
@19.box.s
The civic conception centered on shared political principles and citizenship.
@19.foot
The answer cites files, not memory: 44 source files, 127 bibliography entries, one synopsis index, and every entry marked as full text or synopsis.

## 20 · Verification
@20.h
Now check whether the manuscript says what the source says.
@20.prompt
/oss:fact-check manuscript.md
@20.v1.m
✓ Supported
@20.v1.c
"a modest, short-lived increase in youth turnout that fades within two election cycles"
@20.v1.s
Source, lindqvist2019: "The turnout premium is modest, on the order of three to four points, and it does not survive beyond the second election."
@20.v2.m
∼ Partial
@20.v2.c
"Higher social trust <b>causes</b> higher turnout"
@20.v2.s
Source, osei2020: "We document an association, not a mechanism." Suggested: <i>is associated with</i>.
@20.v3.m
✗ Contradicted
@20.v3.c
"compulsory voting also raises citizens' political knowledge"
@20.v3.s
Source, ferreira-nair2021: "Whatever compulsory voting does, it does not appear to teach."
@20.foot
A sample project with planted errors, from the AI for Research demos. Every reference here passes the format checks. Only reading the source catches the reversal.

## 21 · The chain of checks
@21.h
The checks run in a chain, and the cheap deterministic ones run first.
@21.n1
Provenance
@21.s1
Is the source file there?
@21.n2
Bibliographic
@21.s2
Does the DOI resolve to this work?
@21.n3
BibTeX
@21.s3
Do the entry and the text agree?
@21.n4
Citation
@21.s4
Does every in-text cite have a reference, and the reverse?
@21.n5
Claim
@21.s5
Does the source say this? A model reads the verbatim text.
@21.line
Scripts first, at every commit. The model reads last. Whatever was not checked is reported as NOT CHECKED.

## 22 · The reverse direction
@22.h
Most of the talk about generative AI is about generation. The useful direction runs the other way.
@22.q
I am increasingly interested in the opposite direction: using these systems to inspect, retrieve, verify, and challenge what I have written.
@22.sub
The machine is not producing prose. It is keeping an audit trail.

## 23 · Not yet data
@23.h
The knowledge base begins from documents that already exist. What if the material is not yet data?
@23.line
438 scanned volumes, 24 gigabytes of page images, and not one searchable word.
@23.cap
Historia Polski, 1951. Georg Eckert Institute library, Braunschweig.

## 24 · The pipeline
@24.h
Seven steps turn a textbook into data. The machine changed the cost of each.
@24.strip
438 volumes · 98,295 pages · 1948 to 2020 · 24 GB · Poland and South Korea

## 25 · OCR demo
@25.h
A vision-language model reads the whole page at once. Traditional OCR returns noise on the same scan.
@25.good.k
Vision-language model
@25.good.t
단군(檀君)은 실상 제사장의 이름으로서, 천왕을 받들어 위하던 고조선의 제주(祭主)요 군장이었다.
@25.bad.k
Traditional OCR (Tesseract)
@25.bad.t
AAs 2H] ade Ate ACM an, 2 ate … no usable output
@25.cap
A 1956 history textbook on Dangun and Gojoseon. The model reads the hangul and the hanja glosses, with no Korean-specific setup.

## 26 · Every arrow is a decision
@26.h
Every arrow is a methodological decision.
@26.line
This is research design, not assistance.

## 27 · Proxy as warning
@27.h
Without ground truth, accuracy is a proxy, and the proxy is a warning.
@27.line
When transcription error tracks language, it can pass for a cross-national difference in content.
@27.src
Character-level disagreement among nine OCR systems on 64 pages, preliminary. No human ground truth exists for this corpus, by a recorded decision.

## 28 · What can become data
@28.h
The technology changes what can become data.
@28.n1.v
67
@28.n1.l
Korean history textbooks, 1895 to 2016, already machine-readable
@28.n2.v
11.3M
@28.n2.l
characters of text, cleaned and tokenized
@28.n3.v
3 of 4
@28.n3.l
open models that must agree before a term counts
@28.line
Regime type sets the character of change and institutions set its timing. Nothing detectable moves at 1987. The shift comes with the 1992 to 1997 curriculum and the 2002 reform. Observational, not causal.

## 29 · Two uses
@29.h
Two uses of the workbench.
@29.c1
What do we know?
@29.c2
What can we make knowable?
@29.r1.a
Organizing existing knowledge
@29.r1.b
Producing new research data
@29.r2.a
Literature and sources
@29.r2.b
Primary historical material
@29.r3.a
Retrieval
@29.r3.b
Extraction
@29.r4.a
Verification
@29.r4.b
Transformation
@29.r5.a
Claim checking
@29.r5.b
Corpus construction
@29.bridge
Automate the machinery, not the judgment.

## 30 · Supervision coda
@30.h
The same logic runs the supervision desk.
@30.n1
Read
@30.s1
you
@30.n2
Annotate
@30.s2
you
@30.n3
Dictate
@30.s3
you
@30.n4
Structure
@30.s4
machine
@30.n5
Check
@30.s5
machine
@30.n6
Feedback
@30.s6
you sign
@30.line
The judgment stays mine. The machinery around it is increasingly automated.

## 31 · Students and professors
@31.h
The allocation differs for students and for professors.
@31.l.k
Students
@31.l.t1
Automate the clerical: formatting, filing, conversion.
@31.l.t2
Protect reading, first ideas, and every procedure you are still learning.
@31.l.t3
Collaborate only where you can check the output yourself.
@31.r.k
Professors
@31.r.t1
Automate more of your own machinery, and leave a trace.
@31.r.t2
Protect the formation of your students' judgment: the seminar, the exam, the supervision.
@31.r.t3
Redesign the process around what has become feasible.

## 32 · Allocation, not adoption
@32.big
The question for universities is allocation, not adoption.
@32.sub
Which cognitive work do we keep, which do we hand over, and where do new combinations make the impractical practical?

## 33 · Standout
@33.l1
Automate what does not deserve our attention.
@33.l2
Protect the work through which expertise is built.
@33.l3
Collaborate where machines expand what researchers can do.
@33.cta
Automate the machinery, not the judgment.
@33.by
Steven Denney · Leiden University

## 34 · Working in the open
@34.h
Working in the open.
@34.c1.k
Skills
@34.c1.t
Open Science Skills: 41 skills for Claude Code, 40 for Codex, grounded in published methods sources.
@34.c1.u
github.com/scdenney/open-science-skills
@34.c2.k
Site
@34.c2.t
AI for Research: setup, demos, lectures, and this deck.
@34.c2.u
scdenney.github.io/ai-for-research
@34.c3.k
Substack
@34.c3.t
Pixels and Patterns: the methods behind the corpus work, with code.
@34.c3.u
pixelsandpatterns.substack.com
@34.contact
Steven Denney · Leiden University · scdenney.net
@34.qrcap
These slides

## A1 · The nine systems
@A1.h
Appendix. Nine OCR systems compared on the same 64 pages.
@A1.r1.m
Qwen3.5-35B-A3B
@A1.r1.p
35B, 3B active
@A1.r1.q
GPTQ-Int4
@A1.r1.s
6.2
@A1.r2.m
Qwen3-VL-32B
@A1.r2.p
32B
@A1.r2.q
NF4
@A1.r2.s
30.0
@A1.r3.m
Qwen3.5-9B
@A1.r3.p
9B
@A1.r3.q
NF4
@A1.r3.s
22.8
@A1.r4.m
Gemma 4 E4B
@A1.r4.p
4.5B effective
@A1.r4.q
BF16
@A1.r4.s
15.4
@A1.r5.m
MiniCPM-V 4.5
@A1.r5.p
8B
@A1.r5.q
BF16
@A1.r5.s
53.3
@A1.r6.m
DeepSeek-OCR-2
@A1.r6.p
3.4B
@A1.r6.q
BF16
@A1.r6.s
12.1
@A1.r7.m
GPT-4.1
@A1.r7.p
API
@A1.r7.q
n/a
@A1.r7.s
8.2
@A1.r8.m
Claude Sonnet 4.6
@A1.r8.p
API
@A1.r8.q
n/a
@A1.r8.s
17.3
@A1.r9.m
Tesseract
@A1.r9.p
CPU
@A1.r9.q
n/a
@A1.r9.s
1.7
@A1.src
Seconds per page on one NVIDIA A40. Only Qwen3.5-35B ran under vLLM; the two APIs include network time. Run of 7 April 2026, preliminary.

## A2 · The deliverable pipeline
@A2.h
Appendix. The deliverable pipeline in eight steps.
@A2.s1
Open
@A2.s2
Braindump
@A2.s3
Intake
@A2.s4
Draft
@A2.s5
Gate
@A2.s6
Lint
@A2.s7
React
@A2.s8
Ship
@A2.line
One wiki per piece of research, one manifest per deliverable. The gate is a script that runs at every commit. Lint is a model review that runs only after the gate passes. This deck was built through it.

## A3 · Installing the skills
@A3.h
Appendix. Installing the skills.
@A3.cmd1
claude plugin marketplace add scdenney/open-science-skills
@A3.cmd2
claude plugin install oss@open-science-skills
@A3.line
Then name a skill, such as /oss:fact-check, or describe the task and let the matching skill load.

## A4 · References
@A4.h
Appendix. References.
@A4.r1.who
Kenny 2026
@A4.r1.text
Christopher T. Kenny, "Agentic AI for Political Science Research," Center for the Study of Democratic Politics, Princeton, 10 September 2026. github.com/christopherkenny/skills
@A4.r2.who
Swaney 2026
@A4.r2.text
Colin Swaney, "Claude Overload," Data-Driven Social Science workshop, Princeton, 20 March 2026. github.com/princeton-ddss/claude-overload
@A4.r3.who
Karpathy 2026
@A4.r3.text
Andrej Karpathy, "LLM Wiki," April 2026. gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
@A4.r4.who
Kremer 1993
@A4.r4.text
Michael Kremer, "The O-Ring Theory of Economic Development," Quarterly Journal of Economics 108(3): 551–575.
@A4.r5.who
Paglayan 2026
@A4.r5.text
Agustina S. Paglayan, "Education as a Political Institution," Annual Review of Political Science 29: 525–546.
@A4.r6.who
Denney 2026
@A4.r6.text
Steven Denney, "From Pixels to Patterns: Vision-Language OCR and LLM-Based Text Analysis," Machine Collaborators, 25 June 2026.
@A4.r7.who
Denney and van de Pol 2026
@A4.r7.text
Steven Denney and Aron van de Pol, "Constructing the Nation," working paper on Korean history textbooks, 1895 to 2016.
