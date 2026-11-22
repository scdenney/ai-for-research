#!/usr/bin/env python3
"""Validate the audience-survey spec, then run the toolkit's build_surveys.main().

    python3 build-survey.py --validate --dry-run          # offline, writes _build/leiden26_audience.qsf
    python3 build-survey.py --push --activate --validate  # creates and activates the survey
    python3 build-survey.py --links

Arguments other than --survey are passed through to the toolkit.
"""

from __future__ import annotations

import sys

from _toolkit import HERE, NAME, bs

ALLOWED_TYPES = {"text_block", "mc", "te_short"}


def check_spec() -> list[str]:
    spec = bs.load_spec(NAME)
    problems = []
    meta = spec.get("survey", {})
    if meta.get("anonymous") is not True:
        problems.append("survey.anonymous must be true")
    if meta.get("back_button") is not True:
        problems.append("survey.back_button must be true")
    blocks = spec.get("blocks", [])
    if not blocks:
        problems.append("expected at least one block (each block is one page)")
    for block in blocks:
        if not block.get("questions"):
            problems.append(f"block {block.get('description')!r} has no questions")
    tags = []
    for block in blocks:
        for q in block.get("questions", []):
            qtype = q.get("type")
            if qtype not in ALLOWED_TYPES:
                problems.append(f"type {qtype!r} not allowed (allowed: {sorted(ALLOWED_TYPES)})")
            if qtype != "text_block":
                if q.get("forced") is not False:
                    problems.append(f"{q.get('tag')!r}: forced must be false")
                tags.append(q.get("tag"))
    dupes = sorted({t for t in tags if tags.count(t) > 1})
    if dupes:
        problems.append(f"duplicate tags: {dupes}")
    return problems


def main(argv: list[str]) -> int:
    if "--survey" in argv or "--all" in argv:
        sys.exit("Do not pass --survey or --all; this script always builds " + NAME)
    problems = check_spec()
    if problems:
        print("Spec check FAILED:")
        for p in problems:
            print(f"  - {p}")
        return 1
    print("Spec check: OK (anonymous, one block per page, nothing forced, allowed types, unique tags)")

    code = bs.main(["--survey", NAME, *argv])

    if code == 0 and "--push" in argv:
        entry = bs.load_ids().get(NAME, {})
        survey_id, link = entry.get("id"), entry.get("link")
        if survey_id and link:
            (HERE / "survey-id.txt").write_text(f"{survey_id}\n{link}\n")
            print(f"\nAnonymous link: {link}")
            print(f"Wrote {HERE / 'survey-id.txt'}")
    return code


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
