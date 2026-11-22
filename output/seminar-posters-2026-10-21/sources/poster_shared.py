from pathlib import Path
from html import escape
from base64 import b64encode
import subprocess

BASE = Path(__file__).resolve().parent.parent
SOURCE = BASE / 'sources'
PHOTO = 'data:image/png;base64,' + b64encode((SOURCE / 'portrait-original.png').read_bytes()).decode()

INK = '#142B3B'
BLUE = '#A9CEE1'
DEEP = '#255B79'
ORANGE = '#CC653F'
PEACH = '#F5C39A'
PAPER = '#FBF8F0'
WHITE = '#FFFFFF'

QUESTION = 'What should we shamelessly automate, what should we ruthlessly guard from AI, and where should we collaborate with the machine?'
DESCRIPTION = (QUESTION + ' This seminar offers a conceptual framework for thinking about AI in research and supervision, '
               'followed by practical and responsible ways to put AI and its agents to work in both settings.')

class Art:
    def __init__(self, width, height, bg):
        self.w, self.h = width, height
        self.bits = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
                     f'<rect width="{width}" height="{height}" fill="{bg}"/>']
        self.id = 0
    def rect(self,x,y,w,h,fill,r=0):
        self.bits.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}"/>')
    def line(self,x1,y1,x2,y2,color=INK,sw=2):
        self.bits.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="{sw}"/>')
    def circle(self,x,y,r,fill):
        self.bits.append(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}"/>')
    def text(self,x,y,s,size,color=INK,serif=False,weight=400,anchor='start',tracking=0,italic=False):
        family='EB Garamond' if serif else 'Liberation Sans'
        style='italic' if italic else 'normal'
        self.bits.append(f'<text x="{x}" y="{y}" font-family="{family}" font-size="{size}" font-weight="{weight}" font-style="{style}" fill="{color}" text-anchor="{anchor}" letter-spacing="{tracking}">{escape(s)}</text>')
    def lines(self,x,y,seq,size,lead=None,**kw):
        for i,s in enumerate(seq): self.text(x,y+i*(lead or size*1.08),s,size,**kw)
    def photo(self,x,y,w,h=None,r=0):
        h=h or w; self.id+=1; ident=f'clip{self.id}'
        self.bits.append(f'<defs><clipPath id="{ident}"><rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}"/></clipPath></defs>')
        # Center crop, keeping the source photograph intact.
        side=max(w,h)
        self.bits.append(f'<image x="{x+(w-side)/2}" y="{y+(h-side)/2}" width="{side}" height="{side}" href="{PHOTO}" clip-path="url(#{ident})"/>')
    def save(self,name,kind):
        p=SOURCE/f'{name}-{kind}.svg'; p.write_text(''.join(self.bits)+'</svg>')
        return p
