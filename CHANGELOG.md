# Changelog

All notable changes to spiff are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/).

## [Unreleased]

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

### Skipped

- Custom cursor widget: native Roblox cursors already work; a drawn cursor adds
  nothing here. Add only if a Drawing backend lands.

### Verified

- All `.luau` files compile with `luau-compile` (Luau 0.741).
