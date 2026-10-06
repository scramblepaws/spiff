-- widgets/notifications.luau | stacking top-right toasts
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme

	local W = {}

	function W.new(window, info)
		local api = {}
		local container = render.frame(window.gui, {
			Name = "Notifications",
			Position = UDim2.new(1, -12, 0, 12),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, 240, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 1000,
		})
		render.list(container, { padding = 6 })

		function api:Add(n)
			n = n or {}
			local toast = render.frame(container, {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = theme.background,
				ZIndex = 1001,
			})
			render.corner(toast, 4)
			render.stroke(toast, theme.outline, 1)
			local accent = render.frame(toast, {
				Size = UDim2.new(0, 3, 1, 0),
				BackgroundColor3 = theme.accent,
				ZIndex = 1002,
			})
			render.corner(accent, 4)
			render.label(toast, {
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -14, 1, 0),
				TextYAlignment = Enum.TextYAlignment.Center,
				Text = n.text or "notification",
				TextWrapped = true,
				ZIndex = 1002,
			})
			task.delay(n.lifetime or 5, function()
				if toast and toast.Parent then
					toast:Destroy()
				end
			end)
			return toast
		end

		function api:Destroy()
			container:Destroy()
		end

		return api
	end

	return W
end
