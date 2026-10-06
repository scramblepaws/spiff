-- elements/configbox.luau | Octernal: name field + Create/Load/Save/Delete
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local window = section.window

		local row = base.control(section, 20, theme.darkcontrast)
		local field = render.textbox(row, {
			Size = UDim2.new(1, -8, 1, -2),
			Position = UDim2.new(0, 4, 0, 1),
			BackgroundTransparency = 1,
			Text = info.value or "default",
			PlaceholderText = "config name",
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		local function name()
			return field.Text ~= "" and field.Text or "default"
		end

		local function run(kind, fallback)
			local method = window and window[kind]
			if type(method) == "function" then
				return method(window, name())
			end
			if fallback then
				return fallback(name())
			end
		end

		local actions = {
			{ text = "Create", kind = "SaveConfig" },
			{ text = "Load", kind = "LoadConfig" },
			{ text = "Save", kind = "SaveConfig" },
			{ text = "Delete", kind = "DeleteConfig" },
		}

		local holder = render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = base.order(section),
		})
		render.list(holder, { horizontal = true, padding = 4 })

		for _, action in ipairs(actions) do
			local btn = render.button(holder, {
				Text = action.text,
				Size = UDim2.new(0.25, -3, 1, 0),
				TextColor3 = theme.text,
			})
			render.shade(btn, Color3.fromRGB(44, 44, 44), Color3.fromRGB(29, 29, 29))
			render.borders(btn, theme.outline)
			ctx.util.signal.connect(btn.MouseButton1Click, function()
				run(action.kind, info[action.kind])
			end)
		end

		function api:Set(text)
			field.Text = tostring(text or "")
		end
		function api:Get()
			return field.Text
		end
		function api:Destroy()
			row:Destroy()
			holder:Destroy()
		end

		return base.register(api, base.autoFlag(info))
	end

	return M
end
