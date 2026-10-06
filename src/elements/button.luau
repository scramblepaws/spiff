-- elements/button.luau | full-width outline->inline->lightcontrast button, centered text
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local axis = section.axis

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.lightcontrast)
		local label = render.label(fill, {
			Text = info.text or info.name or "Button",
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local click = render.button(section.frame, {
			Position = UDim2.new(0, 4, 0, axis),
			Size = UDim2.new(1, -8, 0, 20),
			BackgroundTransparency = 1,
			Text = "",
		})
		ctx.util.signal.connect(click.MouseEnter, function()
			fill.BackgroundColor3 = theme.inline
		end)
		ctx.util.signal.connect(click.MouseLeave, function()
			fill.BackgroundColor3 = theme.lightcontrast
		end)
		ctx.util.signal.connect(click.MouseButton1Click, function()
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
			outer:Destroy()
			label:Destroy()
			click:Destroy()
		end

		base.advance(section, 20)
		return base.register(api, info.flag)
	end

	return M
end
