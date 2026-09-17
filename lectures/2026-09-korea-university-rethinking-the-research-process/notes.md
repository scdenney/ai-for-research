# Speaker notes – Rethinking the Research Process

Revised 17 September 2026 after the Part 2 and Part 3 reorganization. **38 main PDF pages, eleven appendices, 49 pages total.** Headings use physical pages; main-deck footers end at 31 and the appendix continues through 42. The author-edited physical page 4 intentionally omits printed footer 3.

**55-minute plan:** introduction 00:00–08:00; Part 1 08:00–23:00; Part 2 23:00–43:00; Part 3 43:00–52:00; closing 52:00–55:00. These are speaking allocations, not a measured rehearsal.

The purpose and basic vocabulary come first. The historical claim is introduced at the end of the introduction, then returns in Part 3. The three modes concern the whole research and teaching process. Part 2 explains the knowledge base, reusable procedures, and distinct kinds of checks in the lecturer’s workflow. Part 3 traces the authentic historical source case and then a separate numerical demonstration using illustrative data.

## 1. Rethinking the Research Process
**00:00–00:30 · 00:30 · PDF page 1**

Welcome the audience and introduce the lecture as a practical account of how AI changes research for both students and professors. Move directly to the scope of the talk.

## 2. Today: AI in research and teaching
**00:30–01:50 · 01:20 · PDF page 2**

Give the audience the three-part agenda. First, ask what research and teaching work should be automated, protected, or done in collaboration with AI. Second, explain how I use a research knowledge base and Open Science Skills. Third, follow two checks back to their evidence: one source claim and one reported result.

## 3. From generative AI to agentic AI
**01:50–03:20 · 01:30 · PDF page 3**

Generative AI is the broad category: systems that produce new material such as text, images, audio, or code. A large language model is a model trained on large amounts of text to predict and produce language. It often supplies the language capability in a generative system.

Agentic AI describes AI that can use tools, observe what those tools return, and choose what action to take next. These categories overlap. An agent can use an LLM to interpret the task and generate language.

Avoid implying that every generative system is an agent or that agents use a different kind of model.

## 4. From a conversation to carrying out a task
**03:20–04:50 · 01:30 · PDF page 4**

Keep the example constant: find the source behind a citation and report what it says. In a basic conversation, the model answers from the conversation and whatever material has been provided. The researcher performs the next action.

A tool-using agent can carry out several steps. It can search the project, open the source, run a command or script when needed, and use the result to decide what to do next. Claude Code and Codex are applications that support this kind of work. Their exact tools and permissions depend on their configuration.

The difference on this slide is the ability to act and continue, not a browser-versus-terminal distinction.

A CLI is a command-line interface used inside a terminal. A CLI agent can work with a repository and tools under the user’s permissions. The same research procedures can be used in suitably configured desktop and IDE agent applications. I mainly use the CLI. I do not recommend chatbot interfaces for this workflow and have not evaluated their behavior; avoid saying that all chat interfaces lack tools.


## 5. What does it mean to use agents for research?
**04:50–06:30 · 01:40 · PDF page 5**

Software development helped make agents useful because agents can edit code, run it, and receive quick feedback from execution, compilers, and tests. Tests check whether code behaves as expected under the cases and specifications supplied. Passing tests does not establish that software is completely correct.

Research has a different checking problem. A source can exist while the sentence citing it remains wrong. Checking support requires reading and interpretation. Measurement, research design, and inference require substantive judgment. An agent can help collect and organize the evidence, but the researcher must understand what that evidence establishes.

This difference motivates the three modes in Part 1 and the project infrastructure in Part 2. AI now runs through research work: it cannot realistically be treated as wholly absent from the lecture's workflow. Particular projects can still restrict particular tools or materials; that is a local decision, not a general claim that all work must be exposed to AI.

Verifiability means being able to inspect the inputs, transformations, and evidence and check the result. Validity concerns whether design and interpretation warrant the conclusion. The research process combines executable checks and substantive judgments. Matt Pocock’s diagnosing-bugs procedure requires a named command capable of exposing the failure before diagnosis begins. The transferable lesson is to establish a useful feedback signal before asking an agent to iterate. His teach material similarly preserves sources to make checking cheaper, while still requiring primary-source reading. These are attributed workflow examples, not empirical evidence that a particular research workflow improves outcomes.

Source: preserved Pocock snapshot 959a8e9f1edc3adbe2f7e3054bb6fbefa6696260, docs/engineering/diagnosing-bugs.md and docs/productivity/teach.md; planning/14-csdp-benchmark.md.


## 6. An example research claim
**06:30–08:00 · 01:30 · PDF page 6**

Read the historical sentence and its two citations. It claimed that studies of unilateral policymaking showed that citizens penalized executive action relative to legislative action.

Ask the audience what those sources would need to establish for the sentence to be accurate. Do not answer yet. Explain only that this is an actual excerpt from an earlier manuscript version. Part 2 will show the working arrangement used to examine sources, and Part 3 will return to what these sources said and how the sentence changed.

