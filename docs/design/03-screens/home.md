# Home (`/home`)

Purpose: browse the catalog by type, sorted and filtered, and open a mod.
Today: `HomePage`, `ModListTab`, `ModPagedList`, `ModCardTile`, `NativeAdView`, `LoadMoreFooter`.

## Layout (360 x 800 dp)

| Region | Size | Content |
|---|---|---|
| App bar | 64 | Leading: the **plate wordmark** "BUSMOD" (plate component, 28 high). No actions. `surface`, `surfaceContainer` when scrolled under. |
| Type tabs | 48 | `TabBar(isScrollable: true, tabAlignment: TabAlignment.start)`, labels in titleMedium (Barlow Condensed 19): Bus, Truck, Car, Map. Indicator 3 dp `primary`, label `primary` when selected, `onSurfaceVariant` otherwise. Side padding 8. |
| Toolbar | 56, padding 16 h | Left: sort chips `ChoiceChip` "Popular", "Newest" (gap 8). Right: **Filters** button (`TextButton.icon`, icon `tune`); with active filters it reads "Filters · 2" and the icon gets a `primary` dot badge. |
| Active filter chips | 48 (only when a filter is set) | Horizontal scroll: `InputChip` per active filter ("Mercedes-Benz", delete icon labelled "Remove filter Mercedes-Benz"), last item TextButton "Clear filters". |
| List | rest | Cards, gap 12, padding 16 h / 4 top / 16 bottom. Native ad cells inserted (see Ads). `RefreshIndicator`. |
| Navigation bar | 80 | 4 destinations (see shell below). |

### Mod card (`ModCardTile`, see [05-components.md](../05-components.md))
328 dp wide on a 360 phone: 16:9 image (328 x 185, top corners radius 12) then padding 12: title titleMedium 2 lines; byline bodyMedium `onSurfaceVariant` "Mercedes-Benz · Germany" 1 line; meta labelMedium `onSurfaceVariant` "SingleDecker · 60 MB · 11.7K downloads" with `download` icon 16 before the count. Maps: byline is the region ("São Paulo, Brazil"), meta "Urban Map · 1 route · 7 stops". Card total about 300 dp; 1.8 cards visible above the nav bar.

A downloaded mod shows a small status pill on the image, bottom-left, 8 dp inset: `tertiaryContainer` with `check_circle` 16 + "Downloaded" (labelSmall). Needs the set of downloaded `sourceId`s at list level (`DownloadedCubit` already holds the records); if that costs more than a selector, ship without the pill. Favorites are not marked on Home cards.

### Shell (navigation bar)
4 destinations: Home (`home_outlined`/`home`), Search (`search`), Library (`video_library_outlined`/`video_library`), Settings (`settings_outlined`/`settings`). `NavigationBar` height 80, indicator `secondaryContainer`. No badges in v1.
5-tab option: Home, Search, Downloaded (`download_outlined`), Favorites (`favorite_border`), Settings.

## Interactions
- Swipe between type tabs or tap a tab; each tab keeps scroll, sort and filter (kept alive, as today).
- Tap tab already selected: scroll that list to top.
- Sort chip: reload with the new order, jump to top.
- Filters: open [filter-sheet.md](filter-sheet.md).
- Card tap: Detail. Long press: none in v1.
- Load more 3 cards before the end (existing threshold).

## States

| State | What shows |
|---|---|
| Loading (first page) | Toolbar visible, filters button disabled; 2 skeleton cards (16:9 block + 3 text bars, `surfaceContainerHighest`, no shimmer) |
| Loaded | cards + ads |
| Loading more | footer 24 dp spinner, 16 dp vertical padding |
| Load-more error | footer "Couldn't load more" + TextButton.icon Retry (48) |
| Refresh failing with cards on screen | cards stay; snackbar with the mapped error |
| Empty with filters | illustration (no results), "No mods match these filters", "Try another body type or manufacturer.", FilledTonal "Clear filters" |
| Empty without filters (type has 0 mirrored mods) | "No mods here yet", "Check back soon." no action |
| Offline, no cache | offline view: illustration, "You're offline", "Check your connection. Your downloaded mods still work in Library.", Filled "Retry" + Text "Open Library" |
| Offline with cached list | list + slim banner under the toolbar: `cloud_off_outlined` 16 + "Offline. Showing saved results." (`secondaryContainer`, 40 high) |
| Server error | error view "Something went wrong on our side. Try again in a moment." + Retry |

## 200% text scale
- App bar: plate wordmark scales with text up to 1.5x then stays (it is a logo).
- Type tabs: scrollable already; labels never truncate; the bar grows to fit (tab height = text height + 24).
- Toolbar becomes a `Wrap`: chips on one run, Filters button on the next run when it does not fit.
- Card: title max 3 lines at > 1.5x, byline 2 lines, meta wraps (Wrap, not Row). Image unchanged.
- Native ad cell: height computed with the text scaler (see [05-components.md](../05-components.md#native-ad-cell)).
- Navigation bar: see [06-accessibility.md](../06-accessibility.md#navigation-bar-at-large-text).

## TalkBack order
App bar wordmark ("Busmod", header) -> type tabs ("Bus, tab 1 of 4, selected") -> sort chips ("Popular, selected") -> Filters ("Filters, 2 active") -> active chips -> cards (one node each: "BMC Procity 12 LF, Turkish Low-Floor City Bus Mod. BMC, Turkey. SingleDecker, 60 MB, 17,462 downloads. Downloaded") -> ad cells ("Advertisement" container label first) -> nav bar.

## Ads
- Native ad cell after the 3rd card, then every 10 cards (`AdListPlacement` defaults; Remote Config may change it later).
- Same width and radius as a card; distinct surface and an "Ad" badge; "Remove ads" link opens Pro.
- Pro users: no ad cells, no gaps.
- If no ad fills: the house ad of the same size, or the cell collapses (no blank card).
