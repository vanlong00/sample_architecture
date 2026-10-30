# Answers to the 13 designer questions (spec §9)

Each answer: recommended default, a one-line reason, one alternative. Items marked **(sign-off)** are the user's call at the design gate.

### 1. Identity: game accessory, public transit, or neutral catalog? **(sign-off)**
- **Answer:** "Destination board": a photo-first catalog with three transit cues only: the dark plate with amber condensed caps, the amber accent, and Barlow Condensed titles. No copy of PBSU's UI.
- **Reason:** ties the app to buses without competing with the screenshots or implying an official PBSU link.
- **Alternative:** calm neutral catalog (blue-grey Material 3, system font): safest, but generic.
- Liked/disliked references: none given by the user. Open question in [09-handoff.md](09-handoff.md).

### 2. Name, icon, brand colors; dark first or equal? **(sign-off)**
- **Answer:** name stays the "Busmod" placeholder (four strings to change later). Brand anchor amber `#FFB547` on slate. Both themes complete, dark designed first, app follows the system theme by default.
- **Reason:** most players use dark, but outdoor daytime use needs a real light theme; the system setting respects both.
- **Alternative:** open in dark by default on first run.

### 3. Navigation: 5 tabs or merged Library? Types as tabs or pages? **(sign-off)**
- **Answer:** 4 bottom tabs: **Home / Search / Library / Settings**. Library has two segments: Downloaded and Favorites. On Home, the 4 types (Bus, Truck, Car, Map) stay as a scrollable tab bar under the app bar.
- **Reason:** both "my mods" lists belong together and work offline; 4 destinations give each label 25% more width, which is what keeps "Trang chủ / Tìm kiếm / Thư viện / Cài đặt" readable at 200% text size. Type tabs keep switching to one swipe.
- **Alternative:** keep the current 5 tabs (Home / Search / Downloaded / Favorites / Settings) with the selected-label-only rule at large text sizes ([06-accessibility.md](06-accessibility.md)). All screen specs work for both.

### 4. Card: big 16:9 single column or 2-column grid? What does it show? **(sign-off)**
- **Answer:** single column, 16:9 image at full width (328 dp on a 360 dp phone). Under it: title (2 lines max), byline "Manufacturer · Country", meta row "Body type · 60 MB · 17.4K downloads". Maps show "Region · N routes · N stops" instead. No flags (text country only), no date on the card. On screens of 600 dp and up: 2 columns, 3 at 840 dp.
- **Reason:** the screenshot is the product; at 2 columns a 16:9 image is ~156 dp wide and buses become unrecognizable, and the long titles (average 51 characters) wrap to 3-4 lines.
- **Alternative:** 2-column compact grid with 1-line titles: denser browsing, weaker images.

### 5. Detail page priority; is the Download/Import button fixed at the bottom?
- **Answer:** order: gallery (full-bleed 16:9, swipe, "1 / 4" counter) -> title -> chips (body type, manufacturer, country) -> quick facts row (size, format, downloads; maps: region, routes, stops) -> specs (3 groups) -> description (collapsed to 6 lines, "Read more") -> "More from Mercedes-Benz". The action bar is **fixed at the bottom** and always visible.
- **Reason:** players decide from the pictures, then act; a fixed bar keeps the main loop one tap away at any scroll position.
- **Alternative:** the button inline under the title, scrolling away with the page (more room for content, but the action disappears).

