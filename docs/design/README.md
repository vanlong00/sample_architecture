# Busmod design

Proposal for the user's sign-off (board feature `ux-design`). The markdown files in this folder are the source of truth for developers; the canvas is a visual of the same spec.

- **Claude Design canvas (private):** https://claude.ai/artifact/6ZCXP7EJmgstMcvckX484X
  Phone frames (360 x 800 dp) in light and dark: Home, Home states, Filter sheet, Search, Detail, action-bar states, Library (Downloaded, Favorites), Settings, Paywall, dialogs, Splash, and Home and Detail at 200% text scale in Vietnamese. Only people the user shares it with can open it.
- Start with [00-overview.md](00-overview.md), then [09-handoff.md](09-handoff.md) for the build order.
- Colors and contrast: edit `tools/contrast.py`, run `python3 docs/design/tools/contrast.py`, copy the printed table into [04-tokens.md](04-tokens.md).
