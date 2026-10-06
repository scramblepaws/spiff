-- elements/keybind.luau | click to rebind, fires on key press/release
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

		local row = base.row(section, { name = info.name or "Keybind" })
		local btn = render.button(row, {
			Text = value.Name,
			Size = UDim2.new(0, 90, 0, 18),
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = theme.row,
			BackgroundTransparency = 0,
			TextColor3 = theme.text,
			TextSize = 12,
		})
		render.corner(btn, 3)
		render.stroke(btn, theme.outline, 1)

		function api:Set(key)
			value = key or Enum.KeyCode.Unknown
			btn.Text = value.Name
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
			btn.Text = "..."
		end)

		ctx.util.signal.connect(UIS.InputBegan, function(input, gpe)
			if gpe then
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
			if value ~= Enum.KeyCode.Unknown and input.KeyCode == value then
				if info.onrelease then
					info.onrelease(false)
				end
			end
		end)

		return base.register(api, base.autoFlag(info))
	end

	return M
end
