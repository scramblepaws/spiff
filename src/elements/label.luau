-- elements/label.luau | static text line
return function(ctx)
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local row, label = base.row(section, {
			name = info.text or info.name or "",
			height = info.height or 20,
		})
		label.Size = UDim2.new(1, -16, 1, 0)

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
