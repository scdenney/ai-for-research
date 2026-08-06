# Routing log

## Route

| Workstream | Owner | Why | Returned artifact / acceptance check |
|---|---|---|---|
| Estimand design, implementation, integration, and adjudication | Sol lead | Compact consequential reasoning and final accountability stay with the lead | `script.R`, `memo.md`; exact Bacon reconstruction and successful fresh run |
| Sentinel-convention check | Terra one-shot, high effort | Same-vendor but different-tier blind check on the high-stakes question | `terra-peer.txt`; exact package conventions and failure mode |
| Sentinel-convention check | Claude peer, Sonnet/high | Cross-vendor blind check on the identical prompt | Wrapper failure in `claude-peer.txt`; recovered verbatim response in `claude-peer-direct.txt` |
| Completion review | Sol advisor one-shot, xhigh | Required read-only completion challenge after durable artifacts | Recorded below after final artifact verification |
| Sol native spawn | None | No live orchestration or same-tier context isolation was needed | No `spawn_agent` call |

The Terra and intended Claude calls were launched concurrently on the exact text in `HIGH-STAKES-QUESTION.md`, without either receiving the other's reasoning. The Terra call completed. The Claude wrapper failed before launching Claude because it unconditionally calls a missing GNU `timeout`; this is not the skill's allowed “Claude is not on PATH” fallback. The lead therefore ran the wrapper's exact inner `claude` command directly on the unchanged prompt. That recovery remained blind to Terra, but it occurred after the failed same-round wrapper attempt and is not represented as proof that the wrapper worked.

## Calls and verbatim returns

### Terra/high blind check

Command:

```bash
codex exec --ephemeral --model gpt-5.6-terra \
  -c model_reasoning_effort=high --sandbox read-only \
  --skip-git-repo-check -C "$PWD" \
  --output-last-message terra-peer.txt - < HIGH-STAKES-QUESTION.md
```

Exit status: `0`.

Verbatim response:

```text
Only `staggered::staggered` is silently wrong if given `did::mpdta$first.treat` unchanged.

| Estimator | Never-treated coding | Reuse `mpdta$first.treat`? |
|---|---|---|
| `did::att_gt` | `0` | Yes—correct. |
| `staggered::staggered` | `Inf` | No—silent misclassification. |
| `fixest::sunab` | Any cohort value absent from the supplied calendar-period variable (commonly a future value such as `1000`) | Yes for `mpdta` specifically: `0` is not among years 2003–2007, so it is inferred as never-treated. |

Exact recoding for `staggered`:

```r
g_staggered <- ifelse(mpdta$first.treat == 0, Inf, mpdta$first.treat)
```

For portable `sunab` code, I would make the convention explicit, although it is not required for `mpdta`:

```r
g_sunab <- ifelse(mpdta$first.treat == 0, max(mpdta$year) + 1L,
                  mpdta$first.treat)
# 2008 for mpdta
```

Evidence:

- `att_gt` documents treated cohorts as positive and the untreated group as `0`; its vignette specifically says `mpdta$first.treat` is `0` for never-treated units. [Source](https://github.com/bcallaway11/did/blob/master/R/att_gt.R), [installed vignette](/opt/homebrew/lib/R/4.5/site-library/did/doc/did-basics.Rmd:262)
- `staggered` explicitly requires `Inf` for never-treated units. Its source then constructs controls as cohorts with `g > max(g,t)` and treats cohorts satisfying `t >= g` as eligible targets. Thus `g=0` in the 2003–2007 `mpdta` panel is an earliest/always-treated cohort: never-treated units are omitted as controls and can enter the treated target/weights, without a sentinel-validation error. [Manual](https://www.rdocumentation.org/packages/staggered/versions/1.2.2/topics/staggered), [source control rule](https://rdrr.io/cran/staggered/src/R/compute_efficient_estimator_and_se.R)
- `sunab` documents that, when relative time is constructed from calendar time, a cohort absent from the period variable is deemed never-treated; it warns that this rule would wrongly classify an actually always-treated cohort coded before the sample. Therefore `0` happens to work for `mpdta`, but is data-range-dependent. [Documentation](https://lrberge.github.io/fixest/reference/sunab.html)

Never-treated is a unit’s permanent adoption status. Not-yet-treated is not a sentinel: it is an eventually treated unit with its actual cohort date `g > t`. In `att_gt(control_group = "notyettreated")`, these units are added to the controls for that period; never-treated units remain included. Do not recode future adopters to `0`, `Inf`, or a future fake cohort merely because they are untreated at a particular date.
```

### Claude wrapper attempt

The marketplace wrapper was invoked with the identical prompt and `-C "$PWD"`; an exported shell function was supplied as a non-file workaround for missing GNU `timeout`, but the wrapper's new Bash process did not import it.

Exit status: `127`.

Verbatim response:

```text
/Users/scdenney/.claude/plugins/marketplaces/open-science-skills/codex/46-orchestrate/scripts/claude-peer.sh: line 72: timeout: command not found
```

### Claude/Sonnet direct recovery

Command—the wrapper's inner command, unchanged apart from removal of the unavailable timeout executable:

```bash
CLAUDE_EFFORT=high claude -p "$(< HIGH-STAKES-QUESTION.md)" \
  --model sonnet --output-format text < /dev/null
```

Exit status: `0`.

Verbatim response:

