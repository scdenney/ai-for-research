#!/usr/bin/env python3
"""build.py -- assemble a self-contained deck from content.md and src/deck.html, then export the PDF.

    python3 src/build.py            # writes index.html and deck.pdf
    python3 src/build.py --html     # index.html only
    python3 src/build.py --pdf NAME # choose the PDF filename

Placeholders in src/deck.html:
  {{FONTS}} {{FLAGS}} {{RUNTIME}}  inlined from src/fonts.css, src/flags.svg.html, src/runtime.js
  {{T:key}}                         text from content.md (`@key` fields)
  {{FIG:name}}                      src/figures/<name> inlined as a data URI (png, jpg, svg)
  {{CHART:name}}                    the SVG returned by CHARTS["name"]() in src/charts.py
  {{QR}}                            src/qr.svg inlined if present, otherwise empty
The build fails on a missing key or any unresolved placeholder, so a typo in
content.md cannot ship as a blank on a slide.
"""
import base64
import importlib.util
import mimetypes
import re
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
CONTENT = ROOT / "content.md"
OUT_HTML = ROOT / "index.html"


def load_content():
    fields, key, buf = {}, None, []
    for line in CONTENT.read_text(encoding="utf-8").splitlines():
        if line.startswith("//"):
            continue
        if line.startswith("@") or line.startswith("##"):
            if key is not None:
                fields[key] = "\n".join(buf).strip()
            key = line[1:].strip() if line.startswith("@") else None
            buf = []
        elif key is not None:
            buf.append(line)
    if key is not None:
        fields[key] = "\n".join(buf).strip()
    return fields


def load_charts():
    p = HERE / "charts.py"
    if not p.exists():
        return {}
    spec = importlib.util.spec_from_file_location("charts", p)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return getattr(mod, "CHARTS", {})


def inline_fig(name):
    p = HERE / "figures" / name
    mime = mimetypes.guess_type(str(p))[0] or "application/octet-stream"
    return "data:%s;base64,%s" % (mime, base64.b64encode(p.read_bytes()).decode("ascii"))


def build_html():
    tpl = (HERE / "deck.html").read_text(encoding="utf-8")
    content = load_content()
    charts = load_charts()
    for tag, fname in (("FONTS", "fonts.css"), ("FLAGS", "flags.svg.html"), ("RUNTIME", "runtime.js")):
        tpl = tpl.replace("{{%s}}" % tag, (HERE / fname).read_text(encoding="utf-8"))
    missing_charts = sorted(set(re.findall(r"\{\{CHART:(\w+)\}\}", tpl)) - set(charts))
    if missing_charts:
        sys.exit("charts.py has no function for: %s" % missing_charts)
    tpl = re.sub(r"\{\{CHART:(\w+)\}\}", lambda m: charts[m.group(1)](), tpl)
    missing = sorted(set(re.findall(r"\{\{T:([\w.]+)\}\}", tpl)) - set(content))
    if missing:
        sys.exit("content.md is missing: %s" % missing)
    tpl = re.sub(r"\{\{T:([\w.]+)\}\}", lambda m: content[m.group(1)], tpl)
    tpl = re.sub(r"\{\{FIG:([\w.\-]+)\}\}", lambda m: inline_fig(m.group(1)), tpl)
    qr = HERE / "qr.svg"
    tpl = tpl.replace("{{QR}}", qr.read_text(encoding="utf-8") if qr.exists() else "")
    leftover = re.findall(r"\{\{[^}]+\}\}", tpl)
    if leftover:
        sys.exit("unresolved placeholders: %s" % leftover)
    OUT_HTML.write_text(tpl, encoding="utf-8")
    print("wrote %s (%.2f MB)" % (OUT_HTML, OUT_HTML.stat().st_size / 1e6))


CHROME_CANDIDATES = [
    "chromium", "chrome", "google-chrome", "google-chrome-stable",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
]


def find_chrome():
    for c in CHROME_CANDIDATES:
        p = shutil.which(c) if "/" not in c else (c if Path(c).exists() else None)
        if p:
            return p
    sys.exit("no chromium/chrome binary found; build with --html and print the deck by hand")


def build_pdf(out_pdf):
    cmd = [find_chrome(), "--headless=new", "--disable-gpu", "--no-pdf-header-footer",
           "--virtual-time-budget=4000", "--print-to-pdf=%s" % out_pdf, "file://%s?print" % OUT_HTML]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print("wrote %s (%.2f MB)" % (out_pdf, out_pdf.stat().st_size / 1e6))


if __name__ == "__main__":
    build_html()
    if "--html" not in sys.argv:
        name = sys.argv[sys.argv.index("--pdf") + 1] if "--pdf" in sys.argv else "deck.pdf"
        build_pdf(ROOT / name)
