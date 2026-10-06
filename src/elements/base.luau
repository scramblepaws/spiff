-- elements/base.luau | Octernal row scaffolding
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = {}

	function base.order(section)
		return #section.content:GetChildren() + 1
	end

	-- borderless row (labels, toggles, sliders): section background shows through
	function base.plain(section, height)
		return render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundTransparency = 1,
			LayoutOrder = base.order(section),
		})
	end

	-- full-width bordered control: outline -> inline -> fill
	function base.control(section, height, fill)
		local row = render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundColor3 = fill or theme.lightcontrast,
			LayoutOrder = base.order(section),
		})
		render.borders(row, theme.outline, theme.inline)
		return row
	end

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
