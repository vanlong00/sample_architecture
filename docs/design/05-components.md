# Components

Mapped to the widgets that exist today. "Keep" = no visual change beyond the theme; "Change" = restyle or new behaviour; "New" = does not exist yet. Most changes come for free from the theme in [04-tokens.md](04-tokens.md#flutter-mapping-theme-setup); this list covers what the theme cannot do.

| Component | Today | Verdict | What changes |
|---|---|---|---|
| Theme | `AppTheme`, `AppColors` (seed `#3366FF`) | Change | Explicit color schemes, Barlow text theme, component themes, `BusmodColors` extension, `AppSpacing` |
| Shell | `ShellScaffold` (5 destinations) | Change | 4 destinations (Library) or keep 5; large-text label rule; NavigationRail at >= 840 dp |
| Plate | none | **New** | `ModPlate` |
| Mod card | `ModCardTile` | Change | Content and variants below |
| Paged list | `ModPagedList` | Change | Gap 12, padding 16; grid columns by width; uses `StateView` for empty |
| Native ad cell | `NativeAdView`, `MoreAppHouseAd`, `AdMetrics` | Change | Ad badge style, "Remove ads" link, text-scaled height |
| Load-more footer | `LoadMoreFooter` | Keep | Copy "Couldn't load more" |
| Skeletons | `LoadingView` (spinner) | **New** `SkeletonCard`, `SkeletonRow` | Static blocks; `LoadingView` stays for small areas |
| State view | `ErrorView`, ad-hoc `Center(Text)` empties | **New** `StateView` replaces both | [dialogs.md](03-screens/dialogs.md#shared-state-view-stateview-replaces-errorview--the-ad-hoc-empty-texts) |
| Offline banner | none | **New** `OfflineBanner` | |
| Filter sheet | `showFilterSheet`, `_FilterSection` | Change | Drag handle, type plate, chip counts as trailing label, Show all, footer layout |
| Active filter chips | none (only a badge) | **New** `ActiveFilterBar` | Row of `InputChip`s + Clear filters |
| Sort + filter toolbar | `_Header` in `ModListTab` | Change | `Wrap`, "Filters · 2" label |
| Gallery | `DetailGallery` (+ dots) | Change | Counter pill instead of dots; tap -> `GalleryViewer` (**New**, full screen, pinch zoom) |
| Detail chips | `DetailChips` | Keep | Type chip removed for vehicles (shown by plate only in mixed lists) |
| Quick facts | none | **New** `DetailFacts` | 3 facts, map variant, vertical at large text |
| Specs | `DetailSpecs` | Change | Group titles localized, divider rows, stacked rows at large text, duplicate rows hidden |
| Description | `DetailHtml` | Change | 6-line collapse with Read more |
| Related | `DetailRelated` | Keep | Spacing tokens only |
| Action bar | `DownloadCta` in a `Material(elevation: 3)` | Change | State table in [detail.md](03-screens/detail.md#action-bar-state-machine): status line, size in label, progress layout, failure variants |
| Import runner | `runImport`, `ImportGuard` | Keep | Copy updates only |
| Downloaded row | `DownloadedTile` | Change | Thumbnail 120, Delete icon neutral, missing variant with Download again, vertical at large text |
| Favorite row | `FavoriteTile` | Change | Becomes `ModCardTile.favorite` variant |
| Favorite toggle | `FavoriteButton` | Keep | Announce on toggle |
| Library segments | none | **New** (4-tab option) | `SegmentedButton` in a `LibraryPage` |
| Dialogs | `showPbsuMissingDialog`, `showConfirmDialog` | Change | Icon slot, copy, filled destructive button, stacked actions at large text |
| Snackbar | `showAppSnackBar` | Change | Error variant = inverse surface + icon (not red container); optional action (Undo) |
| Settings rows | `_ThemeSection`, `_ProTile`, ... | Change | Pro card, theme segmented button |
| Paywall | `PaywallPage` | Change | Layout in [paywall.md](03-screens/paywall.md) |
| Splash | `SplashPage` | Change | Plate wordmark on plate background, LED dots |

## Specs

### ModPlate (new)
The destination-sign element. `Container` with `plateBg`, radius 4, padding 6 h / 2 v, text `labelSmall` uppercase `plateFg`, letter spacing 1.2, Barlow Condensed 700.
Variants: `type` (BUS, TRUCK, CAR, MAP; on card images top-left, 8 dp inset), `wordmark` (BUSMOD, 28 high in app bar; 40 sp on splash with amber 40% outline), `hero` (paywall, 120 high).
Semantics: `type` plate reads as the type name ("Bus"), not the caps string; `wordmark` reads "Busmod".

### ModCardTile
States: default, pressed (ripple on whole card), focused (2 dp `primary` outline, keyboard/switch access).
Variants:
- `browse` (Home): image, title, byline, meta.
- `search`: `browse` + type plate on image.
- `favorite`: image + type plate, title, heart toggle; no byline/meta.
- Map content: byline region, meta "Urban Map · 1 route · 7 stops".
- Downloaded pill on image (optional, see [home.md](03-screens/home.md)).
Slots: image (16:9, radius 12 top), text block padding 12, trailing slot (heart).
Download count format: `NumberFormat.compact(locale)` ("17K" / "17 N" / "17 mil"), full number in the semantics label.
Large text: title maxLines 3 at > 1.5x, meta in a `Wrap`.

### Native ad cell
- Container: same width as cards, radius 12, `surfaceContainer`, 1 dp `outlineVariant` border (cards have none), so it reads as different from mod cards.
- Top row: **Ad badge** (labelSmall, the localized `adLabel`: "Ad" / "Quảng cáo" / "Anúncio", sentence case, never uppercased), `secondaryContainer` / `onSecondaryContainer`, radius 4; right side TextButton "Remove ads" (labelMedium, 48 touch) -> `/pro`. Hidden for Pro users (they see no ads).
- Media 16:9, then icon + headline + body, CTA tonal button (the ad network's CTA text).
- Height: `NativeAdView.heightOf(template, width)` today uses fixed `AdMetrics.mediumChrome = 128`. Change to `width * 9/16 + mediumChrome * textScaler.scale(1)` clamped to `[1, 2]` scale, so labels never clip at 200%; native layouts get the scaled values through `nativeAdOptions`.
- House ad fallback: same container and badge.
- TalkBack: container label "Advertisement" first, then the ad's own content.

### Action bar (DownloadCta)
See [detail.md](03-screens/detail.md#action-bar-state-machine). Component-level rules:
- One `AnimatedSwitcher` around the state body, key = state type, 250 ms fade + size.
- Height not fixed: min 80, grows with text.
- Buttons full width; two-button rows use `Expanded` and switch to a `Column` when `MediaQuery.textScalerOf(context).scale(1) > 1.3`.
- Progress semantics: one live region, announces in 10% steps (keep today's behaviour).

### StateView (new)
Props: `illustration` (enum), `title`, `body`, `primaryAction`, `secondaryAction`. Layout in [dialogs.md](03-screens/dialogs.md). Used by: Home empty/offline/error, Search prompt/no results/offline/error, Detail offline/404/error, Library empties and error, Filter sheet error (compact variant: no illustration).

### Skeletons (new)
`SkeletonCard` (16:9 block + 3 bars at 90%, 60%, 40% width) and `SkeletonRow` (thumb + 2 bars) in `surfaceContainerHighest`, radius as the real thing. No shimmer animation (cheaper on mid-range phones, nothing to reduce for reduced motion). Semantics: one "Loading" label per screen, not per block.

### DetailFacts (new)
3 cells, `IntrinsicHeight` row with vertical dividers; each cell icon 20 `onSurfaceVariant`, value titleSmall, label bodySmall. Hide cells with no value; hide the row when none remain. Large text: column of `ListTile`-like rows.

### ActiveFilterBar (new)
Horizontal `ListView` of `InputChip` (label = option name, delete icon tooltip "Remove filter {name}"), trailing `TextButton` "Clear filters". Height 48. Hidden with no active filter.

### GalleryViewer (new)
Full-screen route, black background in both themes, `InteractiveViewer` per page, counter top-center, Close (48, white icon on 60% scrim) top-left. Back closes. TalkBack: "Screenshot 2 of 4", next/previous actions.

### Dialogs and snackbars
See [dialogs.md](03-screens/dialogs.md).
