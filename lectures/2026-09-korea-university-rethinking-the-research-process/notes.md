# Speaker notes — Rethinking the Research Process

Revised 16 September 2026 after the approved narrative and skills plan. **31 main PDF pages, including cover and three dividers; six appendices; 37 pages total.** Headings below use physical PDF page numbers. Ordinary footer numbers omit the cover/dividers and run 1–33.

**55-minute plan:** opening 00:00–07:00; Part 1 07:00–22:00; Part 2 22:00–45:00; Part 3 45:00–52:00; closing 52:00–55:00. These are speaking notes and inspection beats, not a measured rehearsal.

The historical claim anchors the opening; its answer is reserved for Part 3. The figures separate assisted performance from unaided outcomes. Part 2 teaches why and how to write/use a skill, then inspects authentic source artifacts and new scoped audit results.

## 1. Rethinking the Research Process

**00:00–00:30 · 00:30 · PDF page 1**

Welcome the audience and give only the minimum orientation: this is a practical account of how AI is changing research work and the work through which students learn research. Do not preview a catalogue of tools. The lecture begins with one real claim from the lecturer’s project.

**Transition:** Start with the sentence rather than a definition of AI.

**Evidence locator:** Event, title, date, and affiliation are preserved from the approved cover and the lecture README.

## 2. Do these studies support this claim?

**00:30–02:00 · 01:30 · PDF page 2**

Read the historical sentence aloud. It claimed that two studies showed a penalty for executive rather than legislative action. Ask what the cited studies would need to show for that sentence to hold. The claim is an actual excerpt from a historical manuscript version, not an invented exercise and not the output of a newly run fact-check.

State the objective plainly: this talk is a practical account of AI-augmented workflows. The main choices are what role to give the machine and how to inspect the collaboration. The eventual revision remains a substantive research decision.

**Transition:** The same checking task can be posed in a conversation or given to an agent with tools.

**Evidence locator:** NWO project, `papers/2-legitimacy-policy-process/manuscript`, parent of commit `75366c6ca9ecc96148acba4840a4853c73f47c43`, `sections/frontmatter/front_matter.tex`. The exact excerpt was followed by `ReevesRogowski2016` and `ChristensonKriner2017`. The revision is dated 27 August 2026.

## 3. One task, two ways to work

**02:00–03:15 · 01:15 · PDF page 3**

Keep the task constant: decide whether the two cited studies support the sentence. In a chat setting, the model answers from the conversation and material supplied to it, and the researcher carries out the next action. In an agent setting, the model can choose an available tool, inspect what comes back, and continue for several steps. This is a difference in configured capability, not a browser-versus-terminal rule. Chat applications can expose tools, and agent applications differ in what they can access and change.

Do not imply that either setting makes the answer correct. The practical advantage of the agent setting is that actions and their results can be tied to project artifacts and inspected.

**Transition:** Separate the surrounding application from the model acting inside its loop.

**Evidence locator:** Kenny, *Agentic AI for Political Science Research* (10 September 2026), local PDF `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`, pp. 4–9. The slide deliberately replaces Kenny’s interface-based comparison with a capability-based comparison.

## 4. The application runs an agentic loop

**03:15–05:15 · 02:00 · PDF page 4**

Walk through the diagram once. The model proposes an action. A tool performs it within the permissions the application supplies. The result, including an error, becomes context for the next model step. The cycle continues until the task finishes, a limit is reached, or a person intervenes.

Define the terms on the slide. The application is the surrounding software: it presents the interface and manages available tools, context, permissions, and stopping conditions. Here, an agent means the model acting through this repeated tool-and-result loop toward a task. These labels describe the working arrangement; products may use the words differently.

**Transition:** The loop can reach a project, but availability is not the same as current context.

**Evidence locator:** Kenny PDF pp. 5–9, especially the `Task → Model → Tool → Result → Model → Answer or output` sequence on p. 5 and the repeated-cycle description on p. 9. The application/agent distinction is the lecturer’s operational definition for this talk.

## 5. Available files are not current context

**05:15–07:00 · 01:45 · PDF page 5**

The project can contain sources, drafts, data, code, instructions, and previous decisions. Current context is the much smaller set actually available to the model for this step: the task, selected passages, applicable instructions, and recent tool results. Tools let an agent search and select from the project. A file sitting on disk has not automatically been read.

For the opening claim, the practical question is therefore not only whether the source exists in the project. Ask which source was opened, which passage was consulted, and what the model compared. Part 2 will show how the project makes those answers inspectable. Detailed project instructions and reusable skills belong there.

**Transition:** Before examining that infrastructure, decide what kind of role the machine should have.

**Evidence locator:** Kenny PDF pp. 5–9 for context and tool results; NWO project structure for the examples of stored artifacts. No fixed context-window size or universal instruction filename is claimed.

## 6. Part 1 — Automate, protect, collaborate

**07:00–07:30 · 00:30 · PDF page 6**

Introduce the framework as a choice about the role of human cognition. The labels do not form a sequence or maturity ladder.

**Transition:** Each mode has a different decision rule.

