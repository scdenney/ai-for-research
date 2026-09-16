# Speaker notes: Rethinking the Research Process

Korea University · 18 September 2026 · Steven Denney

Rebuilt 16 September after approval of the five-page design preview. **30 content slides, three section dividers, three appendix pages: 36 PDF pages.** Main-talk budget: **55:00**. Divider transitions are included in the following slide's budget; appendix is outside the talk budget.

These are speaking notes and explicit walkthrough beats, not a script to be read continuously. The budgets allow source reading, diagram explanation, and audience reflection. Rehearse against the clock before delivery; the 55-minute total is a plan, not a measured performance.

## Delivery and evidence conventions

- The opening is 3 minutes; Part 1 is 14; Part 2 is 28; Part 3 is 7; the close is 3.
- Slide numbers below match the numbered content slides. PDF page numbers also include the dividers. Appendix pages are labelled A1–A3.
- Treat the three modes as the author's framework, not an empirically validated taxonomy or sequence.
- Never describe software tests as complete correctness checks or citation-check as free and wholly deterministic.
- All diagrams are explanatory schematics. The source image and historical manuscript excerpts are real artifacts. The Part 3 demo is a historical reconstruction, not a new skill run or synthetic receipt.
- Abbreviated evidence keys are expanded in `planning/02-rebuild-storyboard.md`. Additional exact provenance and current guardrails appear below.

## 01. Rethinking the Research Process

**00:00–00:30 · 00:30 · PDF page 1**

I want to talk about how AI changes the work of research, and how we teach that work. I will use my own projects to show what I automate, what I protect, and how I collaborate with the machine. The longest part concerns the infrastructure that makes this collaboration possible.

**Walkthrough:** Establish that this is a research-workflow lecture, not an installation workshop. Introduce the three parts: choices, infrastructure, one short example.

**Transition:** I will start with why I am building these resources.

**Evidence:** Event details: lecture README; author affiliation in the prior approved deck.

## 02. Why I am building these resources

**00:30–01:30 · 01:00 · PDF page 2**

I work with sources, research designs, analysis, and manuscripts. Many of the tasks recur, but the instructions and standards can disappear into an individual conversation. Open Science Skills is where I make those procedures reusable. AI for Research is the teaching companion: a place to show what the procedures look like in practice. These resources grow from the same work I am describing today.

**Walkthrough:** Point to the difference between a reusable procedure and a worked explanation. Avoid listing skills or installation commands here.

**Transition:** First, consider the research process before adding AI.

**Evidence:** RES: both repository READMEs and public resource pages.

## 03. The process we perform and teach

**01:30–03:00 · 01:30 · PDF page 3**

We begin with questions and ideas. We locate sources, collect or assemble data, analyse them, and write. Checking can send us back to any of these activities. This is not a pipeline that moves smoothly from left to right. A source can change a question. An analysis can expose a design problem. A draft can reveal what we still do not understand.

**Walkthrough:** Trace the forward sequence, then the return arrow. Ask the audience to keep one activity they do or teach in mind as the three modes are introduced.

**Transition:** What role should human cognition play in each activity?

**Evidence:** HIST: author framework, explicitly schematic.

## 04. What role should human cognition play?

**03:00–05:00 · 02:00 · PDF page 5**

Automate when the aim is to get routine work done. Protect when doing the work develops or demonstrates knowledge and judgment. Collaborate when human judgment and machine capability can be combined usefully. These are not three levels of sophistication. The same person can use all three on the same project. The same task can belong in different modes when its learning objective changes.

**Walkthrough:** Read across purposes and examples. Give the qualification its own pause. Return to the activity the audience chose on slide 3 and invite them to place it provisionally.

**Transition:** Start with the work that gains little from our attention.

**Evidence:** HIST and approved preview, page 2.

## 05. Automate without guilt

**05:00–06:45 · 01:45 · PDF page 6**

I think we should be aggressive about this. There is no special virtue in renaming a hundred files by hand or repeatedly applying the same formatting rule. The useful question is whether I can state the intended result and inspect it at a reasonable cost. I still own the outcome. Automation saves attention that I can use for work where my attention makes a difference.

