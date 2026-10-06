-- elements/buttonholder.luau | Octernal: a horizontal strip of full buttons
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}

		local row = render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = base.order(section),
		})
		render.list(row, { horizontal = true, padding = 4 })

		function api:Add(name, callback)
			local btn = render.button(row, {
				Text = tostring(name),
				Size = UDim2.new(0.5, -2, 1, 0),
				BackgroundColor3 = theme.lightcontrast,
				BackgroundTransparency = 0,
				TextColor3 = theme.text,
			})
			render.borders(btn, theme.outline, theme.inline)
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
