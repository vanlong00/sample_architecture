# Pro paywall (`/pro`)

Purpose: offer the subscription that removes ads, and say plainly that it does nothing else.
Today: `PaywallPage`, `PaywallCubit`, `ProStatusCubit`.
Entry points: Settings Pro card; "Remove ads" link on in-list ad cells (new: `/pro` must be pushable from Home and Search).

## Layout (360 x 800 dp)

| Region | Size | Content |
|---|---|---|
| App bar | 64 | Close (X, 48, "Close") instead of back arrow; no title (the headline is the title). |
| Hero plate | 120, padding 16 | The plate component at large size: "NO ADS" in amber caps on the dark plate, centered. Graphic only; not text-critical. |
| Headline | | "Busmod without ads" (headlineMedium), 16 dp gutter |
| What you get | list, 3 rows, 56 each | `check_circle` `tertiary` + "No ads in lists" / "No ads before downloads" / "No ads when you open the app" |
| What does not change | 1 row | `info_outline` `onSurfaceVariant` + "Every mod stays free to download and import, with or without Pro." |
| Spacer | flex | |
| Price block | | "{price} / month" (headlineSmall, tabular) centered; "Renews every month until you cancel in Google Play." (bodySmall `onSurfaceVariant`) |
| Actions | padding 16, bottom inset | Filled **Subscribe** (48, full width); TextButton **Restore purchases** (48) |

## States

| State | What shows |
|---|---|
| Loading plans | price block shows a 120 x 28 skeleton; Subscribe disabled |
| Ready | as above |
| Purchasing | Subscribe shows a spinner, both buttons disabled |
| Pending | snackbar "Payment pending. Pro turns on when Google Play confirms it." Paywall stays |
| Purchased | snackbar "You're Pro. Ads are gone.", page closes |
| Restored | snackbar "Purchases restored", page closes |
| Nothing to restore | snackbar "Nothing to restore" |
| Failed | error snackbar "Purchase didn't go through. Try again." (user cancel: no message) |
| Store unavailable | price block replaced by "Google Play isn't available right now." + TextButton Retry; Subscribe disabled |
| Already Pro (opened from a stale link) | the list stays, price block replaced by "You're Pro", single TextButton "Manage subscription" |
| Offline | same as store unavailable with "You're offline. Connect to subscribe." |

Never: fake countdowns, crossed-out prices, "best value" badges, or a delayed Close button.

## 200% text scale
Whole page scrolls (`ListView`); actions stay at the end of the content, not pinned, so nothing is clipped. Hero plate scales up to 1.3x then stays.

## TalkBack order
Close -> headline (header) -> benefit rows -> "does not change" row -> price + renewal note (merged) -> Subscribe -> Restore.

## Ads
None (and no interstitial when leaving it).
