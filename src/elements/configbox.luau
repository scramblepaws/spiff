-- elements/configbox.luau | config name field + Save/Load/Delete buttons.
-- Wires to window config methods when present, else to info callbacks.
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local window = section.window

		local row = base.row(section, { name = info.name or "Config", height = 26 })

		local field = render.textbox(row, {
			Position = UDim2.new(0, 66, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, 110, 0, 18),
			Text = info.value or "default",
			PlaceholderText = "config name",
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		render.corner(field, 3)
		render.stroke(field, theme.outline, 1)
		render.padding(field, 4, 0)

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
			{ text = "Save", kind = "SaveConfig" },
			{ text = "Load", kind = "LoadConfig" },
			{ text = "Del", kind = "DeleteConfig" },
		}

		local holder = render.frame(row, {
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 0, 0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
		})
		render.list(holder, { horizontal = true, padding = 4 })

		for _, action in ipairs(actions) do
			local btn = render.button(holder, {
				Text = action.text,
				Size = UDim2.new(0, 42, 0, 18),
				BackgroundColor3 = theme.row,
				BackgroundTransparency = 0,
				TextColor3 = theme.text,
				TextSize = 12,
			})
			render.corner(btn, 3)
			render.stroke(btn, theme.outline, 1)
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
		end

		return base.register(api, base.autoFlag(info))
	end

	return M
end
