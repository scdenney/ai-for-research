# Verifiability and the Part 2 deep dive · author context · 17 September 2026

This note combines the existing lecture direction with the author's 17 September additions. It is the source context for the approved 17 September plan in 02-rebuild-storyboard.md. The central addition is **verifiability**: how the research process can be made inspectable and checkable enough for productive agentic work, even though research lacks many of software development's fast, objective feedback signals.

## The revised overview

The talk still begins with the practical question of how to use AI in research and teaching. **Automate / Protect / Collaborate** remains the normative framework for deciding what kind of engagement a task warrants. The new connective argument is that delegation also depends on two properties of the task:

1. **Complexity:** how difficult the task is to specify, execute, and diagnose.
2. **Verifiability:** how readily a human or machine can determine whether the result meets the relevant standard.

Page 16 of Christopher Kenny's CSDP deck places four delegation models on these axes. Complexity runs from easy to hard; verifiability runs from subjective to objective:

| | More subjective verification | More objective verification |
|---|---|---|
| **Hard** | Pair Programming: human and model work together at every step | Planning Commission: human makes the plan; model implements |
| **Easy** | Review Board: model plans and implements; human reviews | Autopilot: human instructs; model implements and validates |

Kenny labels the model as adapted from Colin Swaney's Spring 2026 “Claude Overload” DDSS workshop. We can reproduce or redraw it with attribution. The public record currently supports the chain **our slide → Kenny page 16 → Kenny's attribution to Swaney**. It does not independently establish that the exact quadrant appeared in Swaney's released files.

The point of the grid is not that a task has one permanent location. Verifiability changes with the infrastructure around it. A vague coding task becomes more verifiable when it gains a specification, types, tests, fixtures, browser checks, and a reproducible failure. A research task becomes more verifiable when it gains preserved sources, stable representations, explicit estimands, scripted transformations, diagnostic checks, provenance, and a recorded review trail. Building those conditions is part of the work.

## Verifiability, not a general theory of validity

The lecture should use these terms deliberately.

- **Verifiability** asks whether another person can inspect the inputs, transformations, evidence, and decision criteria and check what was done.
- **Validity** asks whether the design, measurement, inference, and interpretation warrant the substantive conclusion.

The lecture's practical focus is verifiability. It should not imply that a clean audit trail proves a claim true or that a passing check establishes research validity. Better verifiability makes errors, unsupported claims, and disagreements easier to locate. Validity still requires methodological and substantive judgment.

This makes the software/research comparison more precise than “correctness matters more in research.” Both domains care about correctness. The difference is the kind and speed of feedback available.

| Software development | Research |
|---|---|
| A compiler, type checker, unit test, linter, or browser can often produce a fast, repeatable signal. | A claim may require identifying the right source, interpreting it in context, evaluating a design, and deciding whether the inference travels. |
| Expected behavior can often be specified as an input/output condition. | The object of evaluation may be an estimand, evidentiary interpretation, measurement decision, or argument whose standard is only partly formalizable. |
| A failure can often be reproduced and turned into a regression test. | A challenge may require reconstructing provenance, rerunning an analysis, reading sources, or comparing reasonable interpretations. |
| The loop can often be automated: run → fail → revise → pass. | The loop is mixed: retrieve → inspect → diagnose → calculate or compare → judge → record what remains uncertain. |

Research is therefore harder to delegate safely when the check remains subjective, slow, underspecified, or unavailable to the agent. The response is not simply “keep a human in the loop.” It is to construct an inspectable research environment and identify which parts admit deterministic checks, which admit structured review, and which remain decisions for the researcher.

## What Matt Pocock contributes

Matt Pocock's public skills repository offers a useful software-development benchmark. Its core idea is that an agent without feedback on how its code runs is “flying blind.” Static types, browser access, automated tests, and red-green-refactor cycles make the work more verifiable.

The strongest example is `diagnosing-bugs`. It refuses to form a theory until it has a named, already-run command that can go red on the reported bug and green when it is fixed. It then minimizes the reproduction, ranks falsifiable hypotheses, instruments one variable at a time, fixes the cause, and reruns the original scenario. The relevant lesson is not that research should imitate unit tests literally. It is that a workflow improves when the acceptance signal, evidence, and stopping condition are made explicit before the agent acts.

