-- elements/colorpicker.luau | name + right swatch; expands to H/S/V sliders below
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
		local axis = section.axis

		render.label(section.frame, {
			Text = info.name or "Color",
			Position = UDim2.new(0, 4, 0, axis),
			Size = UDim2.new(1, -44, 0, 15),
		})
		local swatchOuter, _, swatch = base.stack(section.frame, UDim2.new(1, -34, 0, axis), UDim2.new(0, 30, 0, 15), theme.outline, theme.inline, Color3.new(1, 1, 1))
		swatch.BackgroundColor3 = value
		local header = render.button(section.frame, {
			Position = UDim2.new(0, 0, 0, axis),
			Size = UDim2.new(1, 0, 0, 15),
			BackgroundTransparency = 1,
			Text = "",
		})

		local holder = render.frame(section.frame, {
			Position = UDim2.new(0, 4, 0, axis + 15),
			Size = UDim2.new(1, -8, 0, 109),
			BackgroundTransparency = 1,
			Visible = false,
		})
		local _, _, preview = base.stack(holder, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 15), theme.outline, theme.inline, Color3.new(1, 1, 1))
		preview.BackgroundColor3 = value

		local h, s, v = value:ToHSV()

		local fake = setmetatable({ frame = holder, axis = 19, side = "left" }, {
			__index = {
				Update = function() end,
			},
		})

		local function apply()
			value = Color3.fromHSV(h, s, v)
			swatch.BackgroundColor3 = value
			preview.BackgroundColor3 = value
			if not syncing and info.callback then
				info.callback(value)
			end
		end

		local sliderH = Slider.new(fake, { name = "H", min = 0, max = 1, value = h, flag = "", callback = function(nv)
			h = nv
			apply()
		end })
		local sliderS = Slider.new(fake, { name = "S", min = 0, max = 1, value = s, flag = "", callback = function(nv)
			s = nv
			apply()
		end })
		local sliderV = Slider.new(fake, { name = "V", min = 0, max = 1, value = v, flag = "", callback = function(nv)
			v = nv
			apply()
		end })

		function api:Toggle(state)
			holder.Visible = (state == nil) and not holder.Visible or state
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
			swatchOuter:Destroy()
			header:Destroy()
			holder:Destroy()
		end

		ctx.util.signal.connect(header.MouseButton1Click, function()
			api:Toggle()
		end)

		base.advance(section, 15)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
