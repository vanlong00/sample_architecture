# Busmod design: overview

Status: proposal, waiting for user sign-off (board feature `ux-design`). Date: 2026-10-30.
Source of truth for `fe-ui-redesign`. The visual mockups live in the Claude Design canvas linked from [README.md](README.md); when the canvas and these docs disagree, these docs win.

## What the app is for

One loop: **find a mod -> download it -> send it to PBSU with one tap**. Everything else (filters, search, library, favorites, settings, Pro) supports that loop. The content is in-game screenshots (16:9), so the screenshots carry the page and the chrome stays quiet.

Users: PBSU players on mid-range Android phones (360-412 dp wide), strong in Brazil, Vietnam and Eastern Europe. Languages: en and vi now, pt-BR next. Vietnamese and Portuguese diacritics must render everywhere, including condensed titles.

## Design principles

1. **Screenshots first.** Every mod surface leads with its 16:9 image at full content width. Text sits under the image, never on top of it (exception: the gallery counter, on a scrim).
2. **One primary action per screen.** On Detail it is the bottom action bar (Download / Import). Nothing else on Detail uses a filled button.
3. **Status is never color alone.** Every state has an icon and words (Downloaded, File not found, No longer available).
4. **Offline is normal.** Library works with no network; online screens say "You're offline" and point to Library.
5. **Honest ads.** Ads are labelled "Ad", never look like a mod, never sit inside the Download -> Import path. Pro removes ads and nothing else, and the copy says so.
6. **Scales to 200%.** Every layout here has a written 200% text-scale rule (see [06-accessibility.md](06-accessibility.md)).

## Identity direction

Three options were weighed.

| Option | What it looks like | For | Against |
|---|---|---|---|
| **A. Destination board (recommended)** | Photo-first catalog. One signature element taken from bus destination signs: a small dark "plate" with amber condensed caps (type badge, splash, launcher icon). Amber accent like an LED sign, cool slate neutrals, Barlow Condensed for titles (a face drawn after highway signage). | Fits a bus-game accessory without copying anyone; amber reads well in dark; condensed titles fit the long mod names (average 51 characters, longest 67, measured on the 609-mod catalog) in 2 lines | Amber in light mode has to be darkened to burnt amber to pass contrast, so light is a little less "LED" |
| B. Calm neutral catalog | Blue-grey Material 3, system font, no signage cues | Zero risk, lowest effort | Generic; nothing ties it to buses or PBSU; looks like the sample app it replaces |
| C. PBSU game skin | Copy the game's menus and colors | Instant familiarity for players | Third-party look we do not own; breaks when the game updates; implies an official link that does not exist |

**Recommendation: A.** Signage cues are limited to three places (the plate, the amber accent, the condensed title face). No LED dot-matrix text in the UI: it is hard to read at small sizes and with Vietnamese marks. The dot-matrix motif appears only in the launcher icon and splash, as a graphic.

## Light and dark

**Recommendation: both themes complete and equal in quality, dark designed first; the app follows the system setting by default** (`ThemeMode.system`, already the Settings default). Most players use dark, and amber was chosen for dark, but daytime use outdoors needs a proper light theme. The plate and splash are dark in both themes on purpose (a destination sign is always dark).

Alternative: open in dark on first run regardless of system. Cheaper to test but ignores the user's system choice.

## Fonts

| Role | Font | License | Vietnamese | Portuguese | Bundled weights |
|---|---|---|---|---|---|
| Display: screen titles, mod titles, tabs, plate | **Barlow Condensed** | SIL OFL 1.1 (Google Fonts) | Yes (full Vietnamese set) | Yes | 600, 700 |
| Text: body, labels, buttons | **Barlow** | SIL OFL 1.1 | Yes | Yes | 400, 500, 600 |

Why Barlow: it is a grotesk drawn after California highway signs, so it carries the transit cue, and it ships a complete Vietnamese character set (precomposed and stacked marks). One superfamily keeps the APK small (5 static TTFs, about 0.5 MB in total; or the variable fonts).

Other free candidates checked: Saira Condensed (OFL, Vietnamese yes; more techno, less signage), Encode Sans Condensed (OFL, Vietnamese yes; wider), Roboto Condensed (Apache 2.0, Vietnamese yes; already on most Android phones as `sans-serif-condensed`).

**Safe fallback:** if the bundled fonts are dropped, use the Android system families: `sans-serif-condensed` (Roboto Condensed) for display and Roboto for text. All layouts here work with either, because sizes are set in the type scale, not tuned to Barlow's widths.

Rules: line height at least 1.2x font size (stacked marks such as "Ẫ" clip below that); uppercase only on the plate; tabular figures for sizes, counts and percentages.

## Name usage

"Busmod" is a placeholder (spec §11). It appears only in `appTitle`, `proTitle` ("Busmod Pro"), `proHeadline` ("Busmod without ads"), the plate wordmark (Home app bar and splash, drawn from `appTitle`) and the launcher icon label, so a rename touches three strings and the icon. Screens never say "Busmod" in body copy; they say "the app" only when needed. PBSU is always written as text ("PBSU" or "Proton Bus Simulator Urbano"), never as a logo or game artwork.

## What is provisional

- App name and launcher icon (placeholder concept in [08-assets.md](08-assets.md)).
- Navigation: 4 tabs with a merged Library (recommended) vs the current 5 tabs. Both are specified.
- Pro price and plan names (from Play Console).
- Force-update screen: deferred with Firebase Phase 2; spec only in [03-screens/force-update.md](03-screens/force-update.md).
- Remote-Config-driven ad cadence: designed with today's defaults (first ad after 3 cards, then every 10).
- pt-BR copy is a draft for a native speaker to review.

## Files

| File | Content |
|---|---|
| [01-spec9-answers.md](01-spec9-answers.md) | Answers to the 13 designer questions of spec §9 |
| [02-flows.md](02-flows.md) | User flows |
| [03-screens/](03-screens/) | One file per screen with layout, states, 200% rules, TalkBack |
| [04-tokens.md](04-tokens.md), [tokens.json](tokens.json) | Color roles with computed contrast, type, spacing, shape, elevation, motion, icons |
| [05-components.md](05-components.md) | Components mapped to the existing widgets |
| [06-accessibility.md](06-accessibility.md) | Checklist per screen |
| [07-copy.md](07-copy.md) | Copy deck en / vi / pt-BR draft |
| [08-assets.md](08-assets.md) | Icon, splash, illustrations, image treatment, fonts |
| [09-handoff.md](09-handoff.md) | Build order and open items |
| [tools/contrast.py](tools/contrast.py) | Recomputes every contrast ratio and rewrites the color part of tokens.json |
