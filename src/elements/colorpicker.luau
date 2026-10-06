-- elements/colorpicker.luau | Octernal: name + right swatch, expands to H/S/V sliders
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local Slider = ctx.require("elements.slider")
		local api = {}
		local value = info.value or info.Value or Color3.new(1, 1, 1)
		local syncing = false
		local open = false

		local row = base.plain(section, 19)

		render.label(row, {
			Text = info.name or "Color",
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local swatch = render.frame(row, {
			Size = UDim2.fromOffset(30, 15),
			Position = UDim2.new(1, -34, 0, 2),
			BackgroundColor3 = value,
		})
		render.borders(swatch, theme.outline, theme.inline)

		local header = render.button(row, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" })

		local holder = render.frame(row, {
			Position = UDim2.new(0, 0, 0, 19),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = theme.darkcontrast,
			Visible = false,
		})
		render.borders(holder, theme.outline, theme.inline)
		render.list(holder, { padding = 4 })
		render.padding(holder, 6, 6)

		local preview = render.frame(holder, {
			Size = UDim2.new(1, 0, 0, 15),
			BackgroundColor3 = value,
		})
		render.borders(preview, theme.outline, theme.inline)

		local h, s, v = value:ToHSV()

		local function apply()
			value = Color3.fromHSV(h, s, v)
			swatch.BackgroundColor3 = value
			preview.BackgroundColor3 = value
			if not syncing and info.callback then
				info.callback(value)
			end
		end

		local fake = { content = holder }
		local sliderH = Slider.new(fake, { name = "H", min = 0, max = 1, value = h, callback = function(nv)
			h = nv
			apply()
		end })
		local sliderS = Slider.new(fake, { name = "S", min = 0, max = 1, value = s, callback = function(nv)
			s = nv
			apply()
		end })
		local sliderV = Slider.new(fake, { name = "V", min = 0, max = 1, value = v, callback = function(nv)
			v = nv
			apply()
		end })

		local holderHeight = 15 + 3 * 31 + 12

		function api:Toggle(state)
			open = (state == nil) and not open or state
			holder.Visible = open
			row.Size = UDim2.new(1, 0, 0, open and (19 + holderHeight) or 19)
		end
		function api:Set(color)
			syncing = true
			value = color
			h, s, v = color:ToHSV()
			sliderH:Set(h)
			sliderS:Set(s)
			sliderV:Set(v)
			syncing = false
			apply()
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			sliderH:Destroy()
			sliderS:Destroy()
			sliderV:Destroy()
			row:Destroy()
		end

		ctx.util.signal.connect(header.MouseButton1Click, function()
			api:Toggle()
		end)

		return base.register(api, base.autoFlag(info))
	end

	return M
end
