-- elements/button.luau | clickable action row
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local row = base.row(section, { name = info.text or info.name or "Button", height = info.height or 26 })

		local btn = render.button(row, {
			Text = info.action or "Run",
			Size = UDim2.new(0, 64, 0, 18),
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = theme.accent,
			BackgroundTransparency = 0,
			TextColor3 = theme.background,
			TextSize = 12,
		})
		theme:Track(btn, "BackgroundColor3", "accent")
		theme:Track(btn, "TextColor3", "background")

		ctx.util.signal.connect(btn.MouseButton1Click, function()
			if info.callback then
				info.callback()
			end
		end)

		function api:Set(text)
			btn.Text = tostring(text)
		end
		function api:Get()
			return btn.Text
		end
		function api:Destroy()
			row:Destroy()
		end

		return base.register(api, info.flag)
	end

	return M
end
