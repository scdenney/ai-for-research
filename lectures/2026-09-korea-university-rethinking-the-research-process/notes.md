# Speaker notes: Rethinking the Research Process

Korea University · 18 September 2026 · Steven Denney

Revised 16 September 2026 after the cosmetic and foundations review. **32 main slides including the unnumbered cover, three unnumbered section dividers, and five numbered appendix slides: 40 PDF pages.** Main-talk budget: **55:00**. These are speaking notes and walkthrough beats, not a script to read continuously. Time is reserved for examining project artifacts, reading evidence plots and source excerpts, and audience reflection. Rehearsal remains necessary: the total is a delivery plan, not a measured performance.

## Delivery and evidence conventions

- Opening: **00:00–03:00**. Foundations: **03:00–13:00**. Part 1: **13:00–28:00**. Part 2: **28:00–45:00**. Part 3: **45:00–52:00**. Closing: **52:00–55:00**.
- The cover is unnumbered. Subsequent ordinary slides are **1–31**; appendices continue **32–36**. PDF pages also include the cover and dividers. The Part 1, Part 2, and Part 3 dividers are PDF pages **11, 19, and 30**; their transitions are included in the following slide's budget.
- Foundations precede the three modes. The goal is to understand the setup and begin one bounded task; installation stays on the Hub.
- Treat Automate, Protect, and Collaborate as the author's framework, not an empirically validated taxonomy, hierarchy, or sequence.
- The first research-repo task is an example request to inspect an existing project read-only, not a fresh audit receipt. Project and skill screenshots show existing artifacts; they do not demonstrate a successful run.
- Diagrams are explanatory schematics. The two learning figures redraw verified published estimates. The source image and historical manuscript excerpts are real artifacts. Part 3 is a historical reconstruction, not a new skill run.
- Routine provenance belongs here and in figure records. Necessary attribution and plot-reading information remain on slides. Evidence keys are expanded below.

## Cover. Rethinking the Research Process

**00:00–00:30 · 00:30 · PDF page 1**

I want to talk about how AI changes the work of research and how we teach that work. The setting today is an assistant that can read and act on project files. I will explain that working setup first, then discuss what to automate, what to protect, and how to collaborate. The practical material comes from the infrastructure I use in my own research.

**Walkthrough:** Establish the subject and audience. This is a research-workflow lecture with a concrete first task; setup and installation are available through the teaching website.

**Transition:** Here is what I would like you to be able to do by the end.

**Evidence:** Event details: lecture README; author affiliation in the prior approved deck.

## 01. What should change in our research practice?

**00:30–01:30 · 01:00 · PDF page 2**

By the end, I want you to understand the working arrangement: an agent, a project, instructions, and reusable procedures. You should be able to begin one bounded task and know what to inspect when it finishes. We will use the three modes to decide where assistance belongs and follow a source from acquisition to a checked claim. Open Science Skills is the collection of procedures I am building; AI for Research is the companion hub with setup guidance and worked explanations.

**Walkthrough:** Read the outcomes as things participants should be able to explain or try. Name both resources explicitly, without beginning a catalogue of tools.

**Transition:** All of this sits inside a research process that we already perform and teach.

**Evidence:** Author learning objectives; RES: both project READMEs and AI for Research getting-started page.

## 02. The process we perform and teach

**01:30–03:00 · 01:30 · PDF page 3**

We begin with questions and ideas. We locate sources, collect or assemble data, analyse them, and write. Checking can send us back to any of these activities. A source can change a question, an analysis can expose a design problem, and a draft can reveal what we still do not understand. The sequence is a schematic, not a rule that checking only happens at the end.

**Walkthrough:** Trace the aligned sequence and its return path. Ask the audience to keep one activity they do or teach in mind. That activity will provide a concrete example when we reach the three modes.

**Transition:** First, what changes when an AI assistant can act within this process?

**Evidence:** HIST: author framework, explicitly schematic.

## 03. An agent is a model that can use tools

**03:00–04:30 · 01:30 · PDF page 4**

A model produces a response or proposes a next action from the information available to it. In an agent application, that action can call a tool: read a file, search, run a command, or edit something. The tool returns a result, which becomes information for the next step. The application connects those steps and manages the available tools and permissions. The researcher supplies the purpose and checks whether the result answers it.

**Walkthrough:** Follow one small loop: ask where the bibliography is; search the project; read the returned file; report its location. Distinguish the model from the application and the tool that performed the search. This is a conceptual sequence, not a recording of a new run.

**Transition:** To do useful work, the agent needs a project to work in.

**Evidence:** KEN slides 4–9; local RR workflow. Tool access depends on the application and configuration; no exhaustive product comparison is implied.

## 04. The project lives in files, not just in a chat

**04:30–05:45 · 01:15 · PDF page 5**

A project gives the work an address. Sources, scripts, drafts, and instructions live in files rather than only in a conversation. A repository also records versions of the files we choose to track, so that we can inspect changes and return to a known state. Git is that version-history system; GitHub is one place a repository can be hosted. Working locally does not require publishing the project.

**Walkthrough:** Use the schematic file examples to distinguish sources, scripts, and the paper. Explain a folder before using the word repository. Explain what version history records, and why a saved version is not proof of correctness.

**Transition:** Being present in the folder is different from being information the model has read.

**Evidence:** RR scaffold; KEN slides 11–12. The folder examples are schematic. Git history does not include ignored originals merely because they sit inside a repository.

## 05. Context: what the model can work from now

**05:45–07:00 · 01:15 · PDF page 6**

Context is the working information supplied to the model: our request, relevant instructions, selected file contents, and results from previous actions. The project may contain hundreds of files without all of them being in the current context. The system must find and read what matters. Context is finite; project files provide durable material that can be consulted again. A saved decision note can help resume work, but it can become stale.

