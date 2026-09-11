#!/usr/bin/env python3
"""Host-side asset checks only. Does not claim Monkey C runtime coverage."""
import json,sys
from pathlib import Path
from PIL import Image
sys.path.insert(0,str(Path(__file__).parent))
import generate_assets as g

g.main()
checks=0
for readable in [False,True]:
 for color in ['#ff0000','#00ffff','#ffffff','#ffaa00']:
  for clock in ['0827','1111','0000','1259','2359']:
   im=g.preview(readable,color,clock,mask_circle=False)
   outside=[]
   for y in range(280):
    for x in range(280):
     if im.getpixel((x,y))!=(0,0,0) and (x-139.5)**2+(y-139.5)**2>139.5**2:
      outside.append((x,y))
   assert not outside, f'Round-edge clipping {readable} {clock}: {outside[:8]} ({len(outside)} pixels)'
   assert all(v in [0,85,170,255] for rgb,n in [(c,n) for n,c in im.getcolors()] for v in rgb)
   checks+=1
for name,glyphs in g.FONTS.items():
 for ch,(im,advance) in glyphs.items():
  assert set(im.getdata()).issubset({0,255})
  assert advance>=im.width
report={'host_asset_cases_passed':checks,'checks':['unmasked design content within 280px circle','4x4x4 RGB palette only','1-bit glyph coverage and advance bounds'],'native_runtime_tests':'NOT ASSESSED BY THIS SCRIPT; see docs/TEST_RESULTS.md'}
(g.ROOT/'docs/asset-checks.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
