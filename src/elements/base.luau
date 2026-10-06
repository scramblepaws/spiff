-- elements/base.luau | Octernal scaffolding: triple-nested 1px stacks + axis layout
return function(ctx)
	local render = ctx.render
	local theme = ctx.util.theme
	local base = {}

	-- outer -> mid -> fill, each inset 1px (the Octernal border signature)
	function base.stack(parent, position, size, outer, mid, fill)
		local outerFrame = render.frame(parent, {
			Position = position,
			Size = size,
			BackgroundColor3 = outer or theme.outline,
		})
		local midFrame = render.frame(outerFrame, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			BackgroundColor3 = mid or theme.inline,
		})
		local fillFrame = render.frame(midFrame, {
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2),
			BackgroundColor3 = fill or theme.darkcontrast,
		})
		return outerFrame, midFrame, fillFrame
	end

	-- advance the section's y-axis past a row (height + 4px gap) and refit
	function base.advance(section, height)
		section.axis = section.axis + height + 4
		section:Update()
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
