# Favorites (Library > Favorites, or the Favorites tab in the 5-tab option)

Purpose: mods the player saved to look at or download later. Stored on the device.
Today: `FavoritesPage`, `FavoriteTile`, `FavoriteButton`, `FavoritesCubit`.

## Layout (360 x 800 dp, inside the Library shell from [downloaded.md](downloaded.md))

| Region | Size | Content |
|---|---|---|
| Summary | 40 | "12 saved mods" (labelLarge `onSurfaceVariant`) |
| List | gap 12, padding 16 h | `ModCardTile` in its favorite variant: same 16:9 card as Home, built from the snapshot (title, thumb, type), with the type plate on the image and a filled heart toggle (48, `primary`) at the end of the title row. Byline and meta are omitted (the snapshot does not hold them). |

Order: most recently saved first.

## Interactions
- Tap card: Detail.
- Tap heart: remove immediately, snackbar "Removed from favorites" with **Undo** (re-adds the same record at the same position). 4 s.

## States

| State | What shows |
|---|---|
| Loading | 2 skeleton cards |
| Loaded | summary + cards |
| Empty | illustration (bus stop with a heart), "No favorites yet", "Tap the heart on a mod to save it here.", Tonal "Browse mods" -> Home |
| Error (local) | "Couldn't load your favorites." + Retry |
| Offline | list works; images not in cache show the placeholder; tapping a card opens Detail in its offline state |

## 200% text scale
Same as the Home card. The heart stays 48 dp and moves under the title when the title needs the full width (scale > 1.5).

## TalkBack order
Segments -> summary -> each card: merged "BMC Procity 12 LF, Bus" -> heart ("Remove BMC Procity 12 LF from favorites"). The Undo snackbar action is announced ("Removed from favorites. Undo, button").

## Ads
None.
