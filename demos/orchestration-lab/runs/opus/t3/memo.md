# Reply to the reviewer: is the crime result a baseline artifact?

We thank the reviewer for pressing on reference-category dependence. The point
is correct as a general statement about AMCEs, and we re-analyzed the data to
establish exactly where it bites and where it does not. Numbers below are in
`sensitivity-table.md`; the figure plots both quantities.

**What is mechanically true.** An AMCE is a contrast against a baseline, so for
any multi-level attribute the per-level estimates move when the reference moves.
Our re-estimation confirms it: the four commuting-time AMCEs are uniformly
negative against a 10-minute baseline and uniformly positive against a 75-minute
baseline (Table B). A ranking of attributes read off raw AMCE coefficients under
one set of default baselines is therefore not a stable quantity, and we agree it
should not carry the headline.

**What is not sensitive.** The Violent Crime Rate attribute is binary (20% below
vs 20% above the national average). A binary attribute has a single contrast, so
changing its reference only reverses the sign of one number; the magnitude is
unchanged. Re-estimated both ways, moving from lower to higher crime shifts
choice probability by 16.5 percentage points (IRR-corrected 25.1 points, 95% CI
[−33.4, −16.8]) whichever level is the baseline (Table A). There is no baseline
under which the crime effect is small, so for this attribute the reviewer's
mechanism cannot operate.

**The baseline-free evidence.** We now rest the claim on marginal means, which
carry no reference category (Table C, Figure). Crime has the widest
within-attribute MM spread of the seven attributes (0.582 vs 0.418; range
0.165), and its two levels sit furthest from the 0.5 indifference line. The
ordering is unchanged by the measurement-error correction.

We will not over-read this. Crime's lead over commuting time (range 0.156) is
only 0.009, and we attach no uncertainty to that rank difference; MM ranges are
also not cleanly comparable across attributes with different numbers of levels,
a comparison that if anything understates a binary attribute. We therefore do
not claim unique dominance.

**What the revised manuscript will claim.** Lower violent crime raises the
probability a community is chosen by 16.5 percentage points (25.1 IRR-corrected);
this estimate does not depend on the reference category; and crime is among the
strongest attributes, with the largest baseline-invariant marginal-mean spread.
We will delete any wording that casts crime as the single dominant driver, and
we will report marginal means alongside AMCEs throughout.
