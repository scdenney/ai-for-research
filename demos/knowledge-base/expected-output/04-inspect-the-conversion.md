# Inspect the conversion (real output)

The conversion is the step people trust without looking. Here is why you look.

This table is in the original PDF of Ferreira and Nair (2021):

| Outcome | Estimate | 95% interval |
|---|---|---|
| Turnout (percentage points) | 11.2 | 8.4 to 14.0 |
| Knowledge index (standard deviations) | 0.01 | −0.06 to 0.08 |

This is what came out the other side, copied from
`sources/md/ferreira-nair-2021-compulsory-voting.md`:

```
### 3. Results Outcome Estimate 95% interval

Turnout (percentage points) 11.2 8.4 to 14.0 Knowledge index (standard deviations) 0.01 −0.06 to 0.08
```

The numbers survived. The structure did not. The header row was absorbed into the
section heading, and the two rows ran together on one line. An agent reading this file
can still find 11.2 and 0.01, and can still quote the sentences around them. It cannot
reliably tell you which interval belongs to which outcome.

The prose converted cleanly, and the quotable passages are intact and greppable:

```
$ grep -n "does not appear to teach" sources/md/*.md
sources/md/ferreira-nair-2021-compulsory-voting.md:36:Whatever compulsory voting does, it does not appear to teach.
```

The `.docx` source took the other branch of the converter and came out with its author
and journal lines promoted to headings:

```
# Social Trust and Turnout: A Cross-National Description

# Daniel Osei

# *Talenian Journal of Comparative Politics* 7(1): 12–39, 2020
```

Neither of these is a failure that stops the pipeline, and that is the point. The file
is written, the run reports success, and the damage is only visible if you open it.

**The rule this leaves you with:** the original is the authority whenever the conversion
is in doubt. Read from `md/` for search and for claim checking. Go back to the PDF for a
table, a figure, a page reference, or anything where layout carried meaning.
