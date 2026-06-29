# Fact-Check Report (illustrative)

> Illustrative output of `fact-check` on `sample-project/`. The skill first runs a
> **pre-flight gate**: it refuses to run unless a per-source Markdown knowledge
> base exists and covers the cited works. This project ships `sources/md/` for
> exactly that reason, so the gate passes. Then it runs `citation-check`, then
> checks each claim against the source files.

Scope: sample-project/manuscript.md
Knowledge base: sample-project/sources/md/ · sources matched: 3/4 cited substantive works
citation-check: ran — `othen2022` flagged LIKELY FABRICATED, carried forward as a citation problem
Summary: 1 contradicted, 0 unsupported, 1 partial, 1 supported, 1 not-in-KB

## Contradicted / Unsupported (blocking)
| Location | Claim (short) | Cite key | Verdict | Source passage | Suggested fix |
|----------|---------------|----------|---------|----------------|---------------|
| §The participation gap | "compulsory voting also raises citizens' political knowledge" | `ferreira-nair2021` | **CONTRADICTED** | "Mandatory turnout did not translate into more informed citizens ... Whatever compulsory voting does, it does not appear to teach." | Remove the knowledge claim, or attribute it to a source that actually supports it. |

## Partially supported / Overclaim (recommended)
| Location | Claim | Cite key | Gap | Source passage | Suggested rewording |
|----------|-------|----------|-----|----------------|---------------------|
| §The participation gap | "Higher social trust **causes** higher turnout" | `osei2020` | Direction of inference: source is observational, disclaims causation | "We document an association, not a mechanism. Nothing here licenses the inference that raising trust would raise turnout." | "Higher social trust is **associated with** higher turnout" |

## Source not in knowledge base
| Cite key | Author-year | Why unresolved | Action |
|----------|-------------|----------------|--------|
| `othen2022` | Othen (2022) | Citation flagged fabricated by citation-check; no source file exists | Resolve the citation first; the claim is unverifiable until then |

## Supported (spot-check log)
| Location | Claim | Cite key | Source passage |
|----------|-------|----------|----------------|
| §Introduction | "modest, short-lived increase in youth turnout ... fades within two election cycles" | `lindqvist2019` | "The turnout premium ... is modest, on the order of three to four points, and it does not survive beyond the second election." |

**The deeper lesson:** `citation-check` would pass `ferreira-nair2021` and
`osei2020` without complaint — the references are well-formed and (in real life)
would resolve. Only reading the *source* catches that one claim is backwards and
another overclaims. Formatting-clean is not the same as true.
