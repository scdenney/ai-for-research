#!/usr/bin/env python3
"""Write qr-audience.png (for slide 2) and qr-audience.pdf (a 16:9 backup slide).

The PNG is RGB on purpose: xdvipdfmx inverts a 1-bit PNG.
"""

from __future__ import annotations

import math
import sys

import qrcode

from _toolkit import HERE, survey_entry

MIN_PIXELS = 900
BORDER = 4  # modules of quiet zone


def main() -> int:
    link = survey_entry()["link"]
    if not link.startswith("https://fra1.qualtrics.com/jfe/form/SV_"):
        sys.exit(f"Unexpected link format: {link}")

    qr = qrcode.QRCode(error_correction=qrcode.constants.ERROR_CORRECT_M, border=BORDER)
    qr.add_data(link)
    qr.make(fit=True)
    modules = qr.modules_count + 2 * BORDER
    qr.box_size = math.ceil(MIN_PIXELS / modules)  # whole pixels per module, no resampling
    img = qr.make_image(fill_color="black", back_color="white").convert("RGB")
    png = HERE / "qr-audience.png"
    img.save(png)
    print(f"Wrote {png} ({img.size[0]}x{img.size[1]} px, {img.mode}, version {qr.version}, "
          f"{qr.modules_count} modules + {BORDER}-module border, box {qr.box_size} px)")

    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    fig = plt.figure(figsize=(16, 9))
    side = 0.72  # fraction of page height
    ax = fig.add_axes([(1 - side * 9 / 16) / 2, 0.2, side * 9 / 16, side])
    ax.imshow(img, interpolation="nearest")
    ax.set_axis_off()
    fig.text(0.5, 0.1, link, ha="center", va="center", family="monospace", fontsize=26)
    pdf = HERE / "qr-audience.pdf"
    fig.savefig(pdf)
    plt.close(fig)
    print(f"Wrote {pdf} (16:9 backup slide)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