**Walkthrough:** Walk through one rule, such as author-year filenames, and its visible check. Distinguish formatting a reference from deciding whether it supports a claim.

**Transition:** Saving effort is valuable, except when the effort is the point.

**Evidence:** Author workflow examples; no quantitative productivity claims.

## 06. Protect the work through which we learn

**06:45–08:45 · 02:00 · PDF page 7**

Reading is the clearest case for me. I need to encounter an argument, work through what it means, and decide what I think about it. If I hand over all that work, I may have a summary but lack the ability to assess it. I am less settled about where to draw the line around early drafting and seed ideas. Those are questions I want us to discuss.

**Walkthrough:** Explain the difference between assistance after reading and replacement of reading. Ask what the student should be able to explain without the assistant.

**Transition:** A learning objective can change where we draw the line.

**Evidence:** HIST: reading strongly protected; drafting and seed ideas left open.

## 07. A learning objective changes the decision

**08:45–10:45 · 02:00 · PDF page 8**

Imagine a student learning to interpret a difficult article and a researcher comparing work they already know well. A generated comparison may be useful in the second case and defeat the learning objective in the first. This is not a permanent distinction between students and faculty. I also need protected practice when I enter a new literature. The relevant question is what capability I am trying to develop or exercise.

**Walkthrough:** Compare the two columns using the same hypothetical article. Give the audience a moment to consider how they would design an assignment around this distinction.

**Transition:** Collaboration begins with a purpose and a decision that remains ours.

**Evidence:** Author framework; hypothetical scenario, no student material.

## 08. Collaborate with a decision still to make

**10:45–12:45 · 02:00 · PDF page 9**

I use collaboration to mean work in which the machine changes what I can do, while I retain decisions about the purpose and the result. It can help compare sources, review code, or structure feedback I have dictated. That does not mean I approve everything at the end without knowing what happened. I need to decide what material the system can use and what evidence I will require before accepting its output.

**Walkthrough:** Use source synthesis as one example: pose the question, identify inputs, inspect the passages behind a proposed comparison.

**Transition:** Research makes this difficult because many errors do not announce themselves.

**Evidence:** RR, FC; supervision workflow in HIST.

## 09. Research needs more than executable checks

**12:45–14:45 · 02:00 · PDF page 10**

Software often provides relatively quick feedback: a program fails, or a test disagrees with an expected result. That is useful, but it is not a guarantee of correctness. Research has executable checks too, especially around code and numbers. The harder problem is a sentence that reads well, cites a real article, and describes its findings incorrectly. Nothing in the writing software has to fail for that sentence to survive.

**Walkthrough:** Contrast a failed unit test with a mistaken attribution. Do not say software correctness is free, complete, or independent of judgment.

**Transition:** The reference can be real while the claim is wrong.

**Evidence:** KEN; correction of overstatement in the earlier notes audit.

## 10. A real reference can support a wrong claim

**14:45–17:00 · 02:15 · PDF page 11**

The spectacular failure is an invented reference. But a bibliography can contain entirely real works and still be attached to a misleading argument. A DOI may belong to a different paper. A real source may concern a different population, find a weaker relationship, or make a different comparison. These are different questions, and a successful existence check should not be mistaken for a successful check of the argument.

**Walkthrough:** Give one conceptual example of scope: a claim about all citizens drawn from one setting. Keep the actual project example for Part 3. Pause on the support question.

**Transition:** We need a workspace where the relevant evidence is available to inspect.

**Evidence:** CC, FC. The four rows are a teaching distinction, not four reported project findings.

## 11. A workspace the researcher can inspect

**17:00–19:00 · 02:00 · PDF page 13**

An agent combines a model with tools that can read files, run commands, and edit a project. The instructions supply project context. Skills supply procedures for recurring work. The researcher sets the question and boundaries, reviews the evidence, and decides what to accept. The files are important because they are available for inspection after the conversation ends. This is the short conceptual primer we need before looking at the research infrastructure.

