#!/usr/bin/env python3
"""Build the illustrative fresh-analysis versus stale-report comparison figure."""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter, MultipleLocator

from compare_report import extract_report_values
from generate_result import calculate_result


ROOT = Path(__file__).resolve().parent
DEFAULT_OUTPUT = ROOT.parent.parent / "overleaf/figures/verification-demo-comparison.pdf"
PAGE = "#FFFCF2"
INK = "#25231F"
MUTED = "#5F5A52"
STRUCTURE = "#6E3B34"
ACCENT = "#2E5E5B"
GRID = "#D9D2C6"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=ROOT / "data/illustrative-binary-outcomes.csv")
    parser.add_argument("--report", type=Path, default=ROOT / "report-stale.md")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    result = calculate_result(args.input)
    abstract_value, table_value = extract_report_values(args.report.read_text(encoding="utf-8"))
    if abs(abstract_value - table_value) > 1e-12:
        raise ValueError("stale illustrative report fields must agree for this comparison figure")

    generated = float(result["value"])
    stale = abstract_value
    categories = ["Fresh analysis", "Stale report"]
    values = [generated, stale]
    colors = [ACCENT, STRUCTURE]

    plt.rcParams.update({
        "font.family": "DejaVu Sans",
        "font.size": 11,
        "axes.labelsize": 11,
        "xtick.labelsize": 9,
        "ytick.labelsize": 11,
        "pdf.fonttype": 42,
    })
    figure, axis = plt.subplots(figsize=(7.2, 2.35), facecolor=PAGE)
    axis.set_facecolor(PAGE)
    bars = axis.barh(categories, values, color=colors, height=0.48)
    axis.invert_yaxis()
    axis.set_xlim(0, 0.35)
    axis.set_xlabel("Positive proportion (share of 25 illustrative rows)", color=INK, labelpad=8)
    axis.xaxis.set_major_locator(MultipleLocator(0.10))
    axis.xaxis.set_major_formatter(FuncFormatter(lambda value, _: f"{value:.2f}"))
    axis.grid(axis="x", color=GRID, linewidth=0.7)
    axis.set_axisbelow(True)
    axis.tick_params(axis="x", colors=MUTED, length=0)
    axis.tick_params(axis="y", colors=INK, length=0, pad=8)
    for spine in axis.spines.values():
        spine.set_visible(False)

    labels = [
        f"{generated:.2f}  computed ({result['positive_count']}/{result['n']})",
        f"{stale:.2f}  reported twice",
    ]
    for bar, label, color in zip(bars, labels, colors):
        axis.text(
            bar.get_width() - 0.006,
            bar.get_y() + bar.get_height() / 2,
            label,
            ha="right",
            va="center",
            color="white",
            fontsize=10,
            fontweight="bold",
        )

    figure.subplots_adjust(left=0.19, right=0.985, top=0.96, bottom=0.29)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    figure.savefig(args.output, format="pdf", facecolor=PAGE)
    plt.close(figure)
    print(args.output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
