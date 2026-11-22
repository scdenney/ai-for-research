#!/usr/bin/env python3
"""Render the Leiden audience-survey results beside published surveys.

    python3 results.py [--input responses.json] [--published published.yaml]
                       [--out results.pdf]

Reads the export written by export-responses.py and the hand-editable
published.yaml, and writes a seven-page 16:9 PDF for projection:
  1 who answered (role, field)   2 how you use AI (use_general, use_for,
  agent)   3 frequency of AI use in research vs OUP 2026
  4 editing / Dr. Bloggs vs Nature 2025   5 supervision talk / worry
  6 open answers: never / happily hand to AI   7 open answers: what you
  want, for yourself and in supervision (overflow, and the full lists, go
  to open-text.md).

"Not applicable" options on the borrowed items (freq, edit: "I don't do
academic research"; discussed: "Not applicable") are left out of the room's
percentages, so the room is compared with the published figures on the same
base; the pages say so in a footnote.

Never crashes on bad input: a missing, empty or malformed responses file is
treated as "no room data yet"; unknown answer labels go to an
"Other/unmatched" bucket and are reported on stderr. Text is typeset with
XeLaTeX via matplotlib's pgf backend (EB Garamond, Noto Sans Mono for
numbers); if that fails, the PDF is rendered again with DejaVu Sans.
Needs Python 3, matplotlib and PyYAML. No network access.
"""
import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
import tempfile
import textwrap
import traceback
from pathlib import Path

import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib import font_manager
from matplotlib.patches import Rectangle
from matplotlib.lines import Line2D
from matplotlib import transforms

HERE = Path(__file__).resolve().parent
W, H = 13.333, 7.5                     # inches, 16:9
ROOM, PUB, PUB2 = '#A84E2C', '#4F5F6C', '#A9CEE1'
INK, HEAD, BG, PANEL = '#142B3B', '#255B79', '#FBF8F0', '#E6F0F2'
MUTED = '#4A5D6B'
# Room bars are ink, because the orange-brown accent now marks social sciences.
ROOM_BAR = INK
# Published series colours, matched on the series label (case-insensitive).
SER_HUM, SER_SOC, SER_OTHER, SER_ALL = '#255B79', '#A84E2C', '#A9CEE1', '#4F5F6C'
SER_OTHER_VAL = '#4F5F6C'      # value labels beside the light-blue bars
OTHER_FIELDS = ('science, technology', 'stm', 'economics', 'computing')


def series_color(label):
    """(bar colour, value-label colour) for a published series."""
    s = str(label).casefold()
    if 'humanities' in s:
        return SER_HUM, INK
    if 'social science' in s:
        return SER_SOC, INK
    if any(k in s for k in OTHER_FIELDS):
        return SER_OTHER, SER_OTHER_VAL
    if 'all respondents' in s:
        return SER_ALL, INK
    return PUB, INK
MIN_PT = 12
ROOM_LINE = ("Room answers are from the anonymous Qualtrics survey at the "
             "start of this seminar.")
PENDING_NOTE = "\u2020 Subgroup value pending recomputation from the microdata."
MAX_PER_COLUMN = 22

OPTIONS = {
    'role': ["PhD candidate", "Postdoc", "Lecturer or professor",
             "Research or support staff", "Bachelor's or master's student",
             "Other"],
    'field': ["Humanities", "Social sciences", "Both or in between", "Other"],
    'use_general': ["Frequently", "Sometimes", "Rarely", "Never"],
    'use_for': ["Writing and editing", "Finding and summarizing information",
                "Code or data", "Teaching or supervision",
                "Administration and e-mail", "Something else",
                "I don't use them"],
    'agent': ["Yes, regularly", "I have tried one", "No, but I am curious",
              "No"],
    'freq': ["Frequently", "Sometimes", "Rarely", "Never",
             "I don't do academic research"],
    'edit': ["Yes, without disclosing that I used AI",
             "Yes, and I disclosed that I used AI",
             "No, but I would be willing to",
             "No, and I wouldn't consider it",
             "I don't do academic research"],
    'draft': ["It's appropriate",
              "It's only appropriate if Dr. Bloggs discloses that they used AI",
              "It's only appropriate if Dr. Bloggs discloses details of the "
              "prompts they used",
              "It's not appropriate under any circumstances"],
    'discussed': ["Yes, and we have explicit agreements", "Yes, informally",
                  "No", "Not applicable"],
    'worry': ["Strongly disagree", "Disagree", "Neither agree nor disagree",
              "Agree", "Strongly agree"],
    'future': ["AI is just the latest in a long line of technological advancements that humans will learn to use to improve their lives and society",
               "AI is very different from the technological advancements that came before, and threatens to harm humans and society"],
}
# Options left out of the room's percentages (borrowed items only).
NOT_APPLICABLE = {
    'freq': ["I don't do academic research"],
    'edit': ["I don't do academic research"],
    'discussed': ["Not applicable"],
}
TEXT_TAGS = ('never', 'automate', 'want_self', 'want_supervision')
# tag: (heading, short line under the heading on the slide, survey question)
TEXT_HEADS = {
    'never': ('Never hand to AI',
              'One thing in your work you would never hand to AI',
              'Name one thing in your work you would never hand to AI.'),
    'automate': ('Happily hand to AI', 'One thing you happily hand to AI',
                 'Name one thing you happily hand to AI.'),
    'want_self': ('For yourself', 'How you want to use AI in the next year',
                  'How would you like to use AI in your own work over the '
                  'next year?'),
    'want_supervision': ('In supervision',
                         'As a supervisor or as a student',
                         'And in supervision, as a supervisor or as a '
                         'student?'),
}
UNMATCHED = "Other/unmatched"


