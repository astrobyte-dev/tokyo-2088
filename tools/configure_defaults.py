#!/usr/bin/env python3
"""Set first-install defaults. Existing watch properties remain authoritative."""
import argparse,xml.etree.ElementTree as ET
from pathlib import Path
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--mode',choices=['original','custom','city','hidden'])
p.add_argument('--line1');p.add_argument('--line2');p.add_argument('--city');p.add_argument('--subtitle')
p.add_argument('--palette',choices=['red','cyan','mono','amber'])
a=p.parse_args();path=Path(__file__).resolve().parents[1]/'resources/settings/properties.xml';tree=ET.parse(path)
values={}
if a.mode:values['HeaderMode']=str(['original','custom','city','hidden'].index(a.mode))
if a.palette:values['Palette']=str(['red','cyan','mono','amber'].index(a.palette))
for arg,key in [('line1','HeaderLine1'),('line2','HeaderLine2'),('city','City'),('subtitle','CitySubtitle')]:
 v=getattr(a,arg)
 if v is not None:
  if len(v)>64:p.error(f'{arg} must be at most 64 characters')
  values[key]=v
for prop in tree.getroot():
 if prop.attrib['id'] in values:prop.text=values[prop.attrib['id']]
ET.indent(tree);tree.write(path,encoding='unicode');print('Updated defaults:',', '.join(values) or '(none)')
