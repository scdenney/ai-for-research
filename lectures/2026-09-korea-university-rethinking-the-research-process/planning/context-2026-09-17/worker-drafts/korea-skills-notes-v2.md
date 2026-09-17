## 0. How I use skills in research

**Duration: 00:20**

This section follows one continuous workflow. I start with a reusable procedure, use it to build a source-centred project, inspect one PDF conversion and its citation record, then show the two checks that operate on that foundation. I close with the separate job of preparing the research outputs for replication.

## 1. What is a skill?

**Duration: 03:00**

A skill is a set of reusable instructions that an agent follows for a named kind of work. The essential part is the written procedure. Scripts, templates, and worked examples are optional supporting materials.

I write a skill when a task recurs and I can state the standard for doing it. That lets me improve the procedure after real use and invoke it again without rebuilding the standard in every prompt. A skill is more specific than the project-wide instructions and more durable than the request I type for one run.

The excerpt is from the current Open Science Skills `research-repo` skill. Its purpose is to set up a new research repository or audit an existing one. The displayed step labels are literal section headings: “Resolve the target and decide the mode” and “Document the intake pipeline.” The output line is a compact rendering of Step 8: report the mode, the tree or status, gaps, and the next three actions.

Use the two links for different purposes: Open Science Skills contains reusable research procedures; AI for Research contains installation, setup, and demonstrations.

Source locators: `/Users/scdenney/Documents/github/resources/open-science-skills/plugin/skills/research-repo/SKILL.md`, description and “Scope and organizing principle,” Step 1, Step 5, Step 8. Links: `https://github.com/scdenney/open-science-skills`; `https://scdenney.github.io/ai-for-research/`.

## 2. research-repo builds the foundation

**Duration: 02:50**

Here “repository” means the whole project folder: sources, analysis, manuscript, and outputs. The knowledge base is the readable source layer inside it. The originals remain the archival record. Markdown gives the agent inspectable source text. The BibTeX file connects a citation key to the identity of that work.

The arrows below show why this structure matters. Literature work consumes readable sources for comparison and synthesis. `citation-check` operates on citation identities and manuscript/reference parity. `fact-check` needs the exact local source text to compare evidence with a manuscript claim.

`research-repo` establishes this structure. The repo-local `process-source` procedure performs one source intake, including conversion. `literature-review` is a downstream consumer; it does not replace the source layer.

Karpathy’s LLM Wiki is a useful related model of a persistent workspace: keep raw sources, a derived wiki, and a schema rather than relying on conversation history alone. This slide adapts that persistence idea to a research project; it does not claim that the two structures are identical.

Source locators: `research-repo/SKILL.md`, “Scope and organizing principle,” Steps 3–6. Karpathy, “LLM Wiki,” 4 April 2026: `https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f`.

## 3. Use the same skill to set up or review a project

**Duration: 02:20**

These are the two visible invocation forms. Claude Code uses `/oss:research-repo`; Codex uses `$research-repo`. The period means the current project folder.

The plain-language request is the same in either environment: “Set up this project around a source library. If files already exist, review the current structure before proposing changes.” The task determines the mode. In a new project, the skill creates the missing source spine and suitable project folders. In an existing project, it first reads what is there and reports what is present and what needs attention.

The invocation loads a procedure; the request still supplies the target and the intended task. I would add constraints such as “do not edit files” when I want a read-only review.

Source locators: `research-repo/SKILL.md`, description, Step 1 “Resolve the target and decide the mode,” and Step 3 “Scaffold the sources spine.”

## 4. Convert a PDF into readable source text

**Duration: 03:10**

This is the same passage in two forms. At left is an authentic crop from page 1 of Christenson and Kriner’s article. At right is the literal text in the project’s Markdown conversion. I use only the first three abstract sentences here, ending “little is known,” so the source-checking answer remains for Part 3.

The intake sequence is concrete. Identify the work. Preserve the original. Convert the prose with OpenDataLoader PDF. Inspect the converted text against the original. Then create or update the bibliographic record separately. The converter produces Markdown; the agent is responsible for the bibliographic step and for checking that the result is usable.

The side-by-side comparison is the review step. A file’s existence does not show that every sentence, table, or symbol converted correctly.

