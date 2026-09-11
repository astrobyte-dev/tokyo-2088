# Asset provenance

- **TOKYO numeral artwork**: original chamfered polygon contours created for this project. Editable source: `assets-src/numerals.json`. Generated hero BMFont atlas contains only digits 0–9 and space. No numeral contours were traced from the reference image or another watch face.
- **DejaVu Sans Condensed / Bold**: supplied editable font source files in `assets-src/`, from Ubuntu's `fonts-dejavu-core`. Used for small printable ASCII and degree glyphs. See full copyright and Bitstream Vera/DejaVu terms in `assets-src/DEJAVU-LICENSE.txt`; upstream https://dejavu-fonts.github.io/ . Generated BMFont subsets are derived raster resources, not full-font loading on the watch.
- **Noto Sans CJK JP Bold**: Ubuntu `fonts-noto-cjk`, font collection face 0, subset with fontTools to 東京 only. Source subset `assets-src/TokyoGlyphs.otf`; full SIL Open Font License and copyright in `assets-src/NOTO-LICENSE.txt`. Upstream https://github.com/notofonts/noto-cjk . No extra Japanese slogans are used.
- **Garmin Connect IQ SDK**: external official toolchain under Garmin's developer agreement; not redistributed. No Garmin logo or hardware art is a runtime resource.
- **Concept board**: user-supplied visual reference at `design/reference/tokyo-2088-concept-board.png`. Reference use only, excluded from Monkey C resource paths. Ownership/licensing for public redistribution is not established here.

Asset regeneration uses Python/Pillow and reads the bundled font subsets and numeral JSON. Original runtime icon and weather/battery primitives were drawn for this project.

## Distribution preparation

The bundled DejaVu TTFs also contain the Arev copyright and permission terms in
their name-table licence metadata. The full embedded licence text is preserved
in [DEJAVU-EMBEDDED-LICENSE.txt](assets-src/DEJAVU-EMBEDDED-LICENSE.txt), in addition
to the original notice above. Retain both files when distributing the fonts or
derived font resources. No existing notice has been removed or replaced.
Only trailing spaces were normalized in the new embedded-licence transcription.

The source font files and their embedded names remain unchanged. Generated
BMFonts use the `Tokyo` family label. Third-party font terms continue to apply
independently of the owner's still-undecided licence for original project code.

Store artwork in `design/store` uses an actual runtime simulator capture and
the bundled DejaVu fonts for captions. It does not use the concept board or
Garmin device enclosure/logo artwork. See the [commercial asset audit](docs/store/LICENSING.md)
for remaining provenance and distribution-delivery decisions. The concept board
already in Git remains a reference with unconfirmed public redistribution rights;
its presence in the repository does not establish permission to reuse it.
