#!/usr/bin/env python3
"""Compose Store canvases from an unaltered native simulator capture.

No concept artwork, device enclosure, synthetic face rendering or recolouring.
The source file is never rewritten. Artwork is labelled in its manifest/captions.
"""
import hashlib
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageCms

ROOT=Path(__file__).resolve().parents[1]
SOURCE=ROOT/'design/store/runtime/store-prep-classic-red-280.png'
OUT=ROOT/'design/store/artwork'

def main():
    digest=hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    face=Image.open(SOURCE).convert('RGB')
    assert face.size==(280,280)
    OUT.mkdir(parents=True,exist_ok=True)
    icc=ImageCms.ImageCmsProfile(ImageCms.createProfile('sRGB')).tobytes()
    def font(size,bold=False):
        return ImageFont.truetype(str(ROOT/'assets-src'/('DejaVuSansCondensed-Bold.ttf' if bold else 'DejaVuSansCondensed.ttf')),size)
    def save(im,name):
        path=OUT/name
        im.save(path,optimize=True,icc_profile=icc)
        return {'file':path.relative_to(ROOT).as_posix(),'width':im.width,'height':im.height,
                'bytes':path.stat().st_size,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()}
    # Solid nonblack outer background; 40px margin exceeds Garmin's 10px padding.
    icon=Image.new('RGB',(500,500),'#333333')
    enlarged=face.resize((420,420),Image.Resampling.NEAREST)
    mask=Image.new('L',(420,420));ImageDraw.Draw(mask).ellipse((0,0,419,419),fill=255)
    icon.paste(enlarged,(40,40),mask)
    records=[save(icon,'store-icon-500.png')]
    hero=Image.new('RGB',(1440,720),'#121416');d=ImageDraw.Draw(hero)
    d.rectangle((54,63,61,657),fill='#ff3333')
    d.text((88,72),'ASTROBYTE',font=font(23,True),fill='#b7bdc4')
    d.text((84,132),'TOKYO',font=font(96,True),fill='white')
    d.text((84,234),'2088',font=font(126,True),fill='#ff3333')
    d.text((89,419),'An industrial MIP watch face.',font=font(29),fill='white')
    d.text((89,480),'Four palettes. Your identity plate.',font=font(24),fill='#b7bdc4')
    d.text((89,555),'fenix 8 Solar 51mm',font=font(22),fill='#b7bdc4')
    d.text((89,611),'SIMULATOR IMAGE / SIMULATED DATA',font=font(19),fill='#b7bdc4')
    # Exact integer nearest-neighbour enlargement; whole native frame retained.
    hero.paste(face.resize((560,560),Image.Resampling.NEAREST),(810,80))
    records.append(save(hero,'hero-en-1440x720.png'))
    screen=Image.new('RGB',(500,500),'#333333');d=ImageDraw.Draw(screen)
    d.text((30,24),'TOKYO 2088 / CLASSIC RED',font=font(22,True),fill='white')
    screen.paste(face,(110,96))
    d.text((30,409),'Native 280 x 280 simulator capture',font=font(20),fill='white')
    d.text((30,449),'Simulated data. Not a watch photograph.',font=font(17),fill='#cccccc')
    records.append(save(screen,'screenshot-classic-red-500.png'))
    assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==digest
    assert all(r['bytes']<150000 for r in records)  # Conservative local target, not an asserted portal limit.
    manifest={'source':SOURCE.relative_to(ROOT).as_posix(),'sourceSha256':digest,
              'sourceKind':'Native Windows simulator Save Screen Capture of production release; simulated data',
              'sourceBytesUnchanged':True,'colourSpace':'sRGB',
              'officialDimensionsSource':'https://developer.garmin.com/brand-guidelines/connect-iq/',
              'portalUploadAndByteLimitsVerified':False,
              'iconCaption':'TOKYO 2088, Classic Red — simulator preview, simulated data',
              'transform':'Icon: uniform nearest-neighbour resize and circular mask. Hero: exact 2x nearest-neighbour. Screenshot: untouched 280px frame on caption canvas.',
              'artifacts':records}
    (OUT/'artwork-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(manifest,indent=2))

if __name__=='__main__':main()
