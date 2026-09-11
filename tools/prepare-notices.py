#!/usr/bin/env python3
"""Generate Garmin string resources from retained font notices, without font edits."""
from pathlib import Path
import argparse
import xml.etree.ElementTree as ET

ROOT=Path(__file__).resolve().parents[1]

def texts():
    dejavu=(ROOT/'assets-src/DEJAVU-EMBEDDED-LICENSE.txt').read_text(encoding='utf-8').strip()
    noto=(ROOT/'assets-src/NOTO-LICENSE.txt').read_text(encoding='utf-8')
    # Debian copyright-format dot escaping is formatting, not part of the OFL.
    ofl=noto.rsplit('\nLicense: SIL-1.1\n',1)[1].split('\nLicense: GPL-3+',1)[0]
    ofl='\n'.join('' if line.strip()=='.' else line.removeprefix(' ') for line in ofl.splitlines()).strip()
    assert len(ofl)>3000 and 'PERMISSION & CONDITIONS' in ofl and 'DISCLAIMER' in ofl
    noto_copyright=(ROOT/'assets-src/NOTO-EMBEDDED-COPYRIGHT.txt').read_text(encoding='utf-8').strip()
    return {'LegalDejaVu':dejavu,
            'LegalNoto':noto_copyright+'\nCopyright: 2010-2012, Google Corporation (bundled package notice).\n\n'+ofl}

def resource_bytes():
    root=ET.Element('strings')
    for key,value in texts().items():
        # Explicit escaped newlines follow Garmin's string-resource syntax.
        ET.SubElement(root,'string',id=key).text=value.replace('\n','\\n')
    ET.indent(root)
    return ET.tostring(root,encoding='utf-8',xml_declaration=True)+b'\n'

if __name__=='__main__':
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--check',action='store_true');args=parser.parse_args()
    path=ROOT/'resources/strings/font-notices.xml';data=resource_bytes()
    if args.check:
        assert path.read_bytes()==data, 'Regenerate font-notices.xml with tools/prepare-notices.py'
    else:
        path.write_bytes(data)
    print('Packaged font notice text: PASS' if args.check else 'Generated Garmin font notice strings; font assets unchanged')
