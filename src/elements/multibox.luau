-- elements/multibox.luau | dropdown that toggles many; count shown right
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local options = info.options or info.Options or {}
		local selected = {}
		local given = info.value or info.Value or {}
		for i = 1, #options do
			selected[i] = given[i] == true
		end
		local axis = section.axis
		local open = false
		local holder = {}

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.darkcontrast)
		local valueLabel = render.label(fill, {
			Position = UDim2.new(1, -18, 0, 0),
			Size = UDim2.new(0, 110, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = theme.dim,
		})
		render.label(fill, {
			Text = "v",
			Position = UDim2.new(1, -12, 0, 0),
			Size = UDim2.new(0, 10, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local header = render.button(section.frame, {
			Position = UDim2.new(0, 4, 0, axis),
			Size = UDim2.new(1, -8, 0, 20),
			BackgroundTransparency = 1,
			Text = "",
		})

		local function close()
			open = false
			for _, o in ipairs(holder) do
				o:Destroy()
			end
			holder = {}
		end

		local function expand()
			close()
			open = true
			for i, opt in ipairs(options) do
				local o, _, f = base.stack(section.frame, UDim2.new(0, 4, 0, axis + 20 + (i - 1) * 20), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.darkcontrast)
				local t = render.label(f, {
					Text = tostring(opt),
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -12, 1, 0),
					TextYAlignment = Enum.TextYAlignment.Center,
					TextColor3 = selected[i] and theme.accent or theme.textcolor,
				})
				local b = render.button(o, {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
				})
				ctx.util.signal.connect(b.MouseButton1Click, function()
					selected[i] = not selected[i]
					t.TextColor3 = selected[i] and theme.accent or theme.textcolor
					api:Refresh()
					if info.callback then
						info.callback(selected)
					end
				end)
				holder[#holder + 1] = o
			end
		end

		function api:Refresh()
			local count = 0
			for i = 1, #options do
				if selected[i] then
					count = count + 1
				end
			end
			valueLabel.Text = count .. " selected"
		end

		function api:Toggle(state)
			if (state == nil and not open) or state == true then
				expand()
			else
				close()
			end
		end
		function api:Set(v)
			for i = 1, #options do
				selected[i] = v and v[i] == true or false
			end
			api:Refresh()
			if info.callback then
				info.callback(selected)
			end
		end
		function api:Get()
			return selected
		end
		function api:Destroy()
			close()
			outer:Destroy()
			header:Destroy()
		end

		ctx.util.signal.connect(header.MouseButton1Click, function()
			if open then
				close()
			else
				expand()
			end
		end)

		api:Refresh()
		base.advance(section, 20)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
