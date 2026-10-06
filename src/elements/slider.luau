-- elements/slider.luau | numeric drag bar with optional step/decimals
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
		local decimals = info.decimals or 0
		local value = info.value or info.Value or min

		local row, label = base.row(section, { name = info.name or "Slider", height = 36 })
		label.Position = UDim2.new(0, 8, 0, 2)
		label.Size = UDim2.new(1, -100, 0, 14)

		local valueLabel = render.label(row, {
			Position = UDim2.new(1, -8, 0, 2),
			Size = UDim2.new(0, 60, 0, 14),
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = "0",
		})
		theme:Track(valueLabel, "TextColor3", "dim")

		local track = render.frame(row, {
			Position = UDim2.new(0, 8, 1, -12),
			Size = UDim2.new(1, -16, 0, 6),
			BackgroundColor3 = theme.inline,
			AnchorPoint = Vector2.new(0, 0),
		})
		local fill = render.frame(track, {
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = theme.accent,
		})
		theme:Track(fill, "BackgroundColor3", "accent")

		local grip = render.button(row, {
			Position = UDim2.new(0, 8, 1, -12),
			Size = UDim2.new(1, -16, 0, 6),
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
			if decimals > 0 then
				return string.format("%." .. decimals .. "f", value)
			end
			return tostring(ctx.util.math.round(value))
		end

		local function refresh()
			fill.Size = UDim2.new(alpha(), 0, 1, 0)
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
			rel = math.clamp(rel, 0, 1)
			api:Set(min + (max - min) * rel)
		end

		local dragging = false
		ctx.util.signal.connect(grip.InputBegan, function(input)
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
