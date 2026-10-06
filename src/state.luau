-- state.luau | per-session shared registries. One instance, passed through ctx.
return function(ctx)
	return {
		connections = {}, -- every tracked RBXScriptConnection
		colors = {}, -- [instance] = { Property = themeKey } for live recolor
		flags = {}, -- [flag] = { get = fn, set = fn, value = any }
		windows = {}, -- active windows, newest last
		root = nil, -- resolved ScreenGui parent
		folders = {
			main = "spiff",
			configs = "spiff/configs",
		},
	}
end