**Walkthrough:** Trace every labelled relationship. Explain that an agent is not a separate authority that makes evidence true. Its outputs must be reviewed using the relevant files and standards.

**Transition:** The conversation is temporary. The project record should not be.

**Evidence:** RR; approved preview page 3.

## 12. Keep context beyond the conversation

**19:00–20:30 · 01:30 · PDF page 14**

A new conversation should not require us to rebuild the entire project from memory. I want the sources, drafts, and decisions to live in files. A session can then start from a record of where the project stands. That record is useful, but it can become stale. A summary of what we decided is also different from evidence that the decision was right. Keeping those distinctions visible makes it easier to resume and correct the work.

**Walkthrough:** Name the difference between a source passage and a decision note. Explain that a later edit can supersede either a draft or a decision summary.

**Transition:** Some files describe the project; other files describe how to work.

**Evidence:** RR and KEN, slide 32.

## 13. Instructions set context; skills specify procedures

**20:30–22:30 · 02:00 · PDF page 15**

The first excerpt is from the project instructions in my immigration research repository. It prevents our own notes from being treated as source evidence. The second is from fact-check. It tells the assistant to examine the contribution of each source when several citations follow a claim. The first instruction depends on how this project is organized. The second can apply across projects. Neither is an assurance that the agent will always follow it correctly.

**Walkthrough:** Read the short excerpts exactly. Explain how the two instructions would apply to a sentence with two references. Full files and locators are in the evidence register.

**Transition:** I maintain these procedures in Open Science Skills and teach their use through AI for Research.

**Evidence:** NWO AGENTS.md Sources section; FC §3. Excerpts verified 16 September 2026.

## 14. Two resources with different jobs

**22:30–24:00 · 01:30 · PDF page 16**

Open Science Skills is the collection of procedures. AI for Research is the teaching space where I explain how to use them. I do not want this part of the talk to become a catalogue of every available skill. Instead, I will follow the dependencies in one useful workflow: build the project around its sources, work with that knowledge base, check the draft, and prepare something another researcher can inspect.

**Walkthrough:** Point out the clickable links. Tell participants that setup instructions are on the website, so they do not need to copy terminal commands during the lecture.

**Transition:** The first dependency is a project organized around its source library.

**Evidence:** RES; links checked 16 September 2026.

## 15. Build the project around its sources

**24:00–26:00 · 02:00 · PDF page 17**

Research-repo sets up or audits the working repository. For a project with a source library, it creates a place for originals, readable conversions, incoming sources, and the bibliography. It also sets up the conversion and intake process, plus instructions for agents working in the project. Analysis and manuscript folders grow around that source library. The scaffold adapts to the project. A theory paper without a PDF corpus need not acquire one just to satisfy a template.

**Walkthrough:** Walk down the left-hand tree and explain the role of each item. Explain the difference between creating the intake procedure and running it on a new source.

**Transition:** Now consider what happens when we acquire one paper.

**Evidence:** RR §§2–6, scaffold paths verified. NWO master bibliography has a different name.

## 16. Bring a source into the project

**26:00–28:00 · 02:00 · PDF page 18**

This is a real source from the project we will use in the final example. At the top is a cropped excerpt of the original author-copy PDF. Below it is text from its Markdown conversion. The point of conversion is to make the source available for searching and reading in the workspace. It does not certify the extraction. Headings, columns, tables, and wording can be damaged, so the conversion needs inspection.

**Walkthrough:** Read the matching passage in the image and text. Explain acquisition and registration before moving on. Mention doc-to-markdown as a conversion option; do not turn this into an OCR-corpus demonstration.

**Transition:** Next, connect that readable text to the reference used in the manuscript.

**Evidence:** DEMO PDF first page and Markdown abstract; RR intake; crop provenance in figures/README.md.

## 17. Build a library that claims can be checked against

**28:00–30:00 · 02:00 · PDF page 19**

The manuscript uses a citation key. The bibliography tells us which work that key names. The source files let us inspect what the work says. In a well-maintained library, I can follow those links without guessing. Derived notes branch from this material, but they do not replace it. The NWO project calls its master bibliography references_master.bib. The name matters less than keeping the mapping reliable.

