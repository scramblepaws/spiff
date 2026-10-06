# Context / glossary

- **sUNC / UNC** — a unified compatibility standard for Roblox executors. spiff
  uses the shared function set (`gethui`, `cloneref`, `loadstring`, `HttpGet`,
  `readfile`/`writefile`/`isfile`/`makefolder`) with fallbacks when absent.
- **ctx** — the shared context object passed to every module (`state`, `util`,
  `render`, `require`, `Library`). See [ARCHITECTURE.md](ARCHITECTURE.md).
- **backend** — the rendering implementation behind `src/render/`. The current
  (and only) backend is native Roblox `Instance`s.
- **window** — top-level menu object returned by `Library.Window(info)`. Owns the
  `ScreenGui`, title bar, tab strip, and the toggle key.
- **page** — a tab inside a window (`win:Page(info)`). Holds sections.
- **section** — a bordered panel inside a page (`page:Section(info)`), on the
  `left` or `right` column. Elements are added to sections.
- **element** — an interactive control (toggle, slider, dropdown, ...). Exposes
  `:Set`, `:Get`, `:Destroy` and reports through a `callback`.
- **widget** — a non-section overlay owned by the window: watermark,
  notifications, keybinds list, status list, cursor.
- **flag** — a unique string key an element registers under in `state.flags`,
  used by config save/load.
- **registry / state.colors** — map from created instance to the theme key it
  uses, so `theme:UpdateColor` can recolor everything live.
- **unload** — destroys every instance and disconnects every tracked connection.
