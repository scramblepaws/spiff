-- elements/colorpicker.luau | swatch row that expands into H/S/V sliders.
-- Reuses the slider element (Ponytail: no second drag implementation).
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

		local row = base.row(section, { name = info.name or "Color", height = 24 })
		row.ClipsDescendants = false

		local swatch = render.frame(row, {
			Size = UDim2.new(0, 120, 0, 18),
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = value,
		})
		render.corner(swatch, 3)
		render.stroke(swatch, theme.outline, 1)

		local header = render.button(row, { Size = UDim2.new(1, 0, 0, 24), Text = "" })

		local holder = render.frame(row, {
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = theme.background,
			Visible = false,
		})
		render.corner(holder, 4)
		render.list(holder, { padding = 2 })
		render.padding(holder, 4, 4)

		local preview = render.frame(holder, {
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundColor3 = value,
		})
		render.corner(preview, 3)
		render.stroke(preview, theme.outline, 1)

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
		local sliderH = Slider.new(fake, { name = "H", min = 0, max = 1, decimals = 2, value = h, callback = function(nv)
			h = nv
			apply()
		end })
		local sliderS = Slider.new(fake, { name = "S", min = 0, max = 1, decimals = 2, value = s, callback = function(nv)
			s = nv
			apply()
		end })
		local sliderV = Slider.new(fake, { name = "V", min = 0, max = 1, decimals = 2, value = v, callback = function(nv)
			v = nv
			apply()
		end })

		local holderHeight = 16 + 3 * 36 + 6 + 8

		function api:Toggle(state)
			open = (state == nil) and not open or state
			holder.Visible = open
			row.Size = UDim2.new(1, 0, 0, open and (24 + holderHeight) or 24)
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
