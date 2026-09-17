#!/usr/bin/env python3
"""Generate a machine-readable result from illustrative binary data.

This is a project-specific teaching example, not research analysis code.
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


def calculate_result(input_path: Path) -> dict[str, object]:
    """Calculate the illustrative positive proportion from a binary CSV."""
    with input_path.open(newline="", encoding="utf-8") as source:
        rows = list(csv.DictReader(source))
    if not rows:
        raise ValueError("input contains no rows")
    values = [row["positive"] for row in rows]
    if any(value not in {"0", "1"} for value in values):
        raise ValueError("positive must be binary 0 or 1")

    positives = sum(int(value) for value in values)
    return {
        "illustrative": True,
        "measure": "positive_proportion",
        "n": len(values),
        "positive_count": positives,
        "value": positives / len(values),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=Path("data/illustrative-binary-outcomes.csv"))
    parser.add_argument("--output", type=Path, default=Path("generated/demo-result.json"))
    args = parser.parse_args()

    result = calculate_result(args.input)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps(result, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
