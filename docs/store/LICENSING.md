# Commercial source and asset audit

Prepared for review, 11 September 2026. No source licence, repository visibility, history or existing third-party notice was changed. The repository's current public visibility is not evidence that all assets can be commercially redistributed.

## Inventory and disposition

| Material | Evidence / distribution consequence |
| --- | --- |
| Monkey C source, original numeral polygons, icon and graphic primitives | Project-authored according to the existing brief/notices and generators. No third-party runtime barrel/library appears in the manifest. Owner must confirm ownership/contributor rights and choose terms for original work; this is not independent authorship clearance. |
| DejaVu Sans Condensed regular/bold and derived BMFont resources | Retain existing `assets-src/DEJAVU-LICENSE.txt`. Audit of both bundled TTF name tables found additional Arev terms: full text preserved in new `assets-src/DEJAVU-EMBEDDED-LICENSE.txt`, with trailing spaces normalized. Font binaries/names were not modified. Commercial bundling is permitted subject to applicable notices/naming restrictions; fonts must not be sold by themselves. [Upstream licence](https://dejavu-fonts.github.io/License.html) |
| Noto Tokyo glyph subset and derived bitmap font | Existing `TokyoGlyphs.otf` contains the two Tokyo characters, documented as a subset of Noto Sans CJK JP Bold. Preserve `assets-src/NOTO-LICENSE.txt`; applicable font terms are SIL OFL 1.1. Commercial bundling is allowed; modified-font naming and any Reserved Font Names must be checked against exact upstream provenance before release. Fonts alone cannot be sold. [OFL guidance](https://openfontlicense.org/how-to-use-ofl-fonts/), [FAQ](https://openfontlicense.org/ofl-faq/) |
| Debian packaging stanzas in supplied font copyright files | GPL references describe the corresponding Debian packaging; they do not by themselves place this original watch-face code under GPL. Keep full files rather than stripping mixed provenance notices. |
| Concept board | Already tracked at `design/reference/tokyo-2088-concept-board.png`; owner-provided reference, public/commercial redistribution rights **unconfirmed**. Not included in production resources, the IQ export or new Store artwork. Owner has been asked for creator/source and permitted uses. Do not infer rights or remove repository history without a decision. |
| Store artwork | Real native production simulator image plus project captions using the bundled DejaVu font. No concept-board compositing, Garmin logo or device enclosure. See [provenance](../../design/store/README.md). Brand-name availability/rights for Astrobyte and TOKYO 2088 still need owner confirmation. |
| Python, Pillow, fontTools and Garmin SDK | Build/art tooling, not runtime payment/data dependencies or redistributed toolchain. The SDK remains external under Garmin's terms. Original host dependencies do not become bundled runtime code just because they generated images. |

The font licence does not automatically become the licence of an image, document or unrelated application using the font. Embedded/redistributed font data and derivatives still require the applicable font conditions. Do not assume changing a resource filename removes those obligations. [OFL FAQ](https://openfontlicense.org/ofl-faq/)

## Notice-delivery gate

The public repository preserves full notices and the exporter places all four notice files in a `notices/` sibling folder. **Those sidecars are not automatically delivered when only the `.iq` is uploaded.** The compiled bitmap-font payload does not provide a verified customer-accessible copy of the full terms. Before submission, complete and verify notice delivery with the actual customer distribution (for example a supported packaged legal resource/about presentation, accompanied by listing links), with the chosen mechanism checked against the licences and Garmin's packaging rules. Do not hand-edit the signed IQ archive to insert files.

This is an explicit release gate, not a claim that a GitHub notice alone completes commercial distribution compliance. Full font source/subsetting provenance and naming review, especially the Noto subset, should be resolved with that step. No font regeneration or replacement was done in this milestone.

## Original-source licence options — owner decision

| Option | Practical tradeoff |
| --- | --- |
| Retain proprietary original code / commercial end-user terms | Keeps licensing control; define customer use and contributor permissions explicitly. Third-party font permissions remain separate. Public hosting still permits GitHub's platform viewing/forking behavior. |
| MIT or Apache-2.0 | Allows broad reuse, commercial forks and redistribution with conditions; Apache adds an express patent framework. Charging for the Store binary remains possible, but exclusivity is reduced. [MIT terms](https://opensource.org/license/mit), [Apache terms](https://www.apache.org/licenses/LICENSE-2.0) |
| Copyleft such as GPL | Can permit commercial sale while requiring corresponding-source/licence obligations for covered distribution. Review how the intended binary distribution and Garmin terms fit before choosing; do not apply casually. See the licence-selection guidance below. |

No `LICENSE` file currently grants an open-source licence to original source. GitHub explains that absent a licence, default copyright restrictions apply, subject to platform terms for public repositories. [GitHub licensing guidance](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)

Owner decisions: original-source terms; ownership/contributions; concept-board provenance and treatment; publisher branding; final customer notice delivery. If rights cannot be established, agree on exclusion/replacement or repository treatment before publishing; no history rewrite or visibility change is authorized here.
