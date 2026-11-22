"""Load the BA3 Text as Data Qualtrics toolkit and repoint it at this folder.

The toolkit stays in ~/Documents/github/courses/ba3tad-26/instructor-workbench/surveys/ and is
never edited from here. Its build script is pinned by hash so a later change to it cannot alter
tomorrow's survey without notice. The template QSF is read from the toolkit folder.
"""

from __future__ import annotations

import hashlib
import os
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TOOLKIT_DIR = (Path.home() / "Documents" / "github" / "courses" / "ba3tad-26"
               / "instructor-workbench" / "surveys")
TOOLKIT_SHA256 = "096a33b200e3f52cad3bfa01d48d3b487fd064804829258c2a9028240c94f6b0"
NAME = "leiden26_audience"

# load_env() binds its default path at import time, so this must come first.
os.environ.setdefault("BA3_QUALTRICS_ENV", str(Path.home() / ".config" / "qualtrics" / "hdw26.env"))

_build_script = TOOLKIT_DIR / "build_surveys.py"
if not _build_script.exists():
    sys.exit(f"Toolkit not found at {_build_script}")
_digest = hashlib.sha256(_build_script.read_bytes()).hexdigest()
if _digest != TOOLKIT_SHA256:
    sys.exit(
        f"Toolkit build_surveys.py has changed (sha256 {_digest[:16]}..., pinned "
        f"{TOOLKIT_SHA256[:16]}...). Review the change, then update TOOLKIT_SHA256 in _toolkit.py."
    )

# Importing from the toolkit folder must not write .pyc files into its __pycache__.
sys.dont_write_bytecode = True
sys.path.insert(0, str(TOOLKIT_DIR))
import build_surveys as bs  # noqa: E402
import manage_attendance_responses as mar  # noqa: E402

# build_surveys reads these module globals at call time (load_spec, main, load_ids, save_ids).
bs.SPECS_DIR = HERE / "specs"
bs.BUILD_DIR = HERE / "_build"
bs.IDS_PATH = HERE / "ids.json"
# manage_attendance_responses copied IDS_PATH at import; only its own main() uses the copy.
mar.IDS_PATH = bs.IDS_PATH


# backup_definition() (used by --update and --retire-replaced) writes into the toolkit's
# ../live/ folder via its own HERE. Redirect it here so nothing is written under courses/.
def _backup_definition(self, survey_id: str, name: str) -> Path:
    import json
    backup_dir = HERE / "_build" / "backup"
    backup_dir.mkdir(parents=True, exist_ok=True)
    path = backup_dir / f"{name}-{survey_id}.json"
    path.write_text(json.dumps(self.fetch_definition(survey_id), indent=2) + "\n")
    return path


bs.QualtricsClient.backup_definition = _backup_definition


def survey_entry() -> dict:
    ids = bs.load_ids()
    entry = ids.get(NAME) or {}
    if not entry.get("id") or not entry.get("link"):
        sys.exit(f"No survey ID or link for {NAME} in {bs.IDS_PATH}. Run build-survey.py --push first.")
    return entry


def client():
    env = bs.load_env()
    return bs.QualtricsClient(env.get("QUALTRICS_API_TOKEN", ""), env.get("QUALTRICS_DATA_CENTER", ""))
