-- elements/listbox.luau | bordered scrolling single-select list
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local options = info.options or info.Options or {}
		local value = info.value or info.Value or options[1]
		local axis = section.axis
		local h = info.height or 100

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, h), theme.outline, theme.inline, theme.darkcontrast)
		local scroll = render.scroll(fill)
		scroll.Position = UDim2.new(0, 1, 0, 1)
		scroll.Size = UDim2.new(1, -2, 1, -2)
		render.list(scroll, { padding = 0 })

		local buttons = {}
		local function highlight()
			for opt, btn in pairs(buttons) do
				btn.TextColor3 = (opt == value) and theme.accent or theme.textcolor
			end
		end

		for i, opt in ipairs(options) do
			local btn = render.button(scroll, {
				Text = tostring(opt),
				Size = UDim2.new(1, 0, 0, 18),
				TextColor3 = theme.textcolor,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = i,
				BackgroundTransparency = 1,
			})
			render.padding(btn, 6, 0)
			buttons[opt] = btn
			ctx.util.signal.connect(btn.MouseButton1Click, function()
				api:Set(opt)
			end)
		end

		function api:Set(v)
			value = v
			highlight()
			if info.callback then
				info.callback(v)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			outer:Destroy()
		end

		highlight()
		base.advance(section, h)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
