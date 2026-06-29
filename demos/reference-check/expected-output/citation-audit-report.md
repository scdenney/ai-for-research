# Citation Audit Report (illustrative)

> This is an **illustrative** report showing the shape of `citation-check`'s
> output on `sample-project/`. Your run will differ in wording and in exactly
> what the web lookups return on the day you run it. Treat it as an answer key
> for the *structure*, not a transcript to match verbatim.

Scope: sample-project/manuscript.md + references.bib
Target style: APA 7
Verification tools used: Crossref, OpenAlex, DOI resolution, exact-title search
Summary: 1 blocking, 2 recommended, 0 minor, 4 needs-author-verification

## Blocking Issues
| Location | Entry/key | Issue | Evidence | Fix |
|----------|-----------|-------|----------|-----|
| §The participation gap | `othen2022` | LIKELY FABRICATED — "Digital Civics and the Participation Gap," *Comparative Political Studies* 55(9). No match on exact title, no author corpus match, DOI does not resolve. | Crossref title query: 0 hits. DOI `10.1177/00104140221099999` 404s. | Locate the source the author intended and replace, or remove the claim. **Confirm by hand before labeling fabricated in public.** |

## Recommended Fixes
| Location | Entry/key | Issue | Evidence | Fix |
|----------|-----------|-------|----------|-----|
| §Design | `vance2018` | Cited in text, missing from references. | No `vance2018` entry in references.bib. | Add the reference or drop the citation. |
| references.bib | `kowalski2017` | In references, never cited in text. | No `\cite`/`@` use of `kowalski2017`. | Cite it or remove it. |

## DOI and Source-Status Table
| Entry/key | Current DOI/URL | Verification status | Suggested action |
|-----------|-----------------|---------------------|------------------|
| `hainmueller2014` | 10.1093/pan/mpt024 | VERIFIED — resolves to the cited work (Political Analysis 22(1):1–30) | None. This is the control: a real source confirmed. |
| `othen2022` | 10.1177/00104140221099999 | DEAD DOI + no title match | Treat as fabricated pending author confirmation |
| `lindqvist2019` | none | NO DOI FOUND (synthetic source — untraceable by design) | In real work, run `process-source` and confirm the PDF exists |
| `ferreira-nair2021` | none | NEEDS AUTHOR VERIFICATION (synthetic) | — |
| `osei2020` | none | NEEDS AUTHOR VERIFICATION (synthetic) | — |

## In-text / Reference Parity
| Type | Citation or key | Location | Suggested action |
|------|-----------------|----------|------------------|
| Cited, not in refs | `vance2018` | §Design | Add reference or remove cite |
| In refs, not cited | `kowalski2017` | references.bib | Cite or remove |

## Needs Author Verification
| Entry/key | Why unresolved | What author should check |
|-----------|----------------|--------------------------|
| `lindqvist2019`, `ferreira-nair2021`, `osei2020` | Synthetic sources with no web footprint | That the PDF exists locally and the metadata matches it |

**Read this report as a worklist, not a verdict.** The one item that ends careers
is `othen2022`; everything else is hygiene. And even `othen2022` gets a human
confirmation step before the word "fabricated" is used anywhere public.
