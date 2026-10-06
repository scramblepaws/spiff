-- elements/dropdown.luau | Octernal: full-width box that expands inline
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
		local open = false

		local row = base.control(section, 20, theme.darkcontrast)
		row.ClipsDescendants = false

		render.label(row, {
			Text = info.name or "Dropdown",
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -130, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local valueLabel = render.label(row, {
			Text = tostring(value or ""),
			Position = UDim2.new(1, -18, 0, 0),
			Size = UDim2.new(0, 110, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = theme.dim,
		})
		render.label(row, {
			Text = "v",
			Position = UDim2.new(1, -12, 0, 0),
			Size = UDim2.new(0, 10, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local header = render.button(row, { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "" })

		local holder = render.frame(row, {
			Position = UDim2.new(0, 0, 0, 20),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = theme.darkcontrast,
			Visible = false,
		})
		render.borders(holder, theme.outline, theme.inline)
		render.list(holder, { padding = 0 })

		for i, opt in ipairs(options) do
			local option = render.button(holder, {
				Text = tostring(opt),
				Size = UDim2.new(1, 0, 0, 20),
				TextColor3 = theme.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = i,
				BackgroundColor3 = theme.lightcontrast,
				BackgroundTransparency = 0,
			})
			render.padding(option, 6, 0)
			ctx.util.signal.connect(option.MouseButton1Click, function()
				api:Set(opt)
				api:Toggle(false)
			end)
		end

		function api:Toggle(state)
			open = (state == nil) and not open or state
			holder.Visible = open
			row.Size = UDim2.new(1, 0, 0, open and (20 + #options * 20) or 20)
		end
		function api:Set(v)
			value = v
			valueLabel.Text = tostring(v)
			if info.callback then
				info.callback(v)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			row:Destroy()
		end

		ctx.util.signal.connect(header.MouseButton1Click, function()
			api:Toggle()
		end)

		return base.register(api, base.autoFlag(info))
	end

	return M
end
