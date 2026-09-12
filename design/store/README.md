# Store artwork — actual simulator rendering

## Local polish candidate 0.1.1 — 12 September 2026

Five new **native Windows simulator Save Screen Capture** PNGs show the actual production beta release on `fenix8solar51mm`. Palettes and custom text were selected through Garmin's App Settings Editor and saved to the running face. The clock renderer, fonts, layout and property schema are unchanged. The captured PRG and final standalone release are byte-identical: SHA-256 `d5a0b647b711b426125b6f7c5a1434a5678b3d53eab0678104046bb0e3e415d1`. These are local candidate images, not photographs of the installed owner beta.

| Variant | Unmodified native 280 × 280 capture | Labelled 720 × 840 canvas |
| --- | --- | --- |
| Classic Red / Original plate | [Raw](runtime/polish-0.1.1/classic-red-final-280.png) | [Canvas](artwork/polish-0.1.1/classic-red-final-720x840.png) |
| Neon Cyan / Original plate | [Raw](runtime/polish-0.1.1/neon-cyan-280.png) | [Canvas](artwork/polish-0.1.1/neon-cyan-720x840.png) |
| Monochrome / Original plate | [Raw](runtime/polish-0.1.1/monochrome-280.png) | [Canvas](artwork/polish-0.1.1/monochrome-720x840.png) |
| Amber / Original plate | [Raw](runtime/polish-0.1.1/amber-280.png) | [Canvas](artwork/polish-0.1.1/amber-720x840.png) |
| Custom / NIGHT SHIFT / FIELD TERMINAL | [Raw](runtime/polish-0.1.1/custom-header-280.png) | [Canvas](artwork/polish-0.1.1/custom-header-720x840.png) |

[Five-image review sheet](artwork/polish-0.1.1/palettes-and-custom-review.png). Each canvas labels **simulator capture / simulated data** and preserves the whole frame at exact 2× nearest-neighbour scaling. No clock pixels are cropped, recoloured, retouched or generated. Raw source hashes, dimensions and transforms are in the [manifest](artwork/polish-0.1.1/artwork-manifest.json). `python tools/prepare-store-art.py --polish` recreates these canvases without replacing the original listing artwork. Visual QA found clear captions, complete frames and no stretching. The 720 × 840 canvases are local review assets; their acceptance by the live listing form has not been tested.

The captures show the simulator's local time/date on 12 September, 50% battery, 0 steps and 13°C. Cyan shows simulated 80 BPM; later captures show unavailable HR (`--`) after the cached sample expires. This is simulated data, not owner health/device data. The earlier pre-reader-fix Red capture remains under ignored `build/windows/beta/polish-0.1.1/validation/classic-red-before-reader-fix.png` and is not used in these product canvases.

Full simulator-window evidence for the notice reader is retained under [runtime/polish-0.1.1/notices](runtime/polish-0.1.1/notices/): DejaVu/Arev pages 1/21/41, Noto/OFL pages 1/19/37 and return to the face. These are raw UI screenshots for navigation review, not product listing images or hardware-navigation evidence.

## Preserved original listing artwork

`runtime/store-prep-classic-red-280.png` is an unchanged **native Windows simulator Save Screen Capture** of the ordinary production release on the `fenix8solar51mm` profile, captured 11 September 2026. The face displayed 08:57 PM, Friday 11 September, Classic Red, Original plate, simulated 50% battery/zero steps and unavailable HR/weather. These are simulated data, not the owner's health/device data.

The captured release is the new Store-prep build, **not** the preserved wrist candidate. Its 25,612-byte PRG SHA-256 is `b18891337d16544063ea118b69d589c60789cd912a57ff59ec5b82f4e6a41d92`. It was built from production `monkey.jungle` with `-r`, signed with the retained temporary Windows development key. Test/capture fixtures were not used. The final committed source/export association is in [validation](../../docs/store/VALIDATION.md).

Raw capture SHA-256: `7b2b429ea7af47dfed8970e2b37634d463e36691617c198f911b7464abced077` (3,020 bytes).

| File | Preparation / intended use |
| --- | --- |
| [Store icon](artwork/store-icon-500.png) | 500 × 500 sRGB PNG; centered circular face preview, uniform nearest-neighbour scaling, 40px margin and solid nonblack outer background. No added descriptive text on the icon. Use caption “TOKYO 2088, Classic Red — simulator preview, simulated data.” |
| [English hero](artwork/hero-en-1440x720.png) | 1440 × 720 sRGB PNG; entire runtime frame at 2× nearest-neighbour, project typography, visible simulator/simulated-data label. Proposed Astrobyte branding requires owner confirmation. |
| [Screenshot canvas](artwork/screenshot-classic-red-500.png) | 500 × 500 sRGB PNG; untouched native 280px frame on a caption canvas, clearly labelled simulator and simulated data. Native source is retained separately. |

Garmin's current brand guidance specifies **500 × 500 sRGB** Store icons, at least 10px padding, centered undistorted content, solid nonblack/nontransparent outer background and no descriptive text; hero images are **1440 × 720**. No Garmin logo or device enclosure artwork is used. The optional 128px on-device Store icon is distinct from this project's existing 40px runtime launcher icon and is not changed here. [Official Connect IQ brand specifications](https://developer.garmin.com/brand-guidelines/connect-iq/)

The current authenticated upload form could not be inspected. Screenshot dimensions/count, file-size ceilings, accepted formats and live text limits remain to be confirmed there before upload. The prepared PNGs are each below 150KB as a conservative production target, **not a claim that 150KB is Garmin's current limit**. Only English is prepared; localize hero callouts if additional listing languages are offered.

Recreate canvases with `python tools/prepare-store-art.py`. It uses the genuine saved frame and bundled font, performs no AI generation or runtime asset regeneration, and records dimensions, transformations, sizes and hashes in [artwork-manifest.json](artwork/artwork-manifest.json). Visual inspection found no clipped captions or stretched face content. No concept board or historical fixture screenshot is represented as the current product.
