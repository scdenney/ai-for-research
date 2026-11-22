"""Four close refinements of the chosen borderless ivory poster."""

from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess
from PIL import ImageFont

from poster_shared import Art, DESCRIPTION, INK, DEEP, ORANGE, PAPER

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / 'sources'
CREAM = '#FFFDF8'
SOFT_PEACH = '#F8E8D9'
SOFT_BLUE = '#E6F0F2'
BODY_FONT = subprocess.check_output(['fc-match', '-f', '%{file}', 'EB Garamond']).decode()


def photo_full(a, x, y, size):
    # The source photograph is square. Use all of it so the hair stays visible.
    a.photo(x, y, size, size, 0)


def overview(a, x, y, width, size, lead, color=INK):
    font = ImageFont.truetype(BODY_FONT, size)
    lines = []
    current = ''
    for word in DESCRIPTION.split():
        test = (current + ' ' + word).strip()
        if font.getlength(test) > width:
            lines.append(current)
            current = word
        else:
            current = test
    lines.append(current)
    a.lines(x, y, lines, size, lead, color=color, serif=True)
    return y + (len(lines)-1)*lead


def heading(a, m, print_format, variant):
    a.text(m, 102 if not print_format else 117, 'PUBLIC SEMINAR',
           29 if not print_format else 33, ORANGE, weight=700, tracking=4)
    if variant in (1, 4):
        a.rect(m, 139 if not print_format else 158, 86, 5, ORANGE)
    a.lines(m, 252 if not print_format else 301,
            ['What Are We', 'Thinking?'],
            108 if not print_format else 138,
            112 if not print_format else 137,
            serif=True, weight=600)
    a.text(m, 455 if not print_format else 540,
           'AI in Research and Supervision',
           45 if not print_format else 57, DEEP, serif=True)


def footer(a, y, m, print_format, variant):
    fill = INK if variant == 4 else DEEP
    a.rect(0, y, a.w, a.h-y, fill)
    a.text(m, y+(67 if not print_format else 78),
           '21 October 2026  |  15:00–17:00',
           38 if not print_format else 50, PAPER, weight=700)
    a.text(m, y+(125 if not print_format else 151),
           'DH Lab, Huizinga 0.09',
           32 if not print_format else 43, PAPER)


