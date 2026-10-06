-- init.luau | assemble spiff and return the public Library table
return function(ctx)
	ctx.state = ctx.require("state")
	ctx.util = ctx.require("util.index")
	ctx.render = ctx.require("render.index")

	local Library = {
		_NAME = "spiff",
		_VERSION = "0.1.0",
	}

	function Library:Unload()
		ctx.util.signal.disconnectAll()
		for _, win in ipairs(ctx.state.windows) do
			pcall(function()
				win:Destroy()
			end)
		end
		table.clear(ctx.state.windows)
		table.clear(ctx.state.flags)
		table.clear(ctx.state.keybinds)
		table.clear(ctx.state.colors)
	end

	return Library
end
