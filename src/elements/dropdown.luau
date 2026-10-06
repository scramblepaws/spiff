-- elements/dropdown.luau | single-select list that expands inline
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

		local row = base.row(section, { name = info.name or "Dropdown", height = 24 })
		row.ClipsDescendants = false

		local valueLabel = render.label(row, {
			Position = UDim2.new(1, -24, 0, 0),
			Size = UDim2.new(0, 110, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = tostring(value or ""),
		})
		theme:Track(valueLabel, "TextColor3", "dim")

		local arrow = render.label(row, {
			Text = "v",
			Position = UDim2.new(1, -14, 0, 0),
			Size = UDim2.new(0, 10, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
		})
		theme:Track(arrow, "TextColor3", "text")

		local header = render.button(row, { Size = UDim2.new(1, 0, 0, 24), Text = "" })

		local holder = render.frame(row, {
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = theme.background,
			Visible = false,
		})
		render.list(holder, { padding = 2 })
		render.padding(holder, 4, 2)

		for i, opt in ipairs(options) do
			local option = render.button(holder, {
				Text = tostring(opt),
				Size = UDim2.new(1, 0, 0, 20),
				TextColor3 = theme.text,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = i,
				BackgroundColor3 = theme.row,
				BackgroundTransparency = 0,
			})
			ctx.util.signal.connect(option.MouseButton1Click, function()
				api:Set(opt)
				api:Toggle(false)
			end)
		end

		function api:Toggle(state)
			open = (state == nil) and not open or state
			holder.Visible = open
			row.Size = UDim2.new(1, 0, 0, open and (24 + #options * 22 + 4) or 24)
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
