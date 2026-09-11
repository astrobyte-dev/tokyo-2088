#!/usr/bin/env python3
"""Enlarge an existing native simulator capture; never modify the original."""
from pathlib import Path
import argparse,hashlib
from PIL import Image
p=argparse.ArgumentParser(description=__doc__);p.add_argument('capture',type=Path);a=p.parse_args()
before=hashlib.sha256(a.capture.read_bytes()).hexdigest()
with Image.open(a.capture) as im:
 if im.size!=(280,280):p.error(f'Expected native 280 x 280 capture, received {im.size}')
 output=a.capture.with_name(a.capture.stem+'-4x-nearest.png')
 im.resize((1120,1120),Image.Resampling.NEAREST).save(output)
assert hashlib.sha256(a.capture.read_bytes()).hexdigest()==before
print(output)