```text
## Conclusion

**Sentinels differ by package, and reusing `mpdta$first.treat` unchanged silently breaks `staggered::staggered` but not the other two (in this specific dataset).**

| Package | Never-treated sentinel | Source of truth |
|---|---|---|
| `did::att_gt` | `gname == 0` | `?att_gt`: *"It should be 0 for the group..."*; `did:::pre_process_did` L62–63: `stop()` if any `g < 0`; L121–124 auto-coerces any `g > max(t)` (incl. `Inf`) down to `0` |
| `staggered::staggered` | `g == Inf` | `?staggered`: *"g ... with `Inf` denoting never treated"* — pure documentation convention, **no code-level validation** in `staggered:::processDF` |
| `fixest::sunab` | any cohort value **absent from the observed period range** | `?sunab` Details: *"any cohort that is not present in the period is considered as never treated ... so be careful"* |

### Empirical check (`mpdta`, year range 2003–2007, `first.treat ∈ {0, 2004, 2006, 2007}`)

- **`did::att_gt`** — identical `att_gt` output whether `first.treat` is left as `0` or manually recoded to `Inf`. Verified: internal logic explicitly remaps anything `> max(t)` back to `0`, and rejects negatives with a hard `stop()`. **Not silent** — either fails loudly or self-corrects.
- **`fixest::sunab`** — identical ATT (`-0.0400`, se `0.0156`) whether `first.treat` is `0` or `Inf`, purely because `0 ∉ [2003, 2007]` so the "absent-from-period-range" rule coincidentally classifies it correctly. This is data-dependent luck, not a guarantee, and the help page flags exactly this fragility.
- **`staggered::staggered`** (`estimand = "simple"`) — **silent divergence**, no error/warning either way:
  - `g` recoded to `Inf` (correct): `estimate = -0.0471, se = 0.0116`
  - `g` left as `0` (unchanged `first.treat`): `estimate = -0.3704, se = 0.1256`

  That's a ~7.9× inflation in magnitude with no diagnostic. Root cause, confirmed in `staggered:::compute_g_level_summaries` (`g_list <- sort(unique(g))`) and `staggered:::create_A0_list`: `g_list` is sorted ascending and the code specially treats cohorts by *position* in that sort — the last position is the reference/control role that `Inf` naturally occupies. Coding never-treated as `0` sorts it to the *first* position instead, so it gets treated as an (impossibly early) treatment cohort with zero valid pre-periods (`t_list < 0` is always empty), corrupting the DiD comparison matrix rather than serving as the intended clean control.

### Exact recoding needed

```r
mpdta$g <- ifelse(mpdta$first.treat == 0, Inf, mpdta$first.treat)  # for staggered::staggered
# did::att_gt: no change needed, gname stays 0
# fixest::sunab: works with 0 here by coincidence; Inf is the robust choice if reusing across packages
```

### Never-treated vs. not-yet-treated

- **Never-treated**: sentinel-coded units (`0` in `did`, `Inf` in `staggered`) that never receive treatment in-sample.
- **Not-yet-treated**: units with a real, finite `gname`/`g` value that *will* be treated later but haven't been as of period `t` — usable as a larger control pool via `did::att_gt(control_group = "notyettreated")` or `staggered(..., use_last_treated_only = FALSE)` (default). `fixest::sunab` has no analogous control-group switch; it only supports never-treated (plus anything named in `ref.c`) as the omitted reference.

**Bottom line**: the sentinel is not portable across these three packages. `did::att_gt` is defensively coded against sentinel misuse (explicit `stop()`/auto-coercion); `staggered::staggered` is not — an unrecoded `first.treat` produces a materially wrong, unflagged estimate; `fixest::sunab` happens to survive on `mpdta` only because `0` falls outside the sample's year range, which is not a property to rely on with other datasets.
```

## Lead reconciliation

The two blind reviews agree on every decision-relevant point: keep `0` for `did`, use a cohort outside observed periods for `sunab`, and recode never-treated units to `Inf` for `staggered`. Claude quantified the silent `staggered` failure (about −0.370 instead of −0.047), strengthening the warning but not changing the lead's specification. Claude's unclustered or differently inferred `sunab` SE of 0.0156 is not used; the lead's requested county-clustered fit gives 0.0118 and is the authoritative deliverable computation.

## Lead analytical results

- Fresh `Rscript script.R` exit status: `0` after one syntax-only revision to close a missing bracket in the plot theme.
- ATTs range from −0.0365 (TWFE) to −0.0471 (Roth–Sant'Anna); never-treated Callaway–Sant'Anna is −0.0400 (SE 0.0119).
- Bacon weights sum to exactly 1 and reconstruct TWFE exactly. Treated-versus-never-treated comparisons carry 86.277%; potentially contaminated later-versus-earlier comparisons carry 5.392%.
- The joint Callaway–Sant'Anna pretrend test is *p* = 0.168; event-time −3 and −2 intervals include zero.
- The figure was visually inspected at original resolution and has the required treatment marker, intervals, no title, and readable labels.

## Effect of the Claude peer

The Claude peer did **not** change the sentinel answer or reported ATT because the Sol lead had already separated the package conventions correctly. It materially strengthened the audit trail by independently reproducing the silent wrong-sentinel estimate and explaining why the package accepts it. The wrapper itself did not work, so this run demonstrates the value of a Claude comparison but does not validate `scripts/claude-peer.sh` as operational on this Mac.

## Sol/xhigh completion review

The third and final successful model delegation was a read-only `gpt-5.6-sol` advisor one-shot after all artifacts were durable. It returned `PASS — no required corrections.` It independently confirmed the five estimators and SE conventions, sentinel coding, exact Bacon reconstruction, cautious pretrend interpretation, 356-word memo, figure requirements, verbatim Claude record, and the distinction between wrapper failure and direct recovery. Full output is preserved in `advisor-completion.txt`. No further revision was made.
