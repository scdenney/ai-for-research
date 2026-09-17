# Speaker notes – Rethinking the Research Process

Revised 17 September 2026 after the Part 2 knowledge-base rebuild. **30 main PDF pages, fifteen appendix pages, 45 pages total.** Headings use physical pages. Main-deck footers end at 25. The author-edited physical page 4 intentionally omits printed footer 3. The separate Part 3 source remains preserved but is excluded from this working build pending its own review.

**55-minute plan:** introduction 00:00–08:00; Part 1 08:00–23:00; Part 2 and the two worked checks 23:00–47:00; closing 47:00–55:00. These are speaking allocations, not a measured rehearsal.

The purpose and basic vocabulary come first. The historical claim is introduced at the end of the introduction and returns at the start of Part 2. The three modes concern the whole research and teaching process. Part 2 begins with a source-check failure, establishes the knowledge-base and research-repo foundation, defines how skills focus agents, and then follows a historical revision and a separate illustrative numerical check.

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

Ask the audience what those sources would need to establish for the sentence to be accurate. Do not answer yet. Explain only that this is an actual excerpt from an earlier manuscript version. Part 2 returns to what these sources said, then shows the working arrangement used to inspect the evidence and record the revision.

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

## 14. AI assistance and later unaided review
**13:05–15:20 · 02:15 · PDF page 14**

Autor and colleagues studied 133 practising patent lawyers at 11 US firms over three months. Junior means fewer than seven years of experience and senior means seven or more. On the left, lawyers drafted a patent with AI available. On the right, they later reviewed and revised a patent without AI.

The assisted-drafting estimates are positive for both experience groups, although the senior interval crosses zero at the approximate 95 percent level. On the unaided review task, the junior estimate is near zero with an interval spanning zero, while the senior estimate is positive. The graph therefore supports the slide's interpretation that both groups drafted better with AI but only senior lawyers showed a clear later unaided gain.

Do not describe the junior result as an average decline or proof of no effect. The authors separately report greater dispersion among juniors, which is not shown by this plot. The tasks differ, professional experience was not randomized, and the study does not directly estimate effects on graduate research skills.

Evidence: Autor et al. (2026), NBER Working Paper 35720, Tables 4 and 6, column 4. Figure 3 and Table 7 report dispersion.

## 15. Practice with AI, then an exam without it
**15:20–17:35 · 02:15 · PDF page 15**

Bastani and colleagues studied high-school mathematics in Turkey. GPT Base provided unrestricted assistance. GPT Tutor provided guided assistance intended to support learning. Both groups performed better than the no-AI control during assisted practice.

The later exam was completed without AI. The unrestricted group scored 5.4 percentage points below control. The guided group estimate was close to zero. Guided AI raised practice scores and avoided the later penalty observed for unrestricted assistance, but it did not establish an unaided learning gain.

Keep assisted practice and the later exam separate. The study does not establish that guardrails improve learning in every setting. Bassner and colleagues provide a limited qualification from programming education, where better assisted performance did not produce greater measured learning.

Evidence: Bastani et al. (2025), PNAS, Table 1. Bassner et al. (2026), *Computers and Education: Artificial Intelligence* 10, 100537.

## 16. Combine human judgment with machine capability
**17:35–17:50 · 00:15 · PDF page 16**

Introduce collaboration as the broad category in which machine capability changes the scale, speed, or form of the work while the human retains responsibility for substantive decisions. Ethical machine augmentation is the goal.

## 17. Collaboration across research and teaching
**17:50–18:50 · 01:00 · PDF page 17**

Collaboration can operate throughout research and teaching. An agent can retrieve literature and compare passages, organize data and help write or test code, assist with visualisation, and help structure or revise writing. In supervision, it can organize feedback after the teacher has read and evaluated the work.

The researcher or teacher retains the substantive decisions about which sources matter, whether an analysis answers the question, what a draft should claim, and what judgment feedback should express.

