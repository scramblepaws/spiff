-- demo.luau | runnable usage proof. Grows one phase at a time.
local Menu = getgenv().Spiff
assert(Menu, "[demo] Spiff not loaded; run loader.luau first")

local win = Menu.Window({ name = "spiff demo" })
local main = win:Page({ name = "Main" })
local general = main:Section({ name = "General", side = "left" })
local settings = win:Page({ name = "Settings" })
local config = settings:Section({ name = "Config", side = "right" })

print("[demo] spiff", Menu._VERSION, "ok")