**Evidence locator:** Lecturer’s framework, recorded in `planning/01-framework-and-structure.md`.

## 7. Choose the role before the tool

**07:30–09:30 · 02:00 · PDF page 7**

Use three tests. Automate when execution follows a rule and its result can be inspected. Protect when doing the task is itself the learning objective. Collaborate when a substantive decision remains open and the evidence used to make it can be inspected. Keep one paper constant across the examples: prepare its files and citation record, read and explain its argument, or compare its finding with a draft claim.

Stress that the same activity can move between modes. Reading a paper may be protected practice for a student learning interpretation. An experienced researcher may collaborate with an agent to locate and compare passages, provided the researcher can assess the comparison. Purpose and capability set the boundary.

**Transition:** Begin with a concrete task whose execution is easy to inspect.

**Evidence locator:** Lecturer’s framework in `planning/01-framework-and-structure.md`; the revised criteria are the approved organizing rules for this version of the lecture.

## 8. Automate an inspectable procedure

**09:30–11:00 · 01:30 · PDF page 8**

Use source intake as the example. The researcher specifies the naming rule, preservation requirement, and one inventory update. The agent performs those operations. The researcher opens the resulting source, checks its identity, and reviews the changed paths and diff. A mismatch or unrelated edit is an exception, not something the agent should smooth over.

The point is not that file work is trivial. It is that the requested execution has a visible rule and a reviewable result. The slide is illustrative and does not claim a new run on the NWO project.

**Transition:** Some tasks should remain effortful because the effort is what develops the capability.

**Evidence locator:** Generic source-intake conventions from the `research-repo` and local `process-source` procedures; no project-specific run result or count is displayed.

## 9. Protect the practice that builds capability

**11:00–13:00 · 02:00 · PDF page 9**

Define cognitive offloading without treating it as inherently good or bad: mental work is moved to an external aid. The learning objective determines what cannot be bypassed. If the objective is interpretation, students need practice marking relevant passages, stating the author’s claim, connecting evidence to an argument, and explaining their choices.

Intermediate artifacts make the process discussable: annotations, an initial interpretation, a reasoned argument, and an explanation of revisions. Assistance may support these steps, but a polished final answer does not by itself show that the learner performed them.

**Transition:** Two experiments clarify why assisted performance and retained or unaided performance must be measured separately.

**Evidence locator:** Lecturer’s teaching framework; local teaching notes cited in `notes.md` under TEACHING. The application to these four practices is pedagogical guidance, not a causal estimate.

## 10. Assisted output and unaided performance differ

**13:00–15:30 · 02:30 · PDF page 10**

Autor and colleagues ran a three-month randomized experiment with 133 practicing patent lawyers at 11 firms. The left panel is drafting with AI available at 90 days. The right panel is redlining without AI at 90 days. These are different tasks, not an individual before-and-after trajectory.

Read the estimates in control-group standard-deviation units: junior assisted drafting 0.60, senior assisted drafting 0.30, junior unaided redlining −0.03, and senior unaided redlining 0.45. Juniors did not decline on average. The authors report greater dispersion among juniors, which is different from an average loss. Professional experience was not randomly assigned, the senior drafting interval includes zero at 95 percent, and a difference in individual significance does not establish a significant subgroup difference. This study concerns patent-law tasks, not graduate research in general.

**Transition:** A second study varies the design of assistance and separates assisted practice from an unaided exam.

**Evidence locator:** Autor et al. (2026), NBER Working Paper 35720, Tables 4 and 6, column 4; Figure 3 and Table 7 for junior dispersion. Plot details, inputs, calculated intervals, and hashes: `overleaf/figures/evidence-plot-provenance.md`.

## 11. Assistance design can change the outcome

**15:30–18:00 · 02:30 · PDF page 11**

Bastani and colleagues compared unrestricted GPT assistance, a tutor with instructional guardrails, and no AI in high-school mathematics in Turkey. Both AI groups performed better during assisted practice. On the later unaided exam, the unrestricted group scored lower than control; the tutor estimate was close to zero.

Read the estimates as percentage points relative to control: practice +13.7 for GPT Base and +36.1 for GPT Tutor; unaided exam −5.4 and −0.4. The tutor mitigated the observed harm in this setting. It did not establish a learning gain over control, and the study does not show that guardrails generally improve learning.

Add the limited qualification from Bassner and colleagues: in a separate 90-minute programming experiment with 275 participants, AI assistance improved exercise performance without greater measured learning in either AI condition. Different domain, duration, and design; this is a qualification, not a third plotted estimate or a universal result.

**Transition:** Collaboration is justified by an open decision and inspectable evidence, not by output quality alone.

**Evidence locator:** Bastani et al. (2025), PNAS 122(26), e2422633122, Table 1 and Appendix Table 3; DOI `10.1073/pnas.2422633122`. Plot provenance: `overleaf/figures/evidence-plot-provenance.md`. Bassner et al. (2026), *Computers and Education: Artificial Intelligence* 10, 100537, DOI `10.1016/j.caeai.2025.100537`; primary TUM record and abstract checked 16 September 2026.

## 12. Collaborate when evidence can change the decision

