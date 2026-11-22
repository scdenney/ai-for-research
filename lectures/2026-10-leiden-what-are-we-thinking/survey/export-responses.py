#!/usr/bin/env python3
"""Export the audience survey's responses to responses.json, or delete old responses.

Export (default):
    python3 export-responses.py                         # live export via the API
    python3 export-responses.py --since 2026-10-20T00:00:00+02:00
    python3 export-responses.py --from-csv ~/Downloads/export.csv   # offline: a CSV from the UI

Keeps finished responses from the anonymous link that started at or after --since. The output
holds only the answer labels: no ResponseId, dates, IP address or location.

Delete (after the seminar):
    python3 export-responses.py --delete-before 2026-10-22T00:00:00+02:00 --confirm-survey-id SV_...
    ... --execute   # actually deletes
"""

from __future__ import annotations

import argparse
import csv
import json
import sys
import tempfile
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

import requests

from _toolkit import HERE, bs, client, mar, NAME

TAGS = ["role", "field", "use_general", "use_for", "agent", "freq", "edit", "draft", "discussed",
        "worry", "future", "never", "automate", "want_self", "want_supervision"]
DEFAULT_SINCE = "2026-10-21T14:30:00+02:00"
# mar.response_rows needs these keys; empty values mean "find the first header row" and
# no name or codeword handling.
ROW_CONFIG = {"name": [], "codeword": None, "reuse": None}


def parse_iso(text: str) -> datetime:
    value = datetime.fromisoformat(text)
    if value.tzinfo is None:
        sys.exit(f"Give a time zone in {text!r}, e.g. {DEFAULT_SINCE}")
    return value


def csv_timezone(csv_path: Path) -> tuple[ZoneInfo | timezone, str]:
    """Read the StartDate time zone from the export's ImportId row."""
    with csv_path.open(newline="", encoding="utf-8-sig") as handle:
        raw = list(csv.reader(handle))[:3]
    if raw and "StartDate" in raw[0]:
        col = raw[0].index("StartDate")
        for row in raw[1:]:
            cell = row[col] if col < len(row) else ""
            if cell.startswith("{"):
                try:
                    tz_name = json.loads(cell).get("timeZone")
                except json.JSONDecodeError:
                    tz_name = None
                if tz_name:
                    # The API export writes "Z" (UTC) unless a timeZone was requested.
                    if tz_name.upper() in {"Z", "UTC", "GMT", "ETC/UTC", "ETC/GMT"}:
                        return timezone.utc, f"{tz_name} (UTC)"
                    try:
                        return ZoneInfo(tz_name), tz_name
                    except Exception:
                        return timezone.utc, f"{tz_name!r} not recognised; assumed UTC"
    return timezone.utc, "not stated in CSV; assumed UTC"


def start_time(row: dict, tz) -> datetime | None:
    text = (row.get("StartDate") or "").strip()
    if not text:
        return None
    value = datetime.fromisoformat(text)
    return value if value.tzinfo else value.replace(tzinfo=tz)


def load_rows(args, survey_id: str, tmp: Path) -> tuple[Path, list[dict]]:
    if args.from_csv:
        csv_path = Path(args.from_csv).expanduser().resolve()
    else:
        csv_path = mar.fetch_export(client(), survey_id, tmp)
    return csv_path, mar.response_rows(csv_path, ROW_CONFIG)


def header_of(csv_path: Path) -> list[str]:
    with csv_path.open(newline="", encoding="utf-8-sig") as handle:
        return next(csv.reader(handle), [])