**Walkthrough:** Distinguish the larger project from the smaller working set. Ask which files are needed for a particular question. Avoid fixed token limits or suggesting that saving a file trains the model or guarantees it will be read.

**Transition:** Some recurring context tells the assistant how this project works.

**Evidence:** KEN slides 5–8 and 32; RR project instructions and source-library design.

## 06. Project instructions establish local rules

**07:00–08:15 · 01:15 · PDF page 7**

Project instruction files record things we otherwise repeat: the purpose of the project, where material lives, conventions, and limits on what the assistant should do. Here the project uses CLAUDE.md and AGENTS.md to make those instructions available to its agents. One rule says, “A .NOTE.md is not a source.” That tells the assistant not to treat our summaries as the documents supporting a research claim. These are written instructions, not an enforcement mechanism or a guarantee of compliance.

**Walkthrough:** Name the instruction file, then read the short source-versus-note rule. Distinguish project guidance from access permissions. The relevant filename and loading rules depend on the application; avoid a vendor-by-vendor workshop.

**Transition:** Project instructions carry local conventions. A skill packages a procedure we can reuse.

**Evidence:** NWO AGENTS.md, Sources section, linked to CLAUDE.md; RR scaffold. Exact quote provenance appears in the accuracy register.

## 07. A skill makes a research procedure reusable

**08:15–09:45 · 01:30 · PDF page 8**

A skill is a written procedure the agent can consult for a recurring task. Its name and description help identify when it is relevant. Its body gives steps, required inputs, and expectations for the result; supporting references or scripts may accompany it. It is not a new model and does not make judgment disappear. Open Science Skills is where I maintain these procedures. Research-repo distinguishes setting up a new project from inspecting an existing one.

**Walkthrough:** Inspect the actual audit-mode paragraph from research-repo SKILL.md. Connect its existing-project condition, present/partial/missing report, and overwrite restriction to the purpose/procedure/output explanation above it. The name and description are useful skill metadata but are outside this crop. A skill invocation starts a procedure; it does not certify its completion.

**Transition:** We can use that skill for a deliberately small first task.

**Evidence:** RR front matter and Step 1; OSS README. The screenshot shows the published audit-mode paragraph at OSS commit 310509da268d7633a03e4e14f797eedd9d7df8dc, not an execution receipt. See overleaf/figures/browser-capture-provenance.md.

## 08. A first task: inspect an existing research project

**09:45–11:30 · 01:45 · PDF page 9**

I would begin by asking the agent to understand the project before changing it. In the existing immigration research repository, invoke research-repo and ask for a read-only audit. Name the target and inspect the source folders, bibliography links, intake process, and project instructions. Ask what is present, missing, or uncertain, with paths behind each assessment. Explicitly say not to create, move, edit, or delete files.

**Walkthrough:** Read the example request and identify target, task, boundary, and expected output. The slide gives Claude and Codex invocation forms; these select the skill while ordinary language narrows its scope. Ask for the next three proposed actions as well as the file evidence. This is the existing NWO project, not an empty folder. Do not execute a broad scaffold or imply a fresh audit has already run.

**Transition:** The next step is deciding whether its findings are credible and useful.

**Evidence:** RR audit mode; NWO project path and existing source conventions. Teaching prompt for a read-only task, not a newly executed report.

## 09. Review the findings before authorizing changes

**11:30–13:00 · 01:30 · PDF page 10**

Each finding should name what was inspected and why it matters. Does the bibliography actually map to source files? Is something missing, or stored under a different name? Can the assistant show the path or passage behind its conclusion? This project uses references_master.bib, which differs from the generic scaffold without necessarily being wrong. Only after reviewing the findings would I choose a change. Then I would inspect the changed files and record the decision.

**Walkthrough:** Walk through review questions, not invented pass/fail results. For this read-only task there should be no file changes to accept. For a later authorized edit, version history makes the change inspectable. A plausible summary is not evidence that an audit was completed.

**Transition:** Now that the working arrangement is concrete, we can ask where it belongs in research and teaching.

**Evidence:** RR audit instructions; NWO sources/references_master.bib; KEN version-control discussion. These are review criteria, not a new audit receipt.

## 10. What role should human cognition play?

**13:00–15:00 · 02:00 · PDF page 12**

Automate when the aim is to get routine work done. Protect when doing the work develops or demonstrates knowledge and judgment. Collaborate when human judgment and machine capability can be combined usefully. These are choices about a task, not stages or levels of sophistication. The same person can use all three in one project. The same task can change modes when its learning objective changes.

**Walkthrough:** Read across purposes and examples. Give the learning-objective qualification its own pause. Return to the activity chosen at the start and invite participants to place it provisionally.

**Transition:** Start with work that gains little from repeated manual attention.

**Evidence:** HIST: author framework and approved three-mode diagram; no claim of an empirically validated taxonomy.

## 11. Automate without guilt

**15:00–16:45 · 01:45 · PDF page 13**

I think we should be aggressive about this. There is no special virtue in renaming a hundred files by hand or repeatedly applying the same formatting rule. The useful question is whether I can state the intended result and inspect it at a reasonable cost. I still own the outcome. Automation saves attention that I can use for work where my attention makes a difference.

**Walkthrough:** Walk through one rule, such as author-year filenames, and its visible check. Distinguish formatting a reference from deciding whether it supports a claim.

**Transition:** Saving effort is valuable, except when the effort is the point.

**Evidence:** Author workflow examples; no quantitative productivity claims.

## 12. Protect the thinking the task should develop

**16:45–19:00 · 02:15 · PDF page 14**

