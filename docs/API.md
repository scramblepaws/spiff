# API

## Library

```lua
local Menu = getgenv().Spiff   -- set by loader.luau
Menu._NAME, Menu._VERSION
Menu.Theme                     -- palette table; Menu.Theme:UpdateColor(key, color3)
Menu.Window(info)              -- -> Window
Menu:Unload()                  -- destroy all windows + disconnect everything
```

### `Menu.Window(info)`

| field | type | default |
|---|---|---|
| `name` / `title` | string | `"spiff"` |
| `size` | Vector2 | `520, 380` |
| `toggleKey` | Enum.KeyCode | `RightShift` |
| `parent` | Instance | `gethui()` / PlayerGui |

Methods: `:Page(info)`, `:Show()`, `:Hide()`, `:Toggle()`, `:Destroy()`,
`:Watermark(info)`, `:Notifications(info)`, `:KeybindsList(info)`,
`:StatusList(info)`, `:GetConfig()`, `:SaveConfig(name)`, `:LoadConfig(name)`,
`:DeleteConfig(name)`, `:ListConfigs()`.

### `win:Page(info)`

`name` / `title` -> string. Methods: `:Section(info)`, `:Show()`,
`:SetActive(on)`, `:Destroy()`.

### `page:Section(info)`

`name`, `side` (`"left"` | `"right"`). Element builders:

| builder | `info` |
|---|---|
| `:AddLabel` | `text` |
| `:AddButton` | `name`, `action`, `callback` |
| `:AddToggle` | `name`, `value`, `callback(boolean)` |
| `:AddSlider` | `name`, `min`, `max`, `value`, `step`, `decimals`, `callback(number)` |
| `:AddTextbox` | `name`, `value`, `placeholder`, `callback(string)` |
| `:AddDropdown` | `name`, `options`, `value`, `callback(value)` |
| `:AddMultibox` | `name`, `options`, `value` (bool array), `callback(array)` |
| `:AddKeybind` | `name`, `value` (Enum.KeyCode), `callback`, `onpress`, `onrelease` |
| `:AddColorpicker` | `name`, `value` (Color3), `callback(Color3)` |
| `:AddListbox` | `name`, `options`, `value`, `height`, `callback(value)` |
| `:AddConfigbox` | `name`, `value` |
| `:AddButtonholder` | `name`, `buttons` -> `{ { name, callback }, ... }` |

Every element returns an api with `:Set(value)`, `:Get()`, `:Destroy()`.
Pass `flag = "uniqueKey"` to make it serializable by config save/load.

### `win:Notifications():Add({ text, lifetime })`

### `win:Watermark({ text })`, `win:StatusList():Set(name, text)`

## Theme keys

`accent`, `background`, `surface`, `section`, `row`, `inline`, `outline`,
`text`, `dim`, `font`, `textsize`.
