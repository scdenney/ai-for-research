"""charts.py -- one function per {{CHART:name}} placeholder in deck.html.

Every function returns an inline SVG string drawn in the deck palette. Diagram
labels live here, beside the geometry, so a label and its box move together.
No result numbers are drawn from a numbers.tex snapshot in this deck; the two
figures on slide 27 are named in NUMBERS with their source.
"""
from html import escape

# Palette (src/deck.html :root)
PAPER, SURFACE, INK, MUTED = "#FBF7EF", "#FFFFFF", "#2E2A26", "#5F564B"
HAIR, OAT, OX, TEAL = "#D8CDB8", "#EFE7D6", "#6E3B34", "#2E5E5B"
SAGE, OCHRE, BRICK = "#4F7046", "#9C6B1A", "#A6442F"
ED = '"EB Garamond Deck","EB Garamond",Georgia,serif'
FN = '"Noto Sans Deck","Noto Sans",Arial,sans-serif'
W = 1752  # slide width minus the 84px side padding

# Cross-model divergence, character level, top-six cluster on body-text pages.
# Source: gei_textbooks/overleaf/technical_report.tex, Table tab:quality_lang
# (preliminary; the by-language figures are not yet in the committed analysis file).
NUMBERS = {"polish_divergence_pct": 2.3, "korean_divergence_pct": 24.6}


def svg(H, label, body, cls="chart"):
    return ('<svg class="%s" viewBox="0 0 %d %d" width="%d" height="%d" role="img" aria-label="%s">%s</svg>'
            % (cls, W, H, W, H, escape(label, quote=True), "".join(body)))


def txt(x, y, s, size, fam=ED, fill=INK, weight=400, anchor="start", extra=""):
    return ('<text x="%.1f" y="%.1f" font-family=\'%s\' font-size="%d" font-weight="%d" fill="%s" text-anchor="%s" %s>%s</text>'
            % (x, y, fam, size, weight, fill, anchor, extra, escape(s)))


def lines(x, y, arr, size, lh, fam=ED, fill=INK, weight=400, anchor="start", extra=""):
    out = []
    for i, s in enumerate(arr):
        out.append(txt(x, y + i * lh, s, size, fam, fill, weight, anchor, extra))
    return "".join(out)


def rect(x, y, w, h, fill, stroke=None, sw=0, rx=8, extra=""):
    st = ' stroke="%s" stroke-width="%s"' % (stroke, sw) if stroke else ""
    return '<rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" rx="%d" fill="%s"%s %s/>' % (x, y, w, h, rx, fill, st, extra)


def arrow(x1, y1, x2, y2, color=MUTED, sw=4, head=14):
    """A straight arrow with a filled head."""
    import math
    ang = math.atan2(y2 - y1, x2 - x1)
    hx, hy = x2 - head * math.cos(ang), y2 - head * math.sin(ang)
    px, py = head * 0.6 * math.sin(ang), head * 0.6 * math.cos(ang)
    return ('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="%s" stroke-width="%d" stroke-linecap="round"/>'
            '<polygon points="%.1f,%.1f %.1f,%.1f %.1f,%.1f" fill="%s"/>'
            % (x1, y1, hx, hy, color, sw, x2, y2, hx + px, hy - py, hx - px, hy + py, color))


# ---------------------------------------------------------------- slide 5, 6, 15, 33
SPACES = [
    ("Assembly line", "Automate", ["Doing it adds nothing."]),
    ("Apprenticeship", "Protect", ["Doing it builds expertise."]),
    ("Workbench", "Collaborate", ["The machine changes the scale."]),
]


def three_spaces(lit):
    """lit: a set of panel indexes drawn in oxblood; the rest are muted."""
    H = 400
    pw, gap = 540, 66
    body = []
    for i, (name, verb, desc) in enumerate(SPACES):
        x = i * (pw + gap)
        on = i in lit
        body.append(rect(x, 10, pw, H - 20, SURFACE, OX if on else HAIR, 6 if on else 2, rx=10))
        body.append(txt(x + pw / 2, 118, name, 50, ED, OX if on else MUTED, 600, "middle"))
        body.append(txt(x + pw / 2, 170, verb.upper(), 24, FN, OCHRE if on else MUTED, 700, "middle", 'letter-spacing="0.22em"'))
        body.append(lines(x + pw / 2, 250, desc, 30, 40, ED, INK if on else MUTED, 400, "middle"))
    return svg(H, "Three spaces for cognitive work: assembly line, apprenticeship, workbench", body)


def chart_three_spaces_all():
    return three_spaces({0, 1, 2})


def chart_three_spaces_p2():
    return three_spaces({2})


