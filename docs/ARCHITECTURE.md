# Architecture

## Runtime flow

```
loader.luau
  ├─ HttpGet(src/manifest.luau)          -- ordered list of module keys
  ├─ for each key: HttpGet(src/<key>.luau?cb=..) -> loadstring -> fn
  ├─ build ctx { state, util, render, mods, require, Library }
  └─ Library = ctx.require("init")(ctx)  -- entry wires everything
getgenv().Spiff = Library
```

No bundler. `src/` is the source of truth; the loader assembles it at load time.
`?cb=<tick()>` busts raw.githubusercontent caches during development.

## Module contract

Every file under `src/` returns a single function of `ctx`:

```lua
return function(ctx)
    -- build using ctx.state / ctx.util / ctx.render
    return SomeBuilder
end
```

`ctx.require(key)` resolves a module once and caches it. Keys map to paths by
replacing `.` with `/`, e.g. `core.window` -> `src/core/window.luau`.

## ctx

| Field | Meaning |
|---|---|
| `state` | shared registries: `connections`, `flags`, `colors`, `folders`, `root` |
| `util` | helpers: math, signals, theme, filesystem, misc |
| `render` | native-Instance backend (the swap point for a Drawing backend) |
| `require(key)` | cached module resolver |
| `Library` | populated by `init`, returned to the user |

## Object contract

Public objects (`Window`, `Page`, `Section`, every element) expose:

- `:Set(value)` — set the current value
- `:Get()` — read the current value
- `:Destroy()` — tear down instances and connections

Elements register their value in `state.flags[flag]` so config can serialize the
whole tree.

## Backend

`src/render/index.luau` is the only place that knows about instances. It exposes
primitives (`frame`, `label`, `button`, `stroke`, `gradient`, `scroll`, `list`,
`corner`, `padding`). Swapping in a `Drawing` backend means writing a second
file with the same primitives; core/elements/widgets are untouched.

## Layout

```
src/
  manifest.luau      load order
  init.luau          wires modules, returns Library
  state.luau         shared registries
  util/   index math signal theme filesystem
  render/ index
  core/   window page section
  elements/ label button toggle slider textbox dropdown multibox keybind
            colorpicker listbox configbox buttonholder
  widgets/ watermark notifications keybindslist statuslist cursor
```