Pocock's `teach` material supplies the necessary limit. It treats model knowledge as untrusted, builds from recorded sources, and uses citations to make verification cheaper. It also states that the primary sources still need to be read and that the skill cannot make itself reliable merely by citing them. That is very close to the distinction this lecture needs: infrastructure lowers the cost of checking without replacing judgment.

Use Pocock as a software-side illustration and acknowledge the source. Do not import his software claims as empirical evidence about research quality. The useful concepts are:

- feedback is the speed limit;
- build the checking loop before asking an agent to iterate;
- require an observable failure or acceptance condition;
- make state, specifications, and evidence durable outside the conversation;
- distinguish a checkable signal from a claim of complete correctness.

## The Part 2 anchor: research repository and knowledge base

Part 2 should now have one unmistakable anchor: **the research repository is the infrastructure that makes agentic research work more verifiable**. The knowledge base is not an ornamental collection of summaries. It organizes the chain from source to decision.

The sequence should be presented as one connected system:

```text
original sources
    ↓ preserve and identify
readable source representations + bibliography
    ↓ connect evidence to stable records
research notes, code, data, drafts, and explicit project instructions
    ↓ inspect changes through Git history
domain-specific checks and reusable skills
    ↓ produce findings, receipts, and unresolved questions
researcher reviews the evidence and remains responsible for the decision
```

This is where the related LLM Wiki material belongs. Karpathy and Kenny show how persistent Markdown pages, indexes, logs, concepts, and syntheses can accumulate across sessions. Our `research-repo` approach adds a stricter source and bibliography contract. The lecture can present them as related answers to the persistence problem while keeping their architectures distinct.

## Skills plugged into the repository

The additional skills should appear as checks operating on the shared foundation, not as an unrelated catalog.

### `citation-check`: source and reference identity

Checks whether the cited work exists, whether metadata and identifiers resolve correctly, whether in-text citations match the reference list, and whether the cited item is the work the manuscript says it is. Its output increases verifiability by making the identity trail inspectable.

### `fact-check`: claim support

Starts from an exact manuscript claim and the acquired source record, locates the relevant evidence, and returns a support judgment with quoted or precisely located evidence and unresolved limitations. It does not establish the truth of the wider theory or research design.

### Domain-specific design, cleaning, and diagnostics

The conjoint suite is a useful example of importing discipline-specific checks into the loop:

- `conjoint-design` requires explicit attributes, restrictions, estimands, power logic, error risks, reference levels, and planned diagnostics before implementation.
- `conjoint-cleaning` specifies a deterministic, scripted profile-level conversion with checks for row counts, choice sums, factor levels, exclusions, package compatibility, and reproducibility metadata.
- `conjoint-diagnostics` reviews design integrity, estimation, measurement error, external validity, and interpretation; when code or data are supplied, it directs review of the implementation as well as the paper's prose.

This illustrates the research analogue to a software feedback loop. Some gates can be machine checked. Others produce prioritized findings for human adjudication. The skill makes the standard explicit, applies it consistently, records evidence, and leaves the research judgment visible.

These checks can support study design, analysis, manuscript reporting, technical appendices, and later review. They are strongest when they connect to the same preserved sources, data, code, decisions, and version history.

### `replication-package`: a related but separate handoff

Replication work follows the same logic of explicit artifacts, scripts, environments, checks, and evidence. It belongs after or beside the core repository workflow because it prepares a curated release for someone else to inspect and rerun. It should not displace the main Part 2 story. A well-formed package improves verifiability; an independent rerun is a further test, and neither alone establishes the validity of every substantive claim.

## Implications for the three parts

### Introduction

Introduce the agent loop and then make the asymmetry visible: coding agents often receive fast executable feedback, whereas research agents work across sources, transformations, methods, and judgments. This establishes the problem the rest of the lecture answers.

### Part 1

Keep Automate / Protect / Collaborate as the decision framework. Add the complexity/verifiability grid as a second lens on **how closely** a researcher should supervise a task. The three modes answer what kind of engagement the task deserves; the grid answers how much planning, joint work, review, or autonomous iteration its current verification environment permits.

The two frameworks should not be collapsed. A task can be easy and objectively checkable but still worth protecting because it develops the student's understanding. Conversely, a complex research transformation might be delegated under a Planning Commission model when its plan and checks are strong.

### Part 2

