# Filter sheet (modal bottom sheet over Home)

Purpose: narrow the current type's list by body type, manufacturer and country.
Today: `showFilterSheet`, `_FilterSheet`, `_FilterSection`, `FilterCubit`.

## Layout (360 x 800 dp)

| Region | Size | Content |
|---|---|---|
| Sheet | max 90% of height, initial 70%, `DraggableScrollableSheet`; top radius 28; `surfaceContainerLow` | |
| Drag handle | 48 high touch area, 32 x 4 visual, `onSurfaceVariant` 40% | `showDragHandle: true` |
| Header | 56 | "Filters" (titleLarge) left; type plate right ("BUS") so the user knows which tab it filters. |
| Sections | scroll | Three sections, 24 dp apart. Section title titleSmall `onSurface` + selected value in bodySmall `primary` ("Mercedes-Benz") so the choice is visible when collapsed. |
| Chip group | Wrap, gap 8 / 8 | `ChoiceChip`, height 32 visual / 48 touch: "All" first, then options sorted by count desc (body type keeps server `order`). Label "Mercedes-Benz" + count in a trailing `labelSmall` `onSurfaceVariant` "37". Selected: `secondaryContainer`, check icon. Options with count 0 for this type are hidden (as today). |
| Show all | 48 | Manufacturer and Country show the top 8 then TextButton "Show all (88)"; tapping expands inline and turns into "Show fewer". Body type always shows all (max 11). |
| Footer | 80 + inset, `surfaceContainerLow`, top divider | Outlined **Reset** (flex 1) + Filled **Apply** (flex 2). No result count on the button: the server gives counts per option, not for combinations, so any number would be a guess. |

## Interactions
- Single choice per section; "All" clears that section.
- Reset clears all sections in the sheet (not applied until Apply).
- Apply closes and returns the filter; swipe down, scrim tap and back dismiss without change.
- Selecting a body type does not re-filter manufacturer counts (counts are per type, from the server; cross-filter counts are not available). Accepted limitation.

## States

| State | What shows |
|---|---|
| Loading | header + 3 section titles with 6 skeleton chip pills each; footer disabled |
| Loaded | as above |
| Error | inline error in the scroll area "Couldn't load filters." + Retry; Reset stays enabled, Apply disabled |
| Offline | same as error with the mapped network message "You're offline. Check your connection." |
| Section with no options | section hidden |

## 200% text scale
- Sheet opens at 90%.
- Chips wrap more; count stays inside the chip.
- Footer buttons stack (Apply on top) when either label does not fit on one line.

## TalkBack order
"Filters" header -> "Filtering Bus mods" (plate) -> section header "Body type, All selected" -> chips ("Mercedes-Benz, 37 mods, selected") -> Show all -> next sections -> Reset -> Apply. The sheet announces "Filters" on open (`Semantics(scopesRoute, namesRoute)`, default for `showModalBottomSheet` with a title).
