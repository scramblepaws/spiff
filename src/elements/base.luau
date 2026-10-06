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

	-- full-width bordered control with a vertical gradient; returns (row, gradient)
	function base.control(section, height, fill)
		local row = render.frame(section.content, {
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = base.order(section),
		})
		local top, bottom
		if fill == theme.lightcontrast then
			top, bottom = Color3.fromRGB(44, 44, 44), Color3.fromRGB(29, 29, 29)
		else
			top, bottom = Color3.fromRGB(26, 26, 26), Color3.fromRGB(17, 17, 17)
		end
		local grad = render.shade(row, top, bottom)
		render.borders(row, theme.outline)
		return row, grad
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