## 18. What might protect learning?
**18:50–20:05 · 01:15 · PDF page 18**

Relevant prior knowledge is specific to the task. Shen and Tamkin recruited people with Python experience who had never used the Trio library being tested. Their preprint reports lower subsequent quiz performance with AI assistance. Identify the Anthropic affiliation and the preprint status. Avoid turning observed interaction patterns into proven instructional prescriptions.

Melumad and Yun compare learning from LLM syntheses with web search. Across seven experiments they examine reported depth of learning and the substance and reception of advice participants subsequently produced. These findings keep active engagement with sources in view. They do not test this lecture's research-repo workflow or establish a universal rule for graduate researchers.

## 19. Match supervision to the research task
**20:05–21:45 · 01:40 · PDF page 19**

Read the axes first. Complexity increases from easy to hard. Verifiability moves from subjective to objective. These are relative positions for a bounded task under its current checking conditions, not permanent categories for whole research activities.

Co-designing a study combines a complex problem with judgments about theory, measurement, and inference. Implementing a specified analysis is a candidate for delegation when the researcher has fixed the specification and can check the code and outputs. Reviewing a summary against a source is bounded but interpretive. Formatting references to a specified style provides explicit criteria for automated checks.

Protect comes before delegation. If doing a task develops the understanding someone needs, ease of checking does not by itself justify outsourcing it. The appendix preserves the detailed plans, acts, and checks role table.

Credit Kenny’s CSDP presentation, page 16, adapting Swaney’s Claude Overload workshop. The research tasks are illustrative applications added for this lecture.

## 20. Research moves through changing risk terrain
**21:45–23:00 · 01:15 · PDF page 20**

Apply the same axes to the research process. Ideation, theory, and interpretation often remain complex and judgment-heavy. Source work, analysis, writing, and publication contain more repeatable operations, but their verifiability becomes brittle when the source, specification, code, output, or reported claim becomes detached from the project.

The positions are illustrative zones rather than measurements. The same stage can move when the task, specification, evidence, or checking infrastructure changes. Follow the arrows through the project and use the dashed return path to show that findings generate revisions and new questions.

Transition directly to the source-check result. It is a concrete example of what happens when a sentence, its citations, and the evidence they contain do not line up.

## 21. The sources are relevant, but the comparison is unsupported
**23:00–26:00 · 03:00 · PDF page 21**

Return to the opening claim. Both cited works exist and concern public reactions to unilateral action. That relevance is insufficient for the comparison the sentence made.

Reeves and Rogowski show low generalized support for unilateral power. They do not compare executive and legislative routes to the same policy. Christenson and Kriner test routes for particular policies, but the relevant route estimates are not statistically significant. A nonsignificant result does not establish a penalty, its opposite, equivalence, or the absence of a meaningful effect.

The verdict is about support for this sentence, not the validity of the two studies. This distinction motivates the rest of Part 2. A useful workflow must preserve the sources, make the claim traceable to them, and retain the reason for any revision.

Evidence: the 16 September scoped receipt, retained source conversions, and Crossref records in `planning/receipts-2026-09-16/`.

## 22. A project knowledge base becomes a new brain
**26:00–28:30 · 02:30 · PDF page 22**

Introduce Karpathy's LLM Wiki as a related persistence pattern. Raw sources remain distinguishable from the wiki, and a schema records names, relationships, and provenance. Ingest creates the project memory. Query and maintenance keep it usable over time.

The transferable idea is persistent structured memory outside the model. A long chat is not a durable research record. An agent needs a bounded project it can inspect across sessions. Do not claim that Karpathy's architecture and research-repo are identical or that a wiki guarantees accurate synthesis.

Source: Andrej Karpathy, “LLM Wiki,” 4 April 2026.

## 23. The research repo grounds that memory in evidence
**28:30–31:30 · 03:00 · PDF page 23**

