-- elements/textbox.luau | free text input row
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local value = info.value or info.Value or ""
		local row = base.row(section, { name = info.name or "Textbox" })

		local box = render.textbox(row, {
			Position = UDim2.new(1, -8, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, 120, 0, 18),
			Text = tostring(value),
			PlaceholderText = info.placeholder or "type...",
			TextXAlignment = Enum.TextXAlignment.Left,
		})
		render.corner(box, 3)
		render.borders(box, theme.outline, theme.inline)
		render.padding(box, 4, 0)
		theme:Track(box, "TextColor3", "text")

		ctx.util.signal.connect(box.FocusLost, function()
			value = box.Text
			if info.callback then
				info.callback(value)
			end
		end)

		function api:Set(text)
			value = tostring(text or "")
			box.Text = value
		end
		function api:Get()
			return value
		end
		function api:Destroy()
			row:Destroy()
		end

		return base.register(api, base.autoFlag(info))
	end

	return M
end
