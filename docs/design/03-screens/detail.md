# Detail (`/mod/:sourceId`)

Purpose: show one mod well enough to decide, then download and send it to PBSU.
Today: `ModDetailPage`, `DetailGallery`, `DetailChips`, `DetailSpecs`, `DetailHtml`, `DetailRelated`, `DownloadCta`, `FavoriteButton`.

## Layout (360 x 800 dp phone, top to bottom)

| Region | Size | Content |
|---|---|---|
| App bar | 64 | Back (48), title (titleLarge, 1 line, fades in once the in-page title scrolls under the app bar), Favorite toggle (48). Background `surface`; `surfaceContainer` when scrolled. |
| Gallery | full width, 16:9 (360 x 203) | `PageView` of 1-4 screenshots, no padding, no radius. Counter pill bottom-right "1 / 4" (labelMedium, white on 60% black scrim, radius full, 8 dp from edges). Page dots removed (counter replaces them). Tap opens the full-screen viewer (pinch zoom, swipe, close). |
| Title block | padding 16 | Title: headlineSmall (Barlow Condensed 26/32), no line limit. 8 dp under it: chips row. |
| Chips row | wraps, gap 8 | Assist chips (not tappable in v1, so rendered as plain `Chip`, height 32): body type, manufacturer, country. Maps: "Map" type plate + category. |
| Quick facts | 16 dp top, 3 equal columns, height 64 | Icon 20 + value (titleSmall, tabular) + label (bodySmall, onSurfaceVariant). Vehicles: Size "60 MB", Format "ZIP", Downloads "17.4K". Maps: Region, Routes, Bus stops (missing fields drop out; 0 left = row hidden). Separated by 1 dp `outlineVariant` vertical rules. |
| Specs | 24 dp top | Section header "Specifications" (titleLarge). One block per group in server order: group title (titleSmall, `primary`) "Compatibility" / "Technical" / "Features", then label/value rows (bodyMedium; label `onSurfaceVariant` 40% width, value `onSurface` 60%, value left-aligned, wraps). Row min height 40, 1 dp `outlineVariant` divider between rows. Duplicate rows (same key and value in the same group) are hidden. |
| Description | 24 dp top | Header "Description" (titleLarge). HTML (bodyLarge) collapsed to 6 lines with a bottom fade; "Read more" text button (48 high). Expanded: "Show less". |
| More from | 24 dp top | "More from Mercedes-Benz" (titleLarge) or "More like this". Horizontal list of compact cards: 200 dp wide, 16:9 image radius 8, title titleSmall 2 lines. Gap 12, side padding 16. |
| Bottom space | 24 | So the last content clears the action bar. |
| **Action bar** | fixed, min 80 + system inset | `surfaceContainerHigh`, 1 dp `outlineVariant` top border, padding 16 / 12. Content per state below. |

Content priority if space is short: gallery > action bar > title > quick facts > specs > description > related.

Tablet (>= 600 dp): content column max 720, centered; gallery keeps 16:9 inside that column with radius 12.

## Action bar state machine

The bar never disappears for a downloadable mod. All buttons are 48 dp high, full width unless noted, `StadiumBorder`. A status line (icon 20 + bodyMedium) sits above the button when the state has something to say. State changes cross-fade (250 ms, standard easing; 0 ms with reduced motion).

| State (`ModDownloadState`) | Status line | Button(s) | TalkBack |
|---|---|---|---|
| Checking | none | Filled, disabled, 20 dp spinner centered, no text | "Checking download status" |
| Idle (no file) | none | Filled **Download · 60 MB** (icon `download`). Size omitted when unknown: **Download** | "Download, 60 megabytes" |
| Downloading, size known | none; a 4 dp `LinearProgressIndicator` along the bar's top edge (track `surfaceContainerHighest`, fill `primary`) | Left: "Downloading 42%" (titleSmall, tabular) over "25 of 60 MB" (bodySmall). Right: Outlined **Cancel** (min 96 wide) | Live region, announces every 10%: "Downloading, 40 percent". Cancel: "Cancel download" |
| Downloading, size unknown | indeterminate bar | "Downloading…" + Cancel | "Downloading" once |
| Downloaded | `check_circle` in `tertiary` + "Downloaded · 60 MB" | Filled **Import to PBSU** (icon `input`) | "Downloaded. Import to PBSU, button" |
| Importing (guard) | as Downloaded | Filled, disabled, spinner | "Sending to PBSU" |
| File missing | `report_outlined` in `error` + "File not found on this device" | Filled **Download again** | status then button |
| Failed, network, no previous copy | `error_outline` in `error` + "Download stopped. Check your connection." | Filled **Retry** | live region announces the status |
| Failed, network, previous copy kept | same status | Row: Filled **Import to PBSU** (flex 1) + Outlined **Retry** (flex 1). At 200% text: stacked, Import first | |
| Failed, storage full | `sd_card_alert` in `error` + "Not enough space. Free up 60 MB and try again." | Filled **Retry** | |
| Failed, 404 | `block` in `onSurfaceVariant` + "This mod is no longer available" | none; bar height shrinks to the status line | announced once |
| Check failed (local storage error) | `error_outline` + "Couldn't check this download." | Filled **Retry** | |

