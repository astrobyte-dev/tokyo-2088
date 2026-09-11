> Original design-handoff prompt retained as historical context. The project is now implemented; start with [README](README.md) and [the open hardware defect](docs/BLACK_SCREEN_INVESTIGATION.md). Do not restart the implementation from this old prompt.

# TOKYO 2088: start here

This is a design and development handoff, not an already-built watch-face project.

Open this extracted folder in VS Code and send Astra the prompt below. Keep the concept board in its supplied location. The right-hand half of the image is the selected design.

```text
Read TOKYO_2088_BRIEF.md completely and inspect design/reference/tokyo-2088-concept-board.png.

We are building the TOKYO 2088 design on the RIGHT side of the image, not DEAD SIGNAL. My watch is the Garmin fēnix 8 Solar 51mm, 280 × 280 MIP, product ID fenix8solar51mm. It is my only physical test device. Start with that model, then expand through explicit simulator-tested profiles.

Follow the brief as the product specification. Keep the stacked time, vertical Tokyo lettering, red industrial styling, and customizable identity plate. Make a native Monkey C watch face, not just a web mockup. Manual branding/city text comes first; do not let automatic city detection delay the working watch face.

Inspect the workspace and toolchain, make sensible decisions, and start implementing. Show real native-resolution previews early. Continue to a runnable primary-device build, tests, and installation instructions rather than stopping after a plan. Report any genuine blocker and never claim hardware or battery testing you have not performed.
```
