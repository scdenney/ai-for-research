from pathlib import Path
import fitz,json,hashlib
from PIL import Image,ImageDraw
import argparse,tempfile
parser=argparse.ArgumentParser()
parser.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
parser.add_argument('--out',type=Path)
args=parser.parse_args()
root=args.root.resolve()
pdf=root/'overleaf/main.pdf';out=args.out or Path(tempfile.mkdtemp(prefix='korea-review-'));out.mkdir(parents=True,exist_ok=True)
doc=fitz.open(pdf);bounds=[];diagonals=[];titles=[];numbers=[];overlaps=[];fill_crossings=[]
for i,page in enumerate(doc):
 pix=page.get_pixmap(matrix=fitz.Matrix(1280/page.rect.width,1280/page.rect.width),alpha=False);pix.save(out/f'page-{i+1:02}.png')
 lines=[(fitz.Rect(l['bbox']), ''.join(s['text'] for s in l['spans'])) for b in page.get_text('dict')['blocks'] if 'lines' in b for l in b['lines']]
 if i<27:
  for k,(a,ta) in enumerate(lines):
   for b,tb in lines[k+1:]:
    r=a&b
    if r.width>3 and r.height>3 and r.get_area()>25:overlaps.append({'page':i+1,'a':ta,'b':tb})
  for drawing in page.get_drawings():
   fill=drawing.get('fill')
   if fill and len(fill)==3 and all(abs(v-w)<.015 for v,w in zip(fill,(242/255,237/255,227/255))):
    box=fitz.Rect(drawing['rect'])
    for r,t in lines:
     inter=r&box
     if inter.get_area()>r.get_area()*.3 and not (fitz.Rect(box.x0-1,box.y0-1,box.x1+1,box.y1+1).contains(r)):
      fill_crossings.append({'page':i+1,'text':t})
 text=page.get_text();titles.append(text.splitlines()[0] if text else '')
 for line in page.get_text('dict')['blocks']:
  if 'lines' not in line:continue
  for l in line['lines']:
   for s in l['spans']:
    r=fitz.Rect(s['bbox'])
    if r.x0<0 or r.y0<0 or r.x1>page.rect.width+.2 or r.y1>page.rect.height+.2:bounds.append({'page':i+1,'text':s['text'],'bbox':list(r)})
    if r.x0>page.rect.width*.90 and r.y0>page.rect.height*.88 and s['text'].strip().isdigit():numbers.append(int(s['text'].strip()))
 for d in page.get_drawings():
  for item in d['items']:
   if item[0]=='l':
    a,b=item[1:];dx=abs(a.x-b.x);dy=abs(a.y-b.y)
    if dx>1 and dy>1 and dx+dy>25:diagonals.append({'page':i+1,'a':list(a),'b':list(b)})
for start in range(0,len(doc),8):
 canvas=Image.new('RGB',(1280,1480),'#dddddd');draw=ImageDraw.Draw(canvas)
 for j in range(start,min(start+8,len(doc))):
  im=Image.open(out/f'page-{j+1:02}.png');im.thumbnail((620,349));x=10+(j-start)%2*640;y=20+(j-start)//2*370
  canvas.paste(im,(x,y));draw.text((x,y-17),str(j+1),fill='black')
 canvas.save(out/f'contact-{start+1:02}.png')
for n in [3,4,8,12,13,20,21,23,24,25,26,27]:
 if n<=len(doc):Image.open(out/f'page-{n:02}.png').save(out/f'720p-{n:02}.jpg',quality=55)
result={'pages':len(doc),'titles':titles,'footer_numbers':numbers,'out_of_page_text':bounds,'long_diagonal_segments':diagonals,'text_overlaps':overlaps,'fill_crossings':fill_crossings,'sha256':hashlib.sha256(pdf.read_bytes()).hexdigest()}
(out/'checks.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2))
