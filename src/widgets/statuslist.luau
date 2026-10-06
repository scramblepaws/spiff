-- widgets/statuslist.luau | named status lines that update in place
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme

	local W = {}

	function W.new(window, info)
		local api = {}
		local entries = {}
		local visible = false

		local frame = render.frame(window.gui, {
			Name = "StatusList",
			Position = UDim2.new(1, -12, 0, 60),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, 170, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.background,
			Visible = false,
			ZIndex = 1000,
		})
		render.corner(frame, 4)
		render.stroke(frame, theme.outline, 1)
		local accent = render.frame(frame, {
			Size = UDim2.new(1, 0, 0, 2),
			BackgroundColor3 = theme.accent,
			ZIndex = 1001,
		})
		render.corner(accent, 4)
		render.label(frame, {
			Position = UDim2.new(0, 8, 0, 4),
			Size = UDim2.new(1, -16, 0, 16),
			Text = info.name or "Status",
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

		function api:Set(name, text)
			local label = entries[name]
			if not label or not label.Parent then
				label = render.label(body, { Size = UDim2.new(1, 0, 0, 16), ZIndex = 1002 })
				entries[name] = label
			end
			label.Text = string.format("%s: %s", name, tostring(text))
		end
		function api:Remove(name)
			if entries[name] then
				entries[name]:Destroy()
				entries[name] = nil
			end
		end
		function api:Toggle(state)
			visible = (state == nil) and not visible or state
			frame.Visible = visible
		end
		function api:Destroy()
			frame:Destroy()
		end

		return api
	end

	return W
end