def warn(msg):
    print(f"results.py: {msg}", file=sys.stderr)


# ----------------------------------------------------------------- data ----

def norm(s):
    s = str(s)
    for a, b in (('\u2019', "'"), ('\u2018', "'"), ('\u201c', '"'),
                 ('\u201d', '"'), ('\xa0', ' ')):
        s = s.replace(a, b)
    return ' '.join(s.split()).casefold()


def load_responses(path):
    meta = {'rows': [], 'exported_utc': '', 'since': '', 'excluded': {},
            'n_raw': None, 'problem': ''}
    try:
        raw = Path(path).read_text(encoding='utf-8-sig')
    except FileNotFoundError:
        warn(f"{path} not found; rendering without room data")
        meta['problem'] = 'no responses file'
        return meta
    except OSError as e:
        warn(f"cannot read {path} ({e}); rendering without room data")
        meta['problem'] = 'responses file unreadable'
        return meta
    if not raw.strip():
        return meta
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as e:
        warn(f"{path} is not valid JSON ({e}); rendering without room data")
        meta['problem'] = 'responses file not valid JSON'
        return meta
    rows = data if isinstance(data, list) else (
        data.get('rows') if isinstance(data, dict) else None)
    if isinstance(data, dict):
        for k in ('exported_utc', 'since', 'n_raw'):
            meta[k] = data.get(k) or meta[k]
        if isinstance(data.get('excluded'), dict):
            meta['excluded'] = data['excluded']
    if not isinstance(rows, list):
        warn(f"{path}: no 'rows' list; rendering without room data")
        rows = []
    clean = []
    for r in rows:
        if not isinstance(r, dict):
            warn(f"skipping a row that is not an object: {str(r)[:60]!r}")
            continue
        clean.append({k: ('' if v is None else str(v)) for k, v in r.items()})
    meta['rows'] = clean
    return meta


def tally(rows, tag):
    """Counts per option (in option order), plus unmatched and blank."""
    opts = OPTIONS[tag]
    lookup = {norm(o): o for o in opts}
    counts = {o: 0 for o in opts}
    unmatched, blank = {}, 0
    for r in rows:
        v = r.get(tag, '')
        if not str(v).strip():
            blank += 1
            continue
        o = lookup.get(norm(v))
        if o is None:
            unmatched[v] = unmatched.get(v, 0) + 1
        else:
            counts[o] += 1
    if unmatched:
        warn(f"{tag}: {sum(unmatched.values())} unmatched answer(s) put in "
             f"'{UNMATCHED}': " + '; '.join(f'{k!r} x{v}' for k, v in
                                           unmatched.items()))
    n_unm = sum(unmatched.values())
    answered = sum(counts.values()) + n_unm
    na = sum(counts[o] for o in NOT_APPLICABLE.get(tag, ()))
    # base: the denominator for percentages (answered minus "not applicable")
    return {'tag': tag, 'counts': counts, 'unmatched': n_unm, 'blank': blank,
            'answered': answered, 'na': na, 'base': answered - na}


def na_note(T, tags):
    """Footnote saying which 'not applicable' answers were left out."""
    bits = []
    for tag in tags:
        for o in NOT_APPLICABLE.get(tag, ()):
            bits.append(f'“{o}” ({tag}: {T[tag]["counts"][o]})')
    if not bits:
        return ''
    return ("Room percentages leave out " + '; '.join(bits) + ", so they "
            "share a base with the published figures.")


def pct(num, den):
    try:
        return None if not den else 100.0 * num / den
    except (TypeError, ZeroDivisionError):
        return None


def fpct(v):
    return 'n/a' if v is None else f'{v:.0f}%'


def room_text(v, count):
    return 'n/a' if v is None else f'{v:.0f}% ({count})'


