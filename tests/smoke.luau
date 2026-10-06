-- tests/smoke.luau | run after loader.luau in an executor.
-- Builds the library and asserts the public surface exists. Grows each phase.
local Menu = getgenv().Spiff
assert(Menu, "[smoke] Spiff not loaded")

assert(type(Menu.Unload) == "function", "[smoke] Library.Unload missing")
assert(type(Menu.Window) == "function", "[smoke] Library.Window missing")

local win = Menu.Window({ name = "spiff smoke" })
assert(type(win.Page) == "function", "[smoke] Window:Page missing")
assert(win.main ~= nil, "[smoke] window.main missing")

local page = win:Page({ name = "Smoke" })
assert(type(page.Section) == "function", "[smoke] Page:Section missing")
assert(page.content ~= nil, "[smoke] page.content missing")

local left = page:Section({ name = "Left", side = "left" })
local right = page:Section({ name = "Right", side = "right" })
assert(left.frame ~= nil and right.frame ~= nil, "[smoke] section.frame missing")

local page2 = win:Page({ name = "Second" })
page2:Show()
assert(win.currentPage == page2, "[smoke] page:Show did not set currentPage")

win:Destroy()
assert(win.gui == nil, "[smoke] window:Destroy did not clear gui")

print("[smoke] ok", Menu._VERSION)
