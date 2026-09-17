# Intro and Part 1 simplification · 17 September 2026

The author rejected the previous crowded slides. This pass addresses printed slide 4 and Part 1, preserving the author’s other intro edits at Overleaf `86c939f39f6448972a6a60b52cb29dfcd5b0d950`. Parts 2 and 3 remain unchanged. Part 2 still requires substantial editorial and visual revision; the earlier geometry pass did not establish that it was presentation-ready.

## Changes and sequence

| Former footer | Current footer | Revision |
|---|---|---|
| 4 | 4 | Two short comparisons and two definitions; removed repeated diagrams and summary banner; larger body text |
| 8 | 8 | Replaced instructional chain with work quality versus researcher capability |
| 32 | 9 | Promoted learning-evidence table into Protect; concrete “Finding” column and shorter rows |
| 33 | 10 | Promoted conceptual learning slide beside it; empirical qualifications in notes |
| Collaborate transition | Unnumbered | Exact author wording: “Ethical machine augmentation is the goal.” |
| 12 | 14 | Centered quadrant names, consistent horizontal axis labels, removed bottom note and duplicate role descriptions |
| 35 | 15 | Role table follows the grid immediately |

Protect runs transition → conceptual distinction → evidence overview → possible learning conditions → existing Autor/Bastani details. Notes frame AI use throughout research as the lecturer’s practical premise, while allowing bounded restrictions; no universal claim that local exclusion is impossible. The grid selects a collaboration pattern, and the following table explains its roles.

38 main physical pages and six appendices, 44 total. The 38 continuous speaking allocations sum to 55:00; Part 1 remains 15:00. This is an allocation, not a measured rehearsal.

## Review and verification

Astra led the edits and integration; Sol reviewed the Protect framing and bounded evidence claims; Terra synchronized notes and independently inspected the rendered changes for density and readability. The lead accepted corrections to distinguish an unaided treatment effect from within-person learning and to name the no-AI comparator. The conceptual source-engagement slide asks a question rather than asserting that self-reported learning measures establish understanding. The author’s requested transition wording was retained.

The independent visual review inspected the seven changed/promoted pages at compressed 1280×720 against their baseline renders, accepting the calmer layouts and identifying the learning table as the densest page. The lead subsequently checked the shorter, final table row and centered axis labels. Rendered images are retained here. Larger type, shorter text, and visible spacing are the criteria; geometric containment alone is insufficient.

XeLaTeX succeeds, all fonts are embedded, no overfull boxes or missing-character/font warnings. One underfull paragraph is non-blocking. All 44 pages rendered. Changed pages have no out-of-page text, overlaps, fill crossings, or long diagonals. The full checker retains one **pre-existing author-baseline fill crossing on physical page 3**, outside the requested edit; compare `author-baseline-checks.json`. The author’s conversation frame also omits the printed footer 3; the visible footer sequence is identical to the pulled baseline. Neither was silently altered.

Exact comparison with `86c939f` confirms that `00-open.tex`, Parts 2/3, closing, and every introductory frame except printed 4 remain unchanged. Source whitespace checks pass. Notes retain the promoted evidence bounds and renumber the untouched sections. Credential, manifest, and prose checks pass; see `deliverable-checks.json`.

## Delivery

Overleaf main: `5d9178cff819d77035b5ea011f349af4b3efab9d`. [Project](https://www.overleaf.com/project/6aaa697efc7ddb608ab4c4d1), entry point `main.tex`, XeLaTeX.

Local PDF SHA-256: `1f204d5d76e45010ce115bb7d24272ff7a06d91be90ab59a78ea84a4cc880db8`. Local artifact: `../../overleaf/main.pdf`. Parent documentation is committed locally; website PDF replacement and parent GitHub publication are separate. Author review, real Zoom sharing, timed rehearsal, and authenticated server-PDF inspection remain.
