# Handoff to `fe-ui-redesign`

Starts only after the user signs off the design (board gate). Work from these docs; the Claude Design canvas is a picture of them.

## Sign-off decisions (user)

| Decision | Recommended default | Alternative |
|---|---|---|
| Identity direction | A. Destination board (plate + amber + Barlow Condensed) | B. Calm neutral catalog |
| Dark-first vs equal | Both complete, dark designed first, follow system | Open in dark by default |
| Navigation | 4 tabs with Library (Downloaded + Favorites segments) | Keep 5 tabs |
| Card layout | Single column 16:9 on phones (2-3 columns from 600 dp) | 2-column compact grid |
| Pro prominence | Settings Pro card + "Remove ads" on in-list ads | Settings only, or + one-time sheet after the 3rd download |
| Banner | None in v1 | Adaptive banner on Home and Search above the nav bar |

## Build order

1. **Theme and tokens** (`lib/core/theme/**`): explicit light/dark `ColorScheme`, text theme with bundled Barlow fonts (`pubspec.yaml` fonts, OFL license registered), component themes from [04-tokens.md](04-tokens.md#flutter-mapping-theme-setup), `BusmodColors` extension, `AppSpacing`. Golden test: a token sheet widget in light and dark.
2. **Shared components** (`lib/core/widgets/**`): `ModPlate`, `StateView` (replaces `ErrorView` and the ad-hoc empties), `SkeletonCard` / `SkeletonRow`, `OfflineBanner`, snackbar update (`showAppSnackBar` error variant + optional action). Dialog updates (`showConfirmDialog` icon slot, filled destructive, stacked actions at large text).
3. **Shell**: navigation per sign-off; label behaviour at large text; NavigationRail >= 840 dp. If Library is chosen: `LibraryPage` with segments hosting the existing Downloaded and Favorites bodies; router keeps `/downloads` and `/favorites` as redirects to `/library?tab=` so deep links survive.
4. **Mod card + list**: `ModCardTile` variants, `ModPagedList` spacing and grid columns, native ad cell restyle and text-scaled height (shared file with `fe-a11y-textscale`; coordinate or do it here).
5. **Home**: plate wordmark, scrollable tabs, wrapping toolbar, `ActiveFilterBar`, all states.
6. **Filter sheet**: draggable sheet, counts, Show all, footer.
7. **Detail**: gallery counter + `GalleryViewer`, `DetailFacts`, specs restyle, description collapse, action bar states (status line, sizes, failure variants), semantics sort keys.
8. **Search**: prompt, type plate on results, no-results action, announcements.
9. **Library**: Downloaded row redesign (missing variant), Favorites as card variant with Undo.
10. **Settings and Paywall**: Pro card, theme segmented button, About section, paywall layout and copy; allow `/pro` from the ad "Remove ads" link.
11. **Splash, launcher icon, system splash**, state illustrations.
12. **Copy**: apply [07-copy.md](07-copy.md) to `app_en.arb` and `app_vi.arb` (new, changed, dropped keys), run `flutter gen-l10n`.

Every screen state in the screen files gets a widget test; key screens get goldens in light, dark and 2.0x text scale (Vietnamese).

## Tokens the Flutter team needs
All of [tokens.json](tokens.json): `color.light`, `color.dark`, `color.signage`, `typography.scale`, `spacing`, `radius`, `elevation`, `motion`, `icons.map`, `layout`.

## Components the Flutter team needs
New: `ModPlate`, `StateView`, `SkeletonCard`, `SkeletonRow`, `OfflineBanner`, `ActiveFilterBar`, `DetailFacts`, `GalleryViewer`, `LibraryPage` (4-tab option).
Changed: `AppTheme`, `ShellScaffold`, `ModCardTile`, `ModPagedList`, `NativeAdView` / `MoreAppHouseAd` / `AdMetrics`, `DetailGallery`, `DetailSpecs`, `DetailHtml`, `DownloadCta`, `DownloadedTile`, `FavoriteTile` (folds into `ModCardTile`), `showFilterSheet`, `showPbsuMissingDialog`, `showConfirmDialog`, `showAppSnackBar`, `SettingsPage`, `PaywallPage`, `SplashPage`, `ModImage` (type-aware placeholder, fade-in).
Kept: `LoadMoreFooter`, `DetailChips`, `DetailRelated`, `FavoriteButton`, `runImport`, `ImportGuard`.

## Data the design needs (check with `fe-contract-align`)
- Compact download counts need only `stats.downloads` (exists).
- Map facts need `map.region`, `map.routesCount`, `map.busStopsCount` on the detail model and, for the card meta, on the card projection. Many maps leave them null; UI hides empty fields.
- Spec group keys from the server are `compatibility`, `technical`, `feature` (lowercase); the app maps them to localized titles. Unknown group keys show the raw key in title case.
- Some mods repeat a spec row (for example "File size" in both Technical and Features); the design hides exact duplicates within a group only.
- `download.sizeBytes` is null until mirroring runs; every size slot must handle null (labels drop the size).

## Open items
1. App name and final icon (placeholder concept only).
2. Reference apps the user likes or dislikes (spec §9 Q1 had none); the direction may shift after that.
3. pt-BR copy review by a native speaker before Portuguese ships.
4. Pro price, plan name and whether a yearly plan exists (paywall shows one monthly plan).
5. Remote Config ad cadence (Phase 2); design assumes first ad after 3 cards, then every 10.
6. Force-update gate: deferred with Firebase Phase 2 ([force-update.md](03-screens/force-update.md)).
7. Whether "Open Library" is allowed from the force-update screen (Phase 2).
8. The real `/pro` entry from ads changes the rule "`/pro` only from Settings" in `CLAUDE.md`; update that note when building.
9. Illustrations and the launcher glyph need drawing (SVG sources); the canvas shows their placement, not final art.