**18:00–19:30 · 01:30 · PDF page 12**

Return to the opening sentence. The researcher first states what the references would need to establish. The agent retrieves the sources, locates relevant passages, and compares direction and scope. The researcher decides whether to retain, narrow, reattribute, or remove the claim and records why.

Do not reveal the historical result here. Ask whether the project can show which source, passage, and comparison informed the eventual decision. Part 2 supplies that inspectable infrastructure, and Part 3 returns to the evidence and manuscript diff. The later correction is one historical case; it does not validate the rest of the manuscript.

**Transition:** Once collaboration is warranted, decide who plans, acts, and checks.

**Evidence locator:** Christenson and Kriner (2017), source Markdown abstract line 7 checked against the original PDF; NWO manuscript commit `75366c6`, `sections/frontmatter/front_matter.tex`. Full historical qualification is in `notes.md`, accuracy guardrails.

## 13. Four patterns for delegating work

**19:30–21:00 · 01:30 · PDF page 13**

Kenny presents four models of agent use, adopting Colin Swaney’s 2026 workshop. The table reorganizes those descriptions around who plans, acts, and checks. Pair programming shares all three. In a planning commission, the human plans, the agent implements, and the human checks. In a review board, the agent plans and implements while the human reviews. In autopilot, the human sets the instruction and the agent implements and validates.

These are patterns inside work already selected for collaboration. They do not answer whether a task should be delegated. Human responsibility also does not disappear in autopilot; the table describes the immediate validation loop.

**Transition:** The amount of autonomy depends in part on what can actually be checked.

**Evidence locator:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, local PDF `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`, p. 16. Kenny states that the four models are adopted from Colin Swaney’s Spring 2026 “Claude Overload” DDSS workshop.

## 14. Research validation extends beyond execution

**21:00–22:00 · 01:00 · PDF page 14**

Executable checks answer formalized questions: whether code runs, expected files appear, and specified tests pass. Research validation adds questions that do not reduce to program execution. Is the citation the intended work? Does the source support this sentence? Does the claim exceed the evidence? Are the research design, measurement, and inference sound?

Part 2 builds an inspectable source-to-claim chain for identity, support, and scope. That chain creates better evidence for judgment. It does not automate methodological judgment or guarantee that the source itself is correct.

**Transition:** Move into Part 2: the project structure, source library, and reusable procedures that make the collaboration inspectable.

**Evidence locator:** Lecturer’s validity framework; `citation-check` and `fact-check` procedure scopes in the Open Science Skills repository. No claim is made that software tests establish complete correctness or that source support exhausts research validity.

## 15. From repeated work to an inspectable procedure

**22:00–22:20 · 00:20 · PDF page 15**

In Part 1, I argued that collaboration is most useful when there is still a decision for the researcher to make. I will now show how I turn one recurring research task into a procedure that an agent can follow and I can inspect. The example stays with one project and one pair of sources all the way through.

**Transition:** Start with the reason to write a skill at all.

## 16. When a standard recurs, write the procedure down

**22:20–24:20 · 02:00 · PDF page 16**

Suppose I repeatedly ask whether every source has a readable conversion and a bibliography entry. I could rewrite that request in each conversation. The problem is not merely inconvenience. Each new prompt may omit a check, change the labels, or hide missing evidence. A skill is useful when the task recurs and I can state a standard for doing it.

The skill makes the stable parts explicit: the inputs, the order of work, what counts as missing evidence, and the form of the report. The immediate question still belongs in the prompt. The recurring procedure belongs in the skill. Christopher Kenny makes the same point with a programming analogy: if you repeat a task, write it as a skill.

Not every prompt should become a skill. A one-off exploratory question may not have a settled procedure. The signal is repetition plus a standard that can be stated and reviewed.

**Walkthrough:** Read the repeated task first, then the four properties on the right. Ask which property would most easily disappear from an improvised prompt.

**Evidence:** Kenny, *Agentic AI for Political Science Research*, p. 23; `research-repo` scope and report contract.

## 17. Give the skill a purpose and a procedure

**24:20–26:50 · 02:30 · PDF page 17**

This is the beginning of the real Codex version of `research-repo`, at Open Science Skills commit `310509da268d`. The short description tells the agent what the skill is for. That description is available for routing. When the task matches, the agent loads the full body and follows its scope, instructions, templates, output rules and boundaries. Kenny calls this progressive disclosure: the model first sees enough to select a skill, then reads the detailed procedure when it is needed.

Three written objects have different jobs. A prompt states the present task, target and constraint. Project instructions establish rules that continue across work in this repository. A skill carries a reusable procedure across appropriate tasks and projects. They can refer to each other, but they should not be collapsed into one large prompt.

The Claude plugin version adds an argument hint and allowed-tool metadata. The Codex version uses a shorter front matter block. Their local instruction paths also differ. I am teaching the shared anatomy rather than claiming that every platform uses an identical file.

**Walkthrough:** Point to `name`, then `description`. Trace down to the three roles. Do not linger on YAML syntax.

**Evidence:** `open-science-skills/codex/research-repo/SKILL.md`, lines 1–18; plugin variant, lines 1–24; Kenny p. 23.

