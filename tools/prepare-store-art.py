#!/usr/bin/env python3
"""Compose Store canvases from an unaltered native simulator capture.

No concept artwork, device enclosure, synthetic face rendering or recolouring.
The source file is never rewritten. Artwork is labelled in its manifest/captions.
"""
import hashlib
import json
import argparse
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

def prepare_polish(version='0.1.1',out_name='polish-0.1.1',label='Local beta 0.1.1'):
    source_dir=ROOT/'design/store/runtime/polish-0.1.1'
    output_dir=OUT/out_name
    output_dir.mkdir(parents=True,exist_ok=True)
    icc=ImageCms.ImageCmsProfile(ImageCms.createProfile('sRGB')).tobytes()
    def font(size,bold=False):
        return ImageFont.truetype(str(ROOT/'assets-src'/('DejaVuSansCondensed-Bold.ttf' if bold else 'DejaVuSansCondensed.ttf')),size)
    variants=[('classic-red-final','Classic Red'),('neon-cyan','Neon Cyan'),
              ('monochrome','Monochrome'),('amber','Amber'),('custom-header','Custom header')]
    records=[]
    sheet=Image.new('RGB',(1600,440),'#202326');sheet_draw=ImageDraw.Draw(sheet)
    sheet_draw.text((20,15),'TOKYO 2088 / Native simulator captures / Simulated data',font=font(24,True),fill='white')
    for index,(slug,title) in enumerate(variants):
        source=source_dir/(slug+'-280.png')
        digest=hashlib.sha256(source.read_bytes()).hexdigest()
        face=Image.open(source).convert('RGB');assert face.size==(280,280)
        canvas=Image.new('RGB',(720,840),'#202326');draw=ImageDraw.Draw(canvas)
        draw.text((48,27),'TOKYO 2088',font=font(24,True),fill='#b7bdc4')
        draw.text((48,65),title,font=font(36,True),fill='white')
        enlarged=face.resize((560,560),Image.Resampling.NEAREST)
        canvas.paste(enlarged,(80,130))
        draw.text((48,721),'SIMULATOR CAPTURE / SIMULATED DATA',font=font(23,True),fill='white')
        draw.text((48,759),'fenix 8 Solar 51mm profile / '+label,font=font(22),fill='#b7bdc4')
        draw.text((48,793),'Not a watch photograph.',font=font(20),fill='#b7bdc4')
        assert canvas.crop((80,130,640,690)).tobytes()==enlarged.tobytes()
        target=output_dir/(slug+'-720x840.png')
        canvas.save(target,optimize=True,icc_profile=icc)
        assert hashlib.sha256(source.read_bytes()).hexdigest()==digest
        sheet.paste(face,(index*320+20,94))
        sheet_draw.text((index*320+20,59),title,font=font(22,True),fill='white')
        sheet_draw.text((index*320+20,388),'Native 280 x 280 frame',font=font(18),fill='#b7bdc4')
        records.append({'title':title,'source':source.relative_to(ROOT).as_posix(),
                        'sourceSha256':digest,'sourceBytes':source.stat().st_size,
                        'file':target.relative_to(ROOT).as_posix(),'width':720,'height':840,
                        'bytes':target.stat().st_size,'sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
    sheet_path=output_dir/'palettes-and-custom-review.png'
    sheet.save(sheet_path,optimize=True,icc_profile=icc)
    manifest={'sourceKind':'Native Windows simulator Save Screen Capture of production beta release; simulated data',
              'version':version,'profile':'fenix8solar51mm',
              'captureBinary':'Beta 0.1.1 release PRG; runtime source and resources are identical to the labelled version (only manifest identity/version differ).',
              'sourcePrgSha256':'d5a0b647b711b426125b6f7c5a1434a5678b3d53eab0678104046bb0e3e415d1',
              'sourceBytesUnchanged':True,'colourSpace':'sRGB',
              'transform':'Whole raw frame at exact 2x nearest-neighbour on labelled 720x840 canvas; review sheet retains native size. No cropping, recolouring or retouching of face.',
              'customExample':{'HeaderMode':1,'HeaderLine1':'NIGHT SHIFT','HeaderLine2':'FIELD TERMINAL','Palette':0},
              'displayedData':'Simulator local time/date; simulated 50% battery, 0 steps and 13 C. Cyan shows simulated 80 BPM; later frames show unavailable HR (--). Not owner health/device data.',
              'portalDimensionsApproved':False,'artifacts':records,
              'reviewSheet':{'file':sheet_path.relative_to(ROOT).as_posix(),'sha256':hashlib.sha256(sheet_path.read_bytes()).hexdigest()}}
    (output_dir/'artwork-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(manifest,indent=2))


if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--polish',action='store_true',help='Compose the preserved 0.1.1 palette/custom captures without replacing original listing artwork.')
    parser.add_argument('--release',action='store_true',help='Compose the same captures labelled for public release 1.0.0 into artwork/release-1.0.0.')
    args=parser.parse_args()
    if args.release:prepare_polish('1.0.0','release-1.0.0','Release 1.0.0')
    elif args.polish:prepare_polish()
    else:main()
