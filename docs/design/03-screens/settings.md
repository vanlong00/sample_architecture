# Settings (`/settings`)

Purpose: theme, language, Pro, purchases, legal, version.
Today: `SettingsPage` (radio lists, Pro tile, restore tile, link tiles, version tile).

## Layout (360 x 800 dp, scrolls)

| Region | Size | Content |
|---|---|---|
| App bar | 64 | "Settings" |
| Pro card | padding 16, card radius 12 `primaryContainer` | Not Pro: icon `workspace_premium_outlined` 24 `onPrimaryContainer`, title "Remove ads with Pro" (titleMedium), body "One subscription. No ads anywhere in the app." (bodyMedium), Filled **See Pro** (48) -> `/pro`. Pro: same card in `tertiaryContainer`, `check_circle`, "You're Pro", "Thanks for supporting the app. Ads are off.", TextButton "Manage subscription" (opens Play subscriptions page). |
| Section "Appearance" | header 48 | Header labelLarge `primary`. Then `SegmentedButton` full width: "System" / "Light" / "Dark" (replaces 3 radio rows; one row instead of three keeps the page short). |
| Section "Language" | | `RadioListTile`s: "English", "Tiếng Việt" (each in its own language, as today). Leaves room for "Português (Brasil)". |
| Section "Purchases" | | ListTile `restore` "Restore purchases" with trailing spinner while running. |
| Section "About" | | ListTile "Privacy policy" (`open_in_new`), "Terms of use" (`open_in_new`), "Privacy choices" (only when the consent SDK says the form is required; feature `fe-consent-privacy`), "Version 1.0.0 (12)" (not tappable, bodyMedium `onSurfaceVariant`). |

All list tiles min height 56, icons 24, trailing icons `onSurfaceVariant`.

## States

| State | What shows |
|---|---|
| Default | as above |
| Restoring | Restore row trailing 24 dp spinner, row disabled |
| Restore results | snackbars: "Purchases restored", "Nothing to restore", error "Couldn't restore purchases. Try again later." |
| Pro active | Pro card in its Pro form, Restore row stays |
| Link fails to open | snackbar "Couldn't open the page." (today failures are silent; this replaces that) |
| Version unknown | version row hidden (as today) |

## 200% text scale
- Pro card: button full width below the text.
- Theme `SegmentedButton`: at scale > 1.3 it becomes 3 radio rows (segments would truncate "Theo hệ thống").
- All tiles grow in height; no truncation.

## TalkBack order
App bar -> Pro card (merged title + body, then the button "See Pro") -> Appearance header -> theme segments ("System, selected, 1 of 3") -> Language header -> radios -> Purchases header -> Restore -> About header -> links ("Privacy policy, opens in browser") -> version.

## Ads
None.
