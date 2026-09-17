---
name: yusaku-horiuchi-replication-package-guide
description: "External methodology source adapted into the `replication-package` skill. Author, repository URL, license posture, and citation policy."
metadata: 
  node_type: memory
  type: reference
  originSessionId: af21fce5-e587-4886-a7ac-b81b03d895aa
---

**Yusaku Horiuchi** — Syde P. Deeb Eminent Scholar in Political Science at Florida State University. A colleague of Steven Denney's. Author of the replication-package-guide repository at https://github.com/yhoriuchi/replication-package-guide.

The repository has **no explicit license file** but the README explicitly authorizes AI agent use: *"designed to be read by humans and by coding agents such as Codex or Claude Code before they prepare, audit, or repair a replication package."* It also warns: *"AI is useful for checking, reorganizing, documenting, and catching inconsistencies, but it should not be treated as a substitute for the author's judgment about which files, scripts, data sources, and results are actually part of the replication record."* Both quotes are folded into the OSS plugin's `replication-package` skill heritage section.

The OSS `replication-package` skill adapts Horiuchi's structural conventions (single-entry-point principle, compact vs. build/analyze layouts, figure/table crosswalk, paper-consistency check, correction workflow, pre-release checklist) and adds FAIR-principle integration on top. Harvard Dataverse and other platform-specific upload mechanics are deliberately dropped.

**Citation policy.** If a package is built using the `replication-package` skill, Horiuchi's guide must be cited as the methodological source — this is asserted in the generated `README.md` template's Attribution section and in the OSS repo's top-level README License section.

**How to apply:** When editing or extending the `replication-package` skill, preserve the heritage section and the citation policy. When the user works in a colleague-collaboration context that mentions Horiuchi, this is who they mean. Related: [[project_repo]] (v2.2.0 release notes).