def load_published(path):
    try:
        import yaml
    except ImportError:
        warn("PyYAML not installed (pip install pyyaml); no published figures")
        return {}
    try:
        with open(path, encoding='utf-8') as f:
            pub = yaml.safe_load(f) or {}
    except FileNotFoundError:
        warn(f"{path} not found; no published figures")
        return {}
    except Exception as e:  # yaml.YAMLError and friends
        warn(f"cannot parse {path} ({e}); no published figures")
        return {}
    return pub if isinstance(pub, dict) else {}


def num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def is_pending(s):
    return str(s.get('verified', '')).strip().lower() == 'pending'


# ------------------------------------------------------------ typesetting --

class Style:
    pgf = False
    mono = 'DejaVu Sans Mono'
    k = 0.58             # average glyph width / font size, for wrapping
    kmono = 0.62


def font_name(family):
    try:
        path = subprocess.check_output(['fc-match', '-f', '%{file}', family],
                                       text=True, timeout=10).strip()
        font_manager.fontManager.addfont(path)
        return font_manager.FontProperties(fname=path).get_name()
    except Exception:
        return None


def setup(use_pgf, with_mono=True):
    plt.rcdefaults()
    rc = {'figure.facecolor': BG, 'axes.facecolor': BG,
          'savefig.facecolor': BG, 'text.color': INK,
          'axes.unicode_minus': True, 'pdf.fonttype': 42}
    if use_pgf:
        if font_name('EB Garamond') != 'EB Garamond':
            raise RuntimeError('EB Garamond not installed')
        pre = r'\usepackage{fontspec}\setmainfont{EB Garamond}'
        if with_mono and font_name('Noto Sans Mono') == 'Noto Sans Mono':
            pre += r'\setmonofont{Noto Sans Mono}'
            Style.mono = 'monospace'
        else:
            Style.mono = 'serif'
        rc.update({'font.family': 'serif', 'pgf.texsystem': 'xelatex',
                   'pgf.rcfonts': False, 'pgf.preamble': pre})
        Style.pgf, Style.k = True, 0.42
    else:
        rc.update({'font.family': 'DejaVu Sans'})
        Style.pgf, Style.k, Style.mono = False, 0.58, 'DejaVu Sans Mono'
    plt.rcParams.update(rc)


_TEX = {'\\': r'\textbackslash{}', '&': r'\&', '#': r'\#', '_': r'\_',
        '$': r'\textdollar{}', '{': r'\{', '}': r'\}', '~': r'\textasciitilde{}'}


def smart_quotes(s):
    s = re.sub(r'(^|[\s(\[])"', '\\1\u201c', s)
    return s.replace('"', '\u201d')


def esc(s, markup=False):
    """Escape for the active backend. markup=True turns *x* into italics."""
    s = smart_quotes(str(s))
    if Style.pgf:
        s = ''.join(_TEX.get(c, c) for c in s)
        if markup:
            s = re.sub(r'\*([^*]+)\*', r'\\textit{\1}', s)
    else:
        s = s.replace('$', r'\$')
        if markup:
            s = re.sub(r'\*([^*]+)\*', r'\1', s)
    return s


def wrap(s, width_in, size, mono=False, max_lines=None):
    k = Style.kmono if mono else Style.k
    chars = max(8, int(width_in * 72 / (size * k)))
    lines = textwrap.wrap(' '.join(str(s).split()), chars) or ['']
    if max_lines and len(lines) > max_lines:
        lines = lines[:max_lines]
        lines[-1] = lines[-1][:max(1, chars - 1)].rstrip() + '\u2026'
    return lines


def text(fig, x, y, s, size=14, color=INK, ha='left', va='baseline',
         mono=False, markup=False, **kw):
    """Place text at (x, y) in inches from the bottom-left of the page."""
    size = max(size, MIN_PT)
    if mono:
        kw['family'] = Style.mono
    return fig.text(x / W, y / H, esc(s, markup), fontsize=size, color=color,
                    ha=ha, va=va, **kw)


def new_page(title, subtitle=None):
    fig = plt.figure(figsize=(W, H))
    fig.patch.set_facecolor(BG)
    text(fig, 0.5, H - 0.72, title, size=30, color=HEAD)
    if subtitle:
        text(fig, 0.5, H - 1.12, subtitle, size=16)
    return fig


