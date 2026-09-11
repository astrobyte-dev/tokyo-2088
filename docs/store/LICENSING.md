# Commercial source and asset audit

Prepared for review, 11 September 2026. No source licence, repository visibility, history or existing third-party notice was changed. The repository's current public visibility is not evidence that all assets can be commercially redistributed.

## Inventory and disposition

| Material | Evidence / distribution consequence |
| --- | --- |
| Monkey C source, original numeral polygons, icon and graphic primitives | Project-authored according to the existing brief/notices and generators. No third-party runtime barrel/library appears in the manifest. Owner must confirm ownership/contributor rights and choose terms for original work; this is not independent authorship clearance. |
| DejaVu Sans Condensed regular/bold and derived BMFont resources | Retain existing `assets-src/DEJAVU-LICENSE.txt`. Audit of both bundled TTF name tables found additional Arev terms: full text preserved in new `assets-src/DEJAVU-EMBEDDED-LICENSE.txt`, with trailing spaces normalized. Font binaries/names were not modified. Commercial bundling is permitted subject to applicable notices/naming restrictions; fonts must not be sold by themselves. [Upstream licence](https://dejavu-fonts.github.io/License.html) |
| Noto Tokyo glyph subset and derived bitmap font | Existing `TokyoGlyphs.otf` contains the two Tokyo characters from Noto Sans CJK JP. Preserve `assets-src/NOTO-LICENSE.txt` and the newly retained `NOTO-EMBEDDED-COPYRIGHT.txt` (Adobe 2014–2021, read directly from the subset). The full applicable SIL OFL 1.1 is packaged with both embedded and package copyright notices. No Reserved Font Name declaration appears after the copyright in these supplied notices; runtime BMFont family is `Tokyo`, not an upstream protected name. Font binaries were not modified. [Upstream Sans licence](https://github.com/notofonts/noto-cjk/blob/main/Sans/LICENSE), [OFL guidance](https://openfontlicense.org/how-to-use-ofl-fonts/) |
| Debian packaging stanzas in supplied font copyright files | GPL references describe the corresponding Debian packaging; they do not by themselves place this original watch-face code under GPL. Keep full files rather than stripping mixed provenance notices. |
| Concept board | Owner confirmed it was **AI-generated during their ChatGPT design conversation for this project**, not sourced from an existing Garmin watch-face listing. It remains at `design/reference/tokyo-2088-concept-board.png`, excluded from runtime resources and product screenshots. This records provenance, not exclusive copyright, originality guarantees or trademark clearance. No history rewrite/removal occurred. |
| Store artwork | Real native production simulator image plus project captions using the bundled DejaVu font. No concept-board compositing, Garmin logo or device enclosure. See [provenance](../../design/store/README.md). Brand-name availability/rights for Astrobyte and TOKYO 2088 still need owner confirmation. |
| Python, Pillow, fontTools and Garmin SDK | Build/art tooling, not runtime payment/data dependencies or redistributed toolchain. The SDK remains external under Garmin's terms. Original host dependencies do not become bundled runtime code just because they generated images. |

The font licence does not automatically become the licence of an image, document or unrelated application using the font. Embedded/redistributed font data and derivatives still require the applicable font conditions. Do not assume changing a resource filename removes those obligations. [OFL FAQ](https://openfontlicense.org/ofl-faq/)

## Notice delivery — implemented in the beta source

`resources/strings/font-notices.xml` contains the full Bitstream/DejaVu/Arev notice and Noto copyrights plus the complete SIL OFL. Garmin's compiler includes these string resources **inside each device PRG**. `TokyoApp.getSettingsView()` exposes an offline **Font notices** menu and paginated reader in the separate watch-face settings context. The normal clock renderer, graphic assets and 12 customer properties are unchanged. No network, permission, permanent property or payment service is added. [Garmin settings entry point](https://developer.garmin.com/connect-iq/api-docs/Toybox/Application/AppBase.html#getSettingsView-instance_function)

`tools/prepare-notices.py` retains the actual licence text, converting only Debian copyright-file paragraph escaping and Garmin XML newline representation. Debian packaging GPL sections remain in the original files but are not presented as the runtime font licence. Font source files and raster assets were not regenerated. Applicable licence conditions allow notices in the distributed program; this implementation supplies both complete text in the PRG and a supported user-visible reader. [OFL distribution conditions](https://openfontlicense.org/ofl-faq/), [DejaVu terms](https://dejavu-fonts.github.io/License.html)

Verification: the package checker finds the **entire expected UTF-8 text** in each exported PRG, not merely a URL or marker. Native `fontNoticeDelivery` loads the real resources through Garmin, opens the app's settings entry point, renders all pages and reconstructs all characters without omission (4,763 DejaVu/Arev characters, 4,243 Noto/OFL characters). Boundary navigation is checked. Sidecars are retained only as supplementary copies; no signed archive is hand-edited.

The compiled delivery mechanism and native reader test pass. Visual inspection of the settings reader, real-device menu navigation and phone installation remain pending because browser/computer control stopped during account preparation. Do not mark those observations complete. After the authorized beta is installed, select its watch-face settings/customization entry and **Font notices**; choose a licence, use UP/DOWN to page and BACK to return. Exact firmware menu labels still require owner confirmation.

## Original-source licence options — owner decision

| Option | Practical tradeoff |
| --- | --- |
| Retain proprietary original code / commercial end-user terms | Keeps licensing control; define customer use and contributor permissions explicitly. Third-party font permissions remain separate. Public hosting still permits GitHub's platform viewing/forking behavior. |
| MIT or Apache-2.0 | Allows broad reuse, commercial forks and redistribution with conditions; Apache adds an express patent framework. Charging for the Store binary remains possible, but exclusivity is reduced. [MIT terms](https://opensource.org/license/mit), [Apache terms](https://www.apache.org/licenses/LICENSE-2.0) |
| Copyleft such as GPL | Can permit commercial sale while requiring corresponding-source/licence obligations for covered distribution. Review how the intended binary distribution and Garmin terms fit before choosing; do not apply casually. See the licence-selection guidance below. |

No `LICENSE` file currently grants an open-source licence to original source. GitHub explains that absent a licence, default copyright restrictions apply, subject to platform terms for public repositories. [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

Owner decisions remain for original-source terms, ownership/contributions and publisher branding/public clearance. Concept provenance is now recorded. No new source-code licence, history rewrite or visibility change is authorized here.