Reading is the clearest case for me. I need to encounter an argument, work through its meaning, and decide what I think. A generated summary can leave me with an answer but without the ability to assess it. Imagine a student learning to interpret a difficult article and a researcher comparing work they already know. Assistance that helps the second activity can undermine the first. This is not a permanent distinction between students and professors: I also need protected practice when I enter a new literature. I am less settled about early drafting and seed ideas; those remain questions for discussion.

**Walkthrough:** Trace the visible-thinking sequence: annotate a source, state an interpretation, build an argument, and explain the choices. This adapts my teaching approach in HDW/HBIR; it is a pedagogical design, not a claim that a process record proves independent cognition. Use the same hypothetical article for the two purposes. Ask what the person should be able to explain without assistance. Distinguish obtaining an output from developing the capability to produce or assess one. No actual student material is shown.

**Transition:** Two studies sharpen that distinction and show why a general claim that AI harms learning would be too simple.

**Evidence:** HIST: author position and hypothetical teaching example. AUT and BAS inform the assisted-performance/unaided-outcome distinction without testing this exact reading scenario.

## 13. Better output does not imply the same learning

**19:00–21:45 · 02:45 · PDF page 15**

Autor and colleagues ran a three-month experiment with practicing patent lawyers. Separate drafting when AI was available from redlining without AI. Assisted-drafting estimates are positive in both experience groups, though the senior estimate is imprecise at the conventional 95 percent level. On unaided redlining, the junior average is close to zero and the senior estimate is positive. Juniors did not decline on average. The authors also report greater dispersion among juniors, a different result from saying everyone lost skill. Professional experience was not randomly assigned. This is evidence about these tasks and lawyers, not a direct estimate for graduate research.

**Walkthrough:** Explain the zero line, control-group standard-deviation units, and approximate intervals. Read the estimates: junior assisted drafting 0.60, senior 0.30; junior unaided redlining −0.03, senior 0.45. These are different tasks at 90 days, not an individual trajectory. Do not infer a statistically significant subgroup difference because one interval excludes zero and another does not.

**Transition:** Prior expertise is one consideration. The design of assistance is another.

**Evidence:** AUT: NBER Working Paper 35720, Tables 4 and 6, column 4; Figure 3 and Table 7 for junior dispersion. Full captions and uncertainty details below and in overleaf/figures/evidence-plot-provenance.md.

## 14. The design of assistance matters

**21:45–24:30 · 02:45 · PDF page 16**

Bastani and colleagues compared unrestricted GPT assistance, a tutor designed with instructional guardrails, and a no-AI control in high-school mathematics in Turkey. Both AI groups did better on assisted practice. On the subsequent unaided exam, the unrestricted group performed worse than control; the tutor estimate was close to zero. The tutor mitigated the harm observed here. It did not establish a learning gain over control or show that guardrails generally improve learning. In a separate programming experiment, Bassner and colleagues found better assisted performance without greater measured learning in either AI condition. Design, domain, and duration matter.

**Walkthrough:** Read practice and exam as distinct outcomes. These are percentage-point effects relative to control: practice +13.7 and +36.1; exam −5.4 and −0.4. Do not call −5.4 a 5.4 percent relative decline, connect the panels as individual trajectories, or equate an interval spanning zero with equivalence.

**Transition:** The purpose of the task should guide collaboration. A better-looking product does not settle the learning question.

**Evidence:** BAS: PNAS, Table 1; primary-source plot provenance below. BASS: primary TUM publication record and abstract checked 16 September 2026; a supporting qualification, not a plotted result.

## 15. Collaborate with a decision still to make

**24:30–26:15 · 01:45 · PDF page 17**

I use collaboration to mean work in which the machine changes what I can do, while I retain decisions about the purpose and the result. It can help compare sources, review code, or structure feedback I have dictated. That does not mean I approve everything at the end without knowing what happened. I need to decide what material the system can use and what evidence I will require before accepting its output.

**Walkthrough:** Use source synthesis as one example: pose the question, identify inputs, inspect the passages behind a proposed comparison.

**Transition:** Research makes this difficult because many errors do not announce themselves.

**Evidence:** RR, FC; supervision workflow in HIST.

## 16. Research needs more than executable checks

**26:15–28:00 · 01:45 · PDF page 18**

Software often offers executable feedback: a program fails, or a test disagrees with an expected result. Such checks are valuable but incomplete. Research also has code and numerical checks. It additionally requires judgments about measurement, inference, interpretation, and sources. A sentence can read well and cite a real paper while describing its findings incorrectly. A resolving DOI can point to the wrong work. Nothing in the writing software has to fail for these errors to survive.

**Walkthrough:** Contrast a failed test with a mistaken attribution. Distinguish source existence, correct identity, and support for a particular claim. Do not suggest that software correctness is easy or less important. Keep the actual project example for Part 3.

**Transition:** We need to organize the project so that the relevant evidence is available to inspect.

**Evidence:** KEN software/research comparison, critically qualified; CC and FC. Teaching distinctions, not reported project findings or comparative error-rate estimates.

## 17. Build the project around its sources

**28:00–29:45 · 01:45 · PDF page 20**

Research-repo sets up or audits the working repository. For a project with a source library, it creates a place for originals, readable conversions, incoming sources, and the bibliography. It also sets up the conversion and intake process, plus instructions for agents working in the project. Analysis and manuscript folders grow around that source library. The scaffold adapts to the project. A theory paper without a PDF corpus need not acquire one just to satisfy a template.

**Walkthrough:** Walk down the scaffold excerpt from the published skill and explain the role of each item. Explain the difference between creating the intake procedure and running it on a new source.

**Transition:** Now consider what happens when we acquire one paper.

**Evidence:** RR §§2–6, scaffold paths verified; screenshot of the published skill excerpt, not a snapshot or audit of the NWO project. NWO master bibliography has a different name.

## 18. Bring a source into the project