Evidence: NWO Paper 2, parent of manuscript commit `75366c6`, `sections/frontmatter/front_matter.tex`; citations `ReevesRogowski2016` and `ChristensonKriner2017`.

## 7. Automate, protect, collaborate
**08:00–08:15 · 00:15 · PDF page 7**

Introduce Part 1 as three modes of AI engagement. They are choices about the role of human cognition, not a sequence in which collaboration is automatically more advanced.

## 8. Three modes of AI engagement
**08:15–09:15 · 01:00 · PDF page 8**

Automate work that is routine and gains little from your personal attention. Protect selected activities when doing the work builds the understanding and judgment needed to stand behind it. Collaborate when human judgment and AI capability both matter.

The same activity can move between modes as its purpose changes. The framework is for research work throughout, not a general policy requiring total exclusion of AI.

## 9. Hand off routine work
**09:15–09:30 · 00:15 · PDF page 9**

State the automation position confidently: hand off routine work. Efficiency is the goal.

## 10. Save time and attention
**09:30–10:20 · 00:50 · PDF page 10**

Use the four rows as ordinary examples: schedule meetings and reminders; track tasks, milestones, and deadlines; file and organize project materials; format references, tables, slides, and documents. These tasks still need clear instructions, but doing them personally contributes little to the substantive objective.

## 11. Preserve the work that builds understanding
**10:20–10:35 · 00:15 · PDF page 11**

Protect the work through which the researcher builds or demonstrates understanding and judgment. This concerns the capability the work develops, rather than a rule about teaching or a categorical ban on AI.

## 12. Protect the reasoning that builds judgment
**10:35–11:35 · 01:00 · PDF page 12**

The protected activity is the practice through which cognitive abilities develop: interpreting sources, weighing competing evidence, and constructing an argument. The point is not simply that a researcher should remain responsible for the final product. It is that routinely receiving an already completed interpretation can remove opportunities to develop the ability to interpret and assess evidence independently.

AI can support this practice through questions, feedback, or criticism. The concern is habitual substitution for the reasoning the person is still learning to do. This is a conceptual rationale for selective protection, not a claim that every use of AI causes cognitive decline. The next slides distinguish assisted performance from measured learning and later unaided capability. Keep the earlier practical premise: AI is present across research; protecting selected reasoning does not require an entirely AI-free workflow.

## 13. Performance and learning need different evidence
**11:35–13:05 · 01:30 · PDF page 13**

Read the three-study table by what was measured and when. Autor separates 90-day drafting with assistance from unaided redlining. Bastani separates assisted practice from the subsequent unaided mathematics exam. Bassner's 90-minute programming experiment measures exercise performance and conceptual learning separately; improved exercise results did not establish greater knowledge gains or code comprehension. This is a selected comparison, not a systematic review or a pooled effect estimate. A better assisted product does not establish retained understanding. A null estimate does not establish equivalence. Do not compare effect magnitudes across standard-deviation units and percentage points.

**Evidence:** AUT Tables 4 and 6; BAS Table 1; BASS primary abstract; figure provenance below. The broader leads in `planning/09-evidence-protect.md` are not all newly audited here. The word learning refers to each study's actual assessment, not a uniform outcome shared across studies.

## 14. What might protect learning?
**13:05–14:20 · 01:15 · PDF page 14**

Relevant prior knowledge is specific to the task. Shen and Tamkin's experiment recruited people with Python experience who had never used the Trio library being tested. Their preprint reports lower subsequent quiz performance with AI assistance. This was an Anthropic-affiliated study; identify that affiliation and its preprint status. The study's observed interaction patterns were not themselves randomly assigned, so avoid turning them into proven instructional prescriptions.

Melumad and Yun compare learning from LLM syntheses with web search. Across seven experiments they examine reported depth of learning and the substance and reception of advice participants subsequently produced. The reported-learning measures are not a direct test of long-term retention. Use the slide's question: what do we learn from a synthesis, and what requires engaging with the sources? These findings motivate keeping active engagement with sources in view; they do not test this lecture's research-repo workflow or establish a universal rule for graduate researchers.

Explain why general seniority differs from familiarity with a new task. Then distinguish a participant's report of learning from the observable qualities of the advice produced. The application to protected reading and research judgment is the lecturer's inference. For the main figures, retain the separate qualifications: Autor's junior result is not average decline; Bastani's tutor did not establish a learning gain; neither plotted study measures graduate research skills or follows participants beyond three months.

**Evidence:** SHEN §4.3 and §5.2; MY abstract and main results.

## 15. AI assistance and later unaided review
**14:20–16:35 · 02:15 · PDF page 15**

Autor and colleagues studied 133 practising patent lawyers at 11 US firms over three months. Junior means fewer than seven years of experience; senior means seven or more. On the left, lawyers drafted a patent with AI available. On the right, they later reviewed and revised a patent without AI. The paper calls that task redlining.

The assisted-drafting estimates are positive for both experience groups, although the senior interval crosses zero at the approximate 95 percent level. On the separate unaided review task, the junior estimate is near zero with an interval spanning zero, while the senior estimate is positive.