**Walkthrough:** Trace the full chain. Then trace the separate branch to derived notes. Explain why a summary that omits a qualification cannot settle a fine-grained claim.

**Transition:** We now have several kinds of knowledge in the project, with different evidentiary roles.

**Evidence:** RR; approved preview page 4. Actual NWO bibliography: sources/references_master.bib.

## 18. Four kinds of project knowledge

**30:00–32:00 · 02:00 · PDF page 20**

I want to keep these four things separate. The original is what we acquired. The conversion is a readable representation of it. The summary is something we or the machine wrote about it. The decision record explains what we chose to do. All four can be useful, but they answer different questions. A decision note can tell me why I changed a paragraph. It cannot substitute for the passage that supports the paragraph.

**Walkthrough:** Use the source from slide 16 to name an example in each category. Ask which one the audience would want to see when checking a disputed claim.

**Transition:** This is closely related to the knowledge-base idea in Kenny’s presentation.

**Evidence:** RR, FC and project instruction separating .NOTE.md from sources; four-layer taxonomy is this lecture’s synthesis.

## 19. A knowledge base, related to the LLM wiki

**32:00–34:00 · 02:00 · PDF page 21**

Kenny asks how a general tool can work helpfully with specialist knowledge. His final example discusses giving the model papers, summarizing them, and preserving a workspace across time. He relates it to Karpathy’s LLM wiki concept. I am doing something closely related. The emphasis here is on retaining the connection between a source, the text we can inspect, the notes we derive, and the claim we eventually write.

**Walkthrough:** Compare the shared purpose and the different organization. Do not attribute this implementation or the Open Science Skills collection to Kenny. These are related approaches, not identical systems.

**Transition:** Once we have that library, we can use it for more than checking.

**Evidence:** KEN pp31–32; title and author from p1. Local reference PDF.

## 20. Work with the library

**34:00–35:45 · 01:45 · PDF page 22**

A useful question is narrower than asking the system to write the literature review. I might ask how a defined set of papers uses a concept, and require passages for each proposed distinction. The assistant can organize that comparison. I then decide whether the distinctions are meaningful, whether a source has been missed, and whether the synthesis fits the question. Literature-review is one skill that can structure this work with the library.

**Walkthrough:** Walk through the example question without supplying invented findings. Explain how source links make it possible to challenge a proposed distinction.

**Transition:** The same library lets us inspect a draft’s citation layer.

**Evidence:** LR and RR; procedural-legitimacy prompt is illustrative.

## 21. Citation-check: inspect the citation layer

**35:45–37:45 · 02:00 · PDF page 23**

Citation-check starts with the manuscript and bibliography. It checks whether the citation points to the intended work and whether the reference information is consistent. External records can help, but an API response still has to be matched to the right article. The skill also inspects how a citation is used. It is not a completely deterministic process, and an unresolved lookup should be reported as unresolved rather than treated as proof of fabrication.

**Walkthrough:** Explain the difference between a DOI resolving and resolving to the intended work. Note that support checking overlaps with fact-check; these are related workflows, not sealed categories.

**Transition:** Fact-check then concentrates on the claim and the source passage.

**Evidence:** CC §§1–6; lookup services and uncertainty rules checked in SKILL.md.

## 22. Fact-check: compare the claim with the source

**37:45–39:45 · 02:00 · PDF page 24**

Fact-check is a comparison against the project’s source library. It requires a prepared knowledge base and starts with citation-check. For each substantive claim, it locates the relevant source and asks whether the passage supports the sentence. A weaker or narrower finding should not become a stronger claim. Missing source text is a limit on what we have checked, not a successful result. The output is evidence for a decision about the draft.

**Walkthrough:** Talk through the inputs and assessment in order. Mention that a faithful full-text conversion can support a finer check than a summary. A summary’s silence does not establish that a source contains no relevant passage.

**Transition:** A traceable check is valuable, but its limits still matter.

