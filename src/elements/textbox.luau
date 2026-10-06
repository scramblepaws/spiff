-- elements/textbox.luau | full-width outline->inline->darkcontrast input
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value or info.Value or ""
		local axis = section.axis

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.darkcontrast)
		local box = render.textbox(fill, {
			Size = UDim2.new(1, -8, 1, -2),
			Position = UDim2.new(0, 4, 0, 1),
			BackgroundTransparency = 1,
			Text = tostring(value),
			PlaceholderText = info.placeholder or "",
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
			outer:Destroy()
			box:Destroy()
		end

		base.advance(section, 20)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
