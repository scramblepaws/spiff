-- elements/keybind.luau | Octernal: full-width control, name left, key right
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local UIS = game:GetService("UserInputService")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value or info.Value or Enum.KeyCode.Unknown
		local listening = false

		local row = base.control(section, 20, theme.darkcontrast)
		render.label(row, {
			Text = info.name or "Keybind",
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -110, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local keyLabel = render.label(row, {
			Text = value.Name,
			Position = UDim2.new(1, -8, 0, 0),
			Size = UDim2.new(0, 100, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
		})

		local btn = render.button(row, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })

		function api:Set(key)
			value = key or Enum.KeyCode.Unknown
			keyLabel.Text = value.Name
			if info.callback then
				info.callback(value)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			for i, entry in ipairs(ctx.state.keybinds) do
				if entry.get == api.Get then
					table.remove(ctx.state.keybinds, i)
					break
				end
			end
			row:Destroy()
		end

		ctx.state.keybinds[#ctx.state.keybinds + 1] = { name = info.name or "Keybind", get = api.Get }

		ctx.util.signal.connect(btn.MouseButton1Click, function()
			listening = true
			keyLabel.Text = "..."
		end)

		ctx.util.signal.connect(UIS.InputBegan, function(input, gpe)
			if gpe or not row.Parent then
				return
			end
			if listening then
				listening = false
				api:Set(input.KeyCode)
			elseif value ~= Enum.KeyCode.Unknown and input.KeyCode == value then
				if info.onpress then
					info.onpress(true)
				end
			end
		end)

		ctx.util.signal.connect(UIS.InputEnded, function(input)
			if row.Parent and value ~= Enum.KeyCode.Unknown and input.KeyCode == value then
				if info.onrelease then
					info.onrelease(false)
				end
			end
		end)

		return base.register(api, base.autoFlag(info))
	end

	return M
end
