-- elements/button.luau | Octernal: full-width control with centered text
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local row = base.control(section, 20, theme.lightcontrast)

		local label = render.label(row, {
			Text = info.text or info.name or "Button",
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})

		local btn = render.button(row, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
		})
		ctx.util.signal.connect(btn.MouseEnter, function()
			row.BackgroundColor3 = theme.inline
		end)
		ctx.util.signal.connect(btn.MouseLeave, function()
			row.BackgroundColor3 = theme.lightcontrast
		end)
		ctx.util.signal.connect(btn.MouseButton1Click, function()
			if info.callback then
				info.callback()
			end
		end)

		function api:Set(text)
			label.Text = tostring(text)
		end
		function api:Get()
			return label.Text
		end
		function api:Destroy()
			row:Destroy()
		end

		return base.register(api, info.flag)
	end

	return M
end
