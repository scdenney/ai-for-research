#!/usr/bin/env python3
"""Verify pinned copied-file hashes without executing OSS or reading live sources."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    manifest_path = ROOT / "SOURCE-MANIFEST.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        records = manifest["records"]
    except (OSError, json.JSONDecodeError, KeyError, TypeError) as error:
        print(f"FAIL: cannot read pinned manifest: {error}")
        return 2
    failures = []
    for record in records:
        try:
            copied = ROOT / record["copy"]
            expected = record["source_sha256"]
            actual = sha256(copied)
            if actual != expected:
                failures.append(f"{record['copy']}: expected {expected}, got {actual}")
        except (OSError, KeyError, TypeError) as error:
            failures.append(f"invalid record: {error}")
    if failures:
        print("FAIL: pinned snapshot hash mismatch")
        print("\n".join(failures))
        return 1
    print(f"PASS: pinned snapshot hashes match; records={len(records)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
