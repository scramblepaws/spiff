-- elements/toggle.luau | 15px checkbox at the left + label, accent when on
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value == true
		local axis = section.axis

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(0, 15, 0, 15), theme.outline, theme.inline, value and theme.accent or theme.lightcontrast)
		local label = render.label(section.frame, {
			Text = info.name or "Toggle",
			Position = UDim2.new(0, 23, 0, axis + 7),
			Size = UDim2.new(1, -30, 0, 15),
		})
		local click = render.button(section.frame, {
			Position = UDim2.new(0, 0, 0, axis),
			Size = UDim2.new(1, 0, 0, 15),
			BackgroundTransparency = 1,
			Text = "",
		})

		function api:Set(v)
			value = v == true
			fill.BackgroundColor3 = value and theme.accent or theme.lightcontrast
			if info.callback then
				info.callback(value)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			outer:Destroy()
			label:Destroy()
			click:Destroy()
		end

		ctx.util.signal.connect(click.MouseButton1Click, function()
			api:Set(not value)
		end)

		base.advance(section, 15)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
