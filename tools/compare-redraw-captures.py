"""Verify exported 280px Garmin PNGs; never generate or alter reference images."""
import argparse
import json
from pathlib import Path
from PIL import Image, ImageChops

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--captures', type=Path, default=Path('design/simulator/windows-redraw'))
args = parser.parse_args()
root = args.captures

def load(name):
    with Image.open(root / name) as image:
        assert image.size == (280, 280), (name, image.size)
        assert image.format == 'PNG', name
        return image.convert('RGB')

off = load('baseline-reset-seconds-off.png')
on = load('baseline-reset-seconds-on.png')
fixed_off = load('candidate-reset-seconds-off.png')
fixed_on = load('candidate-reset-seconds-on.png')
assert off.getbbox() is None, 'Injected baseline seconds-off must be black'
assert on.getbbox() is not None, 'Seconds-only baseline should have visible seconds'
outside_seconds = on.copy()
outside_seconds.paste((0, 0, 0), (209, 145, 235, 166))
assert outside_seconds.getbbox() is None, 'Baseline draws only the seconds region'
reference = Image.open(Path(__file__).resolve().parents[1] / 'design/simulator/classic-red-0827-280.png').convert('RGB')
regions = {'plate': (60, 15, 222, 49), 'tokyo_2088': (30, 65, 78, 183),
           'hour': (91, 59, 198, 136), 'minute': (91, 140, 198, 220)}
for name, bounds in regions.items():
    expected = reference.crop(bounds)
    assert expected.getbbox() is not None, name
    for actual in (fixed_off, fixed_on):
        assert ImageChops.difference(expected, actual.crop(bounds)).getbbox() is None, name
diff = ImageChops.difference(fixed_off, fixed_on)
assert diff.getbbox() is not None, 'Active seconds should be visible'
diff.paste((0, 0, 0), (209, 145, 235, 166))
assert diff.getbbox() is None, 'Only active seconds differ between candidate fixtures'
print(json.dumps({'injected_clear_screen': True, 'baseline_black_off_seconds_only_on': True,
                  'candidate_matches_preserved_reference_regions': list(regions),
                  'candidate_seconds_only_difference': True}, indent=2))