Describe the junior result as no clear average effect. Do not infer either average decline or proof of no effect. The authors separately report greater dispersion among juniors; that variance result is not shown by the plotted mean and interval. These are different tasks at 90 days, professional experience was not randomized, and the study does not directly estimate effects on graduate research skills.

Evidence: Autor et al. (2026), NBER Working Paper 35720, Tables 4 and 6, column 4; Figure 3 and Table 7 for dispersion.

## 16. Practice with AI, then an exam without it
**16:35–18:50 · 02:15 · PDF page 16**

Bastani and colleagues studied high-school mathematics in Turkey. GPT Base provided unrestricted assistance. GPT Tutor provided guided assistance designed to support learning. Both groups performed better than the no-AI control during assisted practice.

The later exam was completed without AI. The unrestricted group scored 5.4 percentage points below control. The guided group estimate was close to zero. The guided tutor mitigated the harm observed in this setting, but it did not establish a learning gain over the control group.

Keep the outcomes separate: assisted practice and the later unaided exam are not a single before-and-after trajectory. The study does not establish that guardrails improve learning in every setting. Bassner and colleagues provide a useful qualification from programming education: better assisted performance did not produce greater measured learning in either AI condition.

Evidence: Bastani et al. (2025), PNAS, Table 1; Bassner et al. (2026), *Computers and Education: Artificial Intelligence* 10, 100537.

## 17. Combine human judgment with machine capability
**18:50–19:05 · 00:15 · PDF page 17**

Introduce collaboration as the broad category in which machine capability changes the scale, speed, or form of the work while the human retains responsibility for substantive decisions. Ethical machine augmentation is the goal.

## 18. Collaboration across research and teaching
**19:05–20:05 · 01:00 · PDF page 18**

Collaboration can operate throughout research and teaching. An agent can retrieve literature and compare passages, organize data and help write or test code, assist with visualisation, and help structure or revise writing. In supervision, it can organize feedback after the teacher has read and evaluated the work.

The researcher or teacher retains the substantive decisions: which sources matter, whether an analysis answers the question, what a draft should claim, and what judgment feedback should express.

## 19. Match supervision to the research task
**20:05–21:45 · 01:40 · PDF page 19**

Read the axes first. Complexity increases upward from easy to hard; verification becomes more objective toward the right. These are relative positions for a bounded task under its current checking conditions, not permanent categories for whole research activities.

The research examples make the borrowed framework useful here. Co-designing a study combines a complex problem with judgments about theory, measurement, and inference, so human and agent work together. Implementing a specified analysis is a candidate for delegation when the researcher has fixed the specification and can check code and outputs against it; an analysis plan alone does not make its implementation objectively verifiable. Reviewing a short summary against an available source is bounded but still requires interpretation. Formatting references to a specified style provides explicit criteria for automated checks. Bibliographic identity and claim support remain separate, substantive tasks.

Protect comes before this delegation decision: if doing a task develops the understanding someone needs, ease of checking does not by itself justify outsourcing it. For tasks we do delegate, choose the supervision arrangement according to both difficulty and available checks.

This is the connection to Part 2. The research repository preserves the source used to check a summary, the analysis specification and code, and the bibliography. Source checking, executable comparisons, and review supply different kinds of feedback. Better checking can make delegation more practical; it does not eliminate research judgment or prove validity.

Credit Kenny’s CSDP presentation, page 16, adapting Swaney’s Claude Overload workshop. The four task examples are our illustrative applications, not examples recovered from that presentation. The appendix preserves the detailed plans/acts/checks role table.

## 20. Research moves through changing risk terrain
**21:45–23:00 · 01:15 · PDF page 20**

Apply the grid to the research process without treating whole stages as permanent categories. Ideation, theory, and interpretation often remain complex and judgment-heavy. Source work, analysis, writing, and publication contain more repeatable operations, but their verifiability is brittle when the source, specification, code, output, or reported claim becomes detached from the rest of the project.

Read the positions as illustrative zones rather than measurements. The same stage can move when the bounded task, specification, available evidence, or checking infrastructure changes. Follow the arrows through the project, then use the dashed return path to show that findings and publication generate revisions and new questions.

Transition: Part 2 shows how a shared repository and explicit procedures improve those checking conditions.

## 21. Building checkability into research
**23:00–23:15 · 00:15 · PDF page 21**

Part 2 asks how a research process becomes checkable enough for productive collaboration. Start with preserved sources, project files, and explicit procedures; then show the checks that operate on them. The repository is the shared foundation across sessions.

## 22. Checkability can be built into the process
**23:15–25:45 · 02:30 · PDF page 22**

A repository is the whole project folder. Its source knowledge base contains preserved originals, readable source text, and a bibliography linking cited identities to files. Analysis, drafts, instructions, and decision notes live alongside it. Derived notes and syntheses remain distinguishable from source evidence.

Show the paths from shared files to named checks and then to researcher decisions. Project instructions state evidence rules; Git records changes. Karpathy and Kenny offer related persistent-workspace ideas, but their LLM Wiki structures are not identical to research-repo. The repository can support literature synthesis without treating a generated summary as the original source.

This is an infrastructure claim: preserved sources, explicit standards, and recorded transformations make inspection easier. They do not establish that a research conclusion is valid.

