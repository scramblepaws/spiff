-- elements/toggle.luau | Octernal: 15px checkbox on the left + label, no row box
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value == true
		local row = base.plain(section, 19)

		local box = render.frame(row, {
			Size = UDim2.fromOffset(15, 15),
			Position = UDim2.new(0, 4, 0, 2),
			BackgroundColor3 = value and theme.accent or theme.lightcontrast,
		})
		render.borders(box, theme.outline, theme.inline)

		render.label(row, {
			Text = info.name or "Toggle",
			Position = UDim2.new(0, 23, 0, 0),
			Size = UDim2.new(1, -30, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})

		local click = render.button(row, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
		})

		function api:Set(v)
			value = v == true
			box.BackgroundColor3 = value and theme.accent or theme.lightcontrast
			if info.callback then
				info.callback(value)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			row:Destroy()
		end

		ctx.util.signal.connect(click.MouseButton1Click, function()
			api:Set(not value)
		end)

		return base.register(api, base.autoFlag(info))
	end

	return M
end
