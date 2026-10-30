# Accessibility

Target: WCAG 2.2 AA as it applies to native apps, plus Android TalkBack and font-size/display-size settings. Each screen file has its own 200% and TalkBack sections; this file holds the global rules and the per-screen checklist used by `fe-a11y-textscale` and QA.

## Global rules

1. **Touch targets** >= 48 x 48 dp for everything tappable (buttons, chips via `MaterialTapTargetSize.padded`, icon buttons, the counter-less gallery area, "Remove ads", "Read more"). Visual size may be smaller (chips 32) as long as the hit area is 48.
2. **Contrast**: text >= 4.5:1, non-text UI and focus rings >= 3:1, in both themes. Every role pair used is computed in [04-tokens.md](04-tokens.md#contrast-computed). Text never sits on a photo without the 60% scrim (worst case 5.74:1).
3. **Color is never the only signal**: every status has an icon and words (Downloaded, File not found, No longer available, Offline, errors). Selected chips show a check icon; the selected nav item has a filled icon and the indicator pill.
4. **Labels**: every icon-only button has a tooltip (= accessible name): Back, Favorite (toggle with selected state), Clear search, Delete {title}, Remove filter {name}, Close, gallery viewer Close. Decorative images and illustrations are excluded from semantics. Mod thumbnails are excluded (the card label carries the title).
5. **One node per card**: card content merges into one label; buttons inside (heart, Import, Delete) stay separate nodes.
6. **Live regions** (announce, do not move focus): download progress in 10% steps; action-bar status changes (Downloaded, failures); offline banner appearing; search settled ("Results updated" / "No mods found for {query}"); splash "Loading". Snackbars are announced by Flutter.
7. **Headers**: screen titles, section headers (Specifications, Description, More from, Settings sections, filter sections) set `Semantics(header: true)`.
8. **Focus order** follows reading order; on Detail the action bar is moved to right after the quick facts with `OrdinalSortKey` (see [detail.md](03-screens/detail.md#talkback-order)).
9. **Motion**: honour `MediaQuery.disableAnimationsOf`: no cross-fades, no splash dot pulse, no row-removal animation. No auto-advancing gallery, no parallax.
10. **No time limits**: snackbars with actions (Undo) stay while focused by TalkBack; nothing important lives only in a snackbar (state is also on screen).
11. **Language**: set `Locale` on the app so TalkBack uses the Vietnamese voice for vi; mod titles stay in their original language (no per-span locale needed).

## 200% text scale rules (global)

Flutter `TextScaler` from Android font size; test at 1.0, 1.3, 1.5, 2.0 with **Vietnamese** (longest labels) and display size "Largest".

- **Never clip**: no fixed heights on anything that holds text. Known fixed heights today: native ad cell (`AdMetrics.mediumChrome`), CTA buttons (min height only, fine), filter sheet `height * 0.7` (switch to `DraggableScrollableSheet`).
- **Never truncate a control label**: buttons, chips, tabs, segments wrap or reflow; ellipsis only on app-bar titles and card titles (with the full title in semantics).
- **Reflow, do not shrink**: rows become columns at scale > 1.3 (Detail facts, spec rows, two-button rows, Downloaded row, footer buttons, theme segments).
- **Logos cap**: the plate wordmark and paywall hero stop growing at 1.3-1.5x (they are logos; WCAG 1.4.4 exempts text in logos).
- Bottom bars (Detail action bar, filter footer) may grow but never above 40% of the viewport; past that the extra text moves into the scroll content.

### Navigation bar at large text
Labels: "Trang chủ", "Tìm kiếm", "Thư viện", "Cài đặt" (4-tab) or + "Đã tải", "Yêu thích" (5-tab).
- Scale <= 1.3: all labels shown (`alwaysShow`), max 1 line.
- Scale > 1.3: `NavigationDestinationLabelBehavior.onlyShowSelected`; the selected label may wrap to 2 lines; unselected destinations keep their tooltip (= label) so TalkBack and long-press still name them. Bar height grows to fit (no fixed 80).
- 5-tab option at 2.0x on a 360 dp phone gives 72 dp per destination: only the selected label fits, which is why the 4-tab option is recommended (90 dp each).

### Home type TabBar
`isScrollable: true` at every scale (already planned in `fe-a11y-textscale`); tab height = text + 24; the bar never wraps.

### Filter chips
Wrap layout, chips grow; the count stays inside the chip as trailing text.

## Per-screen checklist

| Screen | Targets | Labels | Order | Live regions | 200% | Contrast | Motion |
|---|---|---|---|---|---|---|---|
| Splash | none | one node "Busmod. Loading." | n/a | loading | wordmark capped | plate 10.15, tagline 11.37 | dots static |
| Home | tabs, chips, Filters, cards, ad link 48 | Filters "Filters, 2 active"; card merged label incl. downloads in full | app bar, tabs, sort, filters, chips, cards, nav | offline banner | toolbar wraps, card title 3 lines, ad height scaled | all role pairs pass | tab swipe default |
| Filter sheet | chips padded, Show all, footer 48 | chip "Mercedes-Benz, 37 mods, selected" | header, sections, footer | none | 90% height, footer stacks | selected chip 11.47 / 8.14 | default |
| Search | field 56, Clear 48, chips | "Search mods, edit box", "Clear search" | field, chips, results | settled-search announcement | hint wraps, illustration 64 | field border 3.66 / 4.52 (3:1 min) | none |
| Detail | back, favorite, gallery, Read more, action buttons 48 | gallery "Screenshot 1 of 4", favorite toggle state | sort keys put action bar 7th | progress 10% steps, status changes | facts and specs reflow, bar stacks | counter 5.74 worst case; status texts in bar >= 5.26 | cross-fade off |
| Downloaded | Import, Delete 48 | "Import {title} to PBSU", "Delete {title}" | segments, summary, rows | row removal announced by snackbar | row goes vertical | Delete icon neutral, missing state has icon + text | removal anim off |
| Favorites | heart 48 | "Remove {title} from favorites" | segments, summary, cards | Undo snackbar | heart moves under title | heart `primary` 5.42 / 9.73 on cards | none |
| Settings | tiles 56, segments 48 | links "opens in browser" | sections in order | restore result snackbar | segments become radios | header `primary` 5.71 / 10.52 | none |
| Paywall | Close, Subscribe, Restore 48 | Close "Close" | headline, benefits, price, actions | purchase result snackbar | page scrolls, hero capped | price `onSurface` | none |
| Dialogs | actions 48 | dialog named by title | title, body, actions | n/a | actions stack, body scrolls | Delete 6.46 / 7.72 | default |

## Test procedure (for QA)
1. TalkBack on, Vietnamese locale: walk Home -> Detail -> Download -> Import with swipe navigation only; every element has a name, the action bar is reached before the specs, progress is announced at most every 10%.
2. Font size max + display size max (about 2.0x), Vietnamese: no clipped text on Home, Detail (every bar state), Library, Filter sheet, Settings, dialogs, native ad cell.
3. Dark and light: spot-check the pairs in the contrast table with the Accessibility Scanner app.
4. Remove animations (developer option): no cross-fades, splash dots static.
