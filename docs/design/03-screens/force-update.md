# Force update gate: DEFERRED, spec only

Status: **not built in this run.** Depends on Firebase Remote Config (`force_update`, `min_supported_version`), which is feature `firebase-phase2` (deferred by the user on 2026-10-30). This file exists so the redesign leaves room for it; do not implement it in `fe-ui-redesign`.

## When it shows
After Splash, when Remote Config says the installed version is below `min_supported_version` and `force_update` is true. It replaces Home; there is no way past it.

## Layout (360 x 800 dp)
Same dark plate background as Splash (`#14181C`, both themes):
- Center: illustration "Not in service" plate (from the state-view set), 120 dp.
- Title "Update required" (headlineSmall, `#E2E5E9`).
- Body "This version no longer works with the mod catalog. Update to keep browsing and downloading mods. Your downloaded mods are safe." (bodyMedium, `#C9CFD6`).
- Filled **Update** (amber `#FFB547` with `#2B1700` text, 9.75:1), opens the Play listing of this app.
- Text button **Open Library**: offline library and Import still work without the catalog (decide in Phase 2 whether this escape is allowed; recommended yes, since it uses no server).

## States
- Play Store missing: Update opens the https listing.
- Soft update (`force_update` false, newer version exists): no screen; a dismissible banner on Home "A new version is available" + Update. Also Phase 2.

## Copy keys (add with Phase 2, not now)
`forceUpdateTitle`, `forceUpdateBody`, `forceUpdateAction`, `softUpdateBanner`. Texts in [07-copy.md](../07-copy.md#deferred-phase-2).