The research repository is the practical foundation. `sources/og/` preserves acquired originals. `sources/md/` provides readable source text for agents and researchers. `references.bib` links manuscript citation keys to source identities. Analysis, manuscript, and review files operate on the same bounded project. Git records changes.

The source library is the spine because downstream procedures depend on it. A fact check without source text, a citation audit without stable identities, or a numerical comparison without retained inputs is operating on missing evidence. Derived notes and syntheses remain distinguishable from original sources.

This is the central architecture of the talk. The repository does not merely store files. It creates the conditions under which claims, analyses, and revisions can be inspected.

Source: preserved OSS 2.31.0 `research-repo` skill.

## 24. A skill focuses an agent on a repeatable task
**31:30–34:30 · 03:00 · PDF page 24**

Define the pieces separately. The LLM interprets context and generates language. Tools allow reading, searching, running, and editing. An agent combines the model and tools in an iterative task loop. A skill supplies a reusable procedure, criteria, and checks. The research repo supplies the project evidence and history.

The skill does not replace the model. It focuses how the agent uses the model and tools on this project. The output can be a receipt, a proposed revision, or an unresolved question. None of those should be treated as correct merely because a skill produced it.

Invocation details and an example fact-check procedure are in the appendix.

## 25. Skills make different checks repeatable
**34:30–37:30 · 03:00 · PDF page 25**

Reading, running, and comparing answer different questions. Citation-check and fact-check inspect identities and claim support. `/oss:verify` and replication-package inspect package conditions and can run an authorized entry point. A project-specific numerical check compares fresh output with reported values.

Do not blur their capabilities. The OSS verifier does not compare numerical contents. A successful run does not show that the research question, design, measurement, or interpretation is valid. Verification asks whether the artifacts match the specified evidence and procedure. Validation asks whether the specification and substantive choices warrant the claim.

## 26. The recorded revision narrows the claim
**37:30–41:00 · 03:30 · PDF page 26**

Show the historical diff. The old clause asserted a relative penalty for executive action. The revised clause separates low generalized support for unilateral powers from judgments of particular unilateral acts. Each cited work is now attached to the narrower proposition it actually helps support.

The source evidence is preserved, the researcher judges support, and Git records the change. The revision occurred on 27 August. The 16 September receipt inspected the historical record later. Do not imply that the later skill run caused the earlier correction.

## 27. A fresh run exposes the stale result
**41:00–44:00 · 03:00 · PDF page 27**

Switch explicitly to the illustrative numerical case. Seven positive observations among twenty-five produce 0.28. The abstract and table both retain 0.31. Their agreement with each other hides the stale result.

The project pipeline runs the analysis, reads the generated machine-readable value, and compares it with both reported fields. The check fails. This is illustrative data and a project-specific comparator. It is not an NWO estimate or a built-in OSS numerical comparison.

## 28. The agent finds the mismatch. The researcher decides.
**44:00–47:00 · 03:00 · PDF page 28**

The agent runs the explicit comparison and identifies both stale fields. The researcher inspects the data, measure, and intended specification before authorizing any correction. The agent then updates the reported fields and reruns the same pipeline from the retained input.

The passing receipt shows that the fresh value and both reported fields now agree. It does not establish that 0.28 is the right estimand, that the data are valid, or that the claim is substantively warranted. Those remain validation judgments.

## 29. What to take into your own work
**47:00–50:00 · 03:00 · PDF page 29**

Return to the three modes. Automate one routine task with an inspectable result. Protect a capability that the work is meant to develop. Collaborate through a shared research workspace whose sources and outputs can be checked.

The practical starting point is small. Organize one project around a source library, inspect the conversions and citation records, then apply one named procedure to one bounded claim or result.

## 30. Resources and discussion
**50:00–55:00 · 05:00 · PDF page 30**

Use the remaining time for discussion and questions. AI for Research provides setup walkthroughs and teaching materials. Open Science Skills contains the reusable procedures behind the workflow.

