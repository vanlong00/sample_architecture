# Splash (`/`)

Purpose: cover init (local store, cache sync, ads and subscription init, consent) and leave for Home as soon as possible.
Today: `SplashPage` (app title text + spinner), `SplashCubit`.

## Two layers
1. **Android 12+ system splash** (`flutter_native_splash` or the platform theme): background `#14181C` (plate color) in both themes, centered the launcher icon foreground (the plate glyph), no text. This shows during engine start.
2. **Flutter splash** (this page), drawn to match layer 1 so the hand-off is invisible.

## Layout (360 x 800 dp)

| Region | Content |
|---|---|
| Background | `#14181C` full screen, both themes (a destination sign is always dark). Status and nav bars dark with light icons. |
| Center | Plate wordmark "BUSMOD" in amber `#FFB547`, Barlow Condensed 700, 40 sp, letter spacing 2, inside a 1.5 dp amber-at-40% rounded outline (radius 4). Under it 12 dp: "Mods for Proton Bus Simulator Urbano" (bodyMedium, `#C9CFD6`). |
| Bottom (48 dp above the nav inset) | 3 amber dots pulsing in sequence (the LED cue), 6 dp each, 8 dp apart; static three dots with reduced motion. |

No buttons. The consent form (Google UMP) appears on top when required.

## States

| State | What shows |
|---|---|
| Starting | as above |
| Ready | `context.go(Routes.home)`, fade 250 ms |
| Slow (> 4 s) | under the dots: "Still loading…" (bodySmall `#C9CFD6`) |
| Init failure | Splash never blocks: today `SplashCubit` always reaches ready, and Home shows its own error or offline state. Keep it that way. |
| Force update required | deferred with Firebase Phase 2: [force-update.md](force-update.md) |

## 200% text scale
Wordmark capped at 1.3x (logo); tagline wraps, centered, max width 280.

## TalkBack
One node: "Busmod. Loading." (`Semantics(liveRegion: true)`). The dots are excluded.

## Ads
An app-open ad may show after Splash, on later launches only, per the existing `AdsService` rules. Never on the first launch.
