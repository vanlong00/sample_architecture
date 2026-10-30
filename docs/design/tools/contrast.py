"""Builds tokens.json from the color roles below and prints the WCAG 2.x
contrast table used in 04-tokens.md. Run: python3 docs/design/tools/contrast.py
Edit colors here, never in tokens.json by hand."""
import json, pathlib

LIGHT = {
  "primary": "#9A4F00", "onPrimary": "#FFFFFF",
  "primaryContainer": "#FFDCB8", "onPrimaryContainer": "#2E1500",
  "secondary": "#39607F", "onSecondary": "#FFFFFF",
  "secondaryContainer": "#D3E5F7", "onSecondaryContainer": "#0D2A40",
  "tertiary": "#1A6B45", "onTertiary": "#FFFFFF",
  "tertiaryContainer": "#A6F2C4", "onTertiaryContainer": "#002112",
  "error": "#BA1A1A", "onError": "#FFFFFF",
  "errorContainer": "#FFDAD6", "onErrorContainer": "#410002",
  "surface": "#F8F9FB", "onSurface": "#191C1F", "onSurfaceVariant": "#43474E",
  "surfaceDim": "#D8DADD", "surfaceBright": "#F8F9FB",
  "surfaceContainerLowest": "#FFFFFF", "surfaceContainerLow": "#F2F3F6",
  "surfaceContainer": "#ECEEF1", "surfaceContainerHigh": "#E6E8EB",
  "surfaceContainerHighest": "#E0E2E6",
  "outline": "#73777F", "outlineVariant": "#C3C7CF",
  "inverseSurface": "#2E3135", "onInverseSurface": "#EFF1F4", "inversePrimary": "#FFB547",
  "shadow": "#000000", "scrim": "#000000", "surfaceTint": "#9A4F00",
}
DARK = {
  "primary": "#FFB547", "onPrimary": "#2B1700",
  "primaryContainer": "#5C3A00", "onPrimaryContainer": "#FFDCB8",
  "secondary": "#A8C9E8", "onSecondary": "#0D2A40",
  "secondaryContainer": "#264259", "onSecondaryContainer": "#D3E5F7",
  "tertiary": "#8AD8A9", "onTertiary": "#003920",
  "tertiaryContainer": "#005231", "onTertiaryContainer": "#A6F2C4",
  "error": "#FFB4AB", "onError": "#690005",
  "errorContainer": "#93000A", "onErrorContainer": "#FFDAD6",
  "surface": "#111417", "onSurface": "#E2E5E9", "onSurfaceVariant": "#C0C7CF",
  "surfaceDim": "#111417", "surfaceBright": "#373A3E",
  "surfaceContainerLowest": "#0B0E11", "surfaceContainerLow": "#191C20",
  "surfaceContainer": "#1D2024", "surfaceContainerHigh": "#272A2F",
  "surfaceContainerHighest": "#32353A",
  "outline": "#8A9199", "outlineVariant": "#41474E",
  "inverseSurface": "#E2E5E9", "onInverseSurface": "#2E3135", "inversePrimary": "#9A4F00",
  "shadow": "#000000", "scrim": "#000000", "surfaceTint": "#FFB547",
}
# ThemeExtension BusmodColors: identical in both themes (the destination plate).
SIGNAGE = {"plateBg": "#14181C", "plateFg": "#FFB547", "plateFgMuted": "#C9CFD6",
           "imageScrim": "#000000"}  # scrim drawn at 60% opacity over photos

def lum(h):
    h = h.lstrip('#'); r, g, b = [int(h[i:i+2], 16)/255 for i in (0, 2, 4)]
    f = lambda c: c/12.92 if c <= 0.03928 else ((c+0.055)/1.055)**2.4
    return 0.2126*f(r) + 0.7152*f(g) + 0.0722*f(b)

def cr(a, b):
    x, y = sorted([lum(a), lum(b)], reverse=True)
    return round((x+0.05)/(y+0.05), 2)

def blend(fg, bg, a):
    f = [int(fg[i:i+2], 16) for i in (1, 3, 5)]; b = [int(bg[i:i+2], 16) for i in (1, 3, 5)]
    return '#' + ''.join(f'{round(x*a + y*(1-a)):02X}' for x, y in zip(f, b))