Sources: research-repo in planning/oss-2.31.0/; planning/14-csdp-benchmark.md and 15-verifiability-and-deep-dive-context.md.

## 23. Checking the paper requires the work behind it
**25:45–28:00 · 02:15 · PDF page 23**

The paper is not enough to check the paper. A claim needs its cited source and a stable citation key; a reported number needs the input, analysis, generated result, and the reported fields; a revision needs the decision and history that explain it. These materials let a reviewer reconstruct what was checked.

The slide deliberately avoids a directory inventory. It shows the two dependencies needed later: the sentence must lead back to its source passage, and the reported number must lead back to its data, code, and fresh result. Version history and session-continuity details are retained in the appendix.

Sources: versioned research-repo, sitrep, and finished in planning/oss-2.31.0/.

## 24. A searchable source still needs its original
**28:00–30:15 · 02:15 · PDF page 24**

Compare the authentic original-PDF abstract crop with the literal Markdown conversion. The crop contains the first three abstract sentences; the enlarged conversion below prints the first sentence for readability. Reserve the source-check verdict for Part 3. Point to ChristensonKriner2017 as the link to the manuscript and bibliography; the full literal BibTeX record is in the appendix.

Intake identifies the work, preserves the original, converts it, inspects the conversion, and separately creates the bibliography record. OpenDataLoader handles prose conversion in the current template; it does not itself verify bibliographic identity. Retain the original for checking extraction problems.

This is an authentic source record from the historical case, not the numerical illustration introduced later. A searchable conversion helps locate a passage; it cannot replace the original when extraction, tables, page references, or context are in doubt.

Evidence: overleaf/figures/foundation-v2-ck-abstract-original.png and its provenance; the retained Christenson–Kriner original and Markdown; historical source bibliography entry with DOI 10.1111/ajps.12262.

## 25. A skill makes a checking procedure reusable
**30:15–32:00 · 01:45 · PDF page 25**

A skill is a reusable written procedure, optionally supported by scripts, templates, and examples. State the standard once, improve it after use, and invoke it for a specific project. Walk through the four source-support steps on the slide: identify the exact sentence, read the source in context, judge support and scope, and propose a revision for researcher review.

The invocation forms and on-demand context details have moved to the appendix. The procedure makes its standard inspectable; it does not certify a result merely by being invoked.

Source: planning/oss-2.31.0/, versioned skills and invocation metadata.

## 26. Reference identity is only the first check
**32:00–33:45 · 01:45 · PDF page 26**

Show the existing two-reference result. Both references exist and their title, authors, journal, and pages match the DOI metadata. This is a scoped 16 September receipt, not a fresh full-bibliography audit. Citation-check also samples evidentiary use; its remit overlaps with fact-check. Invocation syntax is available in the appendix rather than on this slide.

Evidence: planning/receipts-2026-09-16/audit-receipt.md and retained Crossref response. ReevesRogowski2016 resolves to 10.1086/683433; ChristensonKriner2017 to 10.1111/ajps.12262.

## 27. The sentence determines the evidence required
**33:45–35:45 · 02:00 · PDF page 27**

Start from an exact manuscript sentence and its citation key, locate the source text, and inspect the relevant passage. The report records support, direction, scope, and limitations. The researcher reads the passage in context before accepting a proposed revision. Reserve the historical answer for Part 3.

The source layer must be prepared. In the NWO project, derived .NOTE.md summaries cannot substitute for source evidence. A source existing is a different question from its supporting the claim. Source: versioned fact-check plus the scoped historical receipt.

## 28. A paper can agree with itself and still be wrong
**35:45–38:00 · 02:15 · PDF page 28**

paper-review-lite checks argument, numbers, references, writing, figures, design reporting, preregistration, and the replication archive as applicable. Its default workflow has nine review dimensions and two cross-checkers; experimental dimensions may be not applicable to other designs. Explain the workflow rather than reading an agent roster.

Its Numbers reviewer can notice an abstract reporting 0.34 when the table reports 0.31. When both report 0.31, their agreement does not show that either matches the current analysis. In v2.31 a static package pre-pass supplies additional evidence to the Numbers and Archive reviewers; it does not calculate missing estimates. Execution remains an explicit decision.

The displayed numbers are illustrative, not findings from a real audit. The appendix preserves the review architecture and the separate conjoint example.

Source: versioned paper-review-lite, orientation and review specification.

## 29. Reading, running, and comparing answer different questions
**38:00–41:00 · 03:00 · PDF page 29**

The v2.31 bundled verifier has two tiers. The static tier reads package conditions, including entry point, seed/session markers, dependency files, selected absolute-path and credential patterns, and data hashes. These are heuristics, not guarantees of portability or complete security checks.

With explicit authorization, the execution tier runs the master script in a temporary copy on the current host. It records exit status and compares newly created filenames with the figure/table crosswalk. It inherits the host environment: this is not a hermetic sandbox. It does not compare numerical values or prove output freshness/content.

/oss:verify exposes these checks without a full submission audit. paper-review-lite consumes their evidence; replication-package uses them during package review. Skipped execution is NOT CHECKED. The separate project comparator in the illustrative case asks a different question: whether a fresh generated value agrees with reported values.

