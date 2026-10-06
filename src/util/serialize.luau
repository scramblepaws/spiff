-- util/serialize.luau | JSON-safe encode/decode for element values (Color3, EnumItem)
return function(ctx)
	local S = {}

	local function enc(v)
		local kind = typeof(v)
		if kind == "Color3" then
			local h, s, val = v:ToHSV()
			return { __type = "Color3", h = h, s = s, v = val }
		elseif kind == "EnumItem" then
			return { __type = "EnumItem", enum = tostring(v.EnumType), name = v.Name }
		elseif kind == "table" then
			local out = {}
			for k, item in pairs(v) do
				out[k] = enc(item)
			end
			return out
		end
		return v
	end

	local function dec(v)
		if type(v) == "table" then
			if v.__type == "Color3" then
				return Color3.fromHSV(v.h, v.s, v.v)
			elseif v.__type == "EnumItem" then
				local enum = Enum[v.enum]
				return (enum and enum[v.name]) or Enum.KeyCode.Unknown
			end
			local out = {}
			for k, item in pairs(v) do
				out[k] = dec(item)
			end
			return out
		end
		return v
	end

	function S.encode(value)
		return enc(value)
	end
	function S.decode(value)
		return dec(value)
	end

	return S
end
