-- elements/buttonholder.luau | a horizontal strip of full buttons
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local axis = section.axis

		local row = render.frame(section.frame, {
			Position = UDim2.new(0, 4, 0, axis),
			Size = UDim2.new(1, -8, 0, 20),
			BackgroundTransparency = 1,
		})
		render.list(row, { horizontal = true, padding = 4 })

		local function add(name, callback, scale)
			local btn = render.button(row, {
				Text = tostring(name),
				Size = UDim2.new(scale, -3, 1, 0),
				BackgroundColor3 = theme.inline,
				BackgroundTransparency = 0,
				TextColor3 = theme.textcolor,
			})
			render.borders(btn, theme.outline)
			ctx.util.signal.connect(btn.MouseButton1Click, function()
				if callback then
					callback()
				end
			end)
			return btn
		end

		local buttons = info.buttons or {}
		local n = #buttons
		for _, button in ipairs(buttons) do
			add(button.name, button.callback, 1 / n)
		end

		function api:Add(name, callback)
			return add(name, callback, 0.5)
		end
		function api:Destroy()
			row:Destroy()
		end

		base.advance(section, 20)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
