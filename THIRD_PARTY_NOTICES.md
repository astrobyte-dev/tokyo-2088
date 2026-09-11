# Asset provenance

- **TOKYO numeral artwork**: original chamfered polygon contours created for this project. Editable source: `assets-src/numerals.json`. Generated hero BMFont atlas contains only digits 0–9 and space. No numeral contours were traced from the reference image or another watch face.
- **DejaVu Sans Condensed / Bold**: supplied editable font source files in `assets-src/`, from Ubuntu's `fonts-dejavu-core`. Used for small printable ASCII and degree glyphs. See full copyright and Bitstream Vera/DejaVu terms in `assets-src/DEJAVU-LICENSE.txt`; upstream https://dejavu-fonts.github.io/ . Generated BMFont subsets are derived raster resources, not full-font loading on the watch.
- **Noto Sans CJK JP Bold**: Ubuntu `fonts-noto-cjk`, font collection face 0, subset with fontTools to 東京 only. Source subset `assets-src/TokyoGlyphs.otf`; full SIL Open Font License and copyright in `assets-src/NOTO-LICENSE.txt`. Upstream https://github.com/notofonts/noto-cjk . No extra Japanese slogans are used.
- **Garmin Connect IQ SDK**: external official toolchain under Garmin's developer agreement; not redistributed. No Garmin logo or hardware art is a runtime resource.
- **Concept board**: user-supplied visual reference at `design/reference/tokyo-2088-concept-board.png`. Reference use only, excluded from Monkey C resource paths. Ownership/licensing for public redistribution is not established here.

Asset regeneration uses Python/Pillow and reads the bundled font subsets and numeral JSON. Original runtime icon and weather/battery primitives were drawn for this project.