# (foreground, background, minimum, use)
PAIRS = [
  ("onPrimary", "primary", 4.5, "Filled button label (Download, Import)"),
  ("onPrimaryContainer", "primaryContainer", 4.5, "Tonal button, selected chip"),
  ("onSecondaryContainer", "secondaryContainer", 4.5, "Ad badge, selected nav indicator label"),
  ("onTertiaryContainer", "tertiaryContainer", 4.5, "Downloaded status pill"),
  ("onErrorContainer", "errorContainer", 4.5, "Error banner / file-missing pill"),
  ("onError", "error", 4.5, "Error snackbar"),
  ("onSurface", "surface", 4.5, "Body text"),
  ("onSurface", "surfaceContainerLow", 4.5, "Card text"),
  ("onSurface", "surfaceContainerHighest", 4.5, "Text on highest container"),
  ("onSurfaceVariant", "surface", 4.5, "Secondary text (manufacturer, meta)"),
  ("onSurfaceVariant", "surfaceContainerLow", 4.5, "Card meta text"),
  ("onSurfaceVariant", "surfaceContainerHigh", 4.5, "Meta text in CTA bar / sheet"),
  ("primary", "surface", 4.5, "Text buttons, active tab label, links"),
  ("primary", "surfaceContainerLow", 4.5, "Primary text on cards"),
  ("primary", "surfaceContainer", 4.5, "Primary on nav bar"),
  ("secondary", "surface", 4.5, "Secondary text accents"),
  ("tertiary", "surfaceContainerHigh", 4.5, "'Downloaded' status text in CTA bar"),
  ("error", "surface", 4.5, "Inline error text"),
  ("error", "surfaceContainerHigh", 4.5, "Error text in CTA bar"),
  ("onInverseSurface", "inverseSurface", 4.5, "Snackbar text"),
  ("inversePrimary", "inverseSurface", 4.5, "Snackbar action"),
  ("outline", "surface", 3.0, "Outlined button/chip border, text field (non-text)"),
  ("outline", "surfaceContainerLow", 3.0, "Borders on cards (non-text)"),
  ("primary", "surfaceContainerHighest", 3.0, "Progress bar fill vs track (non-text)"),
  ("outline", "surfaceContainerHigh", 3.0, "Search field border (non-text)"),
  ("onSurfaceVariant", "secondaryContainer", 4.5, "Offline banner icon/text"),
  ("onError", "error", 4.5, "Delete button"),
]

def table(scheme, name):
    rows = []
    for fg, bg, mn, use in PAIRS:
        r = cr(scheme[fg], scheme[bg])
        rows.append({"fg": fg, "bg": bg, "ratio": r, "min": mn, "pass": r >= mn, "use": use, "theme": name})
    return rows

res = table(LIGHT, "light") + table(DARK, "dark")
extra = [
  ("plateFg on plateBg", cr(SIGNAGE["plateFg"], SIGNAGE["plateBg"]), 4.5),
  ("plateFgMuted on plateBg", cr(SIGNAGE["plateFgMuted"], SIGNAGE["plateBg"]), 4.5),
  ("dark onSurface on plateBg", cr(DARK["onSurface"], SIGNAGE["plateBg"]), 4.5),
  ("dark onPrimary on dark primary (force-update button)", cr(DARK["onPrimary"], DARK["primary"]), 4.5),
  ("white on 60% black scrim over pure white photo", cr("#FFFFFF", blend("#000000", "#FFFFFF", 0.6)), 4.5),
]
if __name__ == "__main__":
    out = pathlib.Path(__file__).resolve().parent.parent / "tokens.json"
    tokens = json.loads(out.read_text()) if out.exists() else {}
    tokens["color"] = {"light": LIGHT, "dark": DARK, "signage": SIGNAGE}
    tokens["contrast"] = {"pairs": res, "extra": [{"pair": p, "ratio": r, "min": m, "pass": r >= m} for p, r, m in extra]}
    out.write_text(json.dumps(tokens, indent=2, ensure_ascii=False) + "\n")
    print("| Pair (fg on bg) | Use | Light | Dark | Min |\n|---|---|---|---|---|")
    n = len(PAIRS)
    for i in range(n):
        l, d = res[i], res[i+n]
        mark = lambda x: f"{x['ratio']}" + ("" if x["pass"] else " FAIL")
        print(f"| {l['fg']} on {l['bg']} | {l['use']} | {mark(l)} | {mark(d)} | {l['min']} |")
    for p, r, m in extra:
        print(f"| {p} | signage / photo overlay | {r} | {r} | {m} |")
    fails = [x for x in res if not x["pass"]] + [e for e in extra if e[1] < e[2]]
    print("FAILS:", fails)
