# spiff

A maintainable, modular Roblox menu library in Luau. Native Roblox Instances,
sUNC/UNC-compatible, split into small files (every file < 500 lines).

Feature/feel is modeled on [Octernal Lib](https://github.com/ro0ti/Roblox-Scripting-UI)
(window, pages, sections, and a full element set) but organized as composable
modules instead of one ~5,500-line script.

- **Status:** v1.0.0 (see [docs/ROADMAP.md](docs/ROADMAP.md), [docs/API.md](docs/API.md))
- **Runs in:** Roblox executors supporting the sUNC/UNC API (`loadstring`,
  `HttpGet`, `gethui`, `cloneref`, filesystem functions)
- **Rendering:** native `Instance`s (`ScreenGui` / `Frame`), not the `Drawing` API

## Quickstart

```lua
-- one-liner loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/scramblepaws/spiff/main/loader.luau"))()

-- or, if the lib is already loaded:
local Menu = getgenv().Spiff
local win = Menu.Window({ name = "spiff" })
local page = win:Page({ name = "Main" })
local sec = page:Section({ name = "General", side = "left" })
sec:AddToggle({ name = "Walk", flag = "walk", value = false, callback = print })
```

## Layout

| Path | Purpose |
|---|---|
| `loader.luau` | fetches + assembles `src/**`, exposes `getgenv().Spiff` |
| `demo.luau` | runnable usage proof |
| `docs/` | goal, roadmap, architecture, glossary |
| `src/state.luau` | shared registries (connections, flags, colors, folders) |
| `src/util/` | math, signals, theme, filesystem, misc helpers |
| `src/render/` | native-Instance backend (the only file a new backend replaces) |
| `src/core/` | window, page, section |
| `src/elements/` | label, button, toggle, slider, textbox, dropdown, ... |
| `src/widgets/` | watermark, notifications, keybinds list, status list, cursor |
| `tests/smoke.luau` | builds every element and asserts no errors |

## Conventions

- Every module returns `function(ctx) -> value`; shared state travels in `ctx`.
- Public API objects expose `:Set(v)`, `:Get()`, `:Destroy()`.
- Keep each file under 500 lines; split before crossing.
- Mark deliberate simplifications with a `ponytail:` comment.
