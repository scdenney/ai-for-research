# Answer key — what the checkers should find

This sample project has **deliberately planted problems**. Use it to confirm the
skills behave, and to practice the part no skill can do for you: deciding what to
do about each flag. Everything here is synthetic except the one real reference
(`hainmueller2014`).

## A note on "everything synthetic looks fabricated"

This project is **self-contained**: its sources are invented so the demo runs
offline and names no real scholar. A consequence: when `citation-check` runs an
*existence* pass with web access, it will correctly report that it cannot find
the invented sources online. **That is the right behavior** — to a verifier, an
invented source and a fabricated one are indistinguishable. The point of the demo
is not "watch it confirm real papers" (it confirms exactly one, `hainmueller2014`,
your control). The point is the checks that do **not** depend on the open web:
**parity**, **internal consistency**, and above all **claim support** via
`fact-check` against the local knowledge base in `sources/md/`.

## Planted reference problems (citation-check)

| # | Where | Planted problem | Expected label |
|---|-------|-----------------|----------------|
| 1 | `@othen2022` | A real-looking article that was never written | LIKELY FABRICATED (no trace after title + author search) |
| 2 | `@vance2018` (Design section) | Cited in text, **no entry** in `references.bib` | Cited in text but missing from references (parity) |
| 3 | `@kowalski2017` | Entry exists in the bib, **never cited** in text | In references but never cited (parity) |
| 4 | `@hainmueller2014` | Correct, real reference | VERIFIED via Crossref/OpenAlex (your control — proves the checker is not just flagging everything) |

## Planted claim problems (fact-check, against `sources/md/`)

| # | Claim in manuscript | Source | Expected verdict |
|---|---------------------|--------|------------------|
| 5 | "compulsory voting also raises citizens' political knowledge" | `ferreira-nair2021` | **CONTRADICTED** — the source finds a precise null on knowledge ("does not appear to teach") |
| 6 | "Higher social trust **causes** higher turnout" | `osei2020` | **PARTIALLY SUPPORTED / OVERCLAIM** — the source is explicitly observational and disclaims any causal reading |
| 7 | "Civic education produces a modest, short-lived increase ... fades within two election cycles" | `lindqvist2019` | **SUPPORTED** — matches the source (your control: a correct claim should pass) |
| 8 | "digital media widen ... the participation gap" | `othen2022` | **NOT IN KB / UNVERIFIABLE** — the cited source is fabricated (see #1), so the claim cannot be checked at all |

## What a human still has to decide

- #1: Is `othen2022` truly fabricated, or a real paper the checker could not
  reach (paywalled, mis-keyed, grey literature)? **Confirm by hand before you
  ever call something fabricated in public.**
- #6: "Causes" vs. "is associated with" is a one-word fix that changes whether
  the sentence is defensible. The checker flags it; you decide the rewrite.
- #4 vs. the synthetic sources: the contrast is the lesson. A checker that
  flags *everything* is as useless as one that flags nothing. Read the
  evidence column, not just the verdict.