### 6. States of the primary button
- **Answer:** full state machine in [03-screens/detail.md](03-screens/detail.md#action-bar-state-machine): Checking -> Download -> Downloading x% (Cancel) -> Import to PBSU (stays Import; re-import allowed) ; File not found -> Download again ; Download failed -> Retry (no Retry on 404, which shows "This mod is no longer available") ; Not enough storage -> Retry ; PBSU not installed -> dialog with "Open Google Play" ; import results as snackbars.
- **Reason:** each failure tells the user what happened and gives the one action that can work.
- **Alternative:** a separate "Downloaded" state with a smaller "Import again" link after the first import. Rejected: players often re-import after reinstalling PBSU, so Import stays the primary label.

### 7. Do maps need their own card or detail?
- **Answer:** same components, map-specific content: the card byline becomes "Region" and the meta row "N routes · N stops" (only the fields that exist); the detail quick-facts row shows Region, Routes, Bus stops with icons. No separate layout.
- **Reason:** 34 maps do not justify a second component; the data differs only in 3 fields, and many maps leave them empty.
- **Alternative:** a dedicated map detail with a route list section (wait until the data has real route lists).

### 8. Filters: one sheet or horizontal chips? Counts?
- **Answer:** one bottom sheet with 3 sections (Body type, Manufacturer, Country), single choice per section, counts next to every option ("Mercedes-Benz 37"). Manufacturer and Country show the top 8 and a "Show all (88)" button. After Apply, the active filters appear as removable chips under the sort row on Home.
- **Reason:** 128 manufacturers and 30 countries do not fit in a chip row; the chips row still makes the active state visible and one-tap removable.
- **Alternative:** horizontal chip rows on the list for body type only, with manufacturer and country in the sheet.

### 9. Native ad look; banner position? **(sign-off for banner)**
- **Answer:** the native ad uses the same card width, radius (12) and 16:9 media as a mod card, but sits on a different surface (`surfaceContainer` with a 1 dp `outlineVariant` border), carries a high-contrast "Ad" badge top-left and its own CTA button, and has a "Remove ads" link that opens Pro. Placement: after the 3rd card, then every 10 (current `AdListPlacement`). **No banner in v1.**
- **Reason:** a banner on Detail would fight the fixed action bar, and on Home it would stack with the bottom nav and eat ~10% of a 800 dp screen; native + interstitial already cover the slots.
- **Alternative:** an adaptive banner at the bottom of Home and Search only, above the navigation bar, never on Detail.

### 10. Paywall prominence **(sign-off)**
- **Answer:** low key: a Pro card at the top of Settings, and the "Remove ads" link on every in-list ad. No pop-up after N downloads, no paywall on launch.
- **Reason:** Pro only removes ads; the moment a player sees an ad is the honest moment to offer it.
- **Alternative:** add a one-time bottom sheet after the 3rd completed download, dismissible, never shown again.
- Note: today the router allows `/pro` only from Settings; the "Remove ads" link needs `/pro` from Home and Search too.

### 11. Empty, error, offline illustrations
- **Answer:** four small line illustrations in the plate style (dark plate + amber line art): empty Library (bus depot with empty bays), no search results (a bus stop sign with a question mark), offline (bus with a cloud-off sign), mod no longer available (a "Not in service" destination plate). 96 dp, one per state, each with a title, one sentence and one action. Spec in [08-assets.md](08-assets.md).
- **Reason:** players should understand the state at a glance, and the plate motif keeps them on brand without stock art.
- **Alternative:** Material icons at 64 dp instead of illustrations (no asset work).

### 12. Condensed signage font with Vietnamese and Portuguese marks?
- **Answer:** yes: Barlow Condensed 600/700 for titles and tabs, Barlow 400/500/600 for text, both OFL with full Vietnamese support. Line height at least 1.2x. Fallback: Android `sans-serif-condensed` and Roboto.
- **Reason:** highway-sign lineage, fits long titles, complete diacritics.
- **Alternative:** Roboto Condensed (already on the phone, no bundle cost, less character).

### 13. Tablet layout?
- **Answer:** phone first; no tablet-only screens. The same screens adapt: list columns by width (1 below 600 dp, 2 from 600, 3 from 840), Detail content capped at 720 dp and centered, NavigationRail instead of NavigationBar from 840 dp.
- **Reason:** PBSU players are on phones; width rules give acceptable tablets for little cost.
- **Alternative:** lock to phone layout and center a 600 dp column on tablets.