Make the research repository and knowledge base the main deep dive. Show how preserved sources, readable text, bibliography, instructions, project files, and Git history create the environment in which citation-check, fact-check, conjoint checks, and replication preparation can operate. Each skill should answer one concrete question and leave an inspectable result.

### Part 3

Use the historical claim to demonstrate the completed loop:

```text
claim in an archived manuscript
    → identify its cited works
    → inspect the preserved sources
    → distinguish reference identity from claim support
    → record the judgment and limitations
    → revise the claim
    → inspect the diff and commit history
```

This is the payoff: the repository and skills do not merely generate an answer. They make it possible to see which source was used, what the check found, why the wording changed, and where human judgment entered.

## Attribution and source status

- **Kenny quadrant:** Christopher T. Kenny, [*Agentic AI for Political Science Research*](https://christophertkenny.com/files/2026-09-10-csdp-ai.pdf), CSDP, 10 September 2026, page 16. The slide says it was adopted from Colin Swaney's Spring 2026 “Claude Overload” DDSS workshop.
- **Swaney search result:** [Princeton Research Computing's Spring 2026 materials page](https://researchcomputing.princeton.edu/spring-2026-workshop-materials) lists the 20 March workshop but shows no materials link. The public [`princeton-ddss/claude-overload` repository](https://github.com/princeton-ddss/claude-overload) contains eight demonstration outlines and no slide deck in its current tree, branches, releases, or nine-commit history. Searches of Swaney's public repositories and gists found no separate deck. Slides are therefore **not publicly located**, rather than proven not to exist.
- **Pocock:** [`mattpocock/skills`](https://github.com/mattpocock/skills), locally captured at `959a8e9f1edc3adbe2f7e3054bb6fbefa6696260`; relevant files are `README.md`, `docs/engineering/diagnosing-bugs.md`, `docs/engineering/tdd.md`, and `docs/productivity/teach.md`. His [AI-coding dictionary](https://github.com/mattpocock/dictionary-of-ai-coding) is captured separately at `251fec7ec3b08059e4203863024e6123090a54e3`.
- **Local source snapshots:** `planning/context-2026-09-17/local-sources/csdp-references/`, intentionally Git-ignored. Exact public URLs and revisions are recorded in `14-csdp-benchmark.md` and this note.

## Questions recorded before plan approval

These questions were settled by the approved 17 September storyboard; retained here to show the planning history:

1. whether the complexity/verifiability quadrant replaces or follows the current four-pattern table;
2. which single Pocock feedback-loop example can be explained without turning the lecture into a software-engineering talk;
3. how many layers of the research-repository stack can be shown clearly on one slide;
4. whether conjoint appears as a compact domain-specific example in Part 2 or an appendix illustration;
5. which actions in Part 3 are shown live, captured, or represented by authentic artifacts;
6. what evidence constitutes “done” for each demonstration step, and where the researcher must still adjudicate.

## v2.31 integration and verified limits · 17 September 2026

The release capture is preserved in inbox/. The approved sequence now adds paper-review-lite before a numerical demonstration, and distinguishes three forms of evidence: manuscript consistency, package execution, and explicit agreement between generated and reported values. The demo supplies the third as a project-specific check; it is not a shipped OSS feature.

paper-review-lite has nine review dimensions and two cross-checkers. Its static pre-pass supplies package evidence to the Numbers and Archive reviewers, but cannot establish a new estimate. verify_package.py checks static package conditions and data hashes; its opt-in temporary-copy run records exit status and newly created output filenames against a crosswalk. It inherits the host environment and does not compare numeric contents. Skipped execution remains NOT CHECKED.

The confirmed historical change is a bundled replication-package verifier, not proof that no earlier skill or agent ran any research code. Conjoint procedures specify or review checks; an actual run needs its own evidence. sitrep and finished preserve session state and distinguish committed from verified work. v2.31 skills are explicitly invoked on both platforms; no fixed token or timing saving is asserted.

Planning decisions above are settled in the current storyboard: main quadrant with role-table appendix; one compact Pocock example; repository as anchor; main conjoint illustration plus appendix; captured numerical example in Part 2; historical source demonstration in Part 3. The raw release capture's broad claims are retained as author context, with the implementation-derived corrections recorded here and in 08-open-questions.md. Separate source provenance: oss-2.31.0/.