def footer(fig, sources=(), notes=()):
    """Draw notes, sources and the room line from the bottom up.
    Returns the y (inches) of the rule above the footer."""
    lines = []
    notes = ()  # presentation version: sources only
    srcs = []
    for s in sources:
        s = str(s or '').strip()
        if s and s not in srcs:
            srcs.append(s)
    # "Nature survey (May 2025)" is covered by "Nature survey (May 2025, N=...)"
    srcs = [s for s in srcs if not any(t != s and t.startswith(s.rstrip(')'))
                                       for t in srcs)]
    if srcs:
        label = 'Source: ' if len(srcs) == 1 else 'Sources: '
        lines = wrap(label + '; '.join(srcs) + '.', W - 1.0, 12) + lines
    for n in reversed([n for n in notes if n]):
        lines = wrap(n, W - 1.0, 12) + lines
    if not lines:
        return 0.35
    y = 0.22
    for ln in reversed(lines):
        text(fig, 0.5, y, ln, size=12, color=MUTED, markup=True)
        y += 0.215
    top = y + 0.02
    fig.add_artist(Line2D([0.5 / W, (W - 0.5) / W], [top / H, top / H],
                          color=PUB2, lw=0.8))
    return top


def bar_panel(fig, x, y, w, h, rows, label_w, size=15, panel=False,
              val_w=1.3):
    """Horizontal bars in the box (x, y, w, h), inches.

    rows: dicts with label, value (0-100 or None), color, valtext,
    optional note (second, smaller label line), header=True for a heading
    row without a bar. Rows are packed from the top."""
    if panel:
        fig.add_artist(Rectangle((x / W, y / H), w / W, h / H,
                                 transform=fig.transFigure, color=PANEL,
                                 zorder=0, lw=0))
        x, y, w, h = x + 0.18, y + 0.12, w - 0.3, h - 0.24
    bar_w = max(0.5, w - label_w - val_w)
    ax_w = bar_w + val_w
    avail = h * 72

    def layout(sz):
        lh = sz * 1.18
        out = []
        for r in rows:
            lab = wrap(r.get('label', ''), label_w - 0.15, sz)
            note = wrap(r['note'], label_w - 0.15, MIN_PT) if r.get('note') else []
            text_h = len(lab) * lh + len(note) * MIN_PT * 1.18
            need = text_h + (sz * 0.35 if r.get('header') else sz * 0.5)
            if not r.get('header'):
                need = max(need, sz * 1.9)
            out.append((lab, note, need))
        return out, sum(n for _, _, n in out)

    sz = size
    lay, total = layout(sz)
    while total > avail and sz > MIN_PT:
        sz -= 1
        lay, total = layout(sz)
    # Up to ~12% compression is invisible; beyond that, drop note lines.
    if total > avail * 1.12 and any(r.get('note') for r in rows):
        # Still too tall at the minimum size: drop the secondary note lines.
        rows = [{**r, 'note': ''} for r in rows]
        lay, total = layout(sz)
    stretch = min(avail / total, 1.6) if total else 1.0
    ax = fig.add_axes([(x + label_w) / W, y / H, ax_w / W, h / H])
    ax.set_xlim(0, 100 * ax_w / bar_w)
    ax.set_ylim(avail, 0)
    ax.axis('off')
    ax.patch.set_alpha(0)
    tr = transforms.blended_transform_factory(ax.transAxes, ax.transData)
    lab_x = -0.12 / ax_w
    head_x = -label_w / ax_w
    off = 100 * ax_w / bar_w * 0.012
    top = 0.0
    for r, (lab, note, need) in zip(rows, lay):
        rh = need * stretch
        mid = top + rh / 2
        if r.get('header'):
            ax.text(head_x, top + rh - sz * 0.3, esc('\n'.join(lab)),
                    transform=tr, ha='left', va='baseline', fontsize=sz,
                    color=HEAD, linespacing=1.1)
        else:
            lab_txt = esc('\n'.join(lab))
            if note:
                ax.text(lab_x, mid, lab_txt, transform=tr, ha='right',
                        va='bottom', fontsize=sz, color=INK, linespacing=1.1)
                ax.text(lab_x, mid + 2, esc('\n'.join(note)), transform=tr,
                        ha='right', va='top', fontsize=MIN_PT, color=MUTED,
                        linespacing=1.1)
            else:
                ax.text(lab_x, mid, lab_txt, transform=tr, ha='right',
                        va='center', fontsize=sz, color=INK, linespacing=1.1)
            v = r.get('value')
            thick = min(rh * 0.62, sz * 1.7)
            if v is not None:
                v = max(0.0, min(100.0, v))
                ax.barh(mid, v, height=thick, color=r.get('color', PUB),
                        lw=0)
            ax.text((v or 0) + off, mid, esc(r.get('valtext', fpct(v))),
                    ha='left', va='center', fontsize=sz,
                    family=Style.mono,
                    color=r.get('valcolor', INK) if v is not None else MUTED)
        top += rh
    return ax


def subtle(fig, x, y, s, **kw):
    return text(fig, x, y, s, size=12, color=MUTED, **kw)


# ---------------------------------------------------------------- pages ----

