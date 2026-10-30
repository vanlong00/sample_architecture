# Search (`/search`)

Purpose: find a mod by name, manufacturer, city or keyword, optionally within one type.
Today: `SearchPage`, `_SearchField`, `_TypeChips`, `_SearchBody`, `SearchBloc` (300 ms debounce).

## Layout (360 x 800 dp)

| Region | Size | Content |
|---|---|---|
| Search bar | 72 (56 field + 8/8 padding), padding 16 h | `SearchBar`-style field, radius full, `surfaceContainerHigh`, leading `search` icon, hint "Search mods", trailing Clear (48, only with text). Autofocus on first open of the tab, not when returning to it. |
| Type chips | 48 | Horizontal scroll: "All types", "Bus", "Truck", "Car", "Map" (`ChoiceChip`). |
| Body | rest | Prompt, results list, or a state view. |
| Navigation bar | 80 | |

Results use the same `ModCardTile` as Home, with one addition: the **type plate** ("BUS", "MAP") on the image top-left, because results mix types. No native ads in search results (short, intent-driven lists).

## States

| State | What shows |
|---|---|
| Prompt (empty field) | Centered block, 96 dp search illustration (bus stop sign), title "Find a bus, truck, car or map" (titleLarge), body "Try a model, a manufacturer or a city, like Citaro or São Paulo." (bodyMedium `onSurfaceVariant`). No recent searches in v1. |
| Loading | 2 skeleton cards |
| Results | cards, load more like Home. No total count: the search API returns pages, not a total. |
| No results | illustration, "No mods found for “citaro g”", "Check the spelling or try fewer words." If a type chip is selected: Tonal button "Search all types". |
| Error | error view with mapped message + Retry |
| Offline | offline view: "You're offline", "Search needs a connection. Your downloaded mods are in Library." + Retry + Open Library |
| Refresh fails with results | results stay, snackbar (as today) |

## 200% text scale
- Field grows in height; hint may wrap to 2 lines; Clear stays 48.
- Type chips row scrolls (already horizontal).
- Prompt and empty texts wrap; illustration shrinks to 64 dp when scale > 1.5 so the text stays above the keyboard.

## TalkBack order
Search field ("Search mods, edit box") -> Clear ("Clear search") -> type chips -> cards -> nav bar. After each settled search an announcement (`SemanticsService.sendAnnouncement`) says "Results updated" or "No mods found for citaro g"; nothing while typing.

## Ads
None on Search. Interstitial rules on Detail still apply after opening a result.