No general speed claim is made. The appendix records the verifier internals and its limits.

## 30. Two cases, one evidence trail
**41:00–43:00 · 02:00 · PDF page 30**

The next section follows two distinct cases. The first is an authentic historical source case: an archived manuscript sentence, its cited studies, the recorded source-check receipt, and a revision that actually occurred on 27 August. The 16 September check inspected that history; it did not cause the earlier revision.

The second is an illustrative numerical case: seven positive observations among twenty-five produce 0.28, while an abstract and table both retain 0.31. Its project-specific comparator reads a fresh machine-readable result and the reported values. It is captured material in demos/verification/, not a real research estimate, a live demonstration, or a built-in OSS numerical comparator.

Both cases preserve inputs, transformations, and a decision trail. Neither converts a passing check into a guarantee of substantive validity. The appendix keeps the replication-package handoff and conjoint examples as related, separate reference material.

## 31. Follow the evidence
**43:00–43:15 · 00:15 · PDF page 31**

Move from the general checking environment to the evidence trail. Keep the two cases distinct: the source case is authentic historical material; the numerical case is illustrative data designed to show a specified comparison.

## 32. The first case requires a same-policy comparison
**43:15–44:30 · 01:15 · PDF page 32**

Read the authentic archived comparative claim again. It requires evidence comparing executive and legislative routes for the same policy, not simply evidence that some respondents dislike executive power. Give the audience time to say what finding would establish that comparison. The full old sentence also qualified the claim with partisanship and policy agreement; retaining that qualification still does not establish the asserted route penalty.

**Evidence:** Old text is in manuscript parent `e50d2788ae8df3d3de63e4e9d26be919d4dea971`, `sections/frontmatter/front_matter.tex`; correction is `75366c6ca9ecc96148acba4840a4853c73f47c43`, 27 August 2026. Exact diff: `planning/receipts-2026-09-16/historical-claim-diff.txt`.

## 33. The sources are relevant, but the comparison is unsupported

**44:30–46:40 · 02:10 · PDF page 33**

The 16 September check first established that both cited works exist and match their DOI records. Its preflight then located both per-source Markdown files. The next question is substantive support, which requires reading what the studies actually tested.

Reeves and Rogowski show low generalized support for unilateral power. That is relevant, but it is not a direct comparison of two routes to the same policy. Christenson and Kriner directly test routes for student-loan and immigration policies; the route estimates are not statistically significant. That result does not establish a penalty, its opposite, equivalence, or the absence of a meaningful effect. The comparative claim is unsupported by the evidence attached to it.

Read the two displayed findings and connect each to the comparison required on the previous slide. The receipt documents the distinction between source identity, topical relevance, measurement, and support. A fluent summary alone could blur these distinctions.

**Evidence:** 16 September scoped receipt `planning/receipts-2026-09-16/audit-receipt.md`; source conversions in NWO `sources/md/`; C&K original PDF pp. 10–12, Tables 4–5, Markdown table ranges 396–423 and 479–504 and interpretations 425, 467, 477, 506, 548; R&R survey items and findings, Markdown 114–127. Both DOIs checked via Crossref content negotiation; metadata retained next to receipt. Source-support status is UNSUPPORTED for the comparative claim, not a declaration that the underlying studies are invalid.

## 34. The recorded revision narrows the claim
**46:40–48:05 · 01:25 · PDF page 34**

Show the actual old clause, source clause, and revised clause. The historical revision separates generalized support for unilateral powers from judgments of specific unilateral acts. Christenson and Kriner are attached to the narrower latter claim. These excerpts are clauses from longer sentences; the historical diff preserves the surrounding material.

The point is the chain from question through evidence to a recorded decision. The original paper, readable conversion, citation identity, explicit checking procedure, and revision history make the reasoning inspectable. A skill can help repeat the procedure; the researcher must still decide whether the interpretation and revision are warranted.

## 35. A fresh run exposes the stale result
**48:05–50:05 · 02:00 · PDF page 35**

Now switch explicitly to the illustrative numerical case. There are seven positive observations among twenty-five, so the current analysis computes 0.28. The abstract and table both still report 0.31. Their internal agreement conceals the stale result.

Run the analysis, read its generated machine-readable result, and compare that result explicitly with both reported values. The comparison fails. This is a captured project pipeline, not a live terminal demonstration or a result from the historical source case.

## 36. The agent catches the mismatch; the researcher owns the correction
**50:05–52:00 · 01:55 · PDF page 36**

The project-specific comparator can report that generated 0.28 disagrees with abstract 0.31 and table 0.31. Correct both reported values to 0.28 and repeat the same comparison; it passes. Missing output or failed analysis must never become a passing report.

The agent catches a mismatch only because the researcher supplied the input, fields, and comparison rule, then read the evidence and authorized the correction. A pass establishes this specified numerical agreement, not the validity of the underlying research. Retained code, inputs, commands, output, and hashes make the illustration reproducible.

**Transition:** Return to the three choices the audience can take into their own work.

## 37. What to take into your own work

