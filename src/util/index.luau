-- util/index.luau | aggregates the util modules into ctx.util
return function(ctx)
	local util = {}
	util.math = ctx.require("util.math")
	util.signal = ctx.require("util.signal")
	util.theme = ctx.require("util.theme")
	util.filesystem = ctx.require("util.filesystem")

	local counter = 0
	function util.newFlag(prefix)
		counter = counter + 1
		return string.format("%s_%d", prefix or "flag", counter)
	end

	function util.deepcopy(t)
		if type(t) ~= "table" then
			return t
		end
		local out = {}
		for k, v in pairs(t) do
			out[k] = util.deepcopy(v)
		end
		return out
	end

	function util.toColor(h, s, v)
		return Color3.fromHSV(h, s, v)
	end

	return util
end
