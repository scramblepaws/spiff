-- elements/toggle.luau | boolean switch row
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value == true
		local row = base.row(section, { name = info.name or "Toggle" })

		local box = render.frame(row, {
			Size = UDim2.new(0, 18, 0, 18),
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = value and theme.accent or theme.inline,
		})
		render.stroke(box, theme.outline, 1)

		local click = render.button(row, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
		})

		function api:Set(v)
			value = v == true
			box.BackgroundColor3 = value and theme.accent or theme.inline
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
