-- core/window.luau | top-level menu: ScreenGui, title bar, tab strip, body, drag, toggle key
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local UIS = game:GetService("UserInputService")

	local Window = {}
	Window.__index = Window

	local function resolveRoot()
		local ok, root = pcall(function()
			if typeof(gethui) == "function" then
				return gethui()
			end
			return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		end)
		if ok and root then
			return root
		end
		return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end

	function Window.new(info)
		info = info or {}
		local self = setmetatable({}, Window)
		self.title = info.name or info.title or "spiff"
		self.pages = {}
		self.currentPage = nil
		self.visible = true
		self.destroyed = false
		self.toggleKey = info.toggleKey or info.Key or Enum.KeyCode.RightShift
		local size = info.size or Vector2.new(520, 380)

		local root = info.parent or resolveRoot()
		local gui = render.create("ScreenGui", {
			Name = "spiff_" .. self.title,
			DisplayOrder = 999,
			ResetOnSpawn = false,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, root)
		self.gui = gui

		local main = render.frame(gui, {
			Name = "Main",
			Size = UDim2.fromOffset(size.X, size.Y),
			Position = UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2),
			BackgroundColor3 = theme.surface,
			Active = true,
		})
		render.stroke(main, theme.outline, 2)
		local accent = render.stroke(main, theme.accent, 1)
		theme:Track(accent, "Color", "accent")
		render.corner(main, 6)
		self.main = main

		local top = render.frame(main, {
			Name = "Top",
			Size = UDim2.new(1, 0, 0, 30),
			BackgroundColor3 = theme.background,
			Active = true,
		})
		render.corner(top, 6)
		self.top = top

		local titleW = render.textSize(self.title).X
		local title = render.label(top, {
			Text = self.title,
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(0, titleW + 4, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		theme:Track(title, "TextColor3", "text")
		self.titleLabel = title

		local close = render.button(top, {
			Text = "x",
			Size = UDim2.new(0, 28, 1, 0),
			Position = UDim2.new(1, -28, 0, 0),
			TextSize = 16,
			TextColor3 = theme.dim,
		})
		ctx.util.signal.connect(close.MouseButton1Click, function()
			self:Hide()
		end)

		local strip = render.frame(top, {
			Name = "Tabs",
			Position = UDim2.new(0, 10 + titleW + 12, 0, 0),
			Size = UDim2.new(1, -(10 + titleW + 12 + 36), 1, 0),
			BackgroundTransparency = 1,
		})
		render.list(strip, { horizontal = true, padding = 4, vAlign = Enum.VerticalAlignment.Center })
		self.tabStrip = strip

		local body = render.frame(main, {
			Name = "Body",
			Position = UDim2.new(0, 1, 0, 31),
			Size = UDim2.new(1, -2, 1, -32),
			BackgroundTransparency = 1,
		})
		self.body = body

		-- toggle key
		ctx.util.signal.connect(UIS.InputBegan, function(input, gpe)
			if gpe or self.destroyed then
				return
			end
			if input.KeyCode == self.toggleKey then
				self:Toggle()
			end
		end)

		-- drag on the title bar
		local dragging, dragStart, startPos = false, nil, nil
		ctx.util.signal.connect(top.InputBegan, function(input)
			if
				self.destroyed
				or not (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				return
			end
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end)
		ctx.util.signal.connect(UIS.InputChanged, function(input)
			if
				not dragging
				or self.destroyed
				or not (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				return
			end
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end)
		ctx.util.signal.connect(UIS.InputEnded, function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = false
			end
		end)

		ctx.state.windows[#ctx.state.windows + 1] = self
		return self
	end

	function Window:Show()
		if self.destroyed then
			return
		end
		self.visible = true
		self.main.Visible = true
	end

	function Window:Hide()
		if self.destroyed then
			return
		end
		self.visible = false
		self.main.Visible = false
	end

	function Window:Toggle()
		if self.destroyed then
			return
		end
		if self.visible then
			self:Hide()
		else
			self:Show()
		end
	end

	function Window:Page(info)
		local Page = ctx.require("core.page")
		local page = Page.new(self, info)
		self.pages[#self.pages + 1] = page
		if #self.pages == 1 then
			page:Show()
		end
		return page
	end

	function Window:GetConfig()
		local out = {}
		for flag, api in pairs(ctx.state.flags) do
			local ok, value = pcall(function()
				return api:Get()
			end)
			if ok then
				out[flag] = ctx.util.serialize.encode(value)
			end
		end
		return out
	end

	function Window:SaveConfig(name)
		local fs = ctx.util.filesystem
		fs.ensure(ctx.state.folders.main)
		fs.ensure(ctx.state.folders.configs)
		local path = ctx.state.folders.configs .. "/" .. name .. ".json"
		return fs.write(path, fs.encode(self:GetConfig()))
	end

	function Window:LoadConfig(name)
		local fs = ctx.util.filesystem
		local raw = fs.read(ctx.state.folders.configs .. "/" .. name .. ".json")
		if not raw then
			return false
		end
		local data = fs.decode(raw)
		if type(data) ~= "table" then
			return false
		end
		for flag, value in pairs(data) do
			local api = ctx.state.flags[flag]
			if api and api.Set then
				pcall(function()
					api:Set(ctx.util.serialize.decode(value))
				end)
			end
		end
		return true
	end

	function Window:DeleteConfig(name)
		if typeof(delfile) ~= "function" then
			return false
		end
		local path = ctx.state.folders.configs .. "/" .. name .. ".json"
		return pcall(delfile, path)
	end

	function Window:ListConfigs()
		local out = {}
		if typeof(listfiles) ~= "function" then
			return out
		end
		pcall(function()
			for _, file in ipairs(listfiles(ctx.state.folders.configs)) do
				local name = tostring(file):match("([^/\\]+)%.json$")
				if name then
					out[#out + 1] = name
				end
			end
		end)
		return out
	end

	function Window:Watermark(info)
		return ctx.require("widgets.watermark").new(self, info)
	end

	function Window:Notifications(info)
		return ctx.require("widgets.notifications").new(self, info)
	end

	function Window:KeybindsList(info)
		return ctx.require("widgets.keybindslist").new(self, info)
	end

	function Window:StatusList(info)
		return ctx.require("widgets.statuslist").new(self, info)
	end

	function Window:Destroy()
		self.destroyed = true
		if self.gui then
			self.gui:Destroy()
			self.gui = nil
		end
		for i, page in ipairs(self.pages) do
			pcall(function()
				page:Destroy()
			end)
			self.pages[i] = nil
		end
	end

	return Window
end
