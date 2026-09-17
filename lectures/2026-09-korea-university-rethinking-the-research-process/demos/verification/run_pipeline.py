#!/usr/bin/env python3
"""Generate and compare using a new temporary result on every invocation."""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def relay(completed: subprocess.CompletedProcess[str]) -> None:
    sys.stdout.write(completed.stdout)
    sys.stderr.write(completed.stderr)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--input", type=Path, default=Path("data/illustrative-binary-outcomes.csv"))
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="illustrative-pipeline-") as temporary:
        result = Path(temporary) / "fresh-result.json"
        generate = subprocess.run(
            [sys.executable, "generate_result.py", "--input", str(args.input), "--output", str(result)],
            cwd=ROOT, capture_output=True, text=True,
        )
        relay(generate)
        if generate.returncode != 0:
            print("FAIL: generator failed; comparator was not invoked", file=sys.stderr)
            return generate.returncode or 1
        compare = subprocess.run(
            [sys.executable, "compare_report.py", "--report", str(args.report), "--result", str(result)],
            cwd=ROOT, capture_output=True, text=True,
        )
        relay(compare)
        return compare.returncode


if __name__ == "__main__":
    raise SystemExit(main())
