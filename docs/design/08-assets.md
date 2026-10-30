# Assets

All assets are original. No third-party logos, no PBSU artwork, no manufacturer badges. Brand colors: plate `#14181C`, amber `#FFB547`, muted `#C9CFD6`.

## Launcher icon (concept, placeholder until the app is named)

| Layer | Spec |
|---|---|
| Background (adaptive) | solid `#14181C` |
| Foreground (adaptive, 108 dp canvas, keep content in the 66 dp safe circle) | A destination plate glyph: a rounded rectangle outline (amber, 4 dp stroke at 108 dp scale) holding a front-view bus silhouette made of amber dots on a 7 x 7 dot grid (the LED cue). Reads as "bus sign" at 48 dp. |
| Monochrome (Android 13 themed icons) | the same glyph as a single-color vector (dots + plate outline), transparent background |
| Legacy (pre-26) | foreground on the background, square with radius 20% |
| Play Store 512 px | same art, no text |

Deliverables for `fe-ui-redesign` (or `fe-release-readiness`): `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` with `<background>`, `<foreground>`, `<monochrome>`; vector drawables preferred over PNGs. Do not render the app name in the icon (the name is a placeholder).

## Splash
- Android 12+ system splash: `windowSplashScreenBackground #14181C`, icon = the adaptive foreground, no branding image. Same in light and dark.
- Pre-12: `launch_background.xml` with `#14181C` and the centered glyph.
- Flutter splash: [03-screens/splash.md](03-screens/splash.md). No image assets: the wordmark is text in Barlow Condensed, the dots are drawn.

## State illustrations (4 + 1)

Style: line art, 2 dp stroke at 96 dp, amber (`#FFB547`) strokes on a dark plate rounded square (`#14181C`, radius 16) in both themes, so they read as part of the signage system and need no light/dark variants. Source: one SVG each (kept with the design). Ship as PNG at 1x/2x/3x (96, 192, 288 px) in `assets/images/` through `flutter_gen`; `flutter_svg` is not a dependency and five small images do not justify adding it.

| Asset | Used by | Drawing |
|---|---|---|
| `state_empty_library` | Library empty (both segments use it; favorites adds a small heart) | A bus depot seen from the front: three empty bays (arches) and a ground line |
| `state_no_results` | Search no results, Home filtered empty | A bus stop pole with a sign showing a question mark |
| `state_offline` | Offline views | A bus front with a small cloud and a slash above it |
| `state_unavailable` | Detail 404, force update (deferred) | A destination plate reading "— —" (dashes, no words, so no localization) |
| `state_search_prompt` | Search prompt | A bus stop sign with a magnifier in place of the route number |

Each illustration is decorative (excluded from semantics); the state's title and body carry the meaning.

## Image treatment (mod screenshots)
- Always 16:9, `BoxFit.cover`, centered crop; never stretched, never letterboxed (except the full-screen viewer, which uses `contain` on black).
- Radius: 12 on cards (top corners only, the text block continues the card), 8 in rows and related cards, 0 in the Detail gallery on phones.
- Placeholder (loading, error, blocked host): `surfaceContainerHighest` with the type icon (`directions_bus_outlined`, `local_shipping_outlined`, `directions_car_outlined`, `map_outlined`) 40 dp in `outline`. Today `ModImage` always uses the bus icon; pass the type.
- Decode at display width (`memCacheWidth`, already done in `ModImage`).
- No overlays on images except: type plate (search, favorites), Downloaded pill (Home, optional), gallery counter (60% black scrim pill).
- Fade-in 150 ms when the image arrives (0 with reduced motion).

## Fonts
| File | License | Notes |
|---|---|---|
| `assets/fonts/BarlowCondensed-SemiBold.ttf`, `-Bold.ttf` | SIL OFL 1.1 | from Google Fonts / github.com/jpt/barlow; keep `OFL.txt` next to them |
| `assets/fonts/Barlow-Regular.ttf`, `-Medium.ttf`, `-SemiBold.ttf` | SIL OFL 1.1 | |

Bundle the fonts (do not use the `google_fonts` package at runtime: it downloads fonts on first run, which fails offline and on slow networks). Add the OFL notice to the app's licenses (`LicenseRegistry.addLicense`).

## Not needed
- No manufacturer logos or country flags (country is text).
- No onboarding art, no Pro artwork beyond the drawn plate.