## 18. Specify the procedure and how to check it

**26:50–29:30 · 02:40 · PDF page 18**

The real skill gives us a practical writing test. First name the input: a project path and the files already there. Next say what counts as evidence. Here that means the source folders, manuscript, scripts, bibliography and project conventions. Then order the actions: determine whether this is scaffold or audit mode, identify the project type, inspect the source spine, and compare the bibliography and source files in both directions.

Failure behavior matters. The procedure should not convert uncertainty into a finding. A missing component is reported as partial or missing. A theory project that deliberately has no PDF corpus is marked not applicable rather than defective. The report format is also part of the procedure: mode, evidence-backed status, drift and gaps, then next actions.

Finally, test known cases. The current skill states what to do with an empty directory, an existing research repository, and a half-built project. A useful skill anticipates these cases before it meets them in a live project.

**Walkthrough:** Move down the six rows. Ask where a fluent but poorly specified skill is most likely to fail. The expected answer is often failure behavior or evidence.

**Evidence:** `research-repo/SKILL.md` §§1–2 and §§7–8, OSS `310509da268d`. This slide condenses the literal procedure; it does not introduce a new skill.

## 19. Invoke a skill on a bounded target

**29:30–31:20 · 01:50 · PDF page 19**

The invocation differs by application. From inside the `nwo26-immigration-backlash` project folder, Claude Code can invoke the installed plugin with `/oss:research-repo .`; Codex can invoke the skill with `$research-repo .`. These are invocation examples for the same bounded task, not a claim that a screenshot records the command used for the later receipt.

The important part is the boundary. I name the repository. I ask for an audit of the source library and intake process. I specify the report categories and require file evidence. I ask for next actions, but I say not to edit files. That gives the procedure a real target and keeps this run read-only.

Before running, I check four things: the path, the mode, the permitted actions and the expected form of the result. Invocation is not a magic word. It is a request to apply the written contract to named material under stated constraints.

**Walkthrough:** Read the two invocation forms, then the bounded request. Emphasize that the displayed block is source text, not a fabricated terminal capture.

**Evidence:** AI for Research getting-started guide, lines 168–201; `research-repo/SKILL.md` §§1, 7–8.

## 20. An audit finding should point to its evidence

**31:20–33:40 · 02:20 · PDF page 20**

This is a real read-only audit run on the immigration project on 16 September. The first row compares the original-source stems with the Markdown stems: all 102 originals have a matching Markdown file. The second row shows why the procedure must adapt to the project. The generic scaffold calls the bibliography `references.bib`; this project explicitly names `references_master.bib` as canonical. It contains 126 entries. Calling the standard filename missing would have been a false finding.

The audit did find a smaller documentation problem. `sources/inventory.md` still reports older totals. The source library is present, while its inventory page needs updating. The third row identifies the intake documentation and conversion script that support the project’s stated workflow. The 102-to-102 result is only a filename and stem-presence check. It does not certify conversion fidelity.

The point is not that the repository passed every possible audit. This was bounded to the source library, intake and project instructions. The point is the report form: a status, a check, a file locator and a next action. I can open the path and test whether the finding follows.

**Walkthrough:** Read the partial row in full. It best demonstrates why file evidence matters. State that the audit did not claim complete bibliography-to-file parity.

**Evidence:** `planning/receipts-2026-09-16/audit-receipt.md`, lines 16–30. The receipt records unchanged repository-status hashes before and after the audit.

## 21. Persistent context needs a provenance chain

**33:40–36:10 · 02:30 · PDF page 21**

This project structure is related to Andrej Karpathy’s LLM Wiki idea, which Kenny discusses in his final example. Karpathy separates raw sources, an LLM-maintained wiki and a schema that governs the system. The larger idea is persistent context: useful work should accumulate in files rather than disappear with the chat.

For research checking, I need an additional boundary inside that workspace. The original document records what was acquired. A Markdown conversion makes the text searchable and available for inspection. The bibliography resolves the identity used in the manuscript. `research-repo` establishes this structure; `process-source` performs each source intake and conversion. Notes, comparisons and syntheses are derived interpretations. Decisions and claims grow from them, but should remain traceable backward.

Project instructions and skills play the role of schema: they tell the agent how to ingest, name, compare and maintain these files. The implementation here is related to Karpathy’s pattern, not identical to it. In particular, a project note is useful context but does not automatically become evidence for a manuscript claim.

`literature-review` can consume the derived layer to organize comparisons and synthesis. It is not a substitute for the source layer used in fine-grained support checks.

**Walkthrough:** Trace the arrows left to right, then trace one claim backward. Explain the source and derived layers before discussing the schema row.

**Evidence:** Karpathy, “LLM Wiki,” created 4 April 2026, core idea and three-layer architecture; Kenny p. 32; `research-repo` source spine and intake procedure; NWO project instruction that `.NOTE.md` is not a source.

## 22. Inspect the PDF-to-Markdown conversion

**36:10–38:30 · 02:20 · PDF page 22**

