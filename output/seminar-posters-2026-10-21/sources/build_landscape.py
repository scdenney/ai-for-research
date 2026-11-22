"""16:9 landscape version of the final poster for the building's display screens."""

from pathlib import Path
import subprocess

from poster_shared import Art, INK, DEEP, ORANGE, PAPER
from build_selected import CREAM, overview

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / 'sources'
OUT = ROOT / 'final_choice'
CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
NAME = 'what-are-we-thinking-landscape'

W, H = 1920, 1080
M = 110
PHOTO = 520
PHOTO_X = W - M - PHOTO
FOOT_Y = 912


def make():
    a = Art(W, H, CREAM)
    # Left column: heading, rule, overview.
    a.text(M, 122, 'PUBLIC SEMINAR', 30, ORANGE, weight=700, tracking=4)
    a.rect(M, 152, 80, 5, ORANGE)
    a.lines(M, 272, ['What Are We', 'Thinking?'], 128, 124, serif=True, weight=600)
    a.text(M, 474, 'AI in Research and Supervision', 54, DEEP, serif=True)
    col = PHOTO_X - 110 - M
    a.line(M, 528, M + col, 528, ORANGE, 6)
    overview(a, M, 600, col, 39, 50)
    # Right column: portrait with speaker and moderator beneath.
    a.photo(PHOTO_X, 110, PHOTO, PHOTO, 0)
    a.text(PHOTO_X, 690, 'SPEAKER', 22, ORANGE, weight=700, tracking=3)
    a.text(PHOTO_X, 744, 'Steven Denney', 54, serif=True, weight=600)
    a.text(PHOTO_X, 800, 'MODERATOR', 22, ORANGE, weight=700, tracking=3)
    a.text(PHOTO_X, 844, 'Aron van de Pol', 40, serif=True)
    # Footer band.
    a.rect(0, FOOT_Y, W, H - FOOT_Y, INK)
    a.text(M, FOOT_Y + 70, '21 October 2026  |  15:00–17:00', 46, PAPER, weight=700)
    a.text(M, FOOT_Y + 128, 'DH Lab, Huizinga 0.09', 38, PAPER)
    return a


if __name__ == '__main__':
    a = make()
    svg = SOURCES / f'{NAME}.svg'
    # Liberation Sans is not installed on macOS; Arial is its metric twin.
    markup = ''.join(a.bits).replace('font-family="Liberation Sans"',
                                     'font-family="Liberation Sans, Arial, sans-serif"')
    svg.write_text(markup + '</svg>')
    doc = SOURCES / f'{NAME}.html'
    doc.write_text('<html><head><meta charset="utf-8"><style>'
                   f'@page{{size:{W}px {H}px;margin:0}}html,body{{margin:0}}'
                   'svg{display:block;width:100vw;height:100vh}</style></head>'
                   f'<body>{svg.read_text()}</body></html>')
    png = OUT / f'{NAME}.png'
    subprocess.run([CHROME, '--headless', '--disable-gpu', '--hide-scrollbars',
                    f'--user-data-dir=/tmp/landscape-seminar', f'--window-size={W},{H}',
                    '--force-device-scale-factor=2', f'--screenshot={png}', f'file://{doc}'],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    pdf = OUT / f'{NAME}.pdf'
    subprocess.run([CHROME, '--headless', '--disable-gpu',
                    f'--user-data-dir=/tmp/landscape-seminar-pdf', '--no-pdf-header-footer',
                    f'--print-to-pdf={pdf}', f'file://{doc}'],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print(f'Wrote {png} and {pdf}')
