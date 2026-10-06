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

local sec = page:Section({ name = "Left", side = "left" })
assert(sec.frame ~= nil, "[smoke] section.frame missing")

local label = sec:AddLabel({ text = "hi" })
assert(label:Get() == "hi", "[smoke] label Set/Get")

local fired = false
local button = sec:AddButton({ name = "B", callback = function()
	fired = true
end })
assert(type(button) == "table", "[smoke] button missing")
button:Set("Go")
assert(button:Get() == "Go", "[smoke] button Set/Get")

local toggle = sec:AddToggle({ name = "T", value = false })
assert(toggle:Get() == false, "[smoke] toggle initial")
toggle:Set(true)
assert(toggle:Get() == true, "[smoke] toggle Set/Get")

local slider = sec:AddSlider({ name = "S", min = 0, max = 10, value = 5, step = 1 })
assert(slider:Get() == 5, "[smoke] slider initial")
slider:Set(7)
assert(slider:Get() == 7, "[smoke] slider Set/Get")
slider:Set(99)
assert(slider:Get() == 10, "[smoke] slider clamp")

win:Destroy()
assert(win.gui == nil, "[smoke] window:Destroy did not clear gui")

print("[smoke] ok", Menu._VERSION)