def fmt_time(s):
    if not s:
        return ''
    try:
        t = dt.datetime.fromisoformat(str(s).replace('Z', '+00:00'))
        if t.tzinfo is None:
            t = t.replace(tzinfo=dt.timezone.utc)
        out = t.astimezone(dt.timezone.utc).strftime('%-d %b %Y, %H:%M UTC')
        try:
            from zoneinfo import ZoneInfo
            out += t.astimezone(ZoneInfo('Europe/Amsterdam')).strftime(
                ' (%H:%M in Leiden)')
        except Exception:
            pass
        return out
    except Exception:
        return str(s)


def room_rows(t, labels=None):
    """Room-only distribution rows for a tally."""
    rows = []
    na = NOT_APPLICABLE.get(t.get('tag'), ())
    for o in OPTIONS_OF(t):
        c = t['counts'][o]
        if o in na:   # shown as a count only, outside the percentages
            rows.append({'label': (labels or {}).get(o, o), 'value': None,
                         'color': ROOM_BAR, 'valtext': f'{c} (not in %)'})
            continue
        v = pct(c, t['base'])
        rows.append({'label': (labels or {}).get(o, o), 'value': v,
                     'color': ROOM_BAR, 'valtext': room_text(v, c)})
    if t['unmatched']:
        v = pct(t['unmatched'], t['base'])
        rows.append({'label': UNMATCHED, 'value': v, 'color': ROOM_BAR,
                     'valtext': room_text(v, t['unmatched'])})
    return rows


def OPTIONS_OF(t):
    return list(t['counts'].keys())


def answered_note(t):
    if not t['answered'] and not t['blank']:
        return 'no room data yet'
    return f"n = {t['answered'] - (t.get('na') or 0)}"


def page_title(meta, T):
    rows = meta['rows']
    n = len(rows)
    fig = new_page('Your answers')
    y = H - 1.25
    if n:
        text(fig, 0.5, y, f"{n} response{'s' if n != 1 else ''}", size=22,
             color=ROOM)
    else:
        text(fig, 0.5, y, 'No room data yet' + (
            f" ({meta['problem']})" if meta.get('problem') else ''),
            size=22, color=ROOM)
    bits = []
    if meta.get('exported_utc'):
        bits.append('exported ' + fmt_time(meta['exported_utc']))
    if meta.get('since'):
        bits.append('answers since ' + fmt_time(meta['since']))
    ex = meta.get('excluded') or {}
    exn = [(ex.get(k), lab) for k, lab in (('preview', 'previews'),
           ('before_cutoff', 'before the cutoff'), ('unfinished', 'unfinished'))]
    exn = [f'{v} {lab}' for v, lab in exn if isinstance(v, int) and v > 0]
    if exn:
        bits.append('not counted: ' + ', '.join(exn))
    bits = []  # presentation version: no export metadata
    if bits:
        line = ' \u00b7 '.join(bits)
        line = line[0].upper() + line[1:]
        for i, ln in enumerate(wrap(line, W - 1.0, 14, max_lines=2)):
            text(fig, 0.5, y - 0.4 - i * 0.27, ln, size=14)
    if 0 < n < 10:
        text(fig, W - 0.5, y, 'Small room; read as anecdote.', size=18,
             color=ROOM, ha='right')
    top = footer(fig)
    ptop = H - 2.35
    for (tag, head), x0 in ((('role', 'Your current role'), 0.5),
                            (('field', 'Your field'), 7.0)):
        t = T[tag]
        text(fig, x0, ptop, head, size=20, color=HEAD)
        subtle(fig, x0, ptop - 0.3, answered_note(t))
        bar_panel(fig, x0, top + 0.2, 5.9, ptop - 0.5 - top - 0.25,
                  room_rows(t), label_w=2.9 if tag == 'role' else 2.2,
                  size=16)
    return fig


def page_use(meta, T):
    """General AI use, for everyone in the room (no published comparison)."""
    fig = new_page('How you use AI')
    top = footer(fig)
    ptop = H - 1.6
    cols = (('use_general', 'How often, in daily work or study', 0.5, 1.6),
            ('use_for', 'Mostly used for', 4.62, 2.25),
            ('agent', 'Used an AI agent (works in steps on your files)',
             8.95, 1.75))
    for tag, head, x0, label_w in cols:
        t = T[tag]
        for j, ln in enumerate(wrap(head, 3.9, 18, max_lines=2)):
            text(fig, x0, ptop - j * 0.3, ln, size=18, color=HEAD)
        hl = min(2, len(wrap(head, 3.9, 18)))
        sub_y = ptop - (hl - 1) * 0.3 - 0.32
        subtle(fig, x0, sub_y, answered_note(t))
        bar_panel(fig, x0, top + 0.2, 4.0, sub_y - 0.2 - top - 0.2,
                  room_rows(t), label_w=label_w, size=15, val_w=1.15)
    return fig