Now follow one source that will matter in Part 3. The left side contains two authentic crops from page 1 of the acquired PDF: the title and authors, and the opening drop cap. The middle shows literal text from the Markdown conversion. Its title and author line are available and searchable, but the designed “A” became its own heading and the rest of “At least” moved to the next line. The narrow strip on the right shows selected bibliography fields; it is an abridged display, not a verbatim BibTeX record.

That small defect is instructive. Conversion is not certification. It creates text that an agent can search and quote, but headings, columns, footnotes and tables can be damaged. The original remains available for checking when extraction is doubtful.

The bibliography record on the right supplies a stable identity: cite key, authors, title, year and DOI. We can verify identity without yet reading the article’s substantive finding. I am deliberately withholding that answer because it resolves the question from the opening in Part 3.

**Walkthrough:** Match title and authors across all three representations, then compare the PDF drop cap with `# A` and `t least` in Markdown. Do not read or paraphrase the abstract.

**Evidence:** NWO source library commit `20adba649023`; Markdown lines 1, 5 and 11–13; `references_master.bib` lines 966–975.

## 23. Two checks: citation identity and claim support

**38:30–40:45 · 02:15 · PDF page 23**

The same files support two related checks. `citation-check` begins with the manuscript and bibliography. It inventories citations, checks reference parity, resolves identifiers and compares the returned title, authors, year and venue with the cited work. Its output keeps unresolved and not-checked items visible.

`fact-check` asks the next question: does the resolved source support the exact claim? It requires a prepared local knowledge base. It runs citation-check first, locates the source text, then compares direction, scope and asserted strength. A support, partial-support or contradiction verdict must include a verbatim source passage. If the source text is inadequate, the procedure says so.

The categories overlap. Citation-check also samples evidentiary use, and fact-check depends on citation integrity. The distinction on this slide is a teaching emphasis: identity first, support second.

**Walkthrough:** Read across each row rather than down each column. On the output row, emphasize explicit limits as part of the product.

**Evidence:** `citation-check/SKILL.md` §§1–6; `fact-check/SKILL.md` §§1–6; OSS `310509da268d`.

## 24. Inspect the report by following its evidence backward

**40:45–43:05 · 02:20 · PDF page 24**

Here is the citation-identity portion of the same verified receipt. The check is deliberately narrow: two historical cite keys. For each DOI, content negotiation returned Crossref metadata. The title, both authors, journal, volume, issue and pages match the local bibliography. The slide links each DOI directly so the identity can be inspected beyond the displayed row.

This tells us something important but limited. The cited works exist, the DOI values identify the intended works, and both keys are attached to the archived sentence. It does not tell us that the sentence accurately describes the studies.

To inspect this result, follow the evidence backward. Open the local record. Open the DOI record. Compare title and authors, not merely whether a web page loads. Then read the coverage statement: two keys only, checked on 16 September. A useful report tells us both what it established and where its authority ends.

**Walkthrough:** Follow one row across all four columns. End on the “still unresolved” row and pause before the final slide.

**Evidence:** `planning/receipts-2026-09-16/audit-receipt.md`, citation-check section; raw DOI content-negotiation headers and Crossref records in `crossref-metadata-2026-09-16.json`, accessed 16 September 2026.

## 25. Source support is one layer of research validity

**43:05–45:00 · 01:55 · PDF page 25**

These procedures can inspect citation identity, source support, direction, scope and attribution. They can also make missing evidence visible. That is already more than checking whether a bibliography is formatted correctly.

They do not establish whether the underlying study measured the right concept, used a sound design, or supports a valid causal inference. They cannot guarantee that the source library includes every important work. Even a sentence that faithfully reports a study may still be scientifically weak.

So the workflow creates a verifiable foundation, not a truth machine. It lets us expose the exact claim, the source identity, the passage and the proposed revision. Substantive and methodological judgment still belong to the researcher.

We have now established that the two citations from the opening exist and resolve to the intended works. The remaining question is the one that matters for the sentence: do they establish that citizens penalize executive action relative to legislation? Part 3 answers that question from the acquired source text and the recorded manuscript revision.

**Transition:** Return to the unresolved opening claim.

**Evidence:** `fact-check` limits and verdict requirements; `citation-check` uncertainty rules; no claim that source-grounded validation establishes scientific validity.

## Provenance and display rules

- Slides P2.2 and P2.3 use literal, condensed procedures from Open Science Skills commit `310509da268d`; the exact section locators remain in these notes rather than routine slide footers.
- P2.4 shows authentic invocation syntax and a proposed bounded request. It is not presented as a terminal screenshot or run receipt.
- P2.5 and P2.9 use only findings recorded in `planning/receipts-2026-09-16/audit-receipt.md`. The source-support verdict later in that receipt is intentionally withheld for Part 3.
- P2.6 adapts Karpathy’s three-layer architecture and explicitly labels this project’s source-centered provenance chain as a related implementation.
- P2.7 uses authentic crops from the original PDF, literal Markdown lines, and an explicitly abridged selection of bibliography fields. It does not quote the abstract finding.
- The NWO rule that `.NOTE.md` cannot verify a claim is project-specific and stricter than the general `fact-check` treatment of source summaries.

