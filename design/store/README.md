# Store artwork — actual simulator rendering

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
