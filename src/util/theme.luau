-- util/theme.luau | palette + live recolor registry
return function(ctx)
	local theme = {
		accent = Color3.fromRGB(178, 156, 255), -- Akiri purple
		background = Color3.fromRGB(20, 16, 36),
		surface = Color3.fromRGB(25, 20, 45),
		section = Color3.fromRGB(40, 34, 64),
		row = Color3.fromRGB(46, 42, 76),
		inline = Color3.fromRGB(60, 54, 92),
		outline = Color3.new(0, 0, 0),
		text = Color3.fromRGB(200, 190, 255),
		dim = Color3.fromRGB(140, 135, 180),
		font = Enum.Font.Code,
		textsize = 13,
	}

	-- register an instance property against a theme key, then apply it
	function theme:Track(inst, prop, key)
		local reg = ctx.state.colors
		reg[inst] = reg[inst] or {}
		reg[inst][prop] = key
		inst[prop] = theme[key]
		return inst
	end

	-- recolor every tracked instance using the given theme key
	function theme:UpdateColor(key, color)
		theme[key] = color
		for inst, props in pairs(ctx.state.colors) do
			for prop, k in pairs(props) do
				if k == key then
					pcall(function()
						inst[prop] = color
					end)
				end
			end
		end
	end

	return theme
end