## 26. Part 3 — One claim, checked against its source

**45:00–45:20 · 00:20 · PDF page 26**

Return to the question from the opening. This section combines a newly performed read-only check with an actual historical manuscript revision. It does not claim that today's skill invocation produced the August revision.

## 27. The claim and its references

**45:20–46:30 · 01:10 · PDF page 27**

Read the comparative claim again. It requires evidence comparing executive and legislative routes, not simply evidence that some respondents dislike executive power. Give the audience time to say what finding would establish that comparison. The full old sentence also qualified the claim with partisanship and policy agreement; retaining that qualification still does not establish the asserted route penalty.

**Evidence:** Old text is in manuscript parent `e50d2788ae8df3d3de63e4e9d26be919d4dea971`, `sections/frontmatter/front_matter.tex`; correction is `75366c6ca9ecc96148acba4840a4853c73f47c43`, 27 August 2026. Exact diff: `planning/receipts-2026-09-16/historical-claim-diff.txt`.

## 28. Read the finding behind the verdict

**46:30–49:20 · 02:50 · PDF page 28**

The new check first established that both cited works exist and match their DOI records. Its preflight then located both per-source Markdown files. The next question is substantive support, which requires reading what the studies actually tested.

Reeves and Rogowski show low generalized support for unilateral power. That is relevant, but it is not a direct comparison of two routes to the same policy. Christenson and Kriner directly test routes for student-loan and immigration policies; the route estimates are not statistically significant. That result does not establish a penalty, its opposite, equivalence, or the absence of a meaningful effect. The comparative claim is unsupported by the evidence attached to it.

Read the displayed abstract clause with its surrounding qualification about partisan and policy agreement. Then point to the paper's direct route tests. The receipt documents the distinction between source identity, topical relevance, measurement, and support. A fluent summary alone could blur these distinctions.

**Evidence:** Actual new scoped receipt `planning/receipts-2026-09-16/audit-receipt.md`; source conversions in NWO `sources/md/`; C&K original PDF pp. 10–12, Tables 4–5, Markdown table ranges 396–423 and 479–504 and interpretations 425, 467, 477, 506, 548; R&R survey items and findings, Markdown 114–127. Both DOIs checked via Crossref content negotiation; metadata retained next to receipt. Source-support status is UNSUPPORTED for the comparative claim, not a declaration that the underlying studies are invalid.

## 29. The reference existed. The claim needed revision.

**49:20–52:00 · 02:40 · PDF page 29**

Show the actual old clause, source clause, and revised clause. The historical revision separates generalized support for unilateral powers from judgments of specific unilateral acts. Christenson and Kriner are attached to the narrower latter claim. These excerpts are clauses from longer sentences; the historical diff preserves the surrounding material.

The point is the chain from question through evidence to a recorded decision. The original paper, readable conversion, citation identity, explicit checking procedure, and revision history make the reasoning inspectable. A skill can help repeat the procedure; the researcher must still decide whether the interpretation and revision are warranted.

**Transition:** Return to the three choices the audience can take into their own work.

## 30. What to take into your own work

**52:00–53:30 · 01:30 · PDF page 30**

Choose one routine task to automate, one capability to protect, and one question on which to collaborate. Classify by purpose, rather than assigning tools permanently to categories. The same paper can be filed automatically, read without assistance to develop an interpretation, and later compared with a draft through an agent-assisted procedure.

For collaboration, make the procedure and evidence visible. Start with a bounded question and a result that can be checked against actual files or sources.

## 31. Resources and discussion

**53:30–55:00 · 01:30 · PDF page 31**

Point to AI for Research for setup and worked examples, and Open Science Skills for reusable procedures. The browser capture is the actual deployed getting-started page. Leave these links visible for discussion. Installation is outside the main lecture; the Hub is the next step for someone who wants to try this in a project.

**Evidence:** https://scdenney.github.io/ai-for-research/ and https://github.com/scdenney/open-science-skills. Real captures and provenance are retained with the deck.

## Appendix notes

### 32. Source intake: what happens between the folders

**Outside the 55-minute budget · PDF page 32**

Explain naming and identity before conversion. The scaffold uses `sources/references.bib`; NWO uses `sources/references_master.bib`. Originals remain archival, while source text is convenient for searching and checking; consult the original when extraction is in doubt. `research-repo` creates the intake process; local `process-source` carries out intake, with `doc-to-markdown` supplying conversion options. Do not promise perfect conversion of tables, mathematics, or page locators. Keeping an original privately does not grant permission to redistribute it or its conversion.

**Evidence:** RR §§3–7; doc-to-markdown; NWO conventions.

### 33. When a source check is not ready

**Outside the 55-minute budget · PDF page 33**

The current fact-check skill requires a prepared per-source Markdown knowledge base and no unconverted source backlog. It treats coverage below roughly two-thirds of cited non-background works in scope as not ready. This is an operational threshold, not a statistical guarantee or permission to ignore the uncovered third. Citation-check runs first. Missing, ambiguous, or insufficient sources remain visible. NWO additionally prohibits treating `.NOTE.md` summaries as source evidence. A summary's silence does not show that the original contains no relevant passage. No fresh full-project readiness result is claimed.

