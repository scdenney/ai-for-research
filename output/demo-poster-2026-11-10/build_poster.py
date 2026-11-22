"""16:9 announcement for the 10 November demo, in the "What Are We Thinking?" poster layout."""

from base64 import b64encode
from pathlib import Path
import subprocess
import sys
import tempfile

from PIL import ImageFont

OUT = Path(__file__).resolve().parent
sys.path.insert(0, str(OUT.parent / 'seminar-posters-2026-10-21' / 'sources'))
from poster_shared import Art, INK, DEEP, ORANGE, PAPER  # noqa: E402

CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
NAME = 'ai-agents-demo-landscape'
CREAM = '#FFFDF8'
DESCRIPTION = ('What does working ethically and responsibly with AI agents on a research project '
               'look like in practice? This live demonstration goes step by step through organizing '
               'sources and building a project knowledge base that can help you stay organized, '
               'do better research, and work with the machine in a responsible way.')
RSVP_LINK = 'https://fra1.qualtrics.com/jfe/form/SV_bdrv0bvpvcrMeDc'
RSVP_QR = 'data:image/png;base64,' + b64encode((OUT / 'rsvp' / 'rsvp-qr.png').read_bytes()).decode()

W, H = 1920, 1080
M = 110
PHOTO = 520
PHOTO_X = W - M - PHOTO
FOOT_Y = 912


def wrap(text, width, size):
    path = subprocess.check_output(['fc-match', '-f', '%{file}', 'EB Garamond']).decode()
    font = ImageFont.truetype(path, size)
    lines, current = [], ''
    for word in text.split():
        test = (current + ' ' + word).strip()
        if font.getlength(test) > width:
            lines.append(current)
            current = word
        else:
            current = test
    return lines + [current]


def make():
    a = Art(W, H, CREAM)
    # Left column: heading, rule, overview.
    a.text(M, 122, 'OPEN DEMO', 30, ORANGE, weight=700, tracking=4)
    a.rect(M, 152, 80, 5, ORANGE)
    a.lines(M, 272, ['Working with', 'AI Agents'], 128, 124, serif=True, weight=600)
    a.text(M, 474, 'A Live Demo for Research', 54, DEEP, serif=True)
    col = PHOTO_X - 110 - M
    a.line(M, 528, M + col, 528, ORANGE, 6)
    a.lines(M, 600, wrap(DESCRIPTION, col, 39), 39, 50, serif=True)
    # Right column: portrait with presenter and audience beneath.
    a.photo(PHOTO_X, 110, PHOTO, PHOTO, 0)
    a.text(PHOTO_X, 690, 'PRESENTER', 22, ORANGE, weight=700, tracking=3)
    a.text(PHOTO_X, 744, 'Steven Denney', 54, serif=True, weight=600)
    a.text(PHOTO_X, 800, 'OPEN TO', 22, ORANGE, weight=700, tracking=3)
    a.text(PHOTO_X, 844, 'All HBIR seminar groups', 40, serif=True)
    # Footer band.
    a.rect(0, FOOT_Y, W, H - FOOT_Y, INK)
    a.text(M, FOOT_Y + 70, '10 November 2026  |  11:15–12:45', 46, PAPER, weight=700)
    a.text(M, FOOT_Y + 128, 'Herta Mohr 0.24', 38, PAPER)
    # RSVP: QR at the right of the band, clickable in the PDF.
    qr = 144
    qr_x = W - M - qr
    a.text(qr_x - 32, FOOT_Y + 70, 'Coming?', 46, PAPER, weight=700, anchor='end')
    a.text(qr_x - 32, FOOT_Y + 128, 'Scan to let me know', 38, PAPER, anchor='end')
    a.bits.append(f'<a href="{RSVP_LINK}"><image x="{qr_x}" y="{FOOT_Y + 12}" width="{qr}" height="{qr}" '
                  f'href="{RSVP_QR}"/></a>')
    return a


if __name__ == '__main__':
    # Liberation Sans is not installed on macOS; Arial is its metric twin.
    markup = ''.join(make().bits).replace('font-family="Liberation Sans"',
                                          'font-family="Liberation Sans, Arial, sans-serif"') + '</svg>'
    with tempfile.TemporaryDirectory() as tmp:
        doc = Path(tmp) / f'{NAME}.html'
        doc.write_text('<html><head><meta charset="utf-8"><style>'
                       f'@page{{size:{W}px {H}px;margin:0}}html,body{{margin:0}}'
                       'svg{display:block;width:100vw;height:100vh}</style></head>'
                       f'<body>{markup}</body></html>')
        base = [CHROME, '--headless', '--disable-gpu', f'--user-data-dir={tmp}/profile']
        subprocess.run(base + ['--hide-scrollbars', f'--window-size={W},{H}',
                               '--force-device-scale-factor=2', f'--screenshot={OUT / NAME}.png',
                               f'file://{doc}'],
                       check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(base + ['--no-pdf-header-footer', f'--print-to-pdf={OUT / NAME}.pdf',
                               f'file://{doc}'],
                       check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print(f'Wrote {OUT / NAME}.png and .pdf')
