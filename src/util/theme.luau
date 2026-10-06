-- util/theme.luau | Octernal Lib palette + live recolor registry
return function(ctx)
	local theme = {
		accent = Color3.fromRGB(55, 175, 225),
		lightcontrast = Color3.fromRGB(30, 30, 30),
		darkcontrast = Color3.fromRGB(25, 25, 25),
		outline = Color3.fromRGB(0, 0, 0),
		inline = Color3.fromRGB(50, 50, 50),
		textborder = Color3.fromRGB(0, 0, 0),
		text = Color3.fromRGB(255, 255, 255),
		-- aliases used across modules
		background = Color3.fromRGB(25, 25, 25),
		surface = Color3.fromRGB(30, 30, 30),
		section = Color3.fromRGB(25, 25, 25),
		row = Color3.fromRGB(25, 25, 25),
		dim = Color3.fromRGB(150, 150, 150),
		font = Enum.Font.Code,
		textsize = 13,
	}

	function theme:Track(inst, prop, key)
		local reg = ctx.state.colors
		reg[inst] = reg[inst] or {}
		reg[inst][prop] = key
		inst[prop] = theme[key]
		return inst
	end

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
