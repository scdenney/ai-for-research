#!/usr/bin/env python3
"""Run the teaching demo in a temporary copy and save auditable receipts.

It never runs a bundled OSS verifier or any research pipeline.
"""

from __future__ import annotations

import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path


ROOT = Path(__file__).resolve().parent
RECEIPTS = ROOT / "receipts"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(cwd: Path, *arguments: str) -> dict[str, object]:
    completed = subprocess.run(arguments, cwd=cwd, capture_output=True, text=True)
    return {"command": list(arguments), "returncode": completed.returncode,
            "stdout": completed.stdout, "stderr": completed.stderr}


def expected_nonzero(case: str, record: dict[str, object]) -> None:
    if record["returncode"] == 0:
        raise RuntimeError(f"{case} unexpectedly passed")


def main() -> int:
    RECEIPTS.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="illustrative-verification-") as temporary:
        work = Path(temporary) / "verification"
        shutil.copytree(ROOT, work, ignore=shutil.ignore_patterns("generated", "receipts", "__pycache__"))
        generated = work / "generated/demo-result.json"
        records = {
            "generate": run(work, sys.executable, "generate_result.py"),
            "stale_report": run(work, sys.executable, "compare_report.py", "--report", "report-stale.md", "--result", str(generated)),
            "corrected_report": run(work, sys.executable, "compare_report.py", "--report", "report-corrected.md", "--result", str(generated)),
            "pipeline_stale": run(work, sys.executable, "run_pipeline.py", "--report", "report-stale.md"),
            "pipeline_corrected": run(work, sys.executable, "run_pipeline.py", "--report", "report-corrected.md"),
            "pipeline_failed_analysis": run(work, sys.executable, "run_pipeline.py", "--report", "report-corrected.md", "--input", "data/does-not-exist.csv"),
            "invalid_output": run(work, sys.executable, "compare_report.py", "--report", "report-corrected.md", "--result", "fixtures/invalid-result.json"),
            "nonfinite_output": run(work, sys.executable, "compare_report.py", "--report", "report-corrected.md", "--result", "fixtures/nonfinite-result.json"),
            "out_of_range_output": run(work, sys.executable, "compare_report.py", "--report", "report-corrected.md", "--result", "fixtures/out-of-range-result.json"),
        }
        generated_sha256 = digest(generated)
        generated.unlink()
        records["missing_output"] = run(work, sys.executable, "compare_report.py", "--report", "report-corrected.md", "--result", str(generated))

    expected_nonzero("pipeline_stale", records["pipeline_stale"])
    if records["pipeline_corrected"]["returncode"] != 0:
        raise RuntimeError("pipeline_corrected did not pass")
    expected_nonzero("pipeline_failed_analysis", records["pipeline_failed_analysis"])
    if "comparator was not invoked" not in records["pipeline_failed_analysis"]["stderr"]:
        raise RuntimeError("failed pipeline did not stop before comparison")
    expected_nonzero("invalid_output", records["invalid_output"])
    expected_nonzero("nonfinite_output", records["nonfinite_output"])
    expected_nonzero("out_of_range_output", records["out_of_range_output"])
    expected_nonzero("missing_output", records["missing_output"])
    receipt = {
        "purpose": "illustrative project-specific numerical consistency check",
        "created_utc": datetime.now(timezone.utc).replace(microsecond=0).isoformat(),
        "records": records,
        "generated_output_sha256": generated_sha256,
        "preexisting_result_before_failed_pipeline_sha256": generated_sha256,
        "pipeline_fails_closed": True,
        "failed_pipeline_emitted_pass": "PASS:" in records["pipeline_failed_analysis"]["stdout"],
        "source_sha256": {str(path.relative_to(ROOT)): digest(path) for path in sorted(path for path in ROOT.rglob("*") if path.is_file() and "generated" not in path.parts and "receipts" not in path.parts and "__pycache__" not in path.parts)},
    }
    target = RECEIPTS / "verification-receipt.json"
    target.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(target)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
