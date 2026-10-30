# Downloaded (Library > Downloaded, or the Downloaded tab in the 5-tab option)

Purpose: the offline library of downloaded mod files: import again, free space.
Today: `DownloadedPage`, `DownloadedTile`, `DownloadedCubit`, `runImport`, `showConfirmDialog`.

## Library shell (4-tab option)

| Region | Size | Content |
|---|---|---|
| App bar | 64 | "Library" (titleLarge) |
| Segments | 56, padding 16 h | `SegmentedButton` full width: "Downloaded" (icon `download_outlined`) / "Favorites" (icon `favorite_border`). Selected `secondaryContainer`. |
| Body | rest | the segment's list |

5-tab option: no segments; the app bar title is "Downloaded".

## Layout of the Downloaded segment

| Region | Size | Content |
|---|---|---|
| Summary | 40, padding 16 h | "4 mods · 312 MB on this device" (labelLarge `onSurfaceVariant`, tabular figures) |
| Rows | gap 8, padding 16 h | Row component (below), newest download first |

### Downloaded row (`DownloadedTile`)
Card `surfaceContainerLow`, radius 12, padding 12, min height 104:
- Left: thumbnail 120 x 68 (16:9), radius 8, from the snapshot (works offline; placeholder if not cached).
- Right column: title titleMedium 2 lines; meta labelMedium `onSurfaceVariant` "ZIP · 60 MB"; then an actions row: Tonal **Import to PBSU** (48 high, icon `input`) and an icon button Delete (`delete_outline`, `onSurfaceVariant`, 48, tooltip "Delete BMC Procity 12 LF").
- Delete icon is **not** red: red is kept for errors; the confirm dialog carries the destructive styling.
- Tap on the row outside buttons: Detail.

Missing file (`missingIds`): meta line gets `report_outlined` 16 in `error` + "File not found" (labelMedium `error`); Import becomes Tonal **Download again** which opens Detail (the bar there shows Download again). Thumbnail at 60% opacity.

Downloads in progress are not listed here in v1 (the record only exists once the file is complete); progress lives on Detail. Add an "In progress" row when `DownloadManager` keeps a title/thumb snapshot per transfer.

## States

| State | What shows |
|---|---|
| Loading | 3 skeleton rows |
| Loaded | summary + rows |
| Empty | illustration (empty depot), "No downloads yet", "Mods you download show up here and work offline.", Tonal "Browse mods" -> Home |
| Error (local storage) | error view "Couldn't read your downloads." + Retry |
| Offline | no change: everything here is local. Thumbnails not in the image cache show the placeholder. |
| After delete | row animates out (250 ms), summary updates, snackbar "Mod deleted" |
| Delete failed | error snackbar "Couldn't delete the file. Try again." |
| Import results | same snackbars and dialog as Detail |

## 200% text scale
- Row switches to vertical at scale > 1.3: thumbnail full width 16:9 on top, then text, then the actions row (Import flexes, Delete stays 48).
- Summary wraps.
- Segments: labels wrap to 2 lines; icons hidden at scale > 1.5 so text has room.

## TalkBack order
App bar -> segments ("Downloaded, selected, 1 of 2") -> summary -> each row as: title + meta merged ("BMC Procity 12 LF. ZIP, 60 MB"), Import ("Import BMC Procity 12 LF to PBSU"), Delete ("Delete BMC Procity 12 LF"). Missing row reads "File not found" in the merged label.

## Ads
None on Library (it is the user's own content and must work offline).
