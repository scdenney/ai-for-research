#!/usr/bin/env bash
# Regenerate inbox/ from the synthetic paper text in scripts/originals/.
#
# The point of the inbox is that it looks like a real download folder: the file
# names carry no meaning, one source arrives as .docx instead of .pdf, and one is
# a photographed scan with no text layer at all. Intake has to fix that.
#
# Outputs are committed, so you do not need to run this to use the demo.
# Requires: pandoc, xelatex, pdftoppm (poppler), magick (ImageMagick).
set -euo pipefail

cd "$(dirname "$0")/.."
SRC=scripts/originals
OUT=inbox
mkdir -p "$OUT"

pdf() { pandoc "$SRC/$1" --pdf-engine=xelatex -o "$OUT/$2"; echo "  $2"; }

echo "Rendering inbox/ ..."

# Two ordinary text PDFs, under the names a browser and a publisher gave them.
pdf ferreira-nair-2021.md "Download (3).pdf"
pdf lindqvist-2019.md     "1-s2.0-S0261379421000342.pdf"

# One source that never became a PDF at all.
pandoc "$SRC/osei-2020.md" -o "$OUT/osei_socialtrust_FINAL_v2.docx"
echo "  osei_socialtrust_FINAL_v2.docx"

# One image-only scan: render a text PDF, rasterise it, wrap the images back up.
# The result has no text layer, which is what the converter must refuse to guess at.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
pandoc "$SRC/kowalski-2017.md" --pdf-engine=xelatex -o "$tmp/page.pdf"
pdftoppm -r 120 -png "$tmp/page.pdf" "$tmp/scan"
magick "$tmp"/scan-*.png -quality 60 "$OUT/scan-0417.pdf"
echo "  scan-0417.pdf"

echo "Done. $(ls -1 "$OUT" | wc -l) files in $OUT/"
