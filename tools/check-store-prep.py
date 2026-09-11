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
import importlib.util

ROOT = Path(__file__).resolve().parents[1]
NS = {'iq': 'http://www.garmin.com/xml/connectiq'}
UUID = 'd8c8adfe21c74bdd97fa2088ac010001'
BETA_UUID = 'ca80e764ffae413996a66e11abd76ed9'


def check(iq=None, beta=False):
    properties = {p.attrib['id']: p for p in ET.parse(ROOT/'resources/settings/properties.xml').getroot()}
    strings = {s.attrib['id']: s.text for path in (ROOT/'resources/strings').glob('*.xml') for s in ET.parse(path).getroot()}
    spec=importlib.util.spec_from_file_location('notice_source',ROOT/'tools/prepare-notices.py')
    notices=importlib.util.module_from_spec(spec);spec.loader.exec_module(notices)
    assert (ROOT/'resources/strings/font-notices.xml').read_text(encoding='utf-8')==notices.resource_bytes().decode('utf-8')
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
    beta_app=ET.parse(ROOT/'manifest-beta.xml').find('iq:application',NS)
    assert beta_app.attrib['id']==BETA_UUID and BETA_UUID!=UUID
    assert beta_app.attrib['name']=='@Strings.BetaAppName' and strings['BetaAppName']=='TOKYO 2088 BETA'
    assert {k:v for k,v in beta_app.attrib.items() if k not in ('id','name')}=={k:v for k,v in app.attrib.items() if k not in ('id','name')}
    assert [ET.tostring(c) for c in beta_app]==[ET.tostring(c) for c in app]
    jungle = (ROOT/('beta.jungle' if beta else 'monkey.jungle')).read_text().splitlines()
    assert 'project.manifest = '+('manifest-beta.xml' if beta else 'manifest.xml') in jungle
    for line in ('base.sourcePath = source', 'base.resourcePath = resources', 'base.excludeAnnotations = test;preview;fixture;capture'):
        assert line in jungle
    for name in ('NOTO-LICENSE.txt','DEJAVU-LICENSE.txt','DEJAVU-EMBEDDED-LICENSE.txt'):
        assert (ROOT/'assets-src'/name).stat().st_size > 1000
    result = {'customerSettingsSchema': 'PASS', 'stablePropertyIds': 12,
              'productionInputIsolation': 'PASS', 'manifestProduct': 'fenix8solar51mm',
              'betaIdentity': beta, 'appUuid': BETA_UUID if beta else UUID,
              'fontNoticeResources':'PASS'}
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
        assert manifest.attrib['id'] == (BETA_UUID if beta else UUID) and manifest.attrib['entry'] == 'TokyoApp'
        assert manifest.attrib['name']==('@Strings.BetaAppName' if beta else '@Strings.AppName')
        assert len(manifest.find('iq:permissions',NS)) == 0
        products = list(manifest.find('iq:products',NS))
        # The installed primary Garmin product profile maps to fenix/tactix parts.
        assert {p.attrib['partNumber'] for p in products} == {'006-B4533-00','006-B4776-00'}
        binaries = []
        forbidden = ('ResetSurfaceView','FixtureData','ResetCapture','PreviewView',
                     'customerSettingsPreservation','rendererMatrix','resetSurfaceSecondsOff','fontNoticeDelivery')
        for product in products:
            prg = read(product.attrib['filename'])
            if beta:
                assert b'TOKYO 2088 BETA' in prg
            debug = read(product.attrib['partNumber']+'/debug.xml').decode('utf-8')
            assert all(symbol not in debug for symbol in forbidden)
            assert 'TokyoView' in debug and 'TokyoApp' in debug
            assert 'FontNoticeView' in debug and 'getSettingsView' in debug
            # Garmin string resources are compiled into the device PRG itself.
            # Verify full text, not only names/links or sibling notice files.
            for legal_text in notices.texts().values():
                assert legal_text.encode('utf-8') in prg, 'Full font notice text missing from PRG'
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
                      compiledSettings='PASS', packagedFontNoticeText='PASS', storeAcceptance='NOT TESTED')
    return result


if __name__ == '__main__':
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--iq',type=Path)
    parser.add_argument('--output',type=Path)
    parser.add_argument('--beta',action='store_true')
    args=parser.parse_args()
    output=json.dumps(check(args.iq,args.beta),indent=2)+'\n'
    if args.output:
        args.output.parent.mkdir(parents=True,exist_ok=True)
        args.output.write_text(output,encoding='utf-8')
    print(output,end='')