def make(variant, print_format):
    w,h=(1400,1980) if print_format else (1200,1500)
    a=Art(w,h,CREAM)
    m=98 if print_format else 76
    heading(a,m,print_format,variant)

    if variant == 3:
        if print_format:
            a.line(m,657,w-m,657,ORANGE,6)
            overview(a,m,765,w-2*m,55,69)
            photo_full(a,m,1184,500)
            a.text(665,1330,'SPEAKER',26,ORANGE,weight=700,tracking=3)
            a.text(665,1405,'Steven Denney',64,serif=True,weight=600)
            a.text(665,1480,'MODERATOR',26,ORANGE,weight=700,tracking=3)
            a.text(665,1535,'Aron van de Pol',44,serif=True)
            footer(a,1760,m,True,variant)
        else:
            a.line(m,531,w-m,531,ORANGE,6)
            overview(a,m,615,w-2*m,48,58)
            photo_full(a,m,972,345)
            a.text(472,1061,'SPEAKER',21,ORANGE,weight=700,tracking=3)
            a.text(472,1117,'Steven Denney',55,serif=True,weight=600)
            a.text(472,1179,'MODERATOR',21,ORANGE,weight=700,tracking=3)
            a.text(472,1223,'Aron van de Pol',38,serif=True)
            footer(a,1338,m,False,variant)
        return a

    if print_format:
        photo_y=610
        photo_size=510 if variant in (2,4) else 490
        photo_x=m if variant in (2,4) else w-m-photo_size
        name_x=photo_x+photo_size+65 if variant in (2,4) else m
        photo_full(a,photo_x,photo_y,photo_size)
        a.text(name_x,748,'SPEAKER',26,ORANGE,weight=700,tracking=3)
        a.text(name_x,816,'Steven Denney',62,serif=True,weight=600)
        a.text(name_x,876,'MODERATOR',26,ORANGE,weight=700,tracking=3)
        a.text(name_x,925,'Aron van de Pol',42,serif=True)
        overview_y=1260
        if variant==2:
            a.rect(m,1170,w-2*m,435,SOFT_PEACH)
            a.rect(m,1170,w-2*m,6,ORANGE)
            overview(a,m+46,overview_y,w-2*m-92,48,63)
        elif variant==3:
            a.rect(m,1162,8,455,ORANGE)
            overview(a,m+49,overview_y,w-2*m-100,48,63)
        elif variant==4:
            a.line(m,1168,w-m,1168,ORANGE,6)
            overview(a,m,overview_y,w-2*m,48,63)
        else:
            a.line(m,1168,w-m,1168,ORANGE,6)
            overview(a,m,overview_y,w-2*m,48,63)
        footer(a,1760,m,True,variant)
    else:
        photo_y=505
        photo_size=450 if variant in (2,4) else 430
        photo_x=m if variant in (2,4) else w-m-photo_size
        name_x=photo_x+photo_size+53 if variant in (2,4) else m
        photo_full(a,photo_x,photo_y,photo_size)
        a.text(name_x,624,'SPEAKER',21,ORANGE,weight=700,tracking=3)
        a.text(name_x,681,'Steven Denney',55,serif=True,weight=600)
        a.text(name_x,736,'MODERATOR',21,ORANGE,weight=700,tracking=3)
        a.text(name_x,779,'Aron van de Pol',38,serif=True)
        overview_y=1044
        if variant==2:
            a.rect(m,977,w-2*m,342,SOFT_PEACH)
            a.rect(m,977,w-2*m,5,ORANGE)
            overview(a,m+32,overview_y,w-2*m-64,42,50)
        elif variant==3:
            a.rect(m,971,7,350,ORANGE)
            overview(a,m+37,overview_y,w-2*m-74,42,50)
        elif variant==4:
            a.line(m,981,w-m,981,ORANGE,6)
            overview(a,m,overview_y,w-2*m,42,50)
        else:
            a.line(m,981,w-m,981,ORANGE,6)
            overview(a,m,overview_y,w-2*m,42,50)
        footer(a,1338,m,False,variant)
    return a


NAMES={1:'01-ivory-original-refined',2:'02-warm-reading-panel',
       3:'03-overview-first',4:'04-quiet-ivory'}


def render(item):
    variant,kind=item
    name=NAMES[variant]
    a=make(variant,kind=='print')
    svg=SOURCES/f'{name}-{kind}.svg'
    svg.write_text(''.join(a.bits)+'</svg>')
    doc=SOURCES/f'{name}-{kind}.html'
    page='A3' if kind=='print' else '12in 15in'
    doc.write_text(f'<html><head><meta charset="utf-8"><style>@page{{size:{page};margin:0}}html,body{{margin:0}}svg{{display:block;width:100vw;height:100vh}}</style></head><body>{svg.read_text()}</body></html>')
    pdf=ROOT/f'{name}-{kind}.pdf'
    subprocess.run(['chromium','--headless','--no-sandbox','--disable-gpu',
                    f'--user-data-dir=/tmp/selected-seminar-{variant}-{kind}',
                    '--no-pdf-header-footer',f'--print-to-pdf={pdf}',f'file://{doc}'],
                   check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
    if kind=='social':
        subprocess.run(['pdftoppm','-r','192','-png','-singlefile',str(pdf),str(ROOT/f'{name}-social')],
                       check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
        pdf.unlink()


if __name__=='__main__':
    with ThreadPoolExecutor(max_workers=4) as pool:
        list(pool.map(render,[(i,k) for i in range(1,5) for k in ['social','print']]))
    print('Rendered four refinements of the selected poster.')
