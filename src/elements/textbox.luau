-- elements/textbox.luau | Octernal: full-width bordered input
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value or info.Value or ""
		local row = base.control(section, 20, theme.darkcontrast)

		local box = render.textbox(row, {
			Size = UDim2.new(1, -8, 1, -2),
			Position = UDim2.new(0, 4, 0, 1),
			BackgroundTransparency = 1,
			Text = tostring(value),
			PlaceholderText = info.placeholder or "type...",
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		ctx.util.signal.connect(box.FocusLost, function()
			value = box.Text
			if info.callback then
				info.callback(value)
			end
		end)

		function api:Set(text)
			value = tostring(text or "")
			box.Text = value
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			row:Destroy()
		end

		return base.register(api, base.autoFlag(info))
	end

	return M
end
