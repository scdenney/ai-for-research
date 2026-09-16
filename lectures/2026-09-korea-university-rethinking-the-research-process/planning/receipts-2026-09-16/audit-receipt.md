# Read-only audit receipt — 2026-09-16

## Scope and method

Audited read-only: `/Users/scdenney/Documents/github/research/projects/nwo26-immigration-backlash`.
Output-only location: this receipt directory. No reference-project files, git state, installations, or configuration were changed.

Skills read in full before the audit:

| Audit | Skill and local version | Applied boundary |
|---|---|---|
| Source library / intake / instructions | `research-repo` (`/Users/scdenney/.agents/skills/research-repo/SKILL.md`, 386 lines; SHA-256 `26bbedac3d8ad194881e218676a330c7e61f212730fb7125371bbbbd6837ebb4`) | Audit mode; report present/partial/missing; do not scaffold. |
| Citation identity | `citation-check` (`/Users/scdenney/.agents/skills/citation-check/SKILL.md`, 166 lines; SHA-256 `27a6cb75dda92b881e41c715191793d5fd5199871b39aff78c21286142a5e65e`) | Build a scoped citation/reference inventory and verify each DOI against an authoritative publisher record. |
| Claim support | `fact-check` (`/Users/scdenney/.agents/skills/fact-check/SKILL.md`, 151 lines; SHA-256 `ad56efaace323e3fd9d237d95bcc1f5acea63658093ce9ccf9e1bf234573e778`) | Run the pre-flight gate and citation check first; use local full-text Markdown and quote the decisive passages. |

## Bounded research-repository audit

Mode: **audit**. Archetype: multi-paper empirical research project with an archival source library.

| Area | Status | Evidence / locator | Next action |
|---|---|---|---|
| Source directories | **present** | `sources/og/` (102 files), `sources/md/` (119 `.md` files), `sources/unprocessed/` (only `.gitkeep`) | Continue the documented intake route. |
| Raw-to-Markdown conversion | **present** | Exact stem comparison: 102 `og` originals; **0** lack an `md` counterpart. | None for current originals. |
| Markdown-only material | **present, explained** | 17 `md` stems have no `og` counterpart: 15 `.NOTE` records, `BOOKS_WITHOUT_PDFS`, and one named conversion; `AGENTS.md` explicitly says `.NOTE.md` cannot verify claims. | Keep this distinction in fact checks. |
| Bibliography contract | **present, partial evidence of documentation drift** | Canonical bibliography is **`sources/references_master.bib`** (126 entries), named in `AGENTS.md`; it must not be falsely marked missing merely because it is not `sources/references.bib`. | Refresh `sources/inventory.md`: it still reports the 2026-06-30 94-entry / 72-file state. |
| Intake documentation | **present** | `sources/README.md`; `scripts/convert-sources.sh`; `AGENTS.md` gives unprocessed → og → md workflow. Script targets `sources/og` → `sources/md`. | None. |
| Project instructions | **present, minor naming inconsistency** | Root `AGENTS.md` and `CLAUDE.md` are present and substantively aligned; the first heading inside `AGENTS.md` says `# CLAUDE.md`. | Optional header cleanup only. |
| Git hygiene | **present (tested)** | `.gitignore` ignores `sources/og/` and `.venv/`; `sources/md` has 119 tracked Markdown files. | None. |

The comparison above deliberately does **not** claim a complete bib-to-file parity audit: the requested bounded audit covered source library, intake, and instructions. The repository’s own explicit crosswalk is `sources/inventory.md`, but its totals are stale.

## Citation check — historical manuscript claim

Historical manuscript target: the **parent** of Paper 2 manuscript-submodule commit `75366c6ca9ecc96148acba4840a4853c73f47c43`, namely `e50d2788ae8df3d3de63e4e9d26be919d4dea971:sections/frontmatter/front_matter.tex`, line 10. This is a new check of that historical draft, not a claim that this skill was run on 2026-08-27. The target sentence is: “studies of unilateral policymaking similarly show that citizens penalize executive action relative to legislative action” (`ReevesRogowski2016,ChristensonKriner2017`).

The child commit `75366…` (2026-08-27 20:22 +0200) explicitly corrects this sentence. Its diff replaces the comparative-penalty claim with: Reeves and Rogowski report low generalized support; Christenson and Kriner compare the two routes in Obama-era immigration and find partisanship and policy agreement outweigh constitutional objection. The exact parent/child diff is retained in `historical-claim-diff.txt`.

