# Goal

Build **spiff**: a maintainable, modular Roblox menu library in Luau that is
pleasant to read, easy to extend, and behaves like Octernal Lib for users.

## North star

A developer should be able to open `src/elements/toggle.luau`, understand it in
isolation, change it, and ship without touching the other 11 elements. No file
should ever be large enough to be scary.

## Constraints

1. **Modular** — one concern per file, every file under 500 lines.
2. **sUNC / UNC compatible** — use only the unified executor API, with graceful
   fallbacks when a function is missing (`gethui`, `cloneref`, filesystem).
3. **Native Instances** — build on `ScreenGui`/`Frame`; do not use `Drawing`.
   The render backend is isolated in `src/render/` so a second backend can be
   dropped in without touching core, elements, or widgets.
4. **Version controlled** — GitHub repo `scramblepaws/spiff`, one commit per
   finished piece.
5. **Testable** — every non-trivial module leaves one runnable check behind
   (`tests/smoke.luau` or an in-file `assert` demo).

## Non-goals

- Pixel-exact reproduction of Octernal's drawing math.
- Supporting (non-executor) vanilla Roblox environments.
- A build step or bundler: the source tree is the source of truth and the loader
  assembles it at runtime.

## Done looks like

`v1.0.0`: window, pages, sections; 12 elements (label, textbox, toggle, slider,
button, buttonholder, dropdown, multibox, keybind, colorpicker, listbox,
configbox); widgets (watermark, notifications, keybinds list, status list,
cursor); config save/load; live theme recolor; unload/kill switch.
