#!/usr/bin/env python3
"""Compare the two numerical claims in an illustrative report to generated data."""

from __future__ import annotations

import argparse
import json
import math
import re
import sys
from pathlib import Path


ABSTRACT = re.compile(r"Abstract:\s*reported positive proportion\s*=\s*([0-9]+(?:\.[0-9]+)?)\.")
TABLE = re.compile(r"\|\s*Positive proportion\s*\|\s*([0-9]+(?:\.[0-9]+)?)\s*\|")


def fail(message: str) -> int:
    print(f"FAIL: {message}", file=sys.stderr)
    return 2


def valid_proportion(name: str, value: float) -> bool:
    if not math.isfinite(value):
        fail(f"{name} is not finite")
        return False
    if not 0 <= value <= 1:
        fail(f"{name} is outside the [0, 1] proportion range")
        return False
    return True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--result", type=Path, required=True)
    args = parser.parse_args()
    try:
        report = args.report.read_text(encoding="utf-8")
        result = json.loads(args.result.read_text(encoding="utf-8"))
        generated = float(result["value"])
        if not result.get("illustrative") or result.get("measure") != "positive_proportion":
            return fail("result is not the expected illustrative positive-proportion output")
    except (OSError, json.JSONDecodeError, KeyError, TypeError, ValueError) as error:
        return fail(f"cannot read valid inputs: {error}")

    if not valid_proportion("generated result", generated):
        return 2
    abstract_match = ABSTRACT.search(report)
    table_match = TABLE.search(report)
    if not abstract_match or not table_match:
        return fail("report is missing a parseable abstract or table value")
    abstract_value = float(abstract_match.group(1))
    table_value = float(table_match.group(1))
    if not valid_proportion("abstract value", abstract_value) or not valid_proportion("table value", table_value):
        return 2
    mismatches = [
        name for name, value in (("abstract", abstract_value), ("table", table_value))
        if abs(value - generated) > 1e-12
    ]
    if mismatches:
        return fail(
            f"generated={generated:.2f}; "
            + ", ".join(f"{name}={value:.2f}" for name, value in (("abstract", abstract_value), ("table", table_value)))
            + "; stale fields: " + ", ".join(mismatches)
        )
    print(f"PASS: generated={generated:.2f}; abstract={abstract_value:.2f}; table={table_value:.2f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