**29:45–31:30 · 01:45 · PDF page 21**

This is a real source from the project we will use in the final example. At the top is a cropped excerpt of the original author-copy PDF. Below it is text from its Markdown conversion. The point of conversion is to make the source available for searching and reading in the workspace. It does not certify the extraction. Headings, columns, tables, and wording can be damaged, so the conversion needs inspection.

**Walkthrough:** Read the matching passage in the image and text. Explain acquisition and registration before moving on. Mention doc-to-markdown as a conversion option; do not turn this into an OCR-corpus demonstration.

**Transition:** Next, connect that readable text to the reference used in the manuscript.

**Evidence:** DEMO PDF first page and Markdown abstract; RR intake; crop provenance in figures/README.md.

## 19. Build a library that claims can be checked against

**31:30–33:30 · 02:00 · PDF page 22**

The manuscript uses a citation key. The bibliography identifies the work, and the source files let us inspect what it says. The original is what we acquired; the conversion is a readable representation. Derived summaries and comparisons are interpretations linked to those sources. A project decision records what we chose and why. All four are useful, but answer different questions. A decision record or summary cannot substitute for the source passage needed to support a fine-grained claim.

**Walkthrough:** Trace the source-to-citation mapping, then the separate derived-notes branch. Identify the original, conversion, possible note, and recorded revision for the paper just shown. The NWO bibliography is sources/references_master.bib; the generic scaffold uses sources/references.bib. What matters is a reliable mapping, not one compulsory filename.

**Transition:** This persistent source-linked workspace is related to the knowledge-base idea in Kenny’s presentation.

**Evidence:** RR; FC; NWO rule separating .NOTE.md from source evidence. The four-part distinction is this lecture’s synthesis, not an attributed taxonomy or a claim that all summaries are useless.

## 20. A knowledge base, related to the LLM wiki

**33:30–34:45 · 01:15 · PDF page 23**

Kenny asks how a general tool can work helpfully with specialist knowledge. His final example discusses giving the model papers, summarizing them, and preserving a workspace across time. He relates it to Karpathy’s LLM wiki concept. I am doing something closely related. The emphasis here is on retaining the connection between a source, the text we can inspect, the notes we derive, and the claim we eventually write.

**Walkthrough:** Compare the shared purpose and the different organization. Do not attribute this implementation or the Open Science Skills collection to Kenny. These are related approaches, not identical systems.

**Transition:** Once we have that library, we can use it for more than checking.

**Evidence:** KEN pp31–32; title and author from p1. Local reference PDF.

## 21. Work with the library

**34:45–36:15 · 01:30 · PDF page 24**

A useful question is narrower than asking the system to write the literature review. I might ask how a defined set of papers uses a concept, and require passages for each proposed distinction. The assistant can organize that comparison. I then decide whether the distinctions are meaningful, whether a source has been missed, and whether the synthesis fits the question. Literature-review is one skill that can structure this work with the library.

**Walkthrough:** Walk through the example question without supplying invented findings. Explain how source links make it possible to challenge a proposed distinction.

**Transition:** The same library lets us inspect a draft’s citation layer.

**Evidence:** LR and RR; procedural-legitimacy prompt is illustrative.

## 22. Citation-check: inspect the citation layer

**36:15–38:00 · 01:45 · PDF page 25**

Citation-check starts with the manuscript and bibliography. It checks whether the citation points to the intended work and whether the reference information is consistent. External records can help, but an API response still has to be matched to the right article. The skill also inspects how a citation is used. It is not a completely deterministic process, and an unresolved lookup should be reported as unresolved rather than treated as proof of fabrication.

**Walkthrough:** Explain the difference between a DOI resolving and resolving to the intended work. Note that support checking overlaps with fact-check; these are related workflows, not sealed categories.

**Transition:** Fact-check then concentrates on the claim and the source passage.

**Evidence:** CC §§1–6; lookup services and uncertainty rules checked in SKILL.md.

## 23. Fact-check: compare the claim with the source

**38:00–39:45 · 01:45 · PDF page 26**

Fact-check is a comparison against the project’s source library. It requires a prepared knowledge base and starts with citation-check. For each substantive claim, it locates the relevant source and asks whether the passage supports the sentence. A weaker or narrower finding should not become a stronger claim. Missing source text is a limit on what we have checked, not a successful result. The output is evidence for a decision about the draft.

**Walkthrough:** Talk through the inputs and assessment in order. Mention that a faithful full-text conversion can support a finer check than a summary. A summary’s silence does not establish that a source contains no relevant passage.

**Transition:** A traceable check is valuable, but its limits still matter.

**Evidence:** FC §§1–5; current readiness conditions documented in appendix slide 33.

## 24. What this foundation can establish

**39:45–41:15 · 01:30 · PDF page 27**

It would be a mistake to call this a truth machine. A sentence can faithfully describe a flawed study. The source library can omit an important work. A conversion can lose a table note. An assistant can misread a passage even when that passage is available. What we gain is a more inspectable process: we can see the claim, the proposed evidence, the assessment, and the revision. That helps us find and correct errors.

**Walkthrough:** Return to the research/software comparison. Ask what additional expertise would be needed to assess the underlying study’s design.

**Transition:** The same question about responsibility also applies in supervision.

**Evidence:** FC, CC, and explicit methodological limits; no claim of measured error reduction.

## 25. Supervision: keep the judgment human

**41:15–42:45 · 01:30 · PDF page 28**

I read the work and form the judgment. I annotate it and dictate feedback. The machine can then help structure that feedback and format a document. That is useful collaboration, but it must not quietly replace my assessment with a more polished one of its own. I need to check whether the resulting text expresses the judgment I actually made, including the uncertainty and the priorities I intended.

