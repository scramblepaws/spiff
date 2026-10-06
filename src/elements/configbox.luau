-- elements/configbox.luau | config name field + Create/Load/Save/Delete
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local window = section.window
		local axis = section.axis

		local outer, _, fill = base.stack(section.frame, UDim2.new(0, 4, 0, axis), UDim2.new(1, -8, 0, 20), theme.outline, theme.inline, theme.darkcontrast)
		local field = render.textbox(fill, {
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

		local btnRow = render.frame(section.frame, {
			Position = UDim2.new(0, 4, 0, axis + 20),
			Size = UDim2.new(1, -8, 0, 20),
			BackgroundTransparency = 1,
		})
		render.list(btnRow, { horizontal = true, padding = 4 })

		for _, action in ipairs(actions) do
			local btn = render.button(btnRow, {
				Text = action.text,
				Size = UDim2.new(0.25, -3, 1, 0),
				BackgroundColor3 = theme.inline,
				BackgroundTransparency = 0,
				TextColor3 = theme.textcolor,
			})
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
			outer:Destroy()
			btnRow:Destroy()
		end

		base.advance(section, 40)
		return base.register(api, base.autoFlag(info))
	end

	return M
end