**Evidence:** FC §§1–5; current readiness conditions documented in appendix A2.

## 23. What this foundation can establish

**39:45–41:30 · 01:45 · PDF page 25**

It would be a mistake to call this a truth machine. A sentence can faithfully describe a flawed study. The source library can omit an important work. A conversion can lose a table note. An assistant can misread a passage even when that passage is available. What we gain is a more inspectable process: we can see the claim, the proposed evidence, the assessment, and the revision. That helps us find and correct errors.

**Walkthrough:** Return to the research/software comparison. Ask what additional expertise would be needed to assess the underlying study’s design.

**Transition:** The same question about responsibility also applies in supervision.

**Evidence:** FC, CC, and explicit methodological limits; no claim of measured error reduction.

## 24. Supervision: keep the judgment human

**41:30–43:00 · 01:30 · PDF page 26**

I read the work and form the judgment. I annotate it and dictate feedback. The machine can then help structure that feedback and format a document. That is useful collaboration, but it must not quietly replace my assessment with a more polished one of its own. I need to check whether the resulting text expresses the judgment I actually made, including the uncertainty and the priorities I intended.

**Walkthrough:** Follow the human and machine contributions. Explain that a well-written feedback letter can still distort the supervisor’s view if the final review is skipped.

**Transition:** At the end of a research project, someone outside it also needs to inspect the work.

**Evidence:** HIST: read, annotate, dictate, structure, check, format, edit. No actual student artifact.

## 25. Make the results reproducible by others

**43:00–45:00 · 02:00 · PDF page 27**

A working repository and a replication package serve different readers. The package should tell a competent researcher how to regenerate the published results without hidden manual steps. The skill helps organize a README, an entry script, the environment, and a mapping from results to the code that produces them. If data cannot be released, access conditions need to be explicit. Preparing a package does not mean automatically uploading the whole working repository.

**Walkthrough:** Explain one-command regeneration as a target, not a claim that this lecture’s NWO package has passed an independent audit. Acknowledge Horiuchi’s guide.

**Transition:** Now I will show one historical example of a source changing a claim.

**Evidence:** RP standard and heritage; https://github.com/yhoriuchi/replication-package-guide .

## 26. The claim and its references

**45:00–47:00 · 02:00 · PDF page 29**

This sentence appeared in a draft of my paper on immigration policy and procedural legitimacy. Two works followed the clause as references. The sentence attributed a particular finding to the literature: that citizens penalize executive action relative to legislation. I am showing the historical wording, not a newly generated demonstration. Read the claim before we look at the source. What result would establish it?

**Walkthrough:** Give the audience time to read the excerpt. Identify the implied comparison and direction of the finding. Explain that the surrounding sentence included other qualifications, but these are the exact words attached to the two references.

**Transition:** The reference existed. Acquiring the text let us examine what it actually found.

**Evidence:** DEMO: git show 75366c6^:sections/frontmatter/front_matter.tex .

## 27. What the acquired source said

**47:00–49:30 · 02:30 · PDF page 30**

The abstract says Americans do not instinctively reject unilateral action as a threat to checks and balances. It goes on to explain the role of partisan and policy agreement. That should make us stop before using the paper as straightforward evidence for the penalty described in the draft. The study still examines relevant questions about unilateral action. The problem is what this sentence was asking it to establish.

**Walkthrough:** Read the quotation and paraphrase the remainder of the same sentence. Contrast its direction with the draft. Explain that a full audit would read the relevant experiments and surrounding discussion, not treat one abstract sentence as a universal finding.

**Transition:** The correction separates the claims attached to the two works.

**Evidence:** DEMO Markdown abstract and original PDF; source metadata in sources/references_master.bib.

## 28. The reference existed. The claim needed revision.

**49:30–52:00 · 02:30 · PDF page 31**

The revision describes people judging particular unilateral acts largely by whether they agree with them. That clause is now attached to Christenson and Kriner alone. A separate clause describes generalized support for unilateral powers and cites Reeves and Rogowski. The source changed the claim and the attribution. The recorded change makes that decision inspectable. It does not prove that every other claim in the paper, or every later version, is correct.

