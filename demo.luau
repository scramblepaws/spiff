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
general:AddTextbox({ name = "Name", value = "guest", callback = function(v)
	print("[demo] name", v)
end })
general:AddDropdown({ name = "Mode", options = { "Casual", "Ranked", "Deathmatch" }, value = "Casual", callback = function(v)
	print("[demo] mode", v)
end })
general:AddMultibox({ name = "Extras", options = { "ESP", "Aim", "Fly" }, callback = function(v)
	print("[demo] extras", table.concat(v, ","))
end })
general:AddKeybind({ name = "Toggle UI", value = Enum.KeyCode.RightShift })
general:AddColorpicker({ name = "Accent", value = Color3.fromRGB(178, 156, 255), callback = function(c)
	Menu.Theme:UpdateColor("accent", c)
end })
general:AddListbox({ name = "Loadout", options = { "Default", "Sniper", "Rusher" }, callback = function(v)
	print("[demo] loadout", v)
end })
general:AddButtonholder({ name = "Quick", buttons = {
	{ name = "A", callback = function() print("[demo] A") end },
	{ name = "B", callback = function() print("[demo] B") end },
} })

local settings = win:Page({ name = "Settings" })
settings:Section({ name = "Config", side = "right" })

print("[demo] spiff", Menu._VERSION, "ok")