The separate Part 3 demo source is preserved for the next revision and is not part of this working build.

## 31. Appendix
**Outside the 55-minute budget · PDF page 31**

The remaining slides hold implementation details, limits, and supporting examples removed from the main teaching sequence.

## 32. A searchable source still needs its original
**Outside the 55-minute budget · PDF page 32**

The original PDF, readable conversion, and citation key serve different purposes. The conversion supports search and agent reading. The original remains necessary when extraction, page context, tables, or formatting are in doubt.

## 33. Example skill procedure
**Outside the 55-minute budget · PDF page 33**

Use fact-check as one concrete procedure. It identifies the sentence and citation, reads the source passage in context, judges support and scope, and proposes a revision for the researcher to review.

## 34. Reference identity is only the first check
**Outside the 55-minute budget · PDF page 34**

Both references resolve to the expected works. Identity is necessary but does not establish that either source supports the sentence attached to it.

## 35. Source intake between folders
**Outside the 55-minute budget · PDF page 35**

Intake preserves the acquired original, inspects a readable conversion, and registers the bibliography record. Missing material and conversion limits remain visible.

## 36. Four ways to organize collaboration
**Outside the 55-minute budget · PDF page 36**

The four labels describe who plans, acts, and checks. They are collaboration patterns rather than permanent properties of whole research stages. Credit Kenny's adaptation of Swaney.

## 37. Skill invocation and relevant context
**Outside the 55-minute budget · PDF page 37**

The invocation names a procedure for the current folder. The skill loads task-relevant instructions and supporting resources. The researcher inspects the resulting evidence and decides what happens next.

## 38. Git, finished, and sitrep
**Outside the 55-minute budget · PDF page 38**

Git records local changes and GitHub can share the history. `finished` records changes, checks, and next actions. `sitrep` compares that handoff with the live repository. A committed change is recoverable and attributable, not automatically verified.

## 39. paper-review-lite review architecture
**Outside the 55-minute budget · PDF page 39**

The workflow uses nine review dimensions and two cross-checkers. It can expose internal inconsistencies and assemble available package evidence. It does not calculate missing estimates, replace source reading, or establish validity.

## 40. What /oss:verify checks
**Outside the 55-minute budget · PDF page 40**

The static tier checks package conditions. Authorized execution runs the master script in a temporary copy on the current host and records exit status and created filenames. It is not hermetic and does not compare numerical values.

## 41. When a source check is not ready
**Outside the 55-minute budget · PDF page 41**

A missing or incomplete source library should stop a claim-support audit. Record unresolved citation keys, absent text, and incomplete conversions. Unchecked does not mean supported.

## 42. Document the use of AI
**Outside the 55-minute budget · PDF page 42**

Describe the assistance, accessible materials, consequential human decisions, unresolved limitations, and records needed to inspect the work. This is a discussion aid rather than a universal disclosure template.

## 43. Make the results reproducible by others
**Outside the 55-minute budget · PDF page 43**

Distinguish the working repository, a curated replication package, and an independent rerun. Preparing a package does not prove that another researcher can regenerate every output.

## 44. Literal BibTeX record
**Outside the 55-minute budget · PDF page 44**

This is the complete record used in the source-library example. Connect the citation key to the source file and manuscript citation.

## 45. Conjoint checks and judgment
**Outside the 55-minute budget · PDF page 45**

Design and data invariants admit systematic checks. Estimand clarity, subgroup interpretation, uncertainty, external validity, and reporting still require judgment.

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

- Main PDF pages in this working build: 30 including the cover and three mode transitions. Appendix pages: fifteen. Total: 45. Main-deck footers end at 25; physical page 4 intentionally omits printed footer 3. The separate Part 3 source remains preserved but excluded pending review. Planned duration: 55 minutes; no timed rehearsal or live Zoom test is claimed.
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