**Walkthrough:** Follow the human and machine contributions. Explain that a well-written feedback letter can still distort the supervisor’s view if the final review is skipped.

**Transition:** At the end of a research project, someone outside it also needs to inspect the work.

**Evidence:** HIST: read, annotate, dictate, structure, check, format, edit. No actual student artifact.

## 26. Make the results reproducible by others

**42:45–45:00 · 02:15 · PDF page 29**

A working repository and a replication package serve different readers. The package should tell a competent researcher how to regenerate the published results without hidden manual steps. The skill helps organize a README, an entry script, the environment, and a mapping from results to the code that produces them. If data cannot be released, access conditions need to be explicit. Preparing a package does not mean automatically uploading the whole working repository.

**Walkthrough:** Trace working repository → curated package → independent rerun. Name what must be selected and documented at the handoff, then ask whether an independent researcher can regenerate the reported outputs. Explain one-command regeneration as a target, not a claim that NWO has passed an independent audit. Acknowledge Horiuchi’s guide.

**Transition:** Now I will show one historical example of a source changing a claim.

**Evidence:** RP standard and heritage; https://github.com/yhoriuchi/replication-package-guide .

## 27. The claim and its references

**45:00–47:00 · 02:00 · PDF page 31**

This sentence appeared in a draft of my paper on immigration policy and procedural legitimacy. Two works followed the clause as references. The sentence attributed a particular finding to the literature: that citizens penalize executive action relative to legislation. I am showing the historical wording, not a newly generated demonstration. Read the claim before we look at the source. What result would establish it?

**Walkthrough:** Give the audience time to read the excerpt. Identify the implied comparison and direction of the finding. Explain that the surrounding sentence included other qualifications, but these are the exact words attached to the two references.

**Transition:** The reference existed. Acquiring the text let us examine what it actually found.

**Evidence:** DEMO: git show 75366c6^:sections/frontmatter/front_matter.tex .

## 28. What the acquired source said

**47:00–49:30 · 02:30 · PDF page 32**

The abstract says Americans do not instinctively reject unilateral action as a threat to checks and balances. It goes on to explain the role of partisan and policy agreement. That should make us stop before using the paper as straightforward evidence for the penalty described in the draft. The study still examines relevant questions about unilateral action. The problem is what this sentence was asking it to establish.

**Walkthrough:** Read the quotation and paraphrase the remainder of the same sentence. Contrast its direction with the draft. Explain that a full audit would read the relevant experiments and surrounding discussion, not treat one abstract sentence as a universal finding.

**Transition:** The correction separates the claims attached to the two works.

**Evidence:** DEMO Markdown abstract and original PDF; source metadata in sources/references_master.bib.

## 29. The reference existed. The claim needed revision.

**49:30–52:00 · 02:30 · PDF page 33**

The revision describes people judging particular unilateral acts largely by whether they agree with them. That clause is now attached to Christenson and Kriner alone. A separate clause describes generalized support for unilateral powers and cites Reeves and Rogowski. The source changed the claim and the attribution. The recorded change makes that decision inspectable. It does not prove that every other claim in the paper, or every later version, is correct.

**Walkthrough:** Read the three rows in sequence. Explain that the revision is an excerpt from a longer sentence. This is a reconstruction from source files and a real diff, not a fact-check report printed by a newly executed skill.

**Optional discussion beat:** Research on reliance gives this example a wider purpose. Spatharioti et al. (2025) show how users can follow an erroneous LLM answer. Kim et al. (2025) find that explanations can increase reliance on correct and incorrect answers, while sources and visible inconsistencies can help people resist wrong answers in their experiment. That supports inspecting actual evidence; the mere presence of a citation is not a correctness guarantee. Neither experiment evaluates this research workflow directly.

**Transition:** The value is a process in which we can make and inspect this correction.

**Evidence:** DEMO: 75366c6, front_matter.tex; exact before/after excerpts verified.

## 30. What to take into your own work

**52:00–53:30 · 01:30 · PDF page 34**

Start with one project and one bounded task. Use the read-only research-repo example to inspect what is already there before reorganizing it. Identify routine work to automate, an activity to protect because doing it develops understanding, and a collaboration whose inputs and evidence you can inspect. You do not need every skill. You do need to know what the assistant is doing and what decision remains yours.

**Walkthrough:** Return to the activity selected near the start. Reconsider its mode, identify the relevant files, and name a check to perform before accepting assistance. Tie the conceptual choice to the practical first task.

**Transition:** The resources support that first attempt and the questions it raises.

**Evidence:** Author framework; RR audit-first teaching prompt and demonstrated source-checking process.

## 31. Resources and discussion

**53:30–55:00 · 01:30 · PDF page 35**

The website has the setup walkthrough and worked examples. The skills repository has the procedures themselves. Kenny’s presentation was an important point of reference for thinking about agents and persistent knowledge. I would like to open the discussion with the question on the slide. Which part of your research or teaching would you deliberately protect, and what would make you reconsider that boundary?

**Walkthrough:** Point to the actual AI for Research getting-started capture and the two clickable resource links, then leave the slide visible for discussion. Likely questions: how much source reading is enough; whether a second model is an independent check; what to do with restricted sources; and how students can develop judgment while using these tools.

**Transition:** Invite the moderator to begin the discussion.

**Evidence:** RES and KEN; public resource links checked 16 September 2026.

## Appendix notes

### 32. Source intake: what happens between the folders

**Outside the 55-minute budget · PDF page 36**

Explain naming and identity before conversion. The scaffold uses `sources/references.bib`; NWO uses `sources/references_master.bib`. Originals remain archival, while source text is convenient for searching and checking; consult the original when extraction is in doubt. `research-repo` creates the intake process; local `process-source` carries out intake, with `doc-to-markdown` supplying conversion options. Do not promise perfect conversion of tables, mathematics, or page locators. Keeping an original privately does not grant permission to redistribute it or its conversion.