**Walkthrough:** Read the three rows in sequence. Explain that the revision is an excerpt from a longer sentence. This is a reconstruction from source files and a real diff, not a fact-check report printed by a newly executed skill.

**Transition:** The value is a process in which we can make and inspect this correction.

**Evidence:** DEMO: 75366c6, front_matter.tex; exact before/after excerpts verified.

## 29. What to take into your own work

**52:00–53:30 · 01:30 · PDF page 32**

I would start small. Find one routine task that does not deserve repeated attention. Identify one activity that matters because doing it develops your understanding. Then choose one collaboration where you can make the inputs and the evidence visible. You do not need to adopt every skill or reorganize every project at once. The goal is to know what the machine is doing for you and what you still need to decide.

**Walkthrough:** Return to the activity selected at the opening. Invite the audience to reconsider its mode now that they have seen the infrastructure.

**Transition:** The resources are here, and I would like to hear where you would draw the boundaries.

**Evidence:** Author framework and demonstrated process.

## 30. Resources and discussion

**53:30–55:00 · 01:30 · PDF page 33**

The website has the setup walkthrough and worked examples. The skills repository has the procedures themselves. Kenny’s presentation was an important point of reference for thinking about agents and persistent knowledge. I would like to open the discussion with the question on the slide. Which part of your research or teaching would you deliberately protect, and what would make you reconsider that boundary?

**Walkthrough:** Leave this slide visible for discussion. Likely questions: how much source reading is enough; whether a second model is an independent check; what to do with restricted sources; and how students can develop judgment while using these tools.

**Transition:** Invite the moderator to begin the discussion.

**Evidence:** RES and KEN; public resource links checked 16 September 2026.

## Appendix notes

**A1 · Source intake (PDF page 34).** Explain naming and identity before conversion. The scaffold uses `sources/references.bib`; the NWO project uses `sources/references_master.bib`. Originals remain archival; source text is convenient for checking, with the original available when extraction is in doubt. Do not promise that all formats, tables, or mathematical expressions convert perfectly. Evidence: research-repo §§3–7 and doc-to-markdown.

**A2 · Readiness (PDF page 35).** The current fact-check skill requires a prepared per-source Markdown knowledge base, converted inputs, and at least two-thirds coverage of the cited set in scope before it proceeds. This is the skill's operational threshold, not a statistical guarantee of validity or a license to ignore the uncovered third. It runs citation-check first. The report must still label each unavailable or ambiguous source. The NWO instructions additionally prohibit using `.NOTE.md` summaries as source evidence. Evidence: fact-check §1 and §4; NWO AGENTS.md Sources section. No fresh full-project gate result is claimed for this lecture.

**A3 · Disclosure (PDF page 36).** Ask what a reader needs to know to understand and inspect the assistance. The checklist is the lecturer's discussion aid. It is not a substitute for a journal or institutional policy. The historical manuscript has a Use of AI statement, but it is not quoted on the slide because its full model list is not central to this lecture.

## Accuracy guardrails for the rebuilt deck

These replace the previous deck's count-heavy guardrails for the current talk. The earlier file and its findings remain available in git history and `planning/codex-notes-review-2026-09-16.md`. None of the old project counts, activity counts, audit totals, costs, timings, or synthetic citation examples is carried onto the new slides.

