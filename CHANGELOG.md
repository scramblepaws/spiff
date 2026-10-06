# Changelog

All notable changes to spiff are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/).

## [Unreleased]

### Changed

- Removed all edge rounding (`render.corner` / `UICorner` deleted) to match
  Octernal's square panels.
- Restyled to Octernal Lib's design plan: layered borders
  (outline -> accent -> lightcontrast body; inline -> outline -> darkcontrast
  content), accent top strip on sections, black-outlined text, and the Octernal
  palette (`accent` 55/175/225, `lightcontrast` 30/30/30, `darkcontrast`
  25/25/25, `inline` 50/50/50). Default window size 504x604.

### Fixed

- `Library.Window` was never wired in `init.luau`, so `Menu.Window` was nil and
  the demo failed with `attempt to call a nil value`. Window is now exposed.
- `Section:AddButtonholder` alias added (the dynamic surface only had
  `AddButtonHolder`), fixing `attempt to call missing method`.

- Loader fetched a bare relative path instead of a full URL, causing
  `invalid protocol`. Module and manifest fetches now prefix `Base`.
- Loader no longer silently swallows failures: it logs each stage, surfaces the
  demo traceback via `warn`, and falls back to an inline demo window so the GUI
  always appears.
- Loader resolves HTTP via `HttpGet` / `HttpGetAsync` / `request` /
  `http_request`, and `loadstring` / `load`.
- Window parenting falls back to `PlayerGui` if `gethui()` cannot hold the
  ScreenGui.
- Loader supports `SpiffConfig.Ref` (a tag or commit SHA) because
  raw.githubusercontent caches `main` and ignores query-string cache busting.

### Changed

- `demo.luau` is now a full showcase: 4 pages, every element, all widgets, and
  working callbacks (WalkSpeed/JumpPower, infinite jump, teleport, camera,
  accent recolor, saved-config listing, unload).

## [1.0.0] - 2026-10-06

### Added

- Phase 0: project docs (`GOAL`, `ROADMAP`, `ARCHITECTURE`, `CONTEXT`), README,
  LICENSE, `.gitignore`.
- Phase 1: `state`, `util/*` (math, signal, theme, filesystem, index),
  `render/index` native-Instance backend, `manifest`, runtime `loader`, `init`
  returning the `Library` table, smoke test.
- Phase 2/3: `core/window` (ScreenGui, title bar, tab strip, drag, toggle key,
  destroy), `core/page` (tabs + two-column scroll body), `core/section`
  (bordered panel with a dynamic `AddX` surface).
- Phase 4: `elements/base` (row + flag registry), `label`, `button`, `toggle`,
  `slider`; `:Set`/`:Get`/`:Destroy` on each.
- Phase 5: `elements/textbox`, `dropdown`, `multibox` (inline expand), `keybind`
  (click-to-rebind + press/release hooks); `render.textbox` primitive.
- Phase 6: `elements/colorpicker` (HSV, reuses the slider), `listbox`, `configbox`,
  `buttonholder`.
- Phase 7: widgets `watermark`, `notifications`, `keybindslist`, `statuslist`;
  window methods to create them; keybind elements self-register for the list.

- Phase 8: `util/serialize` (Color3/EnumItem JSON codecs), `Window:GetConfig`,
  `SaveConfig`, `LoadConfig`, `DeleteConfig`, `ListConfigs`; `Library.Theme`
  exposed for live `UpdateColor`; config folders ensured on load.

### Skipped

- Custom cursor widget: native Roblox cursors already work; a drawn cursor adds
  nothing here. Add only if a Drawing backend lands.

- Phase 9: destroy guards on window toggle/drag and slider/keybind input
  handlers; `Window:Destroy` sets a `destroyed` flag; `docs/API.md`.

### Verified

- All `.luau` files compile with `luau-compile` (Luau 0.741).
