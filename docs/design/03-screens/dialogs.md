# Dialogs, snackbars and shared state views

## PBSU missing dialog
Today: `showPbsuMissingDialog` (`AlertDialog`, Cancel + "Open Google Play").

| Part | Spec |
|---|---|
| Container | M3 `AlertDialog`, `surfaceContainerHigh`, radius 28, width 312 on a 360 phone, padding 24 |
| Icon | `sports_esports_outlined` 24, `secondary`, centered above the title (M3 dialog icon slot) |
| Title | "PBSU is not installed" (headlineSmall, centered under the icon) |
| Body | "Mods are sent to Proton Bus Simulator Urbano, which installs them. Install the game from Google Play, then tap Import again." (bodyMedium `onSurfaceVariant`) |
| Actions | TextButton **Not now**, Filled **Open Google Play** (icon `shop_outlined`). Right-aligned, 8 apart. |
| Behaviour | Open Google Play: close, open `market://` then https fallback (as today), suppress the app-open ad on return (as today). Back, scrim tap or Not now: close, nothing else. |
| 200% | actions stack vertically, full width, Open Google Play on top; body scrolls inside the dialog |
| TalkBack | announced as "PBSU is not installed, dialog"; focus starts on the title; order title -> body -> Not now -> Open Google Play |

## Delete confirm dialog
Today: `showConfirmDialog(destructive: true)`.

| Part | Spec |
|---|---|
| Icon | `delete_outline` 24, `error` |
| Title | "Delete this mod?" |
| Body | "“BMC Procity 12 LF” will be removed from this device and free 60 MB. You can download it again later." |
| Actions | TextButton **Cancel**, Filled **Delete** with `error` background and `onError` text (contrast 6.46 light / 7.72 dark) |
| Behaviour | Delete -> file and record removed, snackbar "Mod deleted". Cancel / back / scrim -> nothing. |
| 200% | actions stack, Delete on top |
| TalkBack | "Delete this mod?, dialog"; Delete button label "Delete BMC Procity 12 LF" |

## Snackbars
Today: `showAppSnackBar(message, isError)`; error uses `error` background.

| Kind | Spec |
|---|---|
| Info | floating, `inverseSurface` / `onInverseSurface`, radius 8, margin 16 h + above the nav bar or action bar, 4 s; optional action in `inversePrimary` |
| Error | same container (`inverseSurface`, not `error`), leading `error_outline` icon 20 in `onInverseSurface`, 6 s. The icon plus the wording carry the error, not color. |
| Undo | info + action "Undo", 4 s, stays while TalkBack focus is on it |
| Announce | every snackbar is announced (Flutter does it for `SnackBar`); do not show two at once (`clearSnackBars`, as today) |

Changing errors from a red container to `inverseSurface` + icon keeps one snackbar style and avoids red text-on-red tuning; contrast `onInverseSurface` on `inverseSurface`: 11.55 light / 10.34 dark.

## Shared state view (`StateView`, replaces `ErrorView` + the ad-hoc empty texts)

| Part | Spec |
|---|---|
| Layout | centered column, max width 320, padding 24: illustration 96 dp (or 64 at text scale > 1.5) -> 16 -> title (titleLarge, centered) -> 8 -> body (bodyMedium `onSurfaceVariant`, centered) -> 24 -> primary action (Filled or Tonal, 48) -> 8 -> secondary action (TextButton, 48) |
| Variants | `empty`, `noResults`, `offline`, `error`, `unavailable`; each picks its illustration ([08-assets.md](../08-assets.md)) |
| Scroll | wrapped in a scroll view with `AlwaysScrollableScrollPhysics` so pull-to-refresh and 200% text both work |
| TalkBack | title is a header; illustration excluded from semantics |

## Offline banner
`secondaryContainer`, height 40 (grows with text), `cloud_off_outlined` 16 + "Offline. Showing saved results." Not dismissible; disappears when a request succeeds. `liveRegion` so TalkBack announces it once.