Not downloadable (no `storageUrl`; should not happen because the server hides those): no bar.

### Import results (from any Import button)

| Outcome | Feedback |
|---|---|
| sent | Snackbar "Mod sent to PBSU" (4 s) |
| chooserOpened | Snackbar "Pick PBSU in the list to import this mod" (6 s) |
| notInstalled | PBSU-missing dialog ([dialogs.md](dialogs.md)) |
| failed | Error snackbar "PBSU couldn't open this mod. Try again." with `error_outline` icon (6 s) |
| fileMissing | Bar moves to File missing; error snackbar "File not found on this device" |

### Interstitial
Non-Pro tap on Download (and Retry, Download again) may show an interstitial first, under the existing frequency cap. The bar shows the disabled spinner until the ad closes, then Downloading. Never an ad on Import, on Cancel, or when leaving the page.

## Page states

| State | What shows |
|---|---|
| Loading | App bar (back only) + skeleton: 16:9 block, 2 title lines, 3 chip pills, 3 fact blocks; shimmer off (static `surfaceContainerHighest` blocks; no motion cost on mid-range phones). No action bar. |
| Loaded | as above |
| Offline (no cache) | Offline view: illustration, "You're offline", "Check your connection. Your downloaded mods still work in Library.", Retry + Open Library. If the mod is downloaded, a tonal **Import to PBSU** shows under it (import needs no network). |
| Server error | Error view "Something went wrong on our side. Try again in a moment." + Retry |
| 404 / not available | "Not in service" illustration, "This mod is no longer available", "It was removed from the catalog. If you downloaded it, it's still in Library." No Retry. Button "Open Library" if a local copy exists. |
| No images | single 16:9 placeholder: `surfaceContainerHighest` with the type icon 48 dp `outline` |
| Long title (67 chars) | wraps, no limit |
| Empty specs / description / related | section hidden entirely, headers included |

## 200% text scale
- App bar title stays 1 line, ellipsis; back and favorite stay 48 dp.
- Chips wrap to more rows.
- Quick facts: at scale > 1.3 switch from 3 columns to a vertical list (icon, label, value in one row each).
- Spec rows: at scale > 1.3 label above value (both full width).
- Action bar: status line wraps; two-button rows stack vertically; Downloading row stacks the text above a full-width Cancel. The bar may grow to ~200 dp; the page body keeps scrolling behind it. Cap: if the bar would exceed 40% of the viewport height, the status line moves into the scroll content above the description and the bar keeps only buttons.
- Description collapse threshold stays 6 lines (taller at 2x, that is fine).

## TalkBack order
1. Back. 2. Favorite ("Add to favorites" / "Remove from favorites", toggled state). 3. Gallery ("Screenshot 1 of 4, BMC Procity 12 LF"; custom semantics actions "Next screenshot" / "Previous screenshot"). 4. Title (header). 5. Chips, read as one node: "SingleDecker, BMC, Turkey". 6. Quick facts, one node each: "Size, 60 MB". 7. **Action bar** (status line, then buttons). 8. Specs header, each group header, rows ("Platforms: Android, Windows"). 9. Description header, text, Read more. 10. Related header and cards.

The action bar is drawn last but read 7th: wrap page regions in `Semantics(sortKey: OrdinalSortKey(n))` so a TalkBack user reaches Download right after the facts instead of after the whole description.

## Ads
Interstitial only (above). No native, no banner on Detail.
