-- elements/base.luau | shared row scaffolding + flag registration
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = {}

	-- a standard row: bordered background + left-aligned title label
	function base.row(section, info)
		info = info or {}
		local row = render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, info.height or 24),
			BackgroundColor3 = theme.row,
			LayoutOrder = info.order or (#section.content:GetChildren() + 1),
		})
		render.corner(row, 4)
		render.stroke(row, theme.outline, 1)
		local label = render.label(row, {
			Text = info.name or "",
			Position = UDim2.new(0, 8, 0, 0),
			Size = UDim2.new(1, -100, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		})
		theme:Track(label, "TextColor3", "text")
		return row, label
	end

	-- expose an element to config serialization under state.flags
	function base.register(api, flag)
		if flag and flag ~= "" then
			api.flag = flag
			ctx.state.flags[flag] = api
		end
		return api
	end

	function base.autoFlag(info)
		return info.flag or info.Flag or ctx.util.newFlag("el")
	end

	return base
end
