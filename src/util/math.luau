-- util/math.luau | tiny numeric helpers
return function(ctx)
	return {
		clamp = function(v, lo, hi)
			return math.clamp(v, lo, hi)
		end,
		round = function(v)
			return math.floor(v + 0.5)
		end,
		lerp = function(a, b, t)
			return a + (b - a) * t
		end,
		snap = function(v, step)
			return math.floor(v / step + 0.5) * step
		end,
	}
end