Source locators, read only: `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash/sources/og/christenson-kriner-2017-constitutional-qualms-unilateral.pdf`, page 1; corresponding Markdown file, line 7. Intake procedure: `research-repo/SKILL.md`, Step 5 and the OpenDataLoader conversion script description.

## 5. Keep the source file and citation key connected

**Duration: 02:25**

This is a literal, valid BibTeX excerpt from the project’s canonical bibliography. I omitted only the `keywords` field and wrapped long values for display. The author, title, journal, year, volume, issue, pages, DOI, key, and braces are preserved.

The three handles point to one work. `ChristensonKriner2017` is the bibliography key. The Markdown filename is the local readable source. The manuscript uses the key inside `\cite{...}`. The filename and key do not need identical punctuation, but they must be resolvable to the same author, year, and work.

This connection is what lets a later check move from a manuscript sentence to a bibliographic record and then to the source text that was actually read.

Source locator, read only: `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash/sources/references_master.bib`, entry `ChristensonKriner2017` (currently lines 966–976). Contract: `research-repo/SKILL.md`, Step 6 “The BibTeX contract.”

## 6. Check references with citation-check

**Duration: 02:40**

The invocation pattern is the same: load the skill and give it the manuscript and bibliography. `citation-check` inventories the citations, checks in-text/reference-list parity, resolves identifiers, and compares the returned title, authors, year, venue, and pages with the local record. Anything it cannot verify should remain explicitly not checked.

The two-row table is an actual scoped result from 16 September 2026. Crossref metadata retrieved through DOI content negotiation matched both local records. `ReevesRogowski2016` resolves to DOI `10.1086/683433`; `ChristensonKriner2017` resolves to DOI `10.1111/ajps.12262`. Both identities are verified for this two-key scope.

This establishes that the cited works exist and that these DOI and metadata records point to the works named in the bibliography. It does not answer whether either article supports the opening claim; that is the next procedure.

Source locators: `citation-check/SKILL.md`, workflow and output rules; lecture receipt `planning/receipts-2026-09-16/audit-receipt.md`, “Citation check — historical manuscript claim”; raw Crossref response retained in the same receipt directory. The receipt records two keys only. Citation-check also samples claim support, while fact-check performs the dedicated claim-level audit.

## 7. Check claims with fact-check

**Duration: 02:55**

`fact-check` takes an exact manuscript claim, resolves the cited source, and reads the local full-text Markdown. It compares the claim with the source’s direction, scope, and strength. The output pairs a support status with a verbatim passage and, where necessary, a suggested revision or explicit limit.

That makes the result inspectable. I can read the quoted passage in context, follow it back to the local source, and decide whether the status and proposed revision are warranted. The agent produces a documented judgment; the researcher still interprets the evidence.

The slide intentionally shows the procedure rather than the result for our historical sentence. Part 3 will follow the evidence and answer the question posed at the start of the lecture.

Source locators: `/Users/scdenney/Documents/github/resources/open-science-skills/plugin/skills/fact-check/SKILL.md`, inputs, pre-flight, claim audit, verdict taxonomy, and output requirements. `fact-check` runs the citation layer first; that overlap is why the two checks belong in sequence rather than in separate catalog entries.

## 8. Prepare a package another researcher can rerun

**Duration: 02:20**

The final skill is a companion to the source workflow. `replication-package` organizes or audits the local research outputs: analysis code, data or access documentation, a documented entry point, and the figures and tables the paper reports. Its operational standard is that a competent reader can run one documented command and regenerate the published results without hidden manual steps.

The dashed arrow matters. The skill prepares and checks a local package. Harvard Dataverse, OSF, Zenodo, a journal repository, or an institutional archive may be the publication destination, but upload mechanics belong to the author and the platform. This skill does not upload the package.

The procedure is adapted from Yusaku Horiuchi’s `replication-package-guide`. His caveat remains central: an agent can reorganize, document, and catch inconsistencies, but the researcher must decide which files, data sources, scripts, and outputs form the replication record.

Source locators: `/Users/scdenney/Documents/github/resources/open-science-skills/plugin/skills/replication-package/SKILL.md`, “Heritage and attribution,” “Standard,” structure and audit steps. Horiuchi guide: `https://github.com/yhoriuchi/replication-package-guide`.

**Total: 22:00**
