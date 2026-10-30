# Design tokens

Machine-readable copy: [tokens.json](tokens.json). Color values and every ratio below come from [tools/contrast.py](tools/contrast.py) (WCAG 2.x relative luminance); rerun it after any color change.

## Seed decision
No `ColorScheme.fromSeed`. `fromSeed` with an amber seed produces a muddy brown primary in light and moves our tuned neutrals. Build both schemes with the explicit `ColorScheme(...)` constructor from the tables below. `AppColors.seed` becomes the brand anchor `#FFB547` (documentation only).

## Color roles (Flutter `ColorScheme` field names)

| Role | Light | Dark | Used for |
|---|---|---|---|
| primary | `#9A4F00` | `#FFB547` | Filled buttons (Download, Import, Apply), active tab, selected nav icon, progress fill, links |
| onPrimary | `#FFFFFF` | `#2B1700` | Text/icons on primary |
| primaryContainer | `#FFDCB8` | `#5C3A00` | Pro card, tonal accents |
| onPrimaryContainer | `#2E1500` | `#FFDCB8` | |
| secondary | `#39607F` | `#A8C9E8` | Info icons, secondary accents (signage blue) |
| onSecondary | `#FFFFFF` | `#0D2A40` | |
| secondaryContainer | `#D3E5F7` | `#264259` | Nav indicator, selected chips/segments, Ad badge, offline banner, tonal buttons |
| onSecondaryContainer | `#0D2A40` | `#D3E5F7` | |
| tertiary | `#1A6B45` | `#8AD8A9` | "Downloaded" status, success checks |
| onTertiary | `#FFFFFF` | `#003920` | |
| tertiaryContainer | `#A6F2C4` | `#005231` | Downloaded pill, "You're Pro" card |
| onTertiaryContainer | `#002112` | `#A6F2C4` | |
| error | `#BA1A1A` | `#FFB4AB` | Error icons and text, destructive Delete button |
| onError | `#FFFFFF` | `#690005` | |
| errorContainer | `#FFDAD6` | `#93000A` | |
| onErrorContainer | `#410002` | `#FFDAD6` | |
| surface | `#F8F9FB` | `#111417` | Page background |
| onSurface | `#191C1F` | `#E2E5E9` | Main text |
| onSurfaceVariant | `#43474E` | `#C0C7CF` | Secondary text, meta, inactive icons |
| surfaceDim | `#D8DADD` | `#111417` | |
| surfaceBright | `#F8F9FB` | `#373A3E` | |
| surfaceContainerLowest | `#FFFFFF` | `#0B0E11` | |
| surfaceContainerLow | `#F2F3F6` | `#191C20` | Cards, rows, bottom sheet |
| surfaceContainer | `#ECEEF1` | `#1D2024` | Navigation bar, scrolled app bar, native ad cell |
| surfaceContainerHigh | `#E6E8EB` | `#272A2F` | Action bar, dialogs, search field |
| surfaceContainerHighest | `#E0E2E6` | `#32353A` | Skeletons, image placeholders, progress track |
| outline | `#73777F` | `#8A9199` | Outlined buttons, chip borders, text field border |
| outlineVariant | `#C3C7CF` | `#41474E` | Dividers, ad cell border, action bar top border |
| inverseSurface | `#2E3135` | `#E2E5E9` | Snackbars |
| onInverseSurface | `#EFF1F4` | `#2E3135` | |
| inversePrimary | `#FFB547` | `#9A4F00` | Snackbar action |
| shadow / scrim | `#000000` | `#000000` | |
| surfaceTint | `#9A4F00` | `#FFB547` | Set to `Colors.transparent` on cards and bars to keep surfaces neutral |

### Brand extension (`ThemeExtension<BusmodColors>`, same in both themes)

| Token | Value | Use |
|---|---|---|
| plateBg | `#14181C` | Destination plate background, splash, force-update |
| plateFg | `#FFB547` | Plate text and glyphs |
| plateFgMuted | `#C9CFD6` | Secondary text on the plate (splash tagline) |
| imageScrim | `#000000` at 60% | Behind text drawn on photos (gallery counter, type plate on image uses plateBg instead) |

## Contrast (computed)

Minimum 4.5:1 for text, 3:1 for non-text UI parts (WCAG 1.4.3, 1.4.11). All pass.