**Evidence:** FC §1 and §4–6; NWO AGENTS.md, Sources section. The skill can accept summaries in some settings but explicitly distinguishes their limits from faithful conversions; the local project rule is stricter.

### 34. Document the use of AI

**Outside the 55-minute budget · PDF page 34**

Ask what a reader needs to know to understand the assistance and inspect consequential decisions. Describe the task, tools and materials, human review, and limitations as relevant. This is the lecturer's discussion aid, not a universal disclosure template or a substitute for journal or institutional policy. The historical manuscript includes a Use of AI statement; its full model list is not reproduced. Absence of an AI record would not prove that a task was performed entirely without AI.

**Evidence:** Historical manuscript and prior notes audit; author disclosure discussion. No current journal-policy claim is made.

### 35. Performance and learning need different evidence

**Outside the 55-minute budget · PDF page 35**

Read the three-study table by what was measured and when. Autor separates 90-day drafting with assistance from unaided redlining. Bastani separates assisted practice from the subsequent unaided mathematics exam. Bassner's 90-minute programming experiment measures exercise performance and conceptual learning separately; improved exercise results did not establish greater knowledge gains or code comprehension. This is a selected comparison, not a systematic review or a pooled effect estimate. A better assisted product does not establish retained understanding. A null estimate does not establish equivalence. Do not compare effect magnitudes across standard-deviation units and percentage points.

**Evidence:** AUT Tables 4 and 6; BAS Table 1; BASS primary abstract; figure provenance below. The broader leads in `planning/09-evidence-protect.md` are not all newly audited here. The word learning refers to each study's actual assessment, not a uniform outcome shared across studies.

### 36. What might protect learning?

**Outside the 55-minute budget · PDF page 36**

Relevant prior knowledge is specific to the task. Shen and Tamkin's experiment recruited people with Python experience who had never used the Trio library being tested. Their preprint reports lower subsequent quiz performance with AI assistance. This was an Anthropic-affiliated study; identify that affiliation and its preprint status. The study's observed interaction patterns were not themselves randomly assigned, so avoid turning them into proven instructional prescriptions.

Melumad and Yun compare learning from LLM syntheses with web search. Across seven experiments they examine reported depth of learning and the substance and reception of advice participants subsequently produced. The reported-learning measures are not a direct test of long-term retention. These findings motivate keeping active engagement with sources in view; they do not test this lecture's research-repo workflow or establish a universal rule for graduate researchers.

**Walkthrough:** Explain why general seniority differs from familiarity with a new task. Then distinguish a participant's report of learning from the observable qualities of the advice produced. Bring the discussion back to what the task is intended to develop.

**Evidence:** SHEN §4.3 and §5.2; MY abstract and main results. The application to protected reading and research judgment is the lecturer's inference. For the main figures, retain the separate qualifications: Autor's junior result is not average decline; Bastani's tutor did not establish a learning gain; neither plotted study measures graduate research skills or follows participants beyond three months.

### 37. Make the results reproducible by others

**Outside the 55-minute budget · PDF page 37**

A research repository retains working sources, drafts, experiments, and decisions. A replication package is a curated release: README, entry script, environment, data or access instructions, and a mapping from reported outputs to producing code. An independent rerun is a separate test. The replication-package skill prepares and audits the handoff; it does not itself prove that a rerun succeeds or deposit the files. This is an additional use of a written, inspectable procedure, available for discussion rather than interrupting the source-library lesson.

**Evidence:** OSS replication-package skill, adapted from Yusaku Horiuchi's replication-package guide. No replication audit of NWO is claimed.

## Evidence register

