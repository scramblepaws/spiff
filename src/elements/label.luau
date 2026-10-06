-- elements/label.luau | plain text line
return function(ctx)
	local render = ctx.render
	local base = ctx.require("elements.base")
	local M = {}

	function M.new(section, info)
		info = info or {}
		local api = {}
		local label = render.label(section.frame, {
			Text = info.text or info.name or "",
			Position = UDim2.new(info.middle and 0.5 or 0, info.middle and 0 or 4, 0, section.axis),
			Size = UDim2.new(1, -8, 0, 15),
			TextXAlignment = info.middle and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left,
		})

		function api:Set(text)
			label.Text = tostring(text)
		end
		function api:Get()
			return label.Text
		end
		function api:Destroy()
			label:Destroy()
		end

		base.advance(section, 15)
		return api
	end

	return M
end