def page_freq(meta, T, P):
    t = T['freq']
    pub = P.get('freq') or {}
    series = [s for s in (pub.get('series') or []) if isinstance(s, dict)]
    fig = new_page('How often do you use AI tools in your research?',
                   'This room beside the OUP survey of researchers, by field'
                   + f" (room {answered_note(t)})")
    notes = [na_note(T, ['freq'])]
    for s in pub.get('footnote_series') or []:
        vals = s.get('values') or {}
        notes.append(f"{s.get('label', '')} researchers (OUP): " + ', '.join(
            f"{o} {fpct(num(vals.get(o)))}" for o in OPTIONS['freq']
            if o not in NOT_APPLICABLE['freq']) + '.')
    top = footer(fig, [pub.get('source', '')], notes)
    grid_top = H - 1.45
    cell_h = (grid_top - top - 0.15) / 2
    shown = [o for o in OPTIONS['freq'] if o not in NOT_APPLICABLE['freq']]
    for i, o in enumerate(shown):
        col, row = i % 2, i // 2
        x0 = 0.5 + col * 6.3
        y0 = grid_top - (row + 1) * cell_h
        c = t['counts'][o]
        v = pct(c, t['base'])
        rows = [{'label': o, 'header': True},
                {'label': 'This room', 'value': v, 'color': ROOM_BAR,
                 'valtext': room_text(v, c)}]
        for s in series:
            pv = num((s.get('values') or {}).get(o))
            bar, val = series_color(s.get('label', ''))
            rows.append({'label': s.get('label', ''), 'value': pv,
                         'color': bar, 'valcolor': val, 'valtext': fpct(pv)})
        bar_panel(fig, x0, y0 + 0.1, 6.0, cell_h - 0.15, rows, label_w=2.3,
                  size=17)
    return fig


def comparison_rows(room_label, room_v, room_c, room_n, pub, secondary=None):
    rows = [{'label': room_label, 'value': room_v, 'color': ROOM_BAR,
             'valtext': room_text(room_v, room_c),
             'note': f'n = {room_n}' if room_n else 'no room data yet'}]
    pending = False
    for s in (pub.get('series') or []):
        if not isinstance(s, dict):
            continue
        p = is_pending(s)
        pending |= p
        v = num(s.get('value'))
        bar, val = series_color(s.get('label', ''))
        rows.append({'label': s.get('label', '') + (' \u2020' if p else ''),
                     'value': v, 'color': bar, 'valcolor': val,
                     'valtext': fpct(v), 'note': ''})
    for s in ():  # presentation version: secondary series left out
        if not isinstance(s, dict):
            continue
        v = num(s.get('value'))
        rows.append({'label': s.get('label', ''), 'value': v, 'color': PUB2,
                     'valcolor': SER_OTHER_VAL, 'valtext': fpct(v),
                     'note': s.get('note', '')})
    return rows, pending


def two_row_page(title, specs, T, P):
    """specs: list of (tag, heading, labels, room_label, stat_fn)."""
    fig = new_page(title)
    sources, pending = [], False
    for tag, *_ in specs:
        pub = P.get(tag) or {}
        sources.append(pub.get('source', ''))
        pass  # presentation version: secondary sources left out
        pending |= any(is_pending(s) for s in pub.get('series') or []
                       if isinstance(s, dict))
    notes = [na_note(T, [tag for tag, *_ in specs])]
    top = footer(fig, sources, notes + ([PENDING_NOTE] if pending else []))
    area_top = H - 1.0
    row_h = (area_top - top - 0.1) / len(specs)
    for i, (tag, heading, labels, room_label, stat_fn) in enumerate(specs):
        t = T[tag]
        pub = P.get(tag) or {}
        y_top = area_top - i * row_h
        for j, ln in enumerate(wrap(heading, W - 1.0, 18, max_lines=2)):
            text(fig, 0.5, y_top - 0.32 - j * 0.3, ln, size=18, color=HEAD)
        hl = min(2, len(wrap(heading, W - 1.0, 18)))
        body_top = y_top - 0.32 - (hl - 1) * 0.3 - 0.2
        subtle(fig, 0.5, body_top - 0.12, 'This room, ' + answered_note(t))
        ph = body_top - 0.3 - (y_top - row_h) - 0.05
        bar_panel(fig, 0.5, y_top - row_h + 0.05, 6.1, ph, room_rows(
            t, labels), label_w=3.6, size=15)
        v, c, n = stat_fn(t)
        stat = pub.get('statistic', '')
        subtle(fig, 6.95, body_top - 0.12, stat, markup=True)
        rows, _ = comparison_rows('This room', v, c, n, pub,
                                  pub.get('secondary'))
        bar_panel(fig, 6.85, y_top - row_h + 0.05, 6.0, ph, rows,
                  label_w=3.3, size=15, panel=True)
    return fig