| Pair (fg on bg) | Use | Light | Dark | Min |
|---|---|---|---|---|
| onPrimary on primary | Filled button label (Download, Import) | 6.01 | 9.75 | 4.5 |
| onPrimaryContainer on primaryContainer | Tonal button, selected chip | 13.23 | 7.85 | 4.5 |
| onSecondaryContainer on secondaryContainer | Ad badge, selected nav indicator label | 11.47 | 8.14 | 4.5 |
| onTertiaryContainer on tertiaryContainer | Downloaded status pill | 13.14 | 7.16 | 4.5 |
| onErrorContainer on errorContainer | Error banner / file-missing pill | 13.26 | 7.24 | 4.5 |
| onError on error | Delete button | 6.46 | 7.72 | 4.5 |
| onSurface on surface | Body text | 16.24 | 14.63 | 4.5 |
| onSurface on surfaceContainerLow | Card text | 15.42 | 13.53 | 4.5 |
| onSurface on surfaceContainerHighest | Text on highest container | 13.19 | 9.74 | 4.5 |
| onSurfaceVariant on surface | Secondary text (manufacturer, meta) | 8.86 | 10.84 | 4.5 |
| onSurfaceVariant on surfaceContainerLow | Card meta text | 8.41 | 10.02 | 4.5 |
| onSurfaceVariant on surfaceContainerHigh | Meta text in action bar / sheet | 7.60 | 8.44 | 4.5 |
| primary on surface | Text buttons, active tab label, links | 5.71 | 10.52 | 4.5 |
| primary on surfaceContainerLow | Primary text on cards | 5.42 | 9.73 | 4.5 |
| primary on surfaceContainer | Primary on nav bar | 5.17 | 9.31 | 4.5 |
| secondary on surface | Secondary text accents | 6.32 | 10.72 | 4.5 |
| tertiary on surfaceContainerHigh | "Downloaded" status in action bar | 5.29 | 8.55 | 4.5 |
| error on surface | Inline error text | 6.13 | 10.89 | 4.5 |
| error on surfaceContainerHigh | Error status in action bar | 5.26 | 8.48 | 4.5 |
| onInverseSurface on inverseSurface | Snackbar text | 11.55 | 10.34 | 4.5 |
| inversePrimary on inverseSurface | Snackbar action | 7.44 | 4.76 | 4.5 |
| outline on surface | Outlined button / chip border (non-text) | 4.26 | 5.80 | 3.0 |
| outline on surfaceContainerLow | Borders on cards (non-text) | 4.05 | 5.37 | 3.0 |
| outline on surfaceContainerHigh | Text-field border in search bar (non-text) | 3.66 | 4.52 | 3.0 |
| primary on surfaceContainerHighest | Progress fill vs track (non-text) | 4.64 | 7.01 | 3.0 |
| onSurfaceVariant on secondaryContainer | Offline banner icon/text | 7.25 | 6.14 | 4.5 |
| plateFg on plateBg | Plate text | 10.15 | 10.15 | 4.5 |
| plateFgMuted on plateBg | Splash tagline | 11.37 | 11.37 | 4.5 |
| onSurface (dark) `#E2E5E9` on plateBg | Force-update title | 14.12 | 14.12 | 4.5 |
| white on 60% black scrim over a pure white photo (worst case) | Gallery counter | 5.74 | 5.74 | 4.5 |

Note: dark `inversePrimary` on `inverseSurface` (4.76) is the tightest pair; do not lighten `inverseSurface` in dark.

## Typography (`TextTheme`)

Families: **Barlow Condensed** (display) and **Barlow** (text), both SIL OFL 1.1, bundled under `assets/fonts/`. Fallback: Android `sans-serif-condensed` and Roboto.

| Style | Family | Size / line (sp) | Weight | Letter spacing | Used for |
|---|---|---|---|---|---|
| displaySmall | Condensed | 36 / 44 | 700 | 0 | Splash wordmark base (40 in plate) |
| headlineMedium | Condensed | 28 / 36 | 700 | 0 | Paywall headline |
| headlineSmall | Condensed | 26 / 32 | 600 | 0 | Detail title, dialog titles |
| titleLarge | Condensed | 24 / 30 | 600 | 0 | App bar titles, section headers, empty-state titles |
| titleMedium | Condensed | 19 / 24 | 600 | 0.1 | Card titles, type tabs |
| titleSmall | Barlow | 14 / 20 | 600 | 0.1 | Spec group titles, fact values, related card titles |
| bodyLarge | Barlow | 16 / 24 | 400 | 0.15 | Description, list tile titles |
| bodyMedium | Barlow | 14 / 20 | 400 | 0.2 | Bylines, dialog body, state-view body |
| bodySmall | Barlow | 12 / 16 | 400 | 0.3 | Fact labels, renewal note |
| labelLarge | Barlow | 15 / 20 | 600 | 0.2 | Buttons, summaries |
| labelMedium | Barlow | 12 / 16 | 600 | 0.4 | Card meta, chip counts |
| labelSmall | Barlow | 11 / 16 | 600 | 0.6 | Ad badge, status pills, plate on cards |