# ---------------------------------------------------------------- slide 12, 13
CELLS = [
    ("1", "Pair programming", ["Work together on every step"]),
    ("2", "Planning commission", ["You plan, the machine implements"]),
    ("3", "Review board", ["The machine drafts, you review"]),
    ("4", "Autopilot", ["You instruct, the machine validates"]),
]


def grid_body(ox, oy, scale=1.0, dim=False):
    """The 2x2 at origin (ox, oy). Full size: 1500 x 620 including axes."""
    s = scale
    cw, ch, gap = 720 * s, 260 * s, 24 * s
    ax = ox + 130 * s  # plot left
    ay = oy
    body = []
    name_fill = MUTED if dim else OX
    for i, (n, name, desc) in enumerate(CELLS):
        cx = ax + (i % 2) * (cw + gap)
        cy = ay + (i // 2) * (ch + gap)
        body.append(rect(cx, cy, cw, ch, SURFACE, HAIR, 2 * s, rx=8))
        body.append(txt(cx + 30 * s, cy + 74 * s, n + "  " + name, 40 * s, ED, name_fill, 600))
        body.append(lines(cx + 30 * s, cy + 140 * s, desc, 27 * s, 36 * s, FN, MUTED, 400))
    # axes
    plot_w, plot_h = 2 * cw + gap, 2 * ch + gap
    xa_y = ay + plot_h + 34 * s
    body.append(arrow(ax, xa_y, ax + plot_w, xa_y, INK, max(2, int(3 * s)), 16 * s))
    body.append(txt(ax, xa_y + 40 * s, "subjective", 24 * s, FN, MUTED, 600))
    body.append(txt(ax + plot_w / 2, xa_y + 40 * s, "Verifiability", 26 * s, FN, INK, 700, "middle"))
    body.append(txt(ax + plot_w, xa_y + 40 * s, "objective", 24 * s, FN, MUTED, 600, "end"))
    ya_x = ax - 34 * s
    body.append(arrow(ya_x, ay + plot_h, ya_x, ay, INK, max(2, int(3 * s)), 16 * s))
    body.append(txt(ya_x - 16 * s, ay + plot_h / 2, "Complexity", 26 * s, FN, INK, 700, "middle",
                    'transform="rotate(-90 %.1f %.1f)"' % (ya_x - 16 * s, ay + plot_h / 2)))
    body.append(txt(ya_x - 16 * s, ay + 14 * s, "hard", 24 * s, FN, MUTED, 600, "end"))
    body.append(txt(ya_x - 16 * s, ay + plot_h, "easy", 24 * s, FN, MUTED, 600, "end"))
    return body


def chart_grid():
    H = 640
    body = grid_body(80, 10)
    return svg(H, "Four working modes on axes of complexity and verifiability", body)


def chart_gate():
    H = 640
    body = []
    # the grid, reduced, on the right
    body.extend(grid_body(820, 40, scale=0.60, dim=False))
    # the gate on the left: a diamond
    cx, cy, hw, hh = 330, 320, 300, 190
    pts = "%d,%d %d,%d %d,%d %d,%d" % (cx, cy - hh, cx + hw, cy, cx, cy + hh, cx - hw, cy)
    body.append('<polygon points="%s" fill="%s" stroke="%s" stroke-width="5"/>' % (pts, OAT, OX))
    body.append(lines(cx, cy - 40, ["Does doing it build", "the judgment needed", "to check it?"], 32, 40, ED, INK, 600, "middle"))
    # yes: up to a protect box
    body.append(arrow(cx, cy - hh - 4, cx, 96, INK, 4, 16))
    body.append(txt(cx + 18, 118, "yes", 24, FN, OCHRE, 700))
    body.append(rect(cx - 250, 14, 500, 74, SURFACE, INK, 3, rx=8))
    body.append(txt(cx, 62, "Protect: do it yourself, off the grid", 30, ED, INK, 600, "middle"))
    # no: right, into the grid (the arrow stops short of the grid's own axis)
    body.append(arrow(cx + hw + 6, cy, 860, cy, INK, 4, 16))
    body.append(txt(cx + hw + 30, cy - 22, "no", 24, FN, OCHRE, 700))
    body.append(txt(cx + hw + 80, cy - 22, "enter the grid", 24, FN, MUTED, 600))
    return svg(H, "A gate before the grid: does doing the task build the judgment needed to check it", body)


# ---------------------------------------------------------------- slide 18
LAYERS = [  # bottom first
    ("Original PDFs", "the archive, never edited"),
    ("Markdown conversions", "verbatim and tracked: what the checks read"),
    ("Bibliography", "one key per source, resolvable to a file"),
    ("Synopsis index", "Establishes, Boundary, Supports: the wiki layer"),
    ("Manuscript claims", "each citation points to text a reader can open"),
]


def chart_kb_stack():
    H = 660
    bh, gap, top = 100, 28, 10
    n = len(LAYERS)
    body = []
    for i, (name, desc) in enumerate(LAYERS):
        y = top + (n - 1 - i) * (bh + gap)
        is_top = i == n - 1
        fill = SURFACE if is_top else (OAT if i == 0 else SURFACE)
        g = [rect(0, y, W, bh, fill, OX if is_top else HAIR, 3 if is_top else 2, rx=8),
             txt(34, y + 62, name, 36, ED, OX, 600),
             txt(520, y + 60, desc, 27, FN, MUTED, 400)]
        if i > 0:
            g.append(arrow(120, y + bh + gap + 2, 120, y + bh + 2, INK, 4, 14))
        if i > 0:
            body.append('<g class="fragment">' + "".join(g) + "</g>")
        else:
            body.extend(g)
    return svg(H, "The knowledge base as five layers, from original PDFs to manuscript claims", body)


# ---------------------------------------------------------------- slides 24, 26
STEPS = [
    ["Physical", "textbook"], ["Page", "images"], ["Organized", "archive"], ["Vision-model", "transcription"],
    ["Validated", "text"], ["Structured", "corpus"], ["Analysis and", "inference"],
]
QUESTIONS = [
    ["What counts", "as a source?"],
    ["What gets scanned,", "and how is a page", "identified?"],
    ["How accurate is the", "transcription, and", "how would we know?"],
    ["What happens to", "tables, captions,", "and marginalia?"],
    ["What is the unit", "of analysis?"],
    ["What claims can", "this text support?"],
]


def pipeline_body(build):
    nw, gap, nh, y = 214, 42, 150, 10
    body = []
    for i, lab in enumerate(STEPS):
        x = i * (nw + gap)
        g = [rect(x, y, nw, nh, SURFACE, HAIR, 2, rx=8),
             rect(x, y, nw, 9, OX, rx=4),
             lines(x + nw / 2, y + 74, lab, 30, 36, ED, INK, 600, "middle")]
        if i > 0:
            g.insert(0, arrow(x - gap + 4, y + nh / 2, x - 4, y + nh / 2, MUTED, 4, 14))
        if build and i > 0:
            body.append('<g class="fragment">' + "".join(g) + "</g>")
        else:
            body.extend(g)
    return body, nw, gap, nh, y


def chart_gei_pipeline():
    body, *_ = pipeline_body(build=True)
    return svg(180, "Seven steps from a physical textbook to inference", body)


def chart_decisions():
    body, nw, gap, nh, y = pipeline_body(build=False)
    qw, qh, qy = 236, 190, 250
    for i, q in enumerate(QUESTIONS):
        mid = (i + 1) * (nw + gap) - gap / 2
        body.append('<line x1="%.1f" y1="%d" x2="%.1f" y2="%d" stroke="%s" stroke-width="3" stroke-dasharray="8 8"/>'
                    % (mid, y + nh + 8, mid, qy - 6, OX))
        body.append(rect(mid - qw / 2, qy, qw, qh, OAT, rx=8))
        body.append(lines(mid, qy + 58, q, 24, 32, FN, INK, 600, "middle"))
    return svg(qy + qh + 10, "The same seven steps, with the methodological question under each arrow", body)


# ---------------------------------------------------------------- slide 27
def chart_divergence():
    H = 300
    rows = [("Polish", NUMBERS["polish_divergence_pct"], "about 2%"), ("Korean", NUMBERS["korean_divergence_pct"], "about 25%")]
    x0, bar_max, scale = 300, 1180, 1180 / 25.0
    body = []
    for i, (lab, v, s) in enumerate(rows):
        y = 30 + i * 130
        body.append(txt(0, y + 58, lab, 40, ED, INK, 600))
        bw = max(12, v * scale)
        body.append(rect(x0, y + 14, bw, 66, OX, rx=4))
        body.append(txt(x0 + bw + 24, y + 58, s, 36, FN, INK, 700))
    body.append('<line x1="%d" y1="10" x2="%d" y2="%d" stroke="%s" stroke-width="3"/>' % (x0, x0, H - 20, INK))
    body.append(txt(x0, H - 0, "0", 22, FN, MUTED, 600, "middle"))
    body.append(txt(x0 + bar_max, H - 0, "25% of characters", 22, FN, MUTED, 600, "end"))
    return svg(H + 10, "Cross-model divergence: about 2 percent on Polish pages, about 25 percent on Korean pages", body)


CHARTS = {
    "three_spaces_all": chart_three_spaces_all,
    "three_spaces_p2": chart_three_spaces_p2,
    "grid": chart_grid,
    "gate": chart_gate,
    "kb_stack": chart_kb_stack,
    "gei_pipeline": chart_gei_pipeline,
    "decisions": chart_decisions,
    "divergence": chart_divergence,
}