def stat_sum(opts, exclude=()):
    def f(t):
        den = t['answered'] - sum(t['counts'][o] for o in exclude)
        c = sum(t['counts'][o] for o in opts)
        return pct(c, den), c, den
    return f


REPORT_GROUPS = ('all respondents', 'humanities', 'social sciences', 'netherlands')


def page_writing(meta, T, P):
    E, D = OPTIONS['edit'], OPTIONS['draft']
    P = dict(P)
    for tag in ('edit', 'draft'):
        pub = dict(P.get(tag) or {})
        pub['series'] = [s for s in (pub.get('series') or []) if isinstance(s, dict)
                         and s.get('label', '').lower().split(' (')[0] in REPORT_GROUPS]
        P[tag] = pub
    return two_row_page('Writing with AI: what you do, what you accept', [
        ('edit', 'Have you written a draft of a research article, then used '
                 'generative AI to help edit it?', None, 'This room',
         stat_sum(E[:2], exclude=NOT_APPLICABLE['edit'])),
        ('draft', 'Dr. Bloggs has AI write a first draft from outline points, '
                  "edits it, and doesn't disclose it. Your view?", None,
         'This room', stat_sum(D[3:])),
    ], T, P)


def page_talk(meta, T, P):
    C, Wo = OPTIONS['discussed'], OPTIONS['worry']
    return two_row_page('Talking about it, and worrying about it', [
        ('discussed', 'Have you openly discussed generative AI with your '
                      'supervisor(s), or with those you supervise?', None,
         'This room', stat_sum(C[:2], exclude=NOT_APPLICABLE['discussed'])),
        ('worry', '"I am worried that AI will weaken thinking, research, and '
                  'writing skills."', None, 'This room', stat_sum(Wo[3:])),
    ], T, P)


def page_future(meta, T, P):
    F = OPTIONS['future']
    return two_row_page('What AI is', [
        ('future', 'Just the latest technology, or something different that '
                   'threatens us?', {F[0]: 'Just the latest technology',
                                     F[1]: 'Different, and a threat'},
         'This room', stat_sum(F[:1])),
    ], T, P)


OPEN_SIZES = (15, 14, 13, 12)


def fit_answers(items, col_w, height_in, size):
    """For one font size, choose 1 or 2 sub-columns showing more answers."""
    best = None
    if True:
        for sub in (1, 2):
            gap = 0.3
            sw = (col_w - gap * (sub - 1)) / sub
            lh = size * 1.2 / 72
            cap = int(height_in / lh)
            cols, cur, used, shown = [[]], 0, 0, 0
            for it in items:
                if shown >= MAX_PER_COLUMN:
                    break
                lines = wrap(it, sw - 0.25, size, max_lines=4)
                need = len(lines) + (0.35 if cols[cur] else 0)
                if used + need > cap:
                    if cur + 1 >= sub:
                        break
                    cols.append([])
                    cur, used = cur + 1, 0
                    need = len(lines)
                    if need > cap:
                        break
                cols[cur].append(lines)
                used += need
                shown += 1
            score = (shown, -sub)
            if best is None or score > best[0]:
                best = (score, size, sub, sw, cols)
    return best


def open_lists(rows):
    """Answers per question, identical answers merged with a count, most common first."""
    out = {}
    for tag in TEXT_TAGS:
        seen = {}
        for r in rows:
            a = ' '.join(r.get(tag, '').split())
            if a:
                k = a.lower().rstrip('.')
                if k not in seen:
                    seen[k] = [a, 0]
                seen[k][1] += 1
        out[tag] = [a if c == 1 else f'{a} (\u00d7{c})'
                    for a, c in sorted(seen.values(), key=lambda x: -x[1])]
    return out


