#!/usr/bin/env bash
# Render inbox/ from the synthetic sources in originals/, under the meaningless names a
# download folder gives them: two text PDFs, one Word transcription in Korean, and one
# photographed page with no text layer. Adapted from
# demos/knowledge-base/scripts/make-inbox.sh.
# Requires: pandoc, xelatex, pdftoppm (poppler), magick (ImageMagick).
set -euo pipefail

cd "$(dirname "$0")"
SRC=originals
OUT=inbox
mkdir -p "$OUT"

pdf() { pandoc "$SRC/$1" --pdf-engine=xelatex -V mainfont="EB Garamond" -o "$OUT/$2"; echo "  $2"; }

echo "Rendering inbox/ ..."
pdf han-2018.md     "9780367_ch03_proof.pdf"
pdf bureau-1946.md  "Download (7).pdf"

pandoc "$SRC/hangdo-ilbo-1946.md" -o "$OUT/HD_0314_transcription_FINAL.docx"
echo "  HD_0314_transcription_FINAL.docx"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
pandoc "$SRC/kim-1972.md" --pdf-engine=xelatex -V mainfont="EB Garamond" -o "$tmp/page.pdf"
pdftoppm -r 120 -png "$tmp/page.pdf" "$tmp/scan"
magick "$tmp"/scan-*.png -quality 60 "$OUT/IMG_2231.pdf"
echo "  IMG_2231.pdf"

echo "Done. $(ls -1 "$OUT" | wc -l | tr -d ' ') files in $OUT/"
