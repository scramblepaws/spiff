-- elements/dropdown.luau | full-width box; options overlay below when open
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
		local open = false
		local holder = {}

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.darkcontrast)
		local valueLabel = render.label(fill, {
			Text = tostring(value or ""),
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -24, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local arrow = render.label(fill, {
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
				render.label(f, {
					Text = tostring(opt),
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -12, 1, 0),
					TextYAlignment = Enum.TextYAlignment.Center,
				})
				local b = render.button(o, {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
				})
				ctx.util.signal.connect(b.MouseButton1Click, function()
					api:Set(opt)
					close()
				end)
				holder[#holder + 1] = o
			end
		end

		function api:Toggle(state)
			if (state == nil and not open) or state == true then
				expand()
			else
				close()
			end
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

		base.advance(section, 20)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