def page_open(meta, T, out_dir, tags=('never', 'automate'),
              title='In your words'):
    rows = meta['rows']
    fig = new_page(title)
    top = footer(fig)
    lists = open_lists(rows)
    overflow = False
    col_w, y_top, y_bot = 5.9, H - 1.85, top + 0.45
    # One font size for both columns: the largest that shows the most answers.
    best_size, best_total = OPEN_SIZES[-1], -1
    for size in OPEN_SIZES:
        total = sum(fit_answers(lists[t], col_w, y_top - y_bot, size)[0][0]
                    for t in tags if lists[t])
        if total > best_total:
            best_size, best_total = size, total
    for (tag, x0) in zip(tags, (0.5, 6.95)):
        items = lists[tag]
        head, q, _ = TEXT_HEADS[tag]
        text(fig, x0, H - 1.25, head, size=22, color=HEAD)
        subtle(fig, x0, H - 1.55, q + f"  ({len(items)} answer"
               f"{'s' if len(items) != 1 else ''})")
        if not items:
            text(fig, x0, y_top - 0.3, 'No room data yet' if not rows else
                 'No answers', size=16, color=MUTED)
            continue
        _, size, sub, sw, cols = fit_answers(items, col_w, y_top - y_bot,
                                            best_size)
        lh = size * 1.2 / 72
        shown = 0
        for ci, col in enumerate(cols):
            y = y_top - size / 72
            cx = x0 + ci * (sw + 0.3)
            for lines in col:
                for li, ln in enumerate(lines):
                    if li == 0:
                        text(fig, cx, y, '\u2013', size=size, color=ROOM)
                    text(fig, cx + 0.22, y, ln, size=size)
                    y -= lh
                y -= lh * 0.35
                shown += 1
        if shown < len(items):
            overflow = True
            text(fig, x0, top + 0.18, f"+ {len(items) - shown} more in "
                 "open-text.md", size=13, color=ROOM)
    if any(lists.values()):
        write_open_text(meta, lists, out_dir / 'open-text.md')
    return fig, overflow


def write_open_text(meta, lists, path):
    out = ['# Open answers', '',
           f"Exported {fmt_time(meta.get('exported_utc'))}; "
           f"{len(meta['rows'])} responses.", '']
    for tag in TEXT_TAGS:
        head, _, q = TEXT_HEADS[tag]
        out += [f'## {head} ({len(lists[tag])})', '', f'*{q}*', '']
        out += [f'- {a}' for a in lists[tag]] + ['']
    try:
        path.write_text('\n'.join(out), encoding='utf-8')
    except OSError as e:
        warn(f'cannot write {path}: {e}')


def error_page(name, err):
    fig = new_page(f'{name}: could not be drawn')
    for i, ln in enumerate(wrap(str(err), W - 1.0, 14, max_lines=6)):
        text(fig, 0.5, H - 1.8 - i * 0.3, ln, size=14)
    footer(fig)
    return fig


# ----------------------------------------------------------------- main ----

def render(meta, P, out, use_pgf, with_mono=True):
    setup(use_pgf, with_mono)
    if use_pgf:
        from matplotlib.backends.backend_pgf import PdfPages
    else:
        from matplotlib.backends.backend_pdf import PdfPages
    T = {tag: tally(meta['rows'], tag) for tag in OPTIONS} if True else {}
    out_dir = out.resolve().parent
    builders = [('Your answers', lambda: page_title(meta, T)),
                ('How you use AI', lambda: page_use(meta, T)),
                ('Frequency', lambda: page_freq(meta, T, P)),
                ('Writing', lambda: page_writing(meta, T, P)),
                ('Talk and worry', lambda: page_talk(meta, T, P)),
                ('What AI is', lambda: page_future(meta, T, P)),
                ('Open answers', lambda: page_open(meta, T, out_dir)[0]),
                ('What you want', lambda: page_open(
                    meta, T, out_dir, ('want_self', 'want_supervision'),
                    'What you want from AI')[0])]
    fd, tmp = tempfile.mkstemp(suffix='.pdf', dir=out_dir)
    os.close(fd)
    try:
        with PdfPages(tmp) as pdf:
            for name, build in builders:
                try:
                    fig = build()
                except Exception as e:
                    traceback.print_exc()
                    warn(f'page "{name}" failed; an error page stands in')
                    plt.close('all')
                    fig = error_page(name, e)
                pdf.savefig(fig, facecolor=BG)
                plt.close(fig)
        os.replace(tmp, out)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)
    return len(builders)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('--input', default=str(HERE / 'responses.json'))
    ap.add_argument('--published', default=str(HERE / 'published.yaml'))
    ap.add_argument('--out', default=str(HERE / 'results.pdf'))
    a = ap.parse_args(argv)
    meta = load_responses(a.input)
    P = load_published(a.published)
    out = Path(a.out)
    attempts = [('pgf/xelatex, EB Garamond + Noto Sans Mono', True, True),
                ('pgf/xelatex, EB Garamond', True, False),
                ('default PDF backend, DejaVu Sans', False, False)]
    for label, use_pgf, mono in attempts:
        try:
            pages = render(meta, P, out, use_pgf, mono)
        except Exception as e:
            plt.close('all')
            lines = str(e).strip().splitlines()
            why = [ln for ln in lines if ln.startswith('!')] or lines[:1]
            warn(f"{label} failed: {why[0] if why else type(e).__name__}")
            continue
        print(f"Wrote {out} ({pages} pages, n={len(meta['rows'])}, "
              f"{label})")
        return 0
    warn('all backends failed; no PDF written')
    return 1


if __name__ == '__main__':
    sys.exit(main())
