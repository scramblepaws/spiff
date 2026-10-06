-- elements/slider.luau | Octernal: title above a full-width track, value on the track
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

		local row = base.plain(section, 27)
		render.label(row, {
			Text = info.name or "Slider",
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(1, -8, 0, 15),
		})

		local track = render.frame(row, {
			Position = UDim2.new(0, 4, 0, 15),
			Size = UDim2.new(1, -8, 0, 12),
		})
		render.shade(track, Color3.fromRGB(30, 30, 30), Color3.fromRGB(17, 17, 17))
		render.borders(track, theme.outline)

		local fill = render.frame(track, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(0, 0, 1, -2),
		})
		do
			local a = theme.accent
			render.shade(fill, a, Color3.new(a.R * 0.6, a.G * 0.6, a.B * 0.6))
		end

		local valueLabel = render.label(track, {
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = "0",
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
			fill.Size = UDim2.new(alpha(), 0, 1, -2)
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
			row:Destroy()
		end

		local function fromInput(input)
			local rel = (input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
			api:Set(min + (max - min) * math.clamp(rel, 0, 1))
		end

		local dragging = false
		local hit = render.button(row, {
			Position = UDim2.new(0, 0, 0, 15),
			Size = UDim2.new(1, 0, 0, 12),
			BackgroundTransparency = 1,
			Text = "",
		})
		ctx.util.signal.connect(hit.InputBegan, function(input)
			if
				row.Parent
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
			if not row.Parent then
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
		return base.register(api, base.autoFlag(info))
	end

	return M
end