Rules: line height >= 1.2x size (Vietnamese stacked marks); `FontFeature.tabularFigures()` on sizes, counts, percentages, prices; uppercase only on plates (type names and the wordmark).

## Spacing (dp)

| Token | Value | Use |
|---|---|---|
| xxs | 2 | icon-to-text in dense meta |
| xs | 4 | |
| s | 8 | chip gaps, small stacks |
| m | 12 | card inner padding, card gap |
| l | 16 | page gutter, section padding |
| xl | 24 | between Detail sections, dialog padding |
| xxl | 32 | |
| xxxl | 48 | min touch target, empty-state top padding |

Flutter: `abstract final class AppSpacing { static const xxs = 2.0; ... }` in `lib/core/theme/`.

## Shape (radius, dp)

| Token | Value | Use |
|---|---|---|
| xs | 4 | plate, Ad badge, status pill |
| s | 8 | thumbnails in rows, chips, snackbar, related card image |
| m | 12 | cards, native ad cell (= `AdMetrics.radius`), Pro card |
| l | 16 | |
| xl | 28 | bottom sheet top corners, dialogs |
| full | stadium | buttons, search field, counter pill |

## Elevation
Material 3 tonal elevation, shadows off except dialogs/snackbars.

| Level | dp | Use |
|---|---|---|
| 0 | 0 | cards (on `surfaceContainerLow`) |
| 1 | 1 | bottom sheet |
| 2 | 3 | scrolled app bar, navigation bar, action bar |
| 3 | 6 | dialogs, snackbars, menus |

## Motion

| Token | Value | Use |
|---|---|---|
| short | 150 ms, standard (0.2, 0, 0, 1) | chip/segment selection, favorite toggle |
| medium | 250 ms, standard | action-bar state cross-fade, row removal, splash exit |
| long | 400 ms, Material default | page transitions |
| decelerate | (0.05, 0.7, 0.1, 1) | gallery page settle |
| progress | linear, at most 4 updates per second | download bar |

Reduced motion (`MediaQuery.disableAnimationsOf`): durations 0, splash dots static, no gallery auto-anything (there is none anyway).

## Icons
Material Icons (already bundled), outlined by default, filled for selected nav destinations and the favorite toggle. Sizes: 16 inline meta, 20 status lines and facts, 24 standard, 96 state illustrations. Full mapping in `tokens.json > icons.map`; add `error_outline`, `sd_card_alert`, `info_outline`, `sports_esports_outlined`, `check_circle` where the screens name them.

## Flutter mapping (theme setup)

| ThemeData field | Value |
|---|---|
| `colorScheme` | explicit `ColorScheme` light / dark above |
| `textTheme` | table above, `fontFamily` per style; apply `.apply(bodyColor: onSurface, displayColor: onSurface)` |
| `extensions` | `[BusmodColors(...)]` |
| `cardTheme` | color `surfaceContainerLow`, elevation 0, surfaceTint transparent, shape radius 12, margin zero, clip antiAlias |
| `filledButtonTheme` / `outlinedButtonTheme` / `textButtonTheme` | minimumSize `Size(64, 48)`, StadiumBorder, textStyle labelLarge |
| `chipTheme` | radius 8, labelStyle labelLarge, selected `secondaryContainer`, side `outline` when unselected; `materialTapTargetSize: padded` (48 touch) |
| `navigationBarTheme` | height 80, `surfaceContainer`, indicator `secondaryContainer`, labelTextStyle labelMedium |
| `tabBarTheme` | labelStyle titleMedium, indicatorColor `primary`, indicatorSize label, tabAlignment start, dividerColor `outlineVariant` |
| `appBarTheme` | `surface`, scrolledUnderElevation 3, surfaceTint transparent, titleTextStyle titleLarge, centerTitle false |
| `bottomSheetTheme` | `surfaceContainerLow`, showDragHandle true, top radius 28 |
| `dialogTheme` | `surfaceContainerHigh`, radius 28 |
| `snackBarTheme` | floating, `inverseSurface`, radius 8, actionTextColor `inversePrimary` |
| `segmentedButtonTheme` | selected `secondaryContainer`, min height 48 |
| `searchBarTheme` / `inputDecorationTheme` | filled `surfaceContainerHigh`, StadiumBorder, min height 56 |
| `progressIndicatorTheme` | linearTrackColor `surfaceContainerHighest`, linearMinHeight 4 |
| `visualDensity` | standard (no compact densities: keeps 48 dp targets) |
