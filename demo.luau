-- demo.luau | full spiff showcase. Auto-runs from loader.luau, or call manually.
--   loadstring(game:HttpGet(".../spiff/main/demo.luau"))()
local Menu = getgenv().Spiff
assert(Menu, "[demo] Spiff not loaded; run loader.luau first")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local function humanoid()
	local char = player.Character
	return char and char:FindFirstChildOfClass("Humanoid") or nil
end

-- shared state the menu mutates
local S = getgenv().SpiffDemo or {
	speed = 16,
	jump = 50,
	infiniteJump = false,
	esp = false,
	accent = Color3.fromRGB(178, 156, 255),
}
getgenv().SpiffDemo = S

local win = Menu.Window({ name = "spiff demo", toggleKey = Enum.KeyCode.RightShift })
local notifications = win:Notifications()
local notify = function(text)
	notifications:Add({ text = text, lifetime = 4 })
end

-- ============================================================ Main
local main = win:Page({ name = "Main" })
local general = main:Section({ name = "General", side = "left" })
general:AddLabel({ text = "spiff " .. Menu._VERSION .. " | " .. player.Name })
general:AddToggle({
	name = "Infinite Jump",
	flag = "inf_jump",
	value = S.infiniteJump,
	callback = function(v)
		S.infiniteJump = v
		notify("Infinite Jump " .. (v and "on" or "off"))
	end,
})
general:AddSlider({
	name = "Walk Speed",
	flag = "speed",
	min = 16,
	max = 200,
	step = 1,
	value = S.speed,
	callback = function(v)
		S.speed = v
		local hum = humanoid()
		if hum then
			hum.WalkSpeed = v
		end
	end,
})
general:AddSlider({
	name = "Jump Power",
	flag = "jump",
	min = 50,
	max = 250,
	step = 1,
	value = S.jump,
	callback = function(v)
		S.jump = v
		local hum = humanoid()
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = v
		end
	end,
})
general:AddButton({ name = "Reset Character", callback = function()
	local hum = humanoid()
	if hum then
		hum.Health = 0
	end
end })
general:AddKeybind({ name = "Fly", flag = "fly", value = Enum.KeyCode.F, onpress = function()
	notify("Fly pressed (bind your logic here)")
end })

local movement = main:Section({ name = "Movement", side = "right" })
movement:AddToggle({ name = "Auto Sprint", flag = "sprint", value = false, callback = function(v)
	notify("Auto Sprint " .. (v and "on" or "off"))
end })
movement:AddTextbox({ name = "Teleport To", flag = "tp", value = "", placeholder = "player name", callback = function(v)
	local target = Players:FindFirstChild(v)
	local hum = humanoid()
	if target and target.Character and hum and hum.RootPart then
		hum.RootPart.CFrame = target.Character:GetPivot() * CFrame.new(0, 0, 3)
		notify("Teleported to " .. v)
	else
		notify("No player named " .. tostring(v))
	end
end })
movement:AddButtonholder({ name = "Camera", buttons = {
	{ name = "First", callback = function()
		player.CameraMode = Enum.CameraMode.LockFirstPerson
	end },
	{ name = "Third", callback = function()
		player.CameraMode = Enum.CameraMode.Classic
	end },
} })

-- ============================================================ Combat
local combat = win:Page({ name = "Combat" })
local aim = combat:Section({ name = "Aimbot", side = "left" })
aim:AddToggle({ name = "Enabled", flag = "aim", value = false, callback = function(v)
	notify("Aimbot " .. (v and "on" or "off"))
end })
aim:AddDropdown({
	name = "Hitbox",
	flag = "hitbox",
	options = { "Head", "Torso", "Nearest" },
	value = "Head",
	callback = function(v)
		notify("Hitbox: " .. v)
	end,
})
aim:AddSlider({ name = "FOV", flag = "fov", min = 10, max = 360, value = 90, step = 5, callback = function(v)
	notify("FOV " .. v)
end })

local target = combat:Section({ name = "Targeting", side = "right" })
target:AddMultibox({
	name = "Filters",
	flag = "filters",
	options = { "Team Check", "Wall Check", "Visible Only" },
	value = { true, false, true },
	callback = function(v)
		notify("Filters: " .. tostring(v[1]) .. tostring(v[2]) .. tostring(v[3]))
	end,
})
target:AddListbox({ name = "Priority", flag = "priority", options = { "Distance", "Health", "Threat" }, value = "Distance", callback = function(v)
	notify("Priority: " .. v)
end })

-- ============================================================ Visuals
local visuals = win:Page({ name = "Visuals" })
local esp = visuals:Section({ name = "ESP", side = "left" })
esp:AddToggle({ name = "Enabled", flag = "esp", value = false, callback = function(v)
	S.esp = v
	notify("ESP " .. (v and "on" or "off"))
end })
esp:AddColorpicker({ name = "Box Color", flag = "esp_color", value = Color3.fromRGB(0, 255, 128), callback = function(c)
	S.espColor = c
end })
esp:AddDropdown({ name = "Style", flag = "esp_style", options = { "Box", "Corner", "Both" }, value = "Box", callback = function(v)
	notify("ESP style: " .. v)
end })

local theme = visuals:Section({ name = "Theme", side = "right" })
theme:AddColorpicker({ name = "Accent", flag = "accent", value = S.accent, callback = function(c)
	S.accent = c
	Menu.Theme:UpdateColor("accent", c)
end })
theme:AddToggle({ name = "Rainbow Accent", flag = "rainbow", value = false, callback = function(v)
	S.rainbow = v
	if not v then
		Menu.Theme:UpdateColor("accent", S.accent)
	end
end })
theme:AddLabel({ text = "Keybinds overlay: see top-left." })

-- rainbow thread, lasts until unloaded
task.spawn(function()
	local t = 0
	while getgenv().Spiff == Menu do
		task.wait(0.05)
		if S.rainbow then
			t = t + 0.01
			Menu.Theme:UpdateColor("accent", Color3.fromHSV(t % 1, 0.55, 1))
		end
	end
end)

-- ============================================================ Config
local config = win:Page({ name = "Config" })
local saves = config:Section({ name = "Profiles", side = "left" })
saves:AddConfigbox({ name = "Profile", value = "default" })
saves:AddButton({ name = "List Saved", callback = function()
	local list = win:ListConfigs()
	notify("Configs: " .. (#list > 0 and table.concat(list, ", ") or "none"))
end })

local info = config:Section({ name = "Info", side = "right" })
info:AddLabel({ text = "Version: " .. Menu._VERSION })
info:AddLabel({ text = "Toggle UI: RightShift" })
info:AddButton({ name = "Test Notification", callback = function()
	notify("Hello from spiff!")
end })
info:AddButton({ name = "Unload", callback = function()
	Menu:Unload()
end })

-- ============================================================ widgets + engine hooks
win:Watermark({ text = "spiff" })
local status = win:StatusList()
status:Set("player", player.Name)
status:Set("speed", tostring(S.speed))
win:KeybindsList():Toggle(true)

local function applyHumanoid()
	local hum = humanoid()
	if hum then
		hum.WalkSpeed = S.speed
		hum.UseJumpPower = true
		hum.JumpPower = S.jump
	end
	status:Set("speed", tostring(S.speed))
end
applyHumanoid()
player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applyHumanoid()
end)

UIS.JumpRequest:Connect(function()
	if S.infiniteJump then
		local hum = humanoid()
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

notify("spiff " .. Menu._VERSION .. " loaded - press RightShift")
print("[demo] spiff", Menu._VERSION, "ok")
