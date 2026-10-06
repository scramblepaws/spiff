-- elements/slider.luau | title above a full-width track, value centered on it
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local UIS = game:GetService("UserInputService")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local min = info.min or info.Min or 0
		local max = info.max or info.Max or 100
		local step = info.step or info.Step or 0
		local suffix = info.suffix or info.Suffix or ""
		local value = info.value or info.Value or min
		local axis = section.axis

		local title = render.label(section.frame, {
			Text = info.name or "Slider",
			Position = UDim2.new(0, 4, 0, axis),
			Size = UDim2.new(1, -8, 0, 15),
		})
		local outer, mid, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis + 15), UDim2.new(1, -8, 0, 12), theme.outline, theme.inline, theme.lightcontrast)
		local slide = render.frame(mid, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(0, 0, 1, -2),
			BackgroundColor3 = theme.accent,
		})
		theme:Track(slide, "BackgroundColor3", "accent")
		local valueLabel = render.label(fill, {
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		local hit = render.button(section.frame, {
			Position = UDim2.new(0, 4, 0, axis + 15),
			Size = UDim2.new(1, -8, 0, 12),
			BackgroundTransparency = 1,
			Text = "",
		})

		local function alpha()
			if max == min then
				return 0
			end
			return (value - min) / (max - min)
		end

		local function display()
			local rounded = ctx.util.math.round(value * 100) / 100
			return tostring(rounded) .. suffix .. "/" .. tostring(max) .. suffix
		end

		local function refresh()
			slide.Size = UDim2.new(alpha(), 0, 1, -2)
			valueLabel.Text = display()
		end

		function api:Set(v)
			value = ctx.util.math.clamp(tonumber(v) or min, min, max)
			if step and step > 0 then
				value = ctx.util.math.snap(value, step)
				value = ctx.util.math.clamp(value, min, max)
			end
			refresh()
			if info.callback then
				info.callback(value)
			end
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			title:Destroy()
			outer:Destroy()
			hit:Destroy()
		end

		local function fromInput(input)
			local rel = (input.Position.X - outer.AbsolutePosition.X) / math.max(outer.AbsoluteSize.X, 1)
			api:Set(min + (max - min) * math.clamp(rel, 0, 1))
		end

		local dragging = false
		ctx.util.signal.connect(hit.InputBegan, function(input)
			if
				outer.Parent
				and (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				dragging = true
				fromInput(input)
			end
		end)
		ctx.util.signal.connect(UIS.InputChanged, function(input)
			if not outer.Parent then
				dragging = false
				return
			end
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				fromInput(input)
			end
		end)
		ctx.util.signal.connect(UIS.InputEnded, function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = false
			end
		end)

		refresh()
		base.advance(section, 27)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
