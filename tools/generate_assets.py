#!/usr/bin/env python3
"""Reproducible 1-bit BMFonts. Original numeral paths; licensed text subsets."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import json, math
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'resources/fonts'; OUT.mkdir(parents=True,exist_ok=True)
# Original 50 x 78 chamfered industrial numerals. Each path is a filled contour.
# Negative contours are counters, not distress; retained as editable JSON.
paths=json.loads((ROOT/'assets-src/numerals.json').read_text())
FONTS={}
def savefont(name,glyphs,height):
    width=sum(im.width+2 for im,advance in glyphs.values()); atlas=Image.new('RGBA',(width,height),(0,0,0,0))
    lines=[f'info face="Tokyo {name}" size={height} bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=0 aa=1 padding=0,0,0,0 spacing=0,0',f'common lineHeight={height} base={height} scaleW={width} scaleH={height} pages=1 packed=0',f'page id=0 file="{name}.png"',f'chars count={len(glyphs)}']
    x=0
    for ch,(im,advance) in glyphs.items():
        white=Image.new('RGBA',im.size,'white'); white.putalpha(im); atlas.paste(white,(x,0))
        lines.append(f'char id={ord(ch)} x={x} y=0 width={im.width} height={height} xoffset=0 yoffset=0 xadvance={advance} page=0 chnl=15');x+=im.width+2
    atlas.save(OUT/f'{name}.png'); (OUT/f'{name}.fnt').write_text('\n'.join(lines)+'\n');FONTS[name]=glyphs

def digits(name,w,h):
    glyphs={}
    for ch,contours in paths.items():
        im=Image.new('L',(w,h)); d=ImageDraw.Draw(im)
        for i,p in enumerate(contours):d.polygon([(round(x*(w-1)/49),round(y*(h-1)/77)) for x,y in p],fill=255 if i==0 else 0)
        glyphs[ch]=(im,w+6)
    glyphs[' ']=(Image.new('L',(w,h)),w+6)
    savefont(name,glyphs,h)

def textfont(name,size,bold=False,chars=None,path=None):
    font=ImageFont.truetype(str(path or ROOT/('assets-src/DejaVuSansCondensed-Bold.ttf' if bold else 'assets-src/DejaVuSansCondensed.ttf')),size)
    chars=chars or ''.join(chr(i) for i in range(32,127))+'°'
    boxes=[font.getbbox(c) for c in chars if c!=' ']; top=min(b[1] for b in boxes); bottom=max(b[3] for b in boxes);h=bottom-top
    glyphs={}
    for c in chars:
        advance=math.ceil(font.getlength(c)); im=Image.new('L',(max(1,advance),h));ImageDraw.Draw(im).text((0,-top),c,font=font,fill=255)
        im=im.point(lambda p:255 if p>=100 else 0);glyphs[c]=(im,advance)
    savefont(name,glyphs,h)

def drawtext(im,xy,name,text,color,center=False):
    glyphs=FONTS[name];w=sum(glyphs.get(c,glyphs.get('?'))[1] for c in text);x,y=xy
    if center:x-=w//2
    for c in text:
        mask,a=glyphs.get(c,glyphs.get('?'));im.paste(color,(int(x),int(y)),mask);x+=a

def preview(readable=False,palette='#ff0000',digits_text='0827',mask_circle=True):
    im=Image.new('RGB',(280,280));d=ImageDraw.Draw(im);white='#ffffff';gray='#aaaaaa'
    drawtext(im,(144,22),'label','ASTROBYTE',white,True);drawtext(im,(144,37),'micro','INDUSTRIES',gray,True)
    d.line((79,51,220,51),fill=palette);d.line((80,58,80,214),fill='#555555')
    drawtext(im,(36,69),'tokyo','東',palette);drawtext(im,(36,113),'tokyo','京',palette)
    drawtext(im,(55,166),'data','2088',gray,True)
    drawtext(im,(91,59),'hero',digits_text[:2],white);drawtext(im,(91,140),'hero',digits_text[2:],white)
    drawtext(im,(224,71),'label','FRI',gray,True);drawtext(im,(224,92),'date','11',white,True);drawtext(im,(224,120),'label','SEP',gray,True)
    for j in range(10):d.polygon([(241,148+j*5),(250,140+j*5),(250,143+j*5),(241,151+j*5)],fill=palette if j>=3 else '#555555')
    d.line((43,222,237,222),fill='#555555')
    for x,label,value in [(65,'BAT','74%'),(114,'BPM','68'),(166,'STEP','6.4K'),(214,'OUT','11°')]:
        drawtext(im,(x,228),'label' if not readable else 'data',value,white,True)
        drawtext(im,(x,245),'micro',label,gray,True)
    drawtext(im,(140,260),'micro','TERMINAL // AC-01',palette,True)
    if not mask_circle:return im
    mask=Image.new('L',im.size);ImageDraw.Draw(mask).ellipse((0,0,279,279),fill=255); im.paste((0,0,0),(0,0),Image.eval(mask,lambda p:255-p))
    return im

def main():
    digits('hero',50,78)
    for name,size,bold in [('micro',9,False),('label',13,True),('data',16,True),('date',22,False),('plateSmall',11,True)]:textfont(name,size,bold)
    textfont('tokyo',40,True,'東京',ROOT/'assets-src/TokyoGlyphs.otf')
    for name,color in [('classic-red','#ff0000'),('neon-cyan','#00ffff'),('monochrome','#ffffff'),('amber','#ffaa00')]:
        preview(palette=color).save(ROOT/f'design/previews/design-{name}-280.png')
    for readable in [False,True]:
        im=preview(readable);name='design-readable' if readable else 'design-classic-red';im.save(ROOT/f'design/previews/{name}-280.png');im.resize((1120,1120),Image.Resampling.NEAREST).save(ROOT/f'design/previews/{name}-4x.png')
    icon=Image.new('RGB',(40,40));d=ImageDraw.Draw(icon);d.rectangle((4,4,35,35),outline='#ff0000',width=2);drawtext(icon,(20,13),'label','T88','white',True);icon.save(ROOT/'resources/drawables/launcher.png')
if __name__=='__main__':main()
