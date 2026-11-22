#!/usr/bin/env python3
"""Build the RSVP survey with the BA3 Qualtrics toolkit, which is not edited from here.

    build_rsvp.py --validate --dry-run
    build_rsvp.py --push --activate --validate
    build_rsvp.py qr      # writes rsvp-qr.png from the saved link
"""
import os
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
NAME = 'hbir_demo_rsvp'
os.environ.setdefault('BA3_QUALTRICS_ENV', str(Path.home() / '.config/qualtrics/hdw26.env'))
sys.dont_write_bytecode = True
sys.path.insert(0, str(Path.home() / 'Documents/github/courses/ba3tad-26/instructor-workbench/surveys'))
import build_surveys as bs  # noqa: E402

bs.SPECS_DIR, bs.BUILD_DIR, bs.IDS_PATH = HERE / 'specs', HERE / '_build', HERE / 'ids.json'

if sys.argv[1:] == ['qr']:
    import qrcode
    link = bs.load_ids()[NAME]['link']
    qrcode.make(link, border=2, box_size=20).convert('RGB').save(HERE / 'rsvp-qr.png')
    print(link)
else:
    sys.exit(bs.main(['--survey', NAME, *sys.argv[1:]]))
