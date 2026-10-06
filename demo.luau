-- demo.luau | runnable usage proof. Grows one phase at a time.
local Menu = getgenv().Spiff
assert(Menu, "[demo] Spiff not loaded; run loader.luau first")

local win = Menu.Window({ name = "spiff demo" })

local main = win:Page({ name = "Main" })
local general = main:Section({ name = "General", side = "left" })
general:AddLabel({ text = "spiff " .. Menu._VERSION })
general:AddToggle({ name = "Enabled", value = true, callback = function(v)
	print("[demo] enabled", v)
end })
general:AddSlider({ name = "Speed", min = 0, max = 100, value = 25, callback = function(v)
	print("[demo] speed", v)
end })
general:AddButton({ name = "Ping", callback = function()
	print("[demo] pong")
end })

local settings = win:Page({ name = "Settings" })
settings:Section({ name = "Config", side = "right" })

print("[demo] spiff", Menu._VERSION, "ok")
