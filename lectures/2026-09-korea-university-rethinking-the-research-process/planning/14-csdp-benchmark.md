# CSDP benchmark · 17 September 2026

Use this note during the author review of the Korea University deck. It records what the CSDP presentation contributes to the benchmark, where the current deck already overlaps, and which claims should not be imported without qualification. It is a comparison source, not a new storyboard.

## Source and preservation

Christopher T. Kenny, *Agentic AI for Political Science Research*, Center for the Study of Democratic Politics, Princeton University, 10 September 2026, 32 pages. The public copy is at <https://christophertkenny.com/files/2026-09-10-csdp-ai.pdf>; the event page is <https://csdp.princeton.edu/events/skills-workshop-agentic-ai-political-science-research>.

The Downloads copy is already preserved as `planning/context-2026-09-17/local-sources/2026-09-10-csdp-ai.pdf`, with a `pdftotext -layout` extraction beside it. Its SHA-256 value is `8f012d0f1e2354e0092dcc24f49d97ada0215d338694e8993618fb528bc65105`, identical to `/Users/scdenney/Downloads/2026-09-10-csdp-ai.pdf`.

The following primary materials referenced by the presentation were retrieved on 17 September 2026 under `planning/context-2026-09-17/local-sources/csdp-references/`:

| Material | Saved snapshot | Revision |
|---|---|---|
| Kenny, political-science skills | `kenny-skills/` | `0361413ac4ffa90582a78a6d9dbf04c849c3913d` |
| Swaney, *Claude Overload* workshop | `claude-overload/` | `44773a64cce9067ef42ca8234c90aaa5d3c3af7d` |
| Kenny, CSDP LLM Wiki demonstration | `csdp-llm-wiki/` | `c326e03cc7b12f3f5da0588328af317045ed1c07` |
| Karpathy, *LLM Wiki* idea file | `karpathy-llm-wiki/` | `ac46de1ad27f92b28ac95459c782c07f6b8c964a` |
| Matt Pocock, engineering skills | `mattpocock-skills/` | `959a8e9f1edc3adbe2f7e3054bb6fbefa6696260` |
| Matt Pocock, AI-coding dictionary | `mattpocock-dictionary/` | `251fec7ec3b08059e4203863024e6123090a54e3` |
| Kenny’s public teaching page | `kenny-teaching.html` | SHA-256 `7ee277a9160b0f06e7f7376f9eb68b40e689fd40b9110abac7d1eb252f394254` |

These full snapshots are local and Git-ignored under the existing acquired-source policy. This tracked note preserves their URLs and exact revisions. The ALARM Project GenAI Usage Guidelines cited on slide 15 were not located as a public standalone document. The Princeton Research Computing page confirms the future “AI-as-an-RA Workshop” listing, but it does not yet provide workshop materials: <https://researchcomputing.princeton.edu/learn/workshops-live-training>.

McCarty’s *Polarization: What Everyone Needs to Know* appears on slide 8 only to illustrate tokenization. Its publisher record and DOI are sufficient for that reference; no copyrighted book copy was acquired: <https://doi.org/10.1093/wentk/9780190867782.001.0001>.

## What the CSDP deck explains especially clearly

1. **Agent anatomy.** The Model / Context / Tools decomposition and the task → model → tool → result loop are concise. Our foundations already cover the same mechanism, but this is the clarity benchmark: each term should do one job, and the loop should be readable in a few seconds.
2. **Concrete affordances.** The tool list uses ordinary verbs—find, read, write, run, search, inspect. That is a useful test for our introductory wording.
3. **Version control as a working habit.** “Commit → prompts → review diff → commit or revert” is memorable. Our current slide correctly adds explained checkpoints and GitHub’s role, but its visual sequence should remain equally easy to grasp.
4. **Concrete failure modes.** The verification section names listwise deletion, swallowed warnings, silent exception handling, special-case patches, and ignored weights. These examples are more useful than generic warnings that agents can be wrong.
5. **A tangible persistent workspace.** The CSDP demo repository makes the LLM Wiki idea inspectable: immutable raw sources feed source notes, concepts, syntheses, an index, and an append-only log. Its `AGENTS.md` also makes evidence boundaries and conversion rules explicit.

## Where our lecture should remain distinct

- The Korea University lecture is organized around **Automate / Protect / Collaborate**, including the learning and judgment evidence. CSDP is organized around agent concepts, customization, verification, and an LLM Wiki.
- Our Part 2 presents a source-based research repository plus separate citation identity, claim-support, and replication-package workflows. The CSDP demo emphasizes a maintained knowledge graph. These are related persistence strategies, not identical systems.
- Our running historical claim gives Part 3 a closed evidence trail and a revision decision. The CSDP demo shows a wider corpus and knowledge graph. Borrow its inspectability, not its substantive redistricting example.
- Kenny’s four usage models are already credited on our collaboration slide, including their origin in Swaney’s workshop. Keep that attribution at the point of use; do not repeat it throughout the deck.

## Claims not to inherit as written

- “Correctness matters much more for research” is too broad. Our current distinction is better: software has executable feedback, while research also requires source interpretation and substantive judgment.
- “Wholesale hallucination is less likely these days” is model- and time-dependent and unsupported on the slide.
- A fixed Codex context-window size and page equivalent are product claims that can change.
- “You need to be able to assert that all code is correct” overstates what tests, review, and reproducibility can establish.
- Password protection alone is not a general answer to sensitive-data governance.
- Karpathy’s statement that LLMs do not get bored or forget should be treated as persuasive framing, not an empirical premise.

## Implications for the next deck pass

### Introduction

Use the CSDP deck as a compression test. Our definitions of LLM, generative AI, agent, context, and tools should be at least as immediate as its Model / Context / Tools slide, while retaining our more careful distinction between software feedback and research validation.

### Part 1

Keep the three modes and the learning evidence. Review the four collaboration patterns for visual simplicity against CSDP slide 16, but preserve the role-based reorganization and existing attribution.

### Part 2

Make the source repository feel like a working environment rather than a folder diagram. The strongest CSDP benchmark is the visible progression from raw source to source note, concept, synthesis, index, and log. Our corresponding progression should stay faithful to `research-repo`: original → readable Markdown → bibliography → citation/claim checks, with Git history around the work.

### Part 3 demo

Show one continuous trace rather than three static explanations: archived manuscript claim → cited references → readable source passages → `fact-check` judgment → revised claim → inspectable diff/commit. Keep the current result—the reference existed and the claim needed revision—but make the live or captured actions visible enough that the audience can see how the infrastructure from Part 2 changes the decision.

The CSDP LLM Wiki is a useful benchmark for this because its components are inspectable, but our demo should remain smaller and more decisive. It should close the question introduced near the start of the talk and demonstrate human responsibility for the revision.

The author's subsequent verifiability argument, the software/research comparison, the Matt Pocock material, and the proposed Part 2 anchor are consolidated in `15-verifiability-and-deep-dive-context.md`.
