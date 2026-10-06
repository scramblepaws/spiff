-- elements/buttonholder.luau | a row that holds a horizontal strip of buttons
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local row = base.row(section, { name = info.name or "", height = info.height or 26 })

		local holder = render.frame(row, {
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
		})
		render.list(holder, { horizontal = true, padding = 4 })

		function api:Add(name, callback)
			local btn = render.button(holder, {
				Text = tostring(name),
				Size = UDim2.new(0, 64, 0, 18),
				BackgroundColor3 = theme.accent,
				BackgroundTransparency = 0,
				TextColor3 = theme.background,
				TextSize = 12,
			})
			render.corner(btn, 3)
			ctx.util.signal.connect(btn.MouseButton1Click, function()
				if callback then
					callback()
				end
			end)
			return btn
		end
		function api:Destroy()
			row:Destroy()
		end

		for _, button in ipairs(info.buttons or {}) do
			api:Add(button.name, button.callback)
		end

		return base.register(api, base.autoFlag(info))
	end

	return M
end