**52:00–53:30 · 01:30 · PDF page 37**

Choose one routine task to automate, one capability to protect, and one question on which to collaborate. Classify by purpose, rather than assigning tools permanently to categories. The same paper can be filed automatically, read without assistance to develop an interpretation, and later compared with a draft through an agent-assisted procedure.

For collaboration, make the procedure and evidence visible. Start with a bounded question and a result that can be checked against actual files or sources.

## 38. Resources and discussion

**53:30–55:00 · 01:30 · PDF page 38**

Point to AI for Research for setup and worked examples, and Open Science Skills for reusable procedures. The browser capture is the actual deployed getting-started page. Leave these links visible for discussion. Installation is outside the main lecture; the Hub is the next step for someone who wants to try this in a project.

**Evidence:** https://scdenney.github.io/ai-for-research/ and https://github.com/scdenney/open-science-skills. Real captures and provenance are retained with the deck.

## Appendix notes

### 39. Source intake: what happens between the folders

**Outside the 55-minute budget · PDF page 39**

Explain naming and identity before conversion. The scaffold uses `sources/references.bib`; NWO uses `sources/references_master.bib`. Originals remain archival, while source text is convenient for searching and checking; consult the original when extraction is in doubt. `research-repo` creates the intake process; local `process-source` carries out intake, with `doc-to-markdown` supplying conversion options. Do not promise perfect conversion of tables, mathematics, or page locators. Keeping an original privately does not grant permission to redistribute it or its conversion.

**Evidence:** RR §§3–7; doc-to-markdown; NWO conventions.

### 40. Four ways to organize collaboration

**Outside the 55-minute budget · PDF page 40**

The role table makes the supervision grid concrete. In pair programming, human and agent plan, act, and check together. In a planning commission, the human plans and checks while the agent implements. In a review board, the agent plans and acts while the human reviews. In autopilot, the human instructs, the agent implements, and the agent validates against an explicit rule. Ultimate responsibility remains with the researcher in every arrangement.

This table describes collaboration arrangements; it is not a permission structure for handing all research decisions to an agent. It preserves the role reference moved out of Part 1.

**Evidence:** Kenny (2026), p. 16, adopting Colin Swaney’s “Claude Overload” workshop; table reorganized by role. The talk’s four research-task examples are illustrative applications, not examples recovered from that presentation.

### 41. Skill invocation and relevant context

**Outside the 55-minute budget · PDF page 41**

A skill is a written procedure for a recurring task, with optional scripts, templates, and examples. In the preserved v2.31 snapshot, it is explicitly invoked: for example, `/oss:research-repo .` in Claude Code or `$research-repo .` in Codex, where the period names the current folder. The named procedure then supplies task-relevant instructions.

This is on-demand context loading, not evidence of a measured token or time saving, a universal architecture for other skill libraries, or a successful project run. The researcher still provides the target, reads the resulting evidence, and decides what to do.

**Evidence:** preserved OSS v2.31.0 skill files and invocation metadata in `planning/oss-2.31.0/`.

### 42. Git, finished, and sitrep

**Outside the 55-minute budget · PDF page 42**

Git records local edits; GitHub keeps and shares that history. The minimal loop is edit, inspect the diff, commit with an explanation, and push. That makes a change attributable and recoverable. It does not establish that the change is correct.

At the end of a session, `finished` records changes, checks actually performed, and next actions. At the beginning of the next session, `sitrep` compares that handoff with the live repository. These procedures preserve continuity and make uncertainty visible; they do not verify the research.

**Evidence:** preserved OSS v2.31.0 `finished` and `sitrep` procedures.

### 43. paper-review-lite: review architecture

**Outside the 55-minute budget · PDF page 43**

The default workflow has nine review dimensions: argument, numbers, references, DOI identity, writing, design reporting, preregistration, figures and tables, and the archive. Two cross-checkers then verify passages and filter unsupported findings. Some experimental dimensions can be not applicable for another design.

The workflow can expose disagreement within a manuscript or package evidence available to reviewers. It does not calculate a missing estimate, replace source reading, prove that every concern was found, or establish research validity. The numbers used in the lecture’s numerical illustration are not findings from a real paper-review-lite audit.

**Evidence:** preserved OSS v2.31.0 `paper-review-lite` orientation and review specification.

### 44. /oss:verify: what it checks

**Outside the 55-minute budget · PDF page 44**

`/oss:verify` exposes the v2.31 replication-package verifier without a full submission audit. Its static tier checks package conditions: entry point, dependency files, seed/session markers, selected absolute-path and credential patterns, and data hashes. These are heuristics, not complete portability or security guarantees.

With explicit authorization, its execution tier runs the master script in a temporary copy on the current host, records exit status, and compares newly created filenames with the figure/table crosswalk. The copy inherits the host environment, so it is not hermetic. It does not compare numerical values or prove that outputs are fresh; skipped execution is NOT CHECKED. The illustrative numerical comparator in this lecture is a separate project check.

**Evidence:** preserved v2.31 verifier and command documentation in `planning/oss-2.31.0/`. The confirmed release change is a bundled replication-package verifier; an earlier keyword audit cannot establish that no prior skill or agent ever ran research code.