**Evidence:** RR §§3–7; doc-to-markdown; NWO conventions.

### 33. When a source check is not ready

**Outside the 55-minute budget · PDF page 37**

The current fact-check skill requires a prepared per-source Markdown knowledge base and no unconverted source backlog. It treats coverage below roughly two-thirds of cited non-background works in scope as not ready. This is an operational threshold, not a statistical guarantee or permission to ignore the uncovered third. Citation-check runs first. Missing, ambiguous, or insufficient sources remain visible. NWO additionally prohibits treating `.NOTE.md` summaries as source evidence. A summary's silence does not show that the original contains no relevant passage. No fresh full-project readiness result is claimed.

**Evidence:** FC §1 and §4–6; NWO AGENTS.md, Sources section. The skill can accept summaries in some settings but explicitly distinguishes their limits from faithful conversions; the local project rule is stricter.

### 34. Document the use of AI

**Outside the 55-minute budget · PDF page 38**

Ask what a reader needs to know to understand the assistance and inspect consequential decisions. Describe the task, tools and materials, human review, and limitations as relevant. This is the lecturer's discussion aid, not a universal disclosure template or a substitute for journal or institutional policy. The historical manuscript includes a Use of AI statement; its full model list is not reproduced. Absence of an AI record would not prove that a task was performed entirely without AI.

**Evidence:** Historical manuscript and prior notes audit; author disclosure discussion. No current journal-policy claim is made.

### 35. Performance and learning need different evidence

**Outside the 55-minute budget · PDF page 39**

Read the three-study table by what was measured and when. Autor separates 90-day drafting with assistance from unaided redlining. Bastani separates assisted practice from the subsequent unaided mathematics exam. Bassner's 90-minute programming experiment measures exercise performance and conceptual learning separately; improved exercise results did not establish greater knowledge gains or code comprehension. This is a selected comparison, not a systematic review or a pooled effect estimate. A better assisted product does not establish retained understanding. A null estimate does not establish equivalence. Do not compare effect magnitudes across standard-deviation units and percentage points.

**Evidence:** AUT Tables 4 and 6; BAS Table 1; BASS primary abstract; figure provenance below. The broader leads in `planning/09-evidence-protect.md` are not all newly audited here. The word learning refers to each study's actual assessment, not a uniform outcome shared across studies.

### 36. What might protect learning?

**Outside the 55-minute budget · PDF page 40**

Relevant prior knowledge is specific to the task. Shen and Tamkin's experiment recruited people with Python experience who had never used the Trio library being tested. Their preprint reports lower subsequent quiz performance with AI assistance. This was an Anthropic-affiliated study; identify that affiliation and its preprint status. The study's observed interaction patterns were not themselves randomly assigned, so avoid turning them into proven instructional prescriptions.

Melumad and Yun compare learning from LLM syntheses with web search. Across seven experiments they examine reported depth of learning and the substance and reception of advice participants subsequently produced. The reported-learning measures are not a direct test of long-term retention. These findings motivate keeping active engagement with sources in view; they do not test this lecture's research-repo workflow or establish a universal rule for graduate researchers.

**Walkthrough:** Explain why general seniority differs from familiarity with a new task. Then distinguish a participant's report of learning from the observable qualities of the advice produced. Bring the discussion back to what the task is intended to develop.

**Evidence:** SHEN §4.3 and §5.2; MY abstract and main results. The application to protected reading and research judgment is the lecturer's inference. For the main figures, retain the separate qualifications: Autor's junior result is not average decline; Bastani's tutor did not establish a learning gain; neither plotted study measures graduate research skills or follows participants beyond three months.

## Evidence register