| Key | Local reference identity | Independent authoritative verification | Status |
|---|---|---|---|
| `ReevesRogowski2016` | Reeves & Rogowski (2016), *Journal of Politics* 78(1):137–151; `10.1086/683433` (`sources/references_master.bib`:942–951) | [University of Chicago Press DOI landing page](https://www.journals.uchicago.edu/doi/abs/10.1086/683433) and Crossref deposit match title, both authors, journal, volume/issue, pages, and DOI. | **VERIFIED — DOI resolves to cited work** |
| `ChristensonKriner2017` | Christenson & Kriner (2017), *American Journal of Political Science* 61(2):335–349; `10.1111/ajps.12262` (`sources/references_master.bib`:966–975) | [Wiley DOI landing page](https://onlinelibrary.wiley.com/doi/10.1111/ajps.12262) and Crossref deposit match title, both authors, journal, volume/issue, pages, and DOI. | **VERIFIED — DOI resolves to cited work** |

Citation-check scope was the two keys only. Both are present in the parent revision's `references.bib` and attached to the historical sentence; no citation/reference parity break, identity mismatch, or DOI mismatch was found. The raw Crossref retrieval evidence and DOI content-negotiation response headers are retained in `crossref-metadata-2026-09-16.json`.

## Fact-check — stronger comparative claim

Claim audited: “Studies of unilateral policymaking similarly show that citizens penalize executive action relative to legislative action.” Cited works: `ReevesRogowski2016`; `ChristensonKriner2017`.

### Pre-flight

**READY, scoped 2/2 (100%).** The knowledge base is `sources/md/`; both matching full-text Markdown conversions exist:

- `sources/md/reeves-rogowski-2016-unilateral-powers-public-opinion.md`
- `sources/md/christenson-kriner-2017-constitutional-qualms-unilateral.md`

No unmatched raw files are present for these two sources (the repo-wide raw-to-Markdown check found zero). Citation-check was run first; both source identities are verified above.

| Source | Verdict | Decisive local full-text evidence | Scope qualifier / implication |
|---|---|---|---|
| Reeves & Rogowski (2016) | **PARTIALLY SUPPORTED** | “Only about a quarter of respondents … supported unilateral policy making” (lines 114–127); the instrument asks whether a president may enact policies “without … Congress” (lines 114–117). The original PDF metadata identifies the article, authors, *JOP* 78:137–151. | Supports low *generalized* support for unilateral policymaking. It does **not** randomize or compare a legislative and executive route to the same policy, so it cannot establish the proposed relative penalty. |
| Christenson & Kriner (2017) | **UNSUPPORTED** | The original PDF's Table 4 gives executive-order coefficients −0.15, −0.32, −0.19 and labels the first “statistically insignificant”; Table 5 gives +0.32, +0.11, +0.30 and likewise labels the first “statistically insignificant.” The text says route had “no significant influence” (PDF pp. 10–12; converted Markdown Tables 4–5 at lines 396–423 and 479–504; interpretations at lines 425, 467, 477, 506, and 548). | It directly compares the two routes for U.S. student-loan and immigration cases, but conventional nonsignificance does **not** establish a penalty, its opposite, absence, or equivalence. These results therefore do not support the general claim. |

**Overall verdict: UNSUPPORTED for the stated general comparative claim.** The sources support a narrower contrast: generalized opposition to unilateral power exists (Reeves & Rogowski), while Christenson and Kriner's direct route tests yield conventionally nonsignificant estimates. Those null tests neither substantiate a comparative executive penalty nor demonstrate equivalence or the absence of a meaningful effect. Do not turn them into a generic claim that citizens penalize executive action relative to legislation.

## Compact slide-ready audit finding

| Audit question | Finding | Teaching implication |
|---|---|---|
| Is the evidence infrastructure usable? | Yes: 102/102 raw originals map to Markdown; canonical bib is `references_master.bib`; the inventory page needs updating. | Show that source infrastructure can be auditable without assuming a standard filename. |
| Do both citations exist and resolve? | Yes: both DOI identities match authoritative publisher metadata. | Citation validity is necessary before evaluating a claim. |
| Does the evidence support “executive action is penalized relative to legislation”? | No: the directly comparative source reports nonsignificant estimates; the other measures generalized support only. | A citation may be real and relevant yet fail to support the stronger sentence. |

## Reproducibility record

Commands run (all read-only against the reference repository):

```sh
git -C "$REF" status --short
find "$REF/sources" -maxdepth 2 -type d -print | sort
find "$REF" -maxdepth 4 -type f -name '*.bib' -not -path '*/.git/*' -print | sort
rg -n -C 6 '@.*\\{(ReevesRogowski2016|ChristensonKriner2017)' \
  "$REF/sources/references_master.bib" "$REF/papers/2-legitimacy-policy-process/manuscript/references.bib"
git -C "$SUB" show 75366c6ca9ecc96148acba4840a4853c73f47c43^:sections/frontmatter/front_matter.tex
git -C "$SUB" diff 75366c6ca9ecc96148acba4840a4853c73f47c43^ 75366c6ca9ecc96148acba4840a4853c73f47c43 -- sections/frontmatter/front_matter.tex
comm -23 <(find "$REF/sources/og" -maxdepth 1 -type f | sed 's#.*/##;s/\\.[^.]*$//' | sort) \
  <(find "$REF/sources/md" -maxdepth 1 -type f -name '*.md' | sed 's#.*/##;s/\\.md$//' | sort)
pdftotext -layout "$REF/sources/og/christenson-kriner-2017-constitutional-qualms-unilateral.pdf" - | \
  rg -n -C 3 'Effect of Policy Instrument|statistically insignificant|legislatively or unilaterally'
curl -sS -L -H 'Accept: application/vnd.citationstyles.csl+json' https://doi.org/10.1086/683433
curl -sS -L -H 'Accept: application/vnd.citationstyles.csl+json' https://doi.org/10.1111/ajps.12262
```

External primary-record checks: DOI content negotiation returned HTTP 302 to Crossref transform endpoints for `10.1086/683433` and `10.1111/ajps.12262`, then returned matching CSL-JSON records. The response headers and selected raw metadata fields are saved with this receipt.

## Integrity check

Reference-project status hashes before and after the audit are identical:

| Repository | SHA-256 of `git status --porcelain=v1` |
|---|---|
| Parent research repository | `28c77a057c9d844e99acd08dab71bf5213a8f94ca6604356d1e956086392d4fd` |
| Paper 2 manuscript submodule | `3830040cfdd6349cae076023223c28a6977752a240e50ed35f3e7ab5aa771c47` |