- **HIST:** Steven Denney's framework, examples, and project history in the lecture planning wiki. Hypothetical teaching examples remain hypothetical.
- **RES:** [AI for Research](https://scdenney.github.io/ai-for-research/), local `README.md` and `docs/getting-started/index.html`; [Open Science Skills](https://github.com/scdenney/open-science-skills), its README and skill sources. Installation belongs on the Hub. Avoid stale skill counts or describing a skill as merely a command.
- **KEN:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, CSDP / Data-Driven Social Science. Local PDF: `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`; foundations on slides 4–12, instructions and skills on 20–26, persistent knowledge on 31–32. Adapting its sequence does not endorse every comparison or product-specific claim.
- **RR, CC, FC, LR, RP:** `research-repo`, `citation-check`, `fact-check`, `literature-review`, `replication-package` under `/Users/scdenney/Documents/github/resources/open-science-skills/plugin/skills/`. A procedure's existence does not establish a successful run. RP acknowledges [Yusaku Horiuchi's guide](https://github.com/yhoriuchi/replication-package-guide).
- **NWO / DEMO:** `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash`. Final-example provenance appears in the accuracy register. A new bounded read-only audit of the same project is recorded in planning/receipts-2026-09-16/.
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

The published inputs, table locators, intervals, downloaded-source hashes, and interpretation limits are recorded in `overleaf/figures/evidence-plot-provenance.md`. `evidence-estimates.csv` holds the inputs; `build-evidence-plots.py` creates vector figures and `evidence-intervals.csv`. Intervals use estimate ± 1.96 × published rounded SE. No estimates were read from chart pixels. The author-copy source crop is documented in `overleaf/figures/README.md`. The authentic browser captures are documented in `overleaf/figures/browser-capture-provenance.md`: published research-repo audit-mode paragraph and sources-only scaffold at OSS commit `310509da268d7633a03e4e14f797eedd9d7df8dc`, plus the deployed AI for Research getting-started introduction. These are captures of existing public material, not new audit receipts. The published browser excerpts show the Claude variant; the anatomy slide quotes the Codex variant. The dated receipts record the installed skill versions actually applied.

- **KAR:** Andrej Karpathy, *LLM Wiki*, 4 April 2026, https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f. Raw sources / wiki / schema; ingest / query / maintenance. This is an abstract pattern, not a mandatory OSS implementation or a guarantee of sound synthesis.
- **SWAN:** Kenny slide 16 credits Colin Swaney's Spring 2026 Claude Overload workshop. Public workshop materials: https://github.com/princeton-ddss/claude-overload. The four pattern labels are directly documented in Kenny's slide; the public workshop README does not independently reproduce the grid.
- **RECEIPTS:** planning/receipts-2026-09-16/{audit-receipt.md,audit-receipt.json,crossref-metadata-2026-09-16.json,historical-claim-diff.txt}. Actual scoped execution on 16 September, with installed skill hashes, source locators, metadata, and unchanged reference-project git-state checks.

## Accuracy and presentation boundaries

- Main PDF pages: 31 including cover and three dividers. Appendix pages: six. Total: 37. Ordinary footer numbers: 1–33. Planned duration: 55 minutes; no timed rehearsal or live Zoom test is claimed.
- Agents are defined through available context, tools, and an iterative action loop. A browser interface can expose those capabilities. Project files are not automatically current context. A repository is an organised project folder with recorded versions; explain that term aloud when introducing the files.
- The three modes are the author's framework. Delegation patterns answer a separate question about who plans, acts, and checks. Software also requires specifications, tests, evidence, and judgment; passing tests is not complete correctness.
- Autor's junior results do not show average decline. The unaided task differs from the assisted task; greater dispersion is a separate result, not shown by the plotted mean intervals. Experience was not randomized. Bastani's tutor mitigated observed harm without establishing a learning advantage; Bassner qualifies any broader guardrail claim. Neither study establishes effects on graduate research skills.
- Keep the do-not-cite exclusions from planning/09-evidence-protect.md. The relayed review is not a newly completed systematic review; do not claim literature-wide counts as established here.
- The 102/102 original-to-Markdown count checks stems and file presence only. It does not validate extraction fidelity or full bibliography parity. The stale inventory finding does not imply the canonical bibliography is missing. Derived NOTE files cannot verify claims under this project's instructions.
- The new receipt audits the actual pre-correction draft at e50d2788. The revision at 75366c6 is historical; no claim is made that today's skill procedure caused it. Nonsignificant route estimates do not demonstrate equivalence or the absence of an effect.
- Source identity and claim support overlap in the two checking skills. Fact-check consumes citation-check findings, checks readiness, and records unresolved cases. A summary can be insufficient evidence without the underlying source being unsupportive.
- Source conversion preserves an accessible representation, not guaranteed fidelity. The source's author copy has a 2016 production footer; its bibliographic publication year is 2017. The side-by-side crop joins two real regions from PDF page 1; it is not a continuous page screenshot.
- Skill instructions and illustrative invocation forms are distinguished from actual execution receipts. Current OSS excerpts are pinned to commit 310509da268d7633a03e4e14f797eedd9d7df8dc; installed audit versions are pinned separately by hash. No new skill was created in this revision.
- Preserve the boundary between source support and research validity: measurement, identification, inference, literature coverage, and truth require additional substantive work.
- No student material, Korean text, private credentials, pretest details, invented studies, or fabricated audit results belong in the lecture. Reference repositories remain read-only. Replication-package is an appendix example, not a claim of a completed release audit.

## Likely discussion questions

1. **How much must I read myself?** There is no universal fraction. The claim and your learning objective determine what you need to understand. You remain responsible for consequential interpretations; generated summaries are a route into sources, not a substitute for the evidence needed to defend a claim.
2. **Does a second model solve verification?** It can offer another reading, but shared errors and a common missing source remain possible. Compare the readings against the actual passage and keep unresolved questions visible.
3. **What about restricted material?** Decide which tools may access which files under the applicable terms. A replication package can document restrictions and access conditions. Do not imply that tracking a conversion grants permission to publish copyrighted source text.
4. **How can students learn while using AI?** Specify the capability being developed or assessed. Protect the cognitive work needed for it, then design assistance around that objective. Assess unaided understanding separately from the assisted product. The boundary may change with domain-specific expertise; these experiments do not establish a general rule for graduate research.

5. **What should I try first?** Open an existing project, identify its instructions, and ask research-repo for a read-only audit with named inputs and a report of present, missing, or uncertain components. Inspect the evidence before authorizing changes. Setup instructions are on AI for Research.