- **HIST:** Steven Denney's framework, examples, and project history in the lecture planning wiki. Hypothetical teaching examples remain hypothetical.
- **RES:** [AI for Research](https://scdenney.github.io/ai-for-research/), local `README.md` and `docs/getting-started/index.html`; [Open Science Skills](https://github.com/scdenney/open-science-skills), its README and skill sources. Installation belongs on the Hub. Avoid stale skill counts or describing a skill as merely a command.
- **KEN:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, CSDP / Data-Driven Social Science. Local PDF: `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`; foundations on slides 4–12, instructions and skills on 20–26, persistent knowledge on 31–32. Adapting its sequence does not endorse every comparison or product-specific claim.
- **RR, CC, FC, LR, RP:** `research-repo`, `citation-check`, `fact-check`, `literature-review`, `replication-package` under `/Users/scdenney/Documents/github/resources/open-science-skills/plugin/skills/`. A procedure's existence does not establish a successful run. RP acknowledges [Yusaku Horiuchi's guide](https://github.com/yhoriuchi/replication-package-guide).
- **NWO / DEMO:** `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash`. Final-example provenance appears in the accuracy register. The first task uses the same existing project for an illustrative read-only repository audit.
- **AUT:** Autor et al. (2026), *Does AI Assistance Enhance or Erode Expertise? Evidence from a Three-Month Field Experiment in Patent Drafting*, [NBER Working Paper 35720](https://www.nber.org/papers/w35720). [Author full text](https://shapingwork.mit.edu/wp-content/uploads/2026/09/Autor-et-al-Sept-2026.pdf). Working paper, not a published journal article.
- **BAS:** Bastani et al. (2025), *Generative AI without guardrails can harm learning: Evidence from high school mathematics*, [PNAS 122(26), e2422633122](https://doi.org/10.1073/pnas.2422633122). [Author full text](https://hamsabastani.github.io/education_llm.pdf). The [published correction](https://doi.org/10.1073/pnas.2518204122) fixes Osbert Bastani's affiliation, not reported findings.
- **BASS:** Bassner et al. (2026), *Less stress, better scores, same learning: The dissociation of performance and learning in AI-supported programming education*, [Computers and Education: Artificial Intelligence 10, 100537](https://doi.org/10.1016/j.caeai.2025.100537). [Primary TUM record and abstract](https://portal.fis.tum.de/de/publications/less-stress-better-scores-same-learning-the-dissociation-of-perfo/), checked 16 September 2026. Three-arm programming experiment, N = 275; a limited qualification, not a third plotted result.

- **SHEN:** Judy Hanwen Shen and Alex Tamkin (2026), [How AI Impacts Skill Formation](https://arxiv.org/abs/2601.20245), arXiv:2601.20245v2, preprint. [Full text](https://arxiv.org/html/2601.20245v2), §4.3 and §5.2, checked 16 September 2026: main analysis N = 52; participants had Python experience and no prior Trio use. Work conducted through the Anthropic Fellows Program/Anthropic. No additional quantitative result is plotted here.
- **MY:** Shiri Melumad and Jin Ho Yun (2025), [Experimental evidence of the effects of large language models versus web search on depth of learning](https://doi.org/10.1093/pnasnexus/pgaf316), PNAS Nexus 4(10), pgaf316. Published abstract and main findings checked 16 September 2026. Use the published seven-experiment record, not an earlier four-experiment working-paper abstract.

- **RELIANCE:** Spatharioti et al. (2025), *Effects of LLM-based Search on Decision Making: Speed, Accuracy, and Overreliance*, CHI ’25, [DOI 10.1145/3706598.3714082](https://doi.org/10.1145/3706598.3714082), [Microsoft Research record](https://www.microsoft.com/en-us/research/publication/effects-of-llm-based-search-on-decision-making-speed-accuracy-and-overreliance/). Kim et al. (2025), CHI ’25, [DOI 10.1145/3706598.3714020](https://doi.org/10.1145/3706598.3714020), [Princeton author PDF](https://cognition.princeton.edu/sites/g/files/toruqf3386/files/documents/fostering_reliance_0.pdf). Qualitative supporting discussion only; no new quantitative plot or general guarantee about citation interfaces.
- **TEACHING:** Author's `courses/hdw/shared/admin/ai-theme-feedback-202604/ai_feedback_v2.md`, sections 2–4; HBIR `guidelines/hbir_ai-use-statement_wgr107_DRAFT.md`. These motivate making thinking visible and distinguishing assistance from bypassing practice. The HBIR file remains a draft; this lecture does not announce a finalized course policy or repeat broad causal claims from it.

## Complete figure captions and calculation provenance

### Autor figure

Intent-to-treat effects of access to a custom AI drafting assistant on expert-rated work in a three-month randomized field experiment with 133 practicing patent lawyers at 11 U.S. firms. Left: drafting with AI available at 90 days; right: redlining without AI at 90 days. Junior means fewer than seven years of legal experience; senior means seven or more. The plotted outcomes are rating subcomponents standardized using the control group in the active sample. Tables 4 and 6, column 4, use rating-level OLS with firm and sub-indicator fixed effects and inverse-rating-count weights; standard errors are clustered by individual. The drafting model includes 995 ratings (the corresponding subject-level model has 98 lawyers); redlining includes 925 ratings (91 lawyers in the corresponding subject-level model). Whiskers are approximate 95% intervals calculated from rounded published estimates and standard errors, not author-reported exact intervals.

### Bastani figure

Intent-to-treat effects of GPT Base and GPT Tutor relative to a no-AI control in a randomized high-school mathematics experiment in Turkey. Left: normalized grades on assisted practice problems; right: normalized grades on subsequent unaided exam problems across four sessions. Table 1 reports 2,848 student-session observations in each model; Appendix Table 3 reports 839 students in the main survey sample, excluding honors classes and nonrespondents. Estimates adjust for prior GPA and session, grader, grade-level and teacher fixed effects, with HC1 robust standard errors clustered by classroom, the assignment unit. Whiskers are approximate 95% intervals calculated from the rounded published estimates and SE. Effects are multiplied by 100 to express percentage points.

The published inputs, table locators, intervals, downloaded-source hashes, and interpretation limits are recorded in `overleaf/figures/evidence-plot-provenance.md`. `evidence-estimates.csv` holds the inputs; `build-evidence-plots.py` creates vector figures and `evidence-intervals.csv`. Intervals use estimate ± 1.96 × published rounded SE. No estimates were read from chart pixels. The author-copy source crop is documented in `overleaf/figures/README.md`. The authentic browser captures are documented in `overleaf/figures/browser-capture-provenance.md`: published research-repo audit-mode paragraph and sources-only scaffold at OSS commit `310509da268d7633a03e4e14f797eedd9d7df8dc`, plus the deployed AI for Research getting-started introduction. These are captures of existing public material, not new audit receipts. The shown skill is the Claude variant; Codex instruction/intake-file conventions differ.

## Accuracy guardrails for the rebuilt deck

These preserve the previous deck's accuracy guardrails while updating the structure and adding the learning-evidence figures. The earlier file and its findings remain available in git history and `planning/codex-notes-review-2026-09-16.md`. None of the old project counts, activity counts, audit totals, costs, run timings, or synthetic citation examples is carried onto the new slides. Published study estimates are separately documented above.

- **Event and affiliation:** Korea University, 18 September 2026; Steven Denney, Leiden University. Source: lecture README and prior approved title page. No unverified job title or biography was added.
- **Talk counts/timing:** 32 main slides including the unnumbered cover, three unnumbered dividers, five appendices, 40 PDF pages. Numbered slides run 1–31 in the main talk and 32–36 in the appendix. The section budgets sum to 55:00; rehearsal still required.
- **Kenny reference:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, CSDP / Data-Driven Social Science. Source PDF `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`, title on p1 and LLM wiki discussion on pp31–32. The persistent-workspace idea is related to this implementation, not identical. Kenny names Karpathy's LLM Wiki concept. Do not attribute the OSS skills to Kenny.
- **Project-instruction quote (6):** exact substring “A `.NOTE.md` is not a source” from `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash/AGENTS.md`, Sources section. This file is the project CLAUDE.md link. It is a local rule, not a general claim that no summarization can ever be useful.
- **Retained skill-quote provenance:** exact substring “For multi-source claims, check each source’s contribution separately” from `plugin/skills/fact-check/SKILL.md`, §3, in `/Users/scdenney/Documents/github/resources/open-science-skills`. Punctuation around the quote is typeset; wording is preserved.
- **Scaffold (17,19):** generic paths come from research-repo. The bibliography in its tree is `sources/references.bib`. The NWO historical example uses `sources/references_master.bib`. Research-repo creates the local intake process; process-source runs intake. The converted-source folder is not the same thing as generated summaries.
- **Source artifact (18,28):** acquired author-copy PDF and Markdown file at `sources/og/christenson-kriner-2017-constitutional-qualms-unilateral.pdf` and `sources/md/christenson-kriner-2017-constitutional-qualms-unilateral.md` in the NWO project. The displayed image is a crop of the first-page abstract; its author copy has a 2016 production footer. Bibliographic publication year is 2017. Do not infer a metadata mismatch from the production footer.
- **Published metadata:** Christenson and Kriner (2017), *Constitutional Qualms or Politics as Usual? The Factors Shaping Public Support for Unilateral Action*, AJPS 61(2), 335–349, DOI `10.1111/ajps.12262`. Source: `sources/references_master.bib`, `ChristensonKriner2017`.
- **Exact source excerpt (18,28,29):** “Americans do not instinctively reject unilateral action as a threat to our system of checks and balances”. Source: Markdown abstract, line 7, checked against the original PDF. It is a clause within a longer sentence about partisan and policy preferences, not the complete conclusion of the article.
- **Acquisition:** 27 August 2026, `sources/ACQUIRE.md`, the acquired-sources subsection dated 2026-08-27. The record documents resulting corrections; it is not the source for the quoted finding.
- **Historical correction:** manuscript submodule `papers/2-legitimacy-policy-process/manuscript`, commit `75366c6ca9ecc96148acba4840a4853c73f47c43`, dated 27 August 2026, `sections/frontmatter/front_matter.tex`. Old excerpt: “studies of unilateral policymaking similarly show that citizens penalize executive action relative to legislative action”; followed by ReevesRogowski2016 and ChristensonKriner2017. New excerpt: “judging particular unilateral acts largely by whether they agree with them”; followed by ChristensonKriner2017 alone. It is one clause in a longer revised sentence. No claim that every subsequent manuscript version preserves the correction.
- **Replication-package:** current OSS skill, adapted from Yusaku Horiuchi's replication-package-guide. A separate release package, not a promise that NWO has already passed a replication audit. Does not itself deposit files. Restricted access must be documented; FAIR does not mean every file is openly downloadable.
- **Resources:** `https://scdenney.github.io/ai-for-research/` and `https://github.com/scdenney/open-science-skills`; pages checked 16 September 2026. No skill-count claim. Replication guide: `https://github.com/yhoriuchi/replication-package-guide`.
- **Off the slides by decision:** the 2026-09-15 pretest and registration matter; the hardcoded paths, the fabricated-numbers PDF, and the live token; any student material; text-to-data and the OCR corpus; research-grill and research-wayfinder. No Korean text. Source conversion for the source library remains in scope.

- **Foundations:** distinguish model, surrounding application, tools, project files, and current context. Available files are not automatically in context. Instructions and skills guide rather than guarantee behavior. A skill can include scripts and references. No fixed context-window size or universal instruction-filename claim is made.
- **First task (8–9):** a read-only research-repo audit prompt for the existing NWO repository. No new audit run, verdict, file count, or report is claimed. A different bibliography filename is not automatically a defect. The example does not authorize scaffolding or editing that project.
- **Learning figures (13–14):** separate assisted performance from unaided outcomes and show units and uncertainty. Autor is a working paper; junior dispersion is not average decline; experience was not randomized. Bastani's effects are plotted in percentage points; its tutor mitigated observed harm without establishing a learning gain. Neither study measures graduate research skills. Retain the Bassner qualification without a universal guardrail claim.
- **Broader reading register:** `planning/09-evidence-protect.md` preserves a relayed source list, not a completed systematic review. Do not repeat exact literature-wide counts, universal claims, or unverified numerical leads as newly established findings.

## Likely discussion questions

1. **How much must I read myself?** There is no universal fraction. The claim and your learning objective determine what you need to understand. You remain responsible for consequential interpretations; generated summaries are a route into sources, not a substitute for the evidence needed to defend a claim.
2. **Does a second model solve verification?** It can offer another reading, but shared errors and a common missing source remain possible. Compare the readings against the actual passage and keep unresolved questions visible.
3. **What about restricted material?** Decide which tools may access which files under the applicable terms. A replication package can document restrictions and access conditions. Do not imply that tracking a conversion grants permission to publish copyrighted source text.
4. **How can students learn while using AI?** Specify the capability being developed or assessed. Protect the cognitive work needed for it, then design assistance around that objective. Assess unaided understanding separately from the assisted product. The boundary may change with domain-specific expertise; these experiments do not establish a general rule for graduate research.

5. **What should I try first?** Open an existing project, identify its instructions, and ask research-repo for a read-only audit with named inputs and a report of present, missing, or uncertain components. Inspect the evidence before authorizing changes. Setup instructions are on AI for Research.
