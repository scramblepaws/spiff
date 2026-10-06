-- widgets/watermark.luau | top-left overlay showing fps + ping
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local RunService = game:GetService("RunService")
	local Stats = game:GetService("Stats")

	local W = {}

	function W.new(window, info)
		info = info or {}
		local api = {}
		local running = true

		local frame = render.frame(window.gui, {
			Name = "Watermark",
			Position = UDim2.new(0, 10, 0, 10),
			Size = UDim2.new(0, 230, 0, 22),
			BackgroundColor3 = theme.background,
			ZIndex = 1000,
		})
		render.stroke(frame, theme.outline, 1)
		local accent = render.frame(frame, {
			Size = UDim2.new(0, 3, 1, 0),
			BackgroundColor3 = theme.accent,
			ZIndex = 1001,
		})
		local label = render.label(frame, {
			Position = UDim2.new(0, 10, 0, 0),
			Size = UDim2.new(1, -16, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
			Text = info.text or "spiff",
			ZIndex = 1001,
		})

		local frames = 0
		ctx.util.signal.connect(RunService.RenderStepped, function()
			frames = frames + 1
		end)
		task.spawn(function()
			while running do
				task.wait(1)
				local ping = "?"
				pcall(function()
					ping = tostring(math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
				end)
				if label.Parent then
					label.Text = string.format("%s | %d fps | %s ping", info.text or "spiff", frames, ping)
				end
				frames = 0
			end
		end)

		function api:Set(text)
			info.text = tostring(text)
		end
		function api:Destroy()
			running = false
			frame:Destroy()
		end

		return api
	end

	return W
end
