# Roadmap

One phase per commit + push. Each line is "done" when it is committed and the
`tests/smoke.luau` / `demo.luau` check passes in an executor.

- [x] **Phase 0 — Docs & repo.** GOAL, ROADMAP, ARCHITECTURE, CONTEXT, README,
      CHANGELOG, LICENSE, `.gitignore`; `git init` + new GitHub repo.
- [x] **Phase 1 — Scaffold.** `state`, `util/*`, `render/*`, `manifest`, `loader`,
      `init` returning an empty `Library`; demo proves it loads.
- [x] **Phase 2 — Window shell.** draggable window, title bar, tab strip, toggle
      key, close button, unload.
- [x] **Phase 3 — Page & Section.** pages as tabs, left/right sections, scroll.
- [x] **Phase 4 — Core elements.** label, button, toggle, slider.
- [x] **Phase 5 — Input elements.** textbox, dropdown, multibox, keybind.
- [x] **Phase 6 — Advanced elements.** colorpicker, listbox, configbox,
      buttonholder.
- [x] **Phase 7 — Widgets.** watermark, notifications, keybinds list, status list.
      (cursor skipped: native cursor already exists.)
- [ ] **Phase 8 — Config & theming.** save/load config, `theme:UpdateColor`, unload.
- [ ] **Phase 9 — Hardening.** sUNC fallbacks, guards, docs pass, tag `v1.0.0`.

## Commit convention

`type: short summary` — `docs:`, `feat:`, `fix:`, `refactor:`, `release:`.
Update `CHANGELOG.md` in the same commit.