- **Event and affiliation:** Korea University, 18 September 2026; Steven Denney, Leiden University. Source: lecture README and prior approved title page. No unverified job title or biography was added.
- **Talk counts/timing:** 30 content slides, three dividers, three appendix slides, 36 pages. The section budgets sum to 55:00; rehearsal still required.
- **Kenny reference:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, CSDP / Data-Driven Social Science. Source PDF `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`, title on p1 and LLM wiki discussion on pp31–32. The persistent-workspace idea is related to this implementation, not identical. Kenny names Karpathy's LLM Wiki concept. Do not attribute the OSS skills to Kenny.
- **Project-instruction quote (13):** exact substring “A `.NOTE.md` is not a source” from `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash/AGENTS.md`, Sources section. This file is the project CLAUDE.md link. It is a local rule, not a general claim that no summarization can ever be useful.
- **Skill quote (13):** exact substring “For multi-source claims, check each source’s contribution separately” from `plugin/skills/fact-check/SKILL.md`, §3, in `/Users/scdenney/Documents/github/resources/open-science-skills`. Punctuation around the quote is typeset; wording is preserved.
- **Scaffold (15,17):** generic paths come from research-repo. The bibliography in its tree is `sources/references.bib`. The NWO historical example uses `sources/references_master.bib`. Research-repo creates the local intake process; process-source runs intake. The converted-source folder is not the same thing as generated summaries.
- **Source artifact (16,27):** acquired author-copy PDF and Markdown file at `sources/og/christenson-kriner-2017-constitutional-qualms-unilateral.pdf` and `sources/md/christenson-kriner-2017-constitutional-qualms-unilateral.md` in the NWO project. The displayed image is a crop of the first-page abstract; its author copy has a 2016 production footer. Bibliographic publication year is 2017. Do not infer a metadata mismatch from the production footer.
- **Published metadata:** Christenson and Kriner (2017), *Constitutional Qualms or Politics as Usual? The Factors Shaping Public Support for Unilateral Action*, AJPS 61(2), 335–349, DOI `10.1111/ajps.12262`. Source: `sources/references_master.bib`, `ChristensonKriner2017`.
- **Exact source excerpt (16,27,28):** “Americans do not instinctively reject unilateral action as a threat to our system of checks and balances”. Source: Markdown abstract, line 7, checked against the original PDF. It is a clause within a longer sentence about partisan and policy preferences, not the complete conclusion of the article.
- **Acquisition:** 27 August 2026, `sources/ACQUIRE.md`, the acquired-sources subsection dated 2026-08-27. The record documents resulting corrections; it is not the source for the quoted finding.
- **Historical correction:** manuscript submodule `papers/2-legitimacy-policy-process/manuscript`, commit `75366c6ca9ecc96148acba4840a4853c73f47c43`, dated 27 August 2026, `sections/frontmatter/front_matter.tex`. Old excerpt: “studies of unilateral policymaking similarly show that citizens penalize executive action relative to legislative action”; followed by ReevesRogowski2016 and ChristensonKriner2017. New excerpt: “judging particular unilateral acts largely by whether they agree with them”; followed by ChristensonKriner2017 alone. It is one clause in a longer revised sentence. No claim that every subsequent manuscript version preserves the correction.
- **Replication-package:** current OSS skill, adapted from Yusaku Horiuchi's replication-package-guide. A separate release package, not a promise that NWO has already passed a replication audit. Does not itself deposit files. Restricted access must be documented; FAIR does not mean every file is openly downloadable.
- **Resources:** `https://scdenney.github.io/ai-for-research/` and `https://github.com/scdenney/open-science-skills`; pages checked 16 September 2026. No skill-count claim. Replication guide: `https://github.com/yhoriuchi/replication-package-guide`.
- **Off the slides by decision:** the 2026-09-15 pretest and registration matter; the hardcoded paths, the fabricated-numbers PDF, and the live token; any student material; text-to-data and the OCR corpus; research-grill and research-wayfinder. No Korean text. Source conversion for the source library remains in scope.

## Likely discussion questions

1. **How much must I read myself?** There is no universal fraction. The claim and your learning objective determine what you need to understand. You remain responsible for consequential interpretations; generated summaries are a route into sources, not a substitute for the evidence needed to defend a claim.
2. **Does a second model solve verification?** It can offer another reading, but shared errors and a common missing source remain possible. Compare the readings against the actual passage and keep unresolved questions visible.
3. **What about restricted material?** Decide which tools may access which files under the applicable terms. A replication package can document restrictions and access conditions. Do not imply that tracking a conversion grants permission to publish copyrighted source text.
4. **How can students learn while using AI?** Specify the capability being developed or assessed. Protect the cognitive work needed for it, then design assistance around that objective. The boundary may change as the student gains expertise.
