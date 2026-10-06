-- widgets/keybindslist.luau | live list of registered keybinds
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme

	local W = {}

	function W.new(window, info)
		local api = {}
		local frame = render.frame(window.gui, {
			Name = "KeybindsList",
			Position = UDim2.new(0, 10, 0, 60),
			Size = UDim2.new(0, 170, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.background,
			Visible = false,
			ZIndex = 1000,
		})
		render.stroke(frame, theme.outline, 1)
		local accent = render.frame(frame, {
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = theme.accent,
			ZIndex = 1001,
		})
		render.label(frame, {
			Position = UDim2.new(0, 8, 0, 4),
			Size = UDim2.new(1, -16, 0, 16),
			Text = "Keybinds",
			ZIndex = 1001,
		})
		local body = render.frame(frame, {
			Position = UDim2.new(0, 0, 0, 22),
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 1001,
		})
		render.list(body, { padding = 2 })
		render.padding(body, 6, 4)

		local visible = false
		local function refresh()
			for _, child in ipairs(body:GetChildren()) do
				if child:IsA("TextLabel") then
					child:Destroy()
				end
			end
			for _, entry in ipairs(ctx.state.keybinds) do
				local key = entry.get()
				if key and key ~= Enum.KeyCode.Unknown then
					render.label(body, {
						Size = UDim2.new(1, 0, 0, 16),
						Text = string.format("%s: [%s]", entry.name, key.Name),
						ZIndex = 1002,
					})
				end
			end
		end

		function api:Toggle(state)
			visible = (state == nil) and not visible or state
			frame.Visible = visible
			if visible then
				refresh()
			end
		end
		function api:Refresh()
			refresh()
		end
		function api:Destroy()
			frame:Destroy()
		end

		task.spawn(function()
			while frame.Parent do
				task.wait(0.5)
				if frame.Visible then
					refresh()
				end
			end
		end)

		return api
	end

	return W
end