### 45. When a source check is not ready

**Outside the 55-minute budget · PDF page 45**

The current fact-check skill requires a prepared per-source Markdown knowledge base and no unconverted source backlog. It treats coverage below roughly two-thirds of cited non-background works in scope as not ready. This is an operational threshold, not a statistical guarantee or permission to ignore the uncovered third. Citation-check runs first. Missing, ambiguous, or insufficient sources remain visible. NWO additionally prohibits treating `.NOTE.md` summaries as source evidence. A summary's silence does not show that the original contains no relevant passage. No fresh full-project readiness result is claimed.

**Evidence:** FC §1 and §4–6; NWO AGENTS.md, Sources section. The skill can accept summaries in some settings but explicitly distinguishes their limits from faithful conversions; the local project rule is stricter.

### 46. Document the use of AI

**Outside the 55-minute budget · PDF page 46**

Ask what a reader needs to know to understand the assistance and inspect consequential decisions. Describe the task, tools and materials, human review, and limitations as relevant. This is the lecturer's discussion aid, not a universal disclosure template or a substitute for journal or institutional policy. The historical manuscript includes a Use of AI statement; its full model list is not reproduced. Absence of an AI record would not prove that a task was performed entirely without AI.

**Evidence:** Historical manuscript and prior notes audit; author disclosure discussion. No current journal-policy claim is made.

### 47. Make the results reproducible by others

**Outside the 55-minute budget · PDF page 47**

A research repository retains working sources, drafts, experiments, and decisions. A replication package is a curated release: README, entry script, environment, data or access instructions, and a mapping from reported outputs to producing code. An independent rerun is a separate test. The replication-package skill prepares and audits the handoff; it does not itself prove that a rerun succeeds or deposit the files. This appendix expands the companion skill introduced in Part 2 and distinguishes preparing a package from independently rerunning it.

**Evidence:** OSS replication-package skill, adapted from Yusaku Horiuchi's replication-package guide. No replication audit of NWO is claimed.

### 48. Literal BibTeX record

**Outside the 55-minute budget · PDF page 48**

The literal BibTeX record is the same canonical ChristensonKriner2017 excerpt previously on the main slide. Omitting keywords and wrapping whitespace does not change its metadata. Connect the key to the source file and manuscript citation. DOI 10.1111/ajps.12262.

### 49. Conjoint checks across the research process

**Outside the 55-minute budget · PDF page 49**

Use design specifications and data invariants to support analysis, reporting, appendix preparation, and review. Expected row counts, choice sums, and factor levels admit executable checks; estimand clarity and interpretation still require judgment. These are specified checks rather than receipts from a study audited for this talk.

## Evidence register

- **POC:** Matt Pocock, skills repository, snapshot `959a8e9f1edc3adbe2f7e3054bb6fbefa6696260`; `docs/engineering/diagnosing-bugs.md` and `docs/productivity/teach.md`. Software feedback and source-grounding illustrations, not empirical estimates of research quality. Public links and preservation in `planning/14-csdp-benchmark.md`.
- **OSS231:** Selected installed v2.31.0 skill and verifier files, with Codex file hashes and dirty-source status recorded separately: `planning/oss-2.31.0/SOURCE-MANIFEST.json`. This supersedes the older snapshot for current capability claims without rewriting that historical record.
- **NUM:** `demos/verification/receipts/verification-receipt.json`: illustrative binary dataset, generated proportion, stale and corrected report comparisons, failed-analysis and invalid/missing-output checks. Project-specific comparator; no OSS numerical parity feature or real research replication is claimed.

