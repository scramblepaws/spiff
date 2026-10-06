-- elements/label.luau | plain text line (Octernal: no box)
return function(ctx)
	local render = ctx.render
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local row = base.plain(section, info.height or 17)
		local label = render.label(row, {
			Text = info.text or info.name or "",
			Position = UDim2.new(0, 4, 0, 0),
			Size = UDim2.new(1, -8, 1, 0),
			TextXAlignment = info.middle and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
		})

		function api:Set(text)
			label.Text = tostring(text)
		end
		function api:Get()
			return label.Text
		end
		function api:Destroy()
			row:Destroy()
		end

		return api
	end

	return M
end
