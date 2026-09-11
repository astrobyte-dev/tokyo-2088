#!/usr/bin/env python3
"""Validate customer settings, production inputs and a native Windows IQ export.

Reads 7z IQ members through Windows tar; never extracts arbitrary archive paths.
This checks packaging, not Garmin Store acceptance or phone-to-watch settings.
"""
import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import subprocess
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
NS = {'iq': 'http://www.garmin.com/xml/connectiq'}
UUID = 'd8c8adfe21c74bdd97fa2088ac010001'


def check(iq=None):
    properties = {p.attrib['id']: p for p in ET.parse(ROOT/'resources/settings/properties.xml').getroot()}
    strings = {s.attrib['id']: s.text for s in ET.parse(ROOT/'resources/strings/strings.xml').getroot()}
    settings = ET.parse(ROOT/'resources/settings/settings.xml').getroot()
    assert properties['HeaderLine1'].text == 'YOUR NAME'
    assert properties['City'].text == 'YOUR CITY'
    assert properties['HeaderMode'].text == '0' and properties['Seconds'].text == '0'
    assert len(properties) == len(settings) == 12
    assert len({s.attrib['propertyKey'] for s in settings}) == 12
    for s in settings:
        key = s.attrib['propertyKey'].removeprefix('@Properties.')
        assert key in properties
        for field in ('title', 'prompt'):
            assert strings[s.attrib[field].removeprefix('@Strings.')]
        config = s.find('settingConfig')
        if config.attrib['type'] == 'alphaNumeric':
            assert config.attrib['maxLength'] == '64'
            assert strings[config.attrib['errorMessage'].removeprefix('@Strings.')]
        for entry in config.findall('listEntry'):
            assert strings[entry.text.removeprefix('@Strings.')]
        if config.attrib['type'] == 'list':
            assert properties[key].text in [e.attrib['value'] for e in config]
    app = ET.parse(ROOT/'manifest.xml').find('iq:application', NS)
    assert app.attrib['id'] == UUID
    assert [p.attrib['id'] for p in app.find('iq:products', NS)] == ['fenix8solar51mm']
    assert len(app.find('iq:permissions', NS)) == 0
    assert len(app.find('iq:barrels', NS)) == 0
    jungle = (ROOT/'monkey.jungle').read_text().splitlines()
    for line in ('base.sourcePath = source', 'base.resourcePath = resources', 'base.excludeAnnotations = test;preview;fixture;capture'):
        assert line in jungle
    for name in ('NOTO-LICENSE.txt','DEJAVU-LICENSE.txt','DEJAVU-EMBEDDED-LICENSE.txt'):
        assert (ROOT/'assets-src'/name).stat().st_size > 1000
    result = {'customerSettingsSchema': 'PASS', 'stablePropertyIds': 12,
              'productionInputIsolation': 'PASS', 'manifestProduct': 'fenix8solar51mm'}
    if iq:
        iq = Path(iq).resolve()
        members = subprocess.check_output(['tar','-tf',str(iq)], text=True).splitlines()
        assert len(members) == len(set(members))
        assert all(not PurePosixPath(m).is_absolute() and '..' not in PurePosixPath(m).parts for m in members)
        assert all(not m.lower().endswith(('.der','.pem','.key','.set','.fit')) for m in members)
        def read(member):
            assert member in members
            return subprocess.check_output(['tar','-xOf',str(iq),member])
        manifest = ET.fromstring(read('manifest.xml')).find('iq:application',NS)
        assert manifest.attrib['id'] == UUID and manifest.attrib['entry'] == 'TokyoApp'
        assert len(manifest.find('iq:permissions',NS)) == 0
        products = list(manifest.find('iq:products',NS))
        # The installed primary Garmin product profile maps to fenix/tactix parts.
        assert {p.attrib['partNumber'] for p in products} == {'006-B4533-00','006-B4776-00'}
        binaries = []
        forbidden = ('ResetSurfaceView','FixtureData','ResetCapture','PreviewView',
                     'customerSettingsPreservation','rendererMatrix','resetSurfaceSecondsOff')
        for product in products:
            prg = read(product.attrib['filename'])
            debug = read(product.attrib['partNumber']+'/debug.xml').decode('utf-8')
            assert all(symbol not in debug for symbol in forbidden)
            assert 'TokyoView' in debug and 'TokyoApp' in debug
            data = json.loads(read(product.attrib['settings']))
            compiled = {p['key']: p for p in data['settings']}
            assert set(compiled) == set(properties)
            assert compiled['HeaderLine1']['defaultValue'] == 'YOUR NAME'
            assert compiled['City']['defaultValue'] == 'YOUR CITY'
            for setting in compiled.values():
                assert setting['configPrompt']
                assert any(setting['configPrompt'] in lang for lang in data['languages'].values())
            binaries.append({'partNumber':product.attrib['partNumber'], 'bytes':len(prg),
                             'sha256':hashlib.sha256(prg).hexdigest(),
                             'minFirmwareVersion':product.attrib['minFirmwareVersion']})
        assert len({p['sha256'] for p in binaries}) == 1
        result.update(iqBytes=iq.stat().st_size, iqSha256=hashlib.sha256(iq.read_bytes()).hexdigest(),
                      packagedBinaries=binaries, fixturesExcluded='PASS',
                      compiledSettings='PASS', storeAcceptance='NOT TESTED')
    return result


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--iq',type=Path)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    output=json.dumps(check(args.iq),indent=2)+'\n'
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(output,encoding='utf-8')
    print(output,end='')