- **HIST:** Steven Denney's framework, examples, and project history in the lecture planning wiki. Hypothetical teaching examples remain hypothetical.
- **RES:** [AI for Research](https://scdenney.github.io/ai-for-research/), local `README.md` and `docs/getting-started/index.html`; [Open Science Skills](https://github.com/scdenney/open-science-skills), its README and skill sources. Installation belongs on the Hub. Avoid stale skill counts or describing a skill as merely a command.
- **KEN:** Christopher T. Kenny, *Agentic AI for Political Science Research*, 10 September 2026, CSDP / Data-Driven Social Science. Preserved local PDF: `planning/context-2026-09-17/local-sources/2026-09-10-csdp-ai.pdf`; foundations and the Part 1 collaboration grid, instructions and skills in Part 2, and persistent knowledge in the source-library discussion. The four delegation patterns retain their specific attribution. The revised introduction and other diagrams are original explanations, not repeated adaptations of that deck. See `planning/14-csdp-benchmark.md` for its source trail and comparison notes.
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

The published inputs, table locators, intervals, downloaded-source hashes, and interpretation limits are recorded in `overleaf/figures/evidence-plot-provenance.md`. `evidence-estimates.csv` holds the inputs; `build-evidence-plots.py` creates vector figures and `evidence-intervals.csv`. Intervals use estimate ± 1.96 × published rounded SE. No estimates were read from chart pixels. The author-copy source crop is documented in `overleaf/figures/README.md`. The authentic browser captures are documented in `overleaf/figures/browser-capture-provenance.md`: published research-repo audit-mode paragraph and sources-only scaffold at OSS commit `310509da268d7633a03e4e14f797eedd9d7df8dc`, plus the deployed AI for Research getting-started introduction. These are captures of existing public material, not new audit receipts. The retained historical browser excerpts show the Claude variant; current slide procedures use the separately pinned v2.31 records. The dated receipts record the installed skill versions actually applied.

- **KAR:** Andrej Karpathy, *LLM Wiki*, 4 April 2026, https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f. Raw sources / wiki / schema; ingest / query / maintenance. This is an abstract pattern, not a mandatory OSS implementation or a guarantee of sound synthesis.
- **SWAN:** Kenny slide 16 credits Colin Swaney's Spring 2026 Claude Overload workshop. Public workshop materials: https://github.com/princeton-ddss/claude-overload. The four pattern labels are directly documented in Kenny's slide; the public workshop README does not independently reproduce the grid.
- **RECEIPTS:** planning/receipts-2026-09-16/{audit-receipt.md,audit-receipt.json,crossref-metadata-2026-09-16.json,historical-claim-diff.txt}. Actual scoped execution on 16 September, with installed skill hashes, source locators, metadata, and unchanged reference-project git-state checks.

## Accuracy and presentation boundaries

- Main PDF pages: 38 including the cover, three part dividers, and three mode transitions. Appendix pages: eleven. Total: 49. Main-deck footers end at 31 and the appendix continues through 42; physical page 4 intentionally omits printed footer 3. Planned duration: 55 minutes; no timed rehearsal or live Zoom test is claimed.
- Agents are defined through available context, tools, and an iterative action loop. A browser interface can expose those capabilities. Project files are not automatically current context. A repository is an organised project folder with recorded versions; explain that term aloud when introducing the files.
- The three modes are the author's framework. Delegation patterns answer a separate question about who plans, acts, and checks. Software also requires specifications, tests, evidence, and judgment; passing tests is not complete correctness.
- Autor's junior results do not show average decline. The unaided task differs from the assisted task; greater dispersion is a separate result, not shown by the plotted mean intervals. Experience was not randomized. Bastani's tutor mitigated observed harm without establishing a learning advantage; Bassner qualifies any broader guardrail claim. Neither study establishes effects on graduate research skills.
- Keep the do-not-cite exclusions from planning/09-evidence-protect.md. The relayed review is not a newly completed systematic review; do not claim literature-wide counts as established here.
- The 102/102 original-to-Markdown count checks stems and file presence only. It does not validate extraction fidelity or full bibliography parity. The stale inventory finding does not imply the canonical bibliography is missing. Derived NOTE files cannot verify claims under this project's instructions.
- The 16 September receipt audits the actual pre-correction draft at e50d2788. The revision at 75366c6 is historical; no claim is made that today's skill procedure caused it. Nonsignificant route estimates do not demonstrate equivalence or the absence of an effect.
- Source identity and claim support overlap in the two checking skills. Fact-check consumes citation-check findings, checks readiness, and records unresolved cases. A summary can be insufficient evidence without the underlying source being unsupportive.
- Source conversion preserves an accessible representation, not guaranteed fidelity. The source's author copy has a 2016 production footer; its bibliographic publication year is 2017. The current main-deck crop is the first three abstract sentences from PDF page 1, matched to the Markdown conversion. Older retained crops have separate provenance and are not substituted for this artifact.
- Skill instructions and illustrative invocation forms are distinguished from actual execution receipts. Current OSS v2.31 excerpts are pinned by hashes in planning/oss-2.31.0/SOURCE-MANIFEST.json; the older snapshot and 16 September audit versions remain separately identified. No new skill was created in this revision.
- Preserve the boundary between source support and research validity: measurement, identification, inference, literature coverage, and truth require additional substantive work.
- No student material, Korean text, private credentials, pretest details, invented studies, or fabricated audit results belong in the lecture. Reference repositories remain read-only. Replication-package appears in Part 2 and the appendix; neither claims a completed release audit.

## Likely discussion questions

1. **How much must I read myself?** There is no universal fraction. The claim and your learning objective determine what you need to understand. You remain responsible for consequential interpretations; generated summaries are a route into sources, not a substitute for the evidence needed to defend a claim.
2. **Does a second model solve verification?** It can offer another reading, but shared errors and a common missing source remain possible. Compare the readings against the actual passage and keep unresolved questions visible.
3. **What about restricted material?** Decide which tools may access which files under the applicable terms. A replication package can document restrictions and access conditions. Do not imply that tracking a conversion grants permission to publish copyrighted source text.
4. **How can students learn while using AI?** Specify the capability being developed or assessed. Protect the cognitive work needed for it, then design assistance around that objective. Assess unaided understanding separately from the assisted product. The boundary may change with domain-specific expertise; these experiments do not establish a general rule for graduate research.

5. **What should I try first?** For a new project, ask research-repo to organize it around a source library. For an existing project, ask it to review the current organization first. Begin with a small set of sources you know, inspect their conversions and records, and then use citation-check and fact-check on a short section. Setup instructions are on AI for Research.