def do_export(args, survey_id: str, tmp: Path) -> int:
    since = parse_iso(args.since)
    csv_path, rows = load_rows(args, survey_id, tmp)
    header = header_of(csv_path)
    print(f"CSV columns ({len(header)}): {', '.join(header)}")
    missing = [t for t in TAGS if t not in header]
    if missing:
        sys.exit(f"Export is missing expected columns: {missing}")
    tz, tz_note = csv_timezone(csv_path)
    print(f"StartDate time zone: {tz_note}")

    channels = Counter(r.get("DistributionChannel", "") for r in rows)
    print(f"DistributionChannel values: {dict(channels) or '(no rows)'}")
    excluded = {"preview": 0, "before_cutoff": 0, "unfinished": 0}
    kept = []
    finished_ids = {id(r) for r in mar.finished_rows(rows)}
    for r in rows:
        if r.get("DistributionChannel", "") != "anonymous":
            excluded["preview"] += 1  # every non-anonymous channel (preview, test, ...)
        elif id(r) not in finished_ids:
            excluded["unfinished"] += 1
        else:
            started = start_time(r, tz)
            if started is None or started < since:
                excluded["before_cutoff"] += 1
            else:
                kept.append({t: (r.get(t) or "").strip() for t in TAGS})

    out = {
        "survey_id": survey_id,
        "exported_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "since": since.isoformat(),
        "n_raw": len(rows),
        "excluded": excluded,
        "rows": kept,
    }
    out_path = Path(args.out)
    if not out_path.is_absolute():
        out_path = HERE / out_path
    out_path.write_text(json.dumps(out, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"n_raw {len(rows)}, kept {len(kept)}, excluded {excluded}")
    print(f"Wrote {out_path}")
    return 0


def do_delete(args, survey_id: str, tmp: Path) -> int:
    if args.from_csv:
        sys.exit("--delete-before needs the live export; it cannot be used with --from-csv")
    if args.confirm_survey_id != survey_id:
        sys.exit(f"--confirm-survey-id must exactly match the survey ID in {bs.IDS_PATH}")
    cutoff = parse_iso(args.delete_before)
    csv_path, rows = load_rows(args, survey_id, tmp)
    tz, tz_note = csv_timezone(csv_path)
    print(f"StartDate time zone: {tz_note}")
    matching = [r for r in rows if (start_time(r, tz) or cutoff) < cutoff]
    print(f"{len(matching)} of {len(rows)} exported response(s) started before {cutoff.isoformat()}:")
    for r in matching:
        print(f"  {r.get('ResponseId')}  {r.get('DistributionChannel', '')}")
    if not args.execute:
        print("Nothing deleted. Add --execute to delete these responses.")
        return 0
    mar.delete_remote_responses(client(), survey_id, matching)
    print(f"Deleted {len(matching)} response(s) from {survey_id}.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--since", default=DEFAULT_SINCE, help="keep responses started at or after this ISO time")
    parser.add_argument("--from-csv", metavar="PATH", help="read a CSV exported from the Qualtrics UI instead of the API")
    parser.add_argument("--out", default="responses.json")
    parser.add_argument("--delete-before", metavar="ISO", help="list (and with --execute delete) responses started before this time")
    parser.add_argument("--confirm-survey-id", metavar="SV_...")
    parser.add_argument("--execute", action="store_true")
    args = parser.parse_args()

    entry = bs.load_ids().get(NAME) or {}
    survey_id = entry.get("id", "")
    if not survey_id and not args.from_csv:
        sys.exit(f"No survey ID for {NAME} in {bs.IDS_PATH}")

    try:
        with tempfile.TemporaryDirectory(prefix="leiden26-export-") as tmp:
            if args.delete_before:
                return do_delete(args, survey_id, Path(tmp))
            return do_export(args, survey_id, Path(tmp))
    except requests.HTTPError as err:
        status = err.response.status_code if err.response is not None else "?"
        print(f"Qualtrics API error: HTTP {status}", file=sys.stderr)
        print("Fallback: export the CSV in the Qualtrics UI, then run with --from-csv PATH.",
              file=sys.stderr)
        return 2
    except TimeoutError as err:
        print(f"{err}. Fallback: UI export, then --from-csv PATH.", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
